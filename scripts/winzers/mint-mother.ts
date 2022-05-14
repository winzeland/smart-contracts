import { ethers } from "hardhat";

async function main() {
  const airdroper = await ethers.getContract("WinzerMarketingAirdrop");

  const mint = await airdroper.mintMother();

  const tx = await mint.wait();

  console.log("tx", tx.transactionHash);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
