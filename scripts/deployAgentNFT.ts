import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying AgentNFT contract with the account:", deployer.address);

  const AgentNFTFactory = await ethers.getContractFactory("AgentNFT");
  const agentNFT = await AgentNFTFactory.deploy(); // Assuming default Ownable behavior sets deployer as owner

  await agentNFT.waitForDeployment();

  const agentNFTAddress = await agentNFT.getAddress();
  console.log("AgentNFT deployed to:", agentNFTAddress);

  // You can add further setup logic here if needed,
  // e.g., minting some initial NFTs, configuring base URI, etc.
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
