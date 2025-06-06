import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying BattleArena contract with the account:", deployer.address);

  // Replace with the actual deployed AgentNFT contract address after running deployAgentNFT.ts
  // This can be passed as a command-line argument, read from a file, or hardcoded for initial testing.
  const agentNFTAddress = "0xYourDeployedAgentNFTContractAddress"; // <--- IMPORTANT: Replace this placeholder

  if (agentNFTAddress === "0xYourDeployedAgentNFTContractAddress") {
    console.error("Please replace the placeholder AgentNFT contract address in deployBattleArena.ts");
    process.exit(1);
  }

  const BattleArenaFactory = await ethers.getContractFactory("BattleArena");
  const battleArena = await BattleArenaFactory.deploy(agentNFTAddress);

  await battleArena.waitForDeployment();

  const battleArenaAddress = await battleArena.getAddress();
  console.log("BattleArena deployed to:", battleArenaAddress);

  // You can add further setup logic here, e.g., granting roles or setting parameters.
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
