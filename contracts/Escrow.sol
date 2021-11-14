//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './BondNft.sol';

contract Escrow is Ownable {

  enum Status { LOCKED, READY_TO_CLAIM, CLAIMED }

  struct Bonds {
    uint256 tokenId;
    uint256 amount;
    address erc20;
    uint256 releaseTime;
    Status status;
  }

  uint public numOfBonds = 0;
  BondNft public nftBond;

  mapping (uint => Bonds) bearerBonds;

  constructor (address _nftBond) {
    nftBond = BondNft(_nftBond);
  }

  modifier isReleased(uint tokenId) {
      require(block.timestamp > bearerBonds[tokenId].releaseTime, "not released");
      _;
  }

  modifier isOwner(uint tokenId) {
      require(nftBond.isOwner(tokenId), "not owner");
      _;
  }

  function conceiveBond(uint256 _amount, address _erc20, uint256 _releaseTime) public returns (bool) {
    numOfBonds += 1;
    IERC20 erc20Token = IERC20(_erc20);
    uint256 allowance = erc20Token.allowance(msg.sender, address(this));
    require(allowance >= _amount, "Check the token allowance");
    erc20Token.transferFrom(msg.sender, address(this), _amount);
    _addBond(numOfBonds,_amount,_erc20,_releaseTime);
    nftBond.safeMint(msg.sender, numOfBonds, "http://sample.sol");
    return true;
  }

  function _addBond(uint256 _tokenId, uint256 _amount, address _erc20, uint256 _releaseTime) internal {
    Bonds storage bond = bearerBonds[_tokenId];
    bond.tokenId = _tokenId;
    bond.amount = _amount;
    bond.erc20 = _erc20;
    bond.releaseTime = _releaseTime;
    bond.status = Status.LOCKED;
  }

  function getBond(uint _tokenId) view external returns (uint256 tokenId, uint256 amount, uint256 release_time, address erc20, Status status) {
    Bonds memory bond = bearerBonds[_tokenId];
    return (bond.tokenId, bond.amount, bond.releaseTime, bond.erc20, bond.status);
  }

  function releaseTime(uint __tokenId) public view virtual returns (uint256) {
    return bearerBonds[__tokenId].releaseTime;
  }

  function getStatus(uint ___tokenId) public view virtual returns (Status) {
    return bearerBonds[___tokenId].status;
  }

  function claimBond(uint tokenId) public isReleased(tokenId) isOwner(tokenId) returns (bool) {
    Bonds memory bond = bearerBonds[tokenId];
    IERC20 erc20Token = IERC20(bond.erc20);

    nftBond.burn(tokenId);
    erc20Token.transfer(msg.sender, bond.amount);

    return true;
  }
}
