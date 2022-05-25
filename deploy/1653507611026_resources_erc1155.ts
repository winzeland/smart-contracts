import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types/runtime';

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy('ResourcesERC1155', {
    from: deployer,
    log: true,
    args: [
      'https://www.winzeland.com/meta/resources/{id}',
      'https://www.winzeland.com/meta/contract/resources',
    ],
  });
};

export default func;
