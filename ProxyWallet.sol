// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./IOrganization.sol";

contract ProxyWallet is ERC721Holder {
    //using Address for address;

	/**
	 * @dev Emitted when the `account` is granted an authorization to call the `organization`.
	 */
	event Authorized(address indexed organization, address indexed account);

	/**
	 * @dev Emitted when an authorization is revoked for `account` to call the `organization`.
	 */
	event Revoked(address indexed organization, address indexed account);

	/**
	 * @dev Emitted when a call is executed on the `to` contract
	 */
	event Executed(address indexed to, bytes data);

	// Mapping of authorized accounts for each organization account
	// _authorizations[org][msg.sender] is the actual authorization
	mapping(address => mapping(address => bool)) private _authorizations;

	modifier onlyOrgAdmin(address organization) {
		require(IOrganization(organization).isAdmin(msg.sender), "ProxyWallet: not an organization admin");
		_;
	}

	modifier onlyAuthorized(address organization) {
		require(_authorizations[organization][msg.sender], "ProxyWallet: sender unauthorized");
		_;
	}

	/**
	 * @dev Authorize the specified `account` to call the `organization`
	 * contract.
	 *
	 * Requirements:
	 * - the caller must be one of the `organization` admin
	 */
	function authorize(address organization, address account) public onlyOrgAdmin(organization) {
		_authorizations[organization][account] = true;
		emit Authorized(organization, account);
	}

	/**
	 * @dev Revoke the specified `account` authorization to call the `organization`
	 * contract.
	 *
	 * Requirements:
	 * - the caller must be one of the `organization` admin
	 */
	function revoke(address organization, address account) public onlyOrgAdmin(organization) {
		_authorizations[organization][account] = false;
		emit Revoked(organization, account);
	}

	/**
	 * @dev Performs a Solidity function call using a low level `call` with the
	 * given `data` on the `to` contract target. It ensures that the sender is
	 * authorized to execute the call on the `to` target
	 */
	function execute(address to, bytes memory data) public onlyAuthorized(to) returns (bool) {
		(bool success, bytes memory returnData) = to.call(data);
		require(success, string(returnData));
		emit Executed(to, data);
		return success;
	}

	/**
	 * @dev returns the authorization of organization and account
	 */
	function isAuthorized(address organization, address account) public view returns (bool) {
		return _authorizations[organization][account];
	}
}