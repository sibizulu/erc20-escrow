const Migrations = artifacts.require('Sample')

module.exports = function (deployer) {
  deployer.deploy(Migrations)
}
