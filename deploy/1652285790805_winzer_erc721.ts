import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("WinzerERC721", {
    from: deployer,
    log: true,
  });
};

func.tags = ["WinzerERC721"];

export default func;
