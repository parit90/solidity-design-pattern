// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "./IOrganization.sol";
import "./IUniqueToken.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract UniqueToken is IUniqueToken, ERC721 { 
    	// IOrganization public _organization;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        console.log("UniqueToken Call");
		// _organization = IOrganization(_org);
	}
}