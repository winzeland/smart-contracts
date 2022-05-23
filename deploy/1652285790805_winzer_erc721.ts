import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types/runtime';
import { buildBaseNftMetadataUrl } from '../utils/url-helpers';

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy('WinzerERC721', {
    from: deployer,
    log: true,
    args: [
      deployer,
      buildBaseNftMetadataUrl(deployments.getNetworkName(), '/meta/winzer/'),
      buildBaseNftMetadataUrl(
        deployments.getNetworkName(),
        '/meta/contract/winzers',
      ),
    ],
  });
};

func.tags = ['WinzerERC721'];

// already deployed to mainnet
func.skip = env => Promise.resolve(env.network.name === 'matic');

export default func;
