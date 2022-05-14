import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  ethers,
  getNamedAccounts,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const deployed = await deploy("GubbinsERC20", {
    from: deployer,
    log: true,
  });

  if (deployed.newlyDeployed) {
    const gubbins = await ethers.getContractAt(deployed.abi, deployed.address);

    const addRole = await gubbins.grantRole(
      ethers.utils.id("MINTER_ROLE"),
      deployer
    );

    await addRole.wait();

    const mint = await gubbins.mint(deployer, ethers.utils.parseEther("100"));

    await mint.wait();
  }
};

func.tags = ["GubbinsERC20"];

func.skip = () => Promise.resolve(true);

export default func;
