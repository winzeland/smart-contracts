import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  ethers,
  getNamedAccounts,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const deployed = await deploy("ResourcesERC1155", {
    from: deployer,
    log: true,
  });

  if (deployed.newlyDeployed) {
    const resources = await ethers.getContractAt(
      deployed.abi,
      deployed.address
    );

    const addRole1 = await resources.grantRole(
      ethers.utils.id("MINTER_ROLE"),
      deployer
    );

    await addRole1.wait();

    const addRole2 = await resources.grantRole(
      ethers.utils.id("BURNER_ROLE"),
      deployer
    );

    await addRole2.wait();
  }
};

func.tags = ["ResourcesERC1155"];

export default func;
