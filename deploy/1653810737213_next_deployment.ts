import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { diamond } = deployments;
  const { deployer } = await getNamedAccounts();
  await diamond.deploy('WinzelandProxy', {
    from: deployer,
    owner: deployer,
    facets: ['LandResourceModule'],
  });
};

func.tags = ['WinzelandProxy'];

export default func;
