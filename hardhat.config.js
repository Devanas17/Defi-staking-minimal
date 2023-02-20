require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-deploy");

const COMPILER_SETTINGS = {
  optimizer: {
    enabled: true,
    runs: 1000000,
  },
  metadata: {
    bytecodeHash: "none",
  },
};
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
        COMPILER_SETTINGS,
      },
      {
        version: "0.6.6",
        COMPILER_SETTINGS,
      },
      {
        version: "0.4.24",
        COMPILER_SETTINGS,
      },
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    goerli: {
      url: [process.env.RPC_URL],
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
