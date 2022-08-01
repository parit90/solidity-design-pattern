// SPDX-License-Identifier: BSD-2
pragma solidity >=0.7.0 <0.9.0;

import "@ensdomains/ens-contracts/contracts/resolvers/ResolverBase.sol";

abstract contract RoleResolver is ResolverBase {
	bytes4 private constant ROLE_INTERFACE_ID = 0xaad632a3;

	event RoleChanged(bytes32 indexed node, bytes32 role);

	mapping(bytes32 => bytes32) private _roles;

	/**
	 * @notice Sets the role associated with an ENS node.
	 * @param node The node to update.
	 * @param newRole The role to set.
	 */
	function setRole(bytes32 node, bytes32 newRole) external authorised(node) {
		_roles[node] = newRole;
		emit RoleChanged(node, newRole);
	}

	/**
	 * @notice Returns the role associated with an ENS node.
	 * @param node The ENS node to query.
	 * @return The associated role.
	 */
	function role(bytes32 node) external view returns (bytes32) {
		return _roles[node];
	}

	// @inheritdoc ResolverBase
	function supportsInterface(bytes4 interfaceID) public pure virtual override returns (bool) {
		return interfaceID == ROLE_INTERFACE_ID || super.supportsInterface(interfaceID);
	}
}
