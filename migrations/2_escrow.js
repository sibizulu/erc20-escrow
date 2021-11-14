const Sample = artifacts.require('Sample')
const BondNft = artifacts.require('BondNft')
const Escrow = artifacts.require('Escrow')

module.exports = async deployer => {
  await deployer.deploy(Sample)
  await deployer.deploy(BondNft)
  await deployer.deploy(Escrow, BondNft.address)
}
