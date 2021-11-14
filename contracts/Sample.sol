// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Sample is ERC20 {

    constructor() ERC20("Sample", "SAM") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
