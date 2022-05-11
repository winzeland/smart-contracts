import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const deployed = await deploy("LandERC721", {
    from: deployer,
    log: true,
  });

  if (deployed.newlyDeployed) {
    const lands = await ethers.getContractAt(deployed.abi, deployed.address);

    const minterRole = await lands.grantRole(
      ethers.utils.id("MINTER_ROLE"),
      deployer
    );

    await minterRole.wait();

    const mint = await lands.mint(deployer, {
      race: 0,
      x: 0,
      y: 0,
      climate: 0,
      landType: 0,
      resource1: 1,
      resource2: 2,
      resource3: 0,
      resource4: 0,
      resourceLevel1: 1,
      resourceLevel2: 0,
      resourceLevel3: 0,
      resourceLevel4: 0,
    });

    await mint.wait();
  }
};

func.tags = ["LandERC721"];

export default func;
