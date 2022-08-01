// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IOrganizationFactory.sol";
import "./ISystemRegistrar.sol";
import "./Organization.sol";
import "hardhat/console.sol";

contract OrganizationFactory is IOrganizationFactory { 
    ISystemRegistrar private immutable _registrar;

	modifier onlyAdminManager(){
		console.log("OrganizationFactory msg.sender", msg.sender);
		require(_registrar.accessControl().isAdminManager(msg.sender), "OrganizationFactory: not a manager admin");
		_;
	}
	constructor(address _sysRegistrar) {
		_registrar = ISystemRegistrar(_sysRegistrar);
	}
//org1 -> 0x9b7588f01fee89dffba84215ba50a6d4015f5e94b8ff628a529dd0d3d6fcb1bf
	function newOrganization(bytes32 label) public onlyAdminManager {
		console.log("The new Organization msg.sender...", msg.sender);
		Organization org = new Organization(registrar(), msg.sender);
		console.log("The address of org.....OrganizationFactory = ",address(org));
		_registrar.registerOrganization(msg.sender, label, address(org));
		emit OrganizationCreated(address(org), label);
	}

	function registrar() public view returns (address) {
		return address(_registrar);
	}

}
