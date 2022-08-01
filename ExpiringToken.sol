// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IExpiringToken.sol";
import "./BaseToken.sol";
import "hardhat/console.sol";

contract ExpiringToken is IExpiringToken, BaseToken { 
    	constructor(
            string memory name,
		    string memory symbol,
		    uint8 decimals,
			address organization
        ) BaseToken(name, symbol, decimals, organization) {
            console.log("ExpiringToken Call");
	}
}

//0xc620d70df5a4ad3cac8f00ca8df2cb013356edd4ad82195f3f87585e1492040f, "ExpToken4", "ExpTk4", 2, 0x688c0611a5691B7c1F09a694bf4ADfb456a58Cf7
