// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers, getNamedAccounts } from 'hardhat';
import { getRandomLandAndSign } from '../../utils/randomize';

async function main() {
  const { signer } = await getNamedAccounts();
  const provider = await ethers.getSigner(signer);

  const result = await getRandomLandAndSign(provider, 1, 1);

  console.log(result);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
