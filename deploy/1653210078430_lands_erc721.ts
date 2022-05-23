import { DeployFunction } from 'hardhat-deploy/types';
import { HardhatRuntimeEnvironment } from 'hardhat/types/runtime';
import { buildBaseNftMetadataUrl } from '../utils/url-helpers';

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer, signer } = await getNamedAccounts();
  const land = await deploy('LandERC721', {
    from: deployer,
    log: true,
    args: [
      deployer,
      buildBaseNftMetadataUrl(deployments.getNetworkName(), '/meta/land/'),
      buildBaseNftMetadataUrl(
        deployments.getNetworkName(),
        '/meta/contract/lands',
      ),
    ],
  });

  const claimer = await deploy('LandClaimer', {
    from: deployer,
    log: true,
    args: [land.address, signer],
  });

  if (land.newlyDeployed || claimer.newlyDeployed) {
    const deployedLand = await ethers.getContract('LandERC721');

    const tx = await deployedLand.grantRole(
      ethers.utils.id('MINTER_ROLE'),
      claimer.address,
    );
    await tx.wait();
  }
};

export default func;
