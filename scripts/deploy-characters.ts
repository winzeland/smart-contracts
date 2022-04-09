// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Characters = await ethers.getContractFactory("YonderCharacter");
  const characters = await Characters.deploy();

  await characters.deployed();

  console.log("Characters NFT deployed to:", characters.address);

  await characters.grantRole(ethers.utils.id("MINTER_ROLE"), deployer.address);

  await characters.mint(deployer.address, {
    race: 0,
    sex: 0,
    skill: 0,
    hair: 0,
    beard: 0,
    skin: 0,
    face: 0,
    eyes: 0,
    mouth: 0,
  });

  const res = await characters.dna(0);
  console.log(res);

  const supply = await characters.totalSupply();
  console.log(supply);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
