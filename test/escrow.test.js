const Sample = artifacts.require('Sample')
const BondNft = artifacts.require('BondNft')
const Escrow = artifacts.require('Escrow')
const chai = require('chai')
const expect = chai.expect
const truffleAssert = require('truffle-assertions')

contract('Escrow basics', accounts => {
  it('should approve token', async () => {
    const instance = await Sample.deployed()
    await instance.approve(
      Escrow.address,
      '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'
    )
  })
  it('should grant role', async () => {
    const instance = await BondNft.deployed()
    await instance.grantRole(
      web3.utils.keccak256('MINTER_ROLE'),
      Escrow.address
    )
  })

  it('should conceive bond', async () => {
    const instance = await Escrow.deployed()

    await instance.conceiveBond(
      web3.utils.toWei('1', 'ether'),
      Sample.address,
      ((+new Date() + 10000) / 1000).toFixed(0)
    )
  })

  it('should check the bond', async () => {
    const instance = await Escrow.deployed()
    const res = await instance.getBond(1)
    expect(res.status.toNumber()).to.equal(0)
  })

  it('should check the total bonds', async () => {
    const instance = await Escrow.deployed()
    const res = await instance.numOfBonds()
    expect(res.toNumber()).to.equal(1)
  })

  it('should check the lock', async () => {
    const instance = await Escrow.deployed()
    await sleep(11000)
    try {
      await instance.claimBond(1)
    } catch (e) {
      expect(e.reason).to.equal('not released')
    }
  })

  it('should get the bond details', async () => {
    const instance = await Escrow.deployed()
    const res = await instance.getBond(1)
    expect(res[0].toNumber()).to.equal(1)
  })

  it('should claim the token', async () => {
    const instance = await Escrow.deployed()
    await sleep(1000)
    const res = await instance.claimBond(1)
    console.log(res)
  })
})

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms))
