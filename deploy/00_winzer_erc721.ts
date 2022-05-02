import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const deployed = await deploy("WinzerERC721", {
    from: deployer,
    log: true,
  });

  if (deployed.newlyDeployed) {
    const characters = await ethers.getContractAt(
      deployed.abi,
      deployed.address
    );

    const tx = await characters.grantRole(
      ethers.utils.id("MINTER_ROLE"),
      deployer
    );

    await tx.wait();
  }
};

func.tags = ["WinzerERC721"];

export default func;
