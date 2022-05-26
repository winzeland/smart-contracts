import { ethers, getNamedAccounts } from 'hardhat';

async function main() {
  const { deployer } = await getNamedAccounts();
  const resource = await ethers.getContract('ResourcesERC1155');

  const wood = await resource.mint(deployer, 0, 100);
  console.log('wood', wood.hash);
  await wood.wait();

  const stone = await resource.mint(deployer, 1, 10);
  console.log('stone', stone.hash);
  await stone.wait();

  const ironOre = await resource.mint(deployer, 2, 25);
  console.log('irone ore', ironOre.hash);
  await ironOre.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
