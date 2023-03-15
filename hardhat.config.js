// require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");
// require('solidity-coverage')
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  namedAccounts: {
    deployer: {
      default: 0
    }
  }
};
