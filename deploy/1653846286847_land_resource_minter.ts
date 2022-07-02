import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types/runtime';

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const land = await ethers.getContract('LandERC721');
  const winzer = await ethers.getContract('WinzerERC721');
  const resources = await ethers.getContract('ResourcesERC1155');

  await deploy('RawResourceMinter', {
    from: deployer,
    log: true,
    args: [land.address, winzer.address, resources.address],
  });

  const raw = await ethers.getContract('RawResourceMinter');

  // forest -> wood (2 minutes)
  await raw.updateResourceData(1, { resourceID: 0, requiredTime: 120 });
  // stone deposit -> stone (2 minutes)
  await raw.updateResourceData(2, { resourceID: 1, requiredTime: 120 });
  // clay deposit -> clay (2 minutes)
  await raw.updateResourceData(3, { resourceID: 3, requiredTime: 120 });
  // iron deposit -> iron ore (5 minutes)
  await raw.updateResourceData(4, { resourceID: 2, requiredTime: 300 });
  // await raw.updateResourceData(5, { resourceID: 0, requiredTime: 900 });
  // await raw.updateResourceData(6, { resourceID: 0, requiredTime: 1200 });
  // await raw.updateResourceData(7, { resourceID: 0, requiredTime: 120 });
  // await raw.updateResourceData(8, { resourceID: 0, requiredTime: 120 });

  const minter = await resources.grantRole(
    ethers.utils.id('MINTER_ROLE'),
    raw.address,
  );

  console.log('minter', minter.hash);

  await minter.wait();
};

func.tags = ['RawResourceMinter'];

export default func;
