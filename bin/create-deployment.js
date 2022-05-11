const fs = require("fs");

const run = async () => {
  const name = `${Date.now()}_next_deployment.ts`;
  const path = `./deploy/${name}`;

  try {
    if (!fs.existsSync(path)) {
      console.log("create", path);

      fs.writeFileSync(
        path,
        `import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

const func: DeployFunction = async function ({
  deployments,
  getNamedAccounts,
  ethers,
}: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("NextContractName", {
    from: deployer,
    log: true,
  });
};

export default func;
`
      );

      console.log("Created migration file", name);
    }
  } catch (err) {
    console.error(err);
  }
};

run().then();
