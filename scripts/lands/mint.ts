// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers, getNamedAccounts } from 'hardhat';

const random = (min: number = 0, max: number = 256) => {
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

async function main() {
  const { deployer } = await getNamedAccounts();

  const lands = await ethers.getContract('LandERC721');

  const sex = random(0, 1);

  const tx = await lands.mint(deployer, {
    race: 0,
    sex,
    skill: random(0, 12),
    hair: random(0, 12),
    beard: sex === 0 ? random(0, 12) : 0,
    skin: random(0, 5),
    face: random(0, 8),
    eyes: random(0, 24),
    mouth: random(0, 24),
  });

  await tx.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
