import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";
import { buildBaseNftMetadataUrl } from "../utils/url-helpers";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("LandERC721", {
    from: deployer,
    log: true,
    args: [
      deployer,
      buildBaseNftMetadataUrl(deployments.getNetworkName(), "/meta/land/"),
      buildBaseNftMetadataUrl(
        deployments.getNetworkName(),
        "/meta/contract/lands"
      ),
    ],
  });
};

export default func;
