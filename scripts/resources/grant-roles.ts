import { ethers, getNamedAccounts } from 'hardhat';

async function main() {
  const { deployer } = await getNamedAccounts();
  const resource = await ethers.getContract('ResourcesERC1155');

  const creator = await resource.grantRole(
    ethers.utils.id('CREATOR_ROLE'),
    deployer,
  );

  console.log('creator', creator.hash);

  await creator.wait();

  const minter = await resource.grantRole(
    ethers.utils.id('MINTER_ROLE'),
    deployer,
  );

  console.log('minter', minter.hash);

  await minter.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
