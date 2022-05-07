// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers, getNamedAccounts } from "hardhat";
import { randomizeWinzerLogically } from '@winzeland/winzer/dist';

async function main() {
  const { deployer } = await getNamedAccounts();

  // @ts-ignore
  const characters = await ethers.getContract("WinzerERC721");

  const traits = randomizeWinzerLogically();

  const dna = {
    race: traits.race,
    sex: traits.sex,
    skin: traits.skinTone,
    head: traits.head,
    ears: traits.ears,
    hair: traits.hair,
    beard: traits.beard,
    mouth: traits.mouth,
    eyes: traits.eyes,
    eyebrows: traits.eyebrows,
    nose: traits.nose,
    scars: traits.scars,
  };

  const extra = {
    accessory: traits.accessories,
    makeup: traits.makeup,
    skill1: 0,
    skill2: 0,
    skill3: 0,
    skill4: 0,
    skill5: 0,
  };

  const tx = await characters.mint(deployer, dna, extra);

  await tx.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
