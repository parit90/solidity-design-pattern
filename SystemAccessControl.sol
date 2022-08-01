// SPDX-License-Identifier: BSD-2
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "hardhat/console.sol";

contract SystemRoles {
	bytes32 public constant ADMIN_MANAGER_ROLE = keccak256("ADMIN_MANAGER_ROLE");
	bytes32 public constant USER_ADMIN = keccak256("USER_ADMIN");
}

contract SystemAccessControl is AccessControl, SystemRoles {
	
	constructor(address initialAdmin) {
		console.log("SystemAccessControl initialAdmin....",initialAdmin);
		// ADMIN_MANAGER users can add/remove other ADMIN_MANAGER users. 
		// (bytes32,bytes32) as args definied in docs openzappline. 
		// first arg represent role, second arg represent admin_role 
		_setRoleAdmin(ADMIN_MANAGER_ROLE, ADMIN_MANAGER_ROLE);
		// ADMIN_MANAGER users can add/remove USER_ADMIN users
		_setRoleAdmin(USER_ADMIN, ADMIN_MANAGER_ROLE);
		// Contract creator is by default a ADMIN_MANAGER
		_setupRole(ADMIN_MANAGER_ROLE, initialAdmin);
		bool _AMR = hasRole(ADMIN_MANAGER_ROLE, initialAdmin);
		console.log("_AMR....",_AMR);
	}

	function isAdminManager(address account) public view returns (bool) {
		return hasRole(ADMIN_MANAGER_ROLE, account);
	}

	function isUserAdmin(address account) public view returns (bool) {
		console.log("The account is .....",account);
		console.logBytes32(USER_ADMIN);
		bool _is = hasRole(USER_ADMIN, account);
		console.log("_is .....",_is);
		return _is;
	}
}