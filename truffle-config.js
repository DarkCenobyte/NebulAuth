module.exports = {
  networks: {
    loc_dev_dev: {
      network_id: "*",
      port: 8545,
      host: "127.0.0.1"
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
