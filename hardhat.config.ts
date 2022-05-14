import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "hardhat-deploy";
import "hardhat-gas-reporter";
import "solidity-coverage";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const accounts = process.env.TESTNET_DEPLOYER_PKEY
  ? [process.env.TESTNET_DEPLOYER_PKEY]
  : [];

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  networks: {
    // MAINNET
    matic: {
      url: "https://polygon-rpc.com/",
      accounts: process.env.MAINNET_DEPLOYER_PKEY
        ? [process.env.MAINNET_DEPLOYER_PKEY]
        : [],
      tags: ["mainnet", "matic"],
    },
    // DEV
    hardhat: {
      chainId: 1337,
      tags: ["testnet"],
    },
    localhost: {
      tags: ["testnet"],
    },
    // TESTNET
    mumbai: {
      url: "https://matic-mumbai.chainstacklabs.com",
      accounts,
      tags: ["testnet"],
    },
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts,
      tags: ["testnet"],
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
