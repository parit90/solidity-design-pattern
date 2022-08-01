// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IWalletFactory.sol";
import "./ISystemRegistrar.sol";
import "./ProxyWallet.sol";
import "hardhat/console.sol";

contract WalletFactory is IWalletFactory { 
    	ISystemRegistrar private immutable _registrar;
        
        modifier onlyUserAdmin() {
		    require(_registrar.accessControl().isUserAdmin(msg.sender), "WalletFactory: not a user admin");
		    _;
    	}
        constructor(address _sysRegistrar) {
            console.log("Address of SystemRegistrar.......in wallet Factory",_sysRegistrar);
		    _registrar = ISystemRegistrar(_sysRegistrar);
            console.log("Address of WalletFactory.......in wallet Factory",address(this));
	    }
        
        function newWallet(bytes32 role) public override onlyUserAdmin {
		    ProxyWallet wallet = new ProxyWallet();
		    emit ProxyWalletCreated(address(wallet), role);
	    }
}