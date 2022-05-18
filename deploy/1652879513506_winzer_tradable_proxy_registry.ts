import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("WinzerTradableProxyRegistry", {
    from: deployer,
    log: true,
  });
};

func.tags = ["WinzerTradableProxyRegistry"];

export default func;
