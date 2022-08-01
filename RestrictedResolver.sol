// SPDX-License-Identifier: BSD-2
pragma solidity >=0.7.0 <0.9.0;

import "@ensdomains/ens-contracts/contracts/resolvers/profiles/AddrResolver.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/InterfaceResolver.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/NameResolver.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/profiles/TextResolver.sol";

import "./ISystemRegistrar.sol";
import "./RoleResolver.sol";
//import "./IEnsTest.sol";
import "hardhat/console.sol";

/**
 * A simple resolver for address, interface, name, text and role;
 * Restrict authorisation to the given role, checked on the SystemRegistrar's AccesControl contract
 */
contract RestrictedResolver is AddrResolver, InterfaceResolver, NameResolver, RoleResolver, TextResolver {
	ISystemRegistrar public immutable registrar;
	bytes32 public immutable authorisedRole;

	constructor(ISystemRegistrar _registrar, bytes32 _authorisedRole) {
		registrar = _registrar;
		authorisedRole = _authorisedRole;

		console.logBytes32(_authorisedRole);
	}

	/**
	 * @dev Returns whether the sender is authorised to modify this Resolver. It checks the system's
	 * access-control contract against the set role to check ; or if the sender is the registrar
	 */
	function isAuthorised(bytes32 node) internal view override returns (bool) {
		node; // Ignore unused-variable
		return msg.sender == address(registrar) || registrar.accessControl().hasRole(authorisedRole, msg.sender);
	}

	/// @inheritdoc InterfaceResolver
	function supportsInterface(bytes4 interfaceID)
		public
		pure
		virtual
		override(AddrResolver, InterfaceResolver, NameResolver, RoleResolver, TextResolver)
		returns (bool)
	{
		return super.supportsInterface(interfaceID);
	}
}

   

