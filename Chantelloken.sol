//SPDX-License-Identifer : MIT

pragma solidity >=0.6.0<0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Chantelloken is ERC20{
    constructor(uint256 initialSupply) ERC20("Chantello","CTL"){
        _mint(msg.sender, initialSupply);
    }
}
