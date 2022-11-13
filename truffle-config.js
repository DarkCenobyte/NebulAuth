require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
module.exports = {
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  },
  networks: {
    loc_dev_dev: {
      network_id: "*",
      port: 8545,
      host: "127.0.0.1"
    },
    "inf_infura-testnet_sepolia": {
      network_id: "11155111",
      gasPrice: 1000000,
      provider: new HDWalletProvider(fs.readFileSync('/home/darkcenobyte/Projects/keys.txt', 'utf-8'), "https://sepolia.infura.io/v3/" + process.env.INFURA_API_KEY)
    },
    mainnet: {
      network_id: "1",
      gas: 2540604,
      gasPrice: 81000000000,
      provider: new HDWalletProvider(fs.readFileSync('/home/darkcenobyte/Projects/keys_mainnet.txt', 'utf-8'), "https://mainnet.infura.io/v3/" + process.env.INFURA_API_KEY)
    }
  },
  mocha: {},
  compilers: {
    solc: {
      version: "0.8.17",
      settings: {
        optimizer: {
          enabled: true,
          runs: 5000000
        },
        evmVersion: "london"
      }
    }
  }
};
