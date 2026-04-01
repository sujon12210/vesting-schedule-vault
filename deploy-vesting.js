const hre = require("hardhat");

async function main() {
  const TOKEN_ADDRESS = "0x..."; // Your Project Token
  
  const Vesting = await hre.ethers.getContractFactory("TokenVesting");
  const vesting = await Vesting.deploy(TOKEN_ADDRESS);

  await vesting.waitForDeployment();
  console.log("Vesting Vault deployed to:", await vesting.getAddress());

  // Example: 4-year vesting (126144000s) with 1-year cliff (31536000s)
  const amount = hre.ethers.parseEther("1000000");
  const cliff = 31536000;
  const duration = 126144000;

  await vesting.createSchedule("0xBeneficiaryAddress", amount, cliff, duration);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
