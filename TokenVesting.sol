// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenVesting is Ownable, ReentrancyGuard {
    struct VestingSchedule {
        uint256 totalAmount;
        uint256 amountReleased;
        uint256 start;
        uint256 cliff;
        uint256 duration;
        bool revoked;
    }

    IERC20 public immutable token;
    mapping(address => VestingSchedule) public schedules;

    event VestingScheduled(address indexed beneficiary, uint256 amount);
    event TokensReleased(address indexed beneficiary, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function createSchedule(
        address _beneficiary,
        uint256 _amount,
        uint256 _cliffDuration,
        uint256 _totalDuration
    ) external onlyOwner {
        require(schedules[_beneficiary].totalAmount == 0, "Schedule exists");
        
        schedules[_beneficiary] = VestingSchedule({
            totalAmount: _amount,
            amountReleased: 0,
            start: block.timestamp,
            cliff: block.timestamp + _cliffDuration,
            duration: _totalDuration,
            revoked: false
        });

        emit VestingScheduled(_beneficiary, _amount);
    }

    function release() external nonReentrant {
        VestingSchedule storage schedule = schedules[msg.sender];
        require(schedule.totalAmount > 0, "No schedule");
        require(block.timestamp >= schedule.cliff, "Cliff not reached");

        uint256 vested = _calculateVestedAmount(schedule);
        uint256 unreleased = vested - schedule.amountReleased;

        require(unreleased > 0, "Nothing to release");

        schedule.amountReleased += unreleased;
        token.transfer(msg.sender, unreleased);

        emit TokensReleased(msg.sender, unreleased);
    }

    function _calculateVestedAmount(VestingSchedule memory _schedule) internal view returns (uint256) {
        if (block.timestamp < _schedule.cliff) return 0;
        if (block.timestamp >= _schedule.start + _schedule.duration) return _schedule.totalAmount;
        
        return (_schedule.totalAmount * (block.timestamp - _schedule.start)) / _schedule.duration;
    }
}
