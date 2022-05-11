import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const characters = await ethers.getContract("WinzerERC721");

  const deployed = await deploy("WinzerClaimer", {
    from: deployer,
    log: true,
    args: [characters.address],
  });

  if (deployed.newlyDeployed) {
    const tx = await characters.grantRole(
      ethers.utils.id("MINTER_ROLE"),
      deployed.address
    );
    await tx.wait();
  }
};

func.tags = ["WinzerClaimer"];

// only deploy for testnet networks
func.skip = (env) => Promise.resolve(!env.network.tags?.testnet);

export default func;
