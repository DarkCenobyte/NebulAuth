// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Dummy contract for test purpose
contract DummyToken is ERC20, ERC20Burnable {
    function decimals() pure public override returns (uint8) {
        return 6;
    }

    constructor() ERC20("DummyToken", "DUMMY") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}