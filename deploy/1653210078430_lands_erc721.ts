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

  console.log('signer address', signer);

  if (land.newlyDeployed || claimer.newlyDeployed) {
    const deployedLand = await ethers.getContract('LandERC721');

    const tx = await deployedLand.grantRole(
      ethers.utils.id('MINTER_ROLE'),
      claimer.address,
    );
    await tx.wait();
  }

  const actualClaimer = await ethers.getContract('LandClaimer');

  const tx = await actualClaimer.mint(
    ['1', '1', '2', '2', '5', '4', '3', '5', '6', '4', '2', '2'],
    '0x507f49509d618bdbb57e7d922b128381120b11fa347a268747389f21d485da9e7e401233a4e0ed0aec484b22959a7f35eefc1cebd2ff176b03b39fecb189af911c',
  );

  await tx.wait();
};

export default func;
