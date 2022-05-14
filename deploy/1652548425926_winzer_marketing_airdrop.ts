import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const winzerContract = await ethers.getContract("WinzerERC721");

  await deploy("WinzerMarketingAirdrop", {
    from: deployer,
    log: true,
    args: [winzerContract.address],
  });
};

func.tags = ["WinzerMarketingAirdrop"];

export default func;
