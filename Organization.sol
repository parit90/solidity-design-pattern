// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IOrganization.sol";
import "./ISystemRegistrar.sol";
import "./IUniqueToken.sol";
import "./BaseToken.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Organization is IOrganization, AccessControl { 
        // Accounts w/ `ORG_ADMIN_MANAGER_ROLE` can add/remove `ORG_ADMIN` accounts
	    bytes32 public constant ORG_ADMIN_MANAGER_ROLE = keccak256("ORG_ADMIN_MANAGER_ROLE");
	    // Only accounts w/ `ORG_ADMIN_ROLE` can execute `onlyAdmin` actions
	    bytes32 public constant ORG_ADMIN_ROLE = keccak256("ORG_ADMIN_ROLE");

		mapping(address => bytes32) public _userRole;

		mapping(bytes32 => address) public _tokensAddress;
		// Mapping from token contract address to token ID (bytes32)
		mapping(address => bytes32) public _tokensId;
		// List of registered token addresses
		address[] public _tokens;
    	// The system registrar
	    ISystemRegistrar public immutable registrar;
		/**
		* @dev Ensures that the caller is an Organization administrator or the given address
		*/
		modifier onlyAdminOr(address expectedSender) {
			console.log("inside Organization modf msg.sender.....",msg.sender);
			console.log("inside Organization modf expectedSender.....",expectedSender);
			console.log("inside Organization modf isAdmin.....",isAdmin(msg.sender));
			
			require(msg.sender == expectedSender || isAdmin(msg.sender), "Organization: not an admin *onlyAdminOr*");
			_;
		}
		modifier onlyValidTokens(address tokens) {
			//for (uint256 i = 0; i < tokens.length; i += 1) {
				_ensureTokenValidity(tokens);
			//}
			_;
		}

		modifier onlyAdmin {
			require(isAdmin(msg.sender), "Organization: not an admin *onlyAdmin*");
			_;
		}

		// _sender is 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 which is second account
    	constructor(address _registrar, address _sender) {
			console.log("~~~~~~~Organization Invocation~~~~~~~~~");
		// Accounts w/ `ORG_ADMIN_MANAGER_ROLE` can grant/revoke other `ORG_ADMIN_MANAGER` accounts
		_setRoleAdmin(ORG_ADMIN_MANAGER_ROLE, ORG_ADMIN_MANAGER_ROLE);
		// Accounts w/ `ORG_ADMIN_MANAGER_ROLE` can grant/revoke `ORG_ADMIN` accounts
		_setRoleAdmin(ORG_ADMIN_ROLE, ORG_ADMIN_MANAGER_ROLE);
		// By default, the contract creator is an `ORG_ADMIN_MANAGER`
		_setupRole(ORG_ADMIN_MANAGER_ROLE, _sender);

		registrar = ISystemRegistrar(_registrar);
	}

	function registerToken(address token, bytes32 _tokenId) public override onlyAdminOr(address(registrar.tokenFactory())){
		console.log("Inside Register Token call.....");
		bytes32 _test = _tokenId;
		_tokensAddress[_test] = address(token);
		_tokensId[token] = _test;
		_tokens.push(token);
		emit TokenAdded(token); 
	}

		/// @inheritdoc IOrganization
	function isAdmin(address account) public view override returns (bool) {
		return hasRole(ORG_ADMIN_ROLE, account);
	}

		// @inheritdoc IOrganization
	function userRole(address account) public view override returns (bytes32) {
		return _userRole[account];
	}
	// get token count
	function getTokensCount() public view override returns (uint256) {
		return _tokens.length;
	}

	// @inheritdoc IOrganization
	function getTokenAt(uint256 index) public view override returns (address token, bytes32 id) {
		require(index < _tokens.length, "Organization: index out of bounds");
		token = _tokens[index];
		return (token, _tokensId[token]);
	}

	function mint(
		address  tokens,
		address  accounts,
		uint256  values
	) public override onlyAdmin onlyValidTokens(tokens) {
		// require(accounts.length == values.length, "Organization: accounts and values length mismatch");
		// require(accounts.length == tokens.length, "Organization: accounts and tokens length mismatch");
		//for (uint256 i = 0; i < accounts.length; i += 1) {
			IBaseToken(tokens).mint(accounts, values);
		//}
		console.log("inside minted method.....");
	}

	function _ensureTokenValidity(address token) internal view {
		require(hasToken(token), "Organization: unknown token");
	}

		// @inheritdoc IOrganization
	function hasToken(address token) public view override returns (bool) {
		return _tokensId[token] != bytes32(0x0);
	}

	// @inheritdoc IOrganization
	function adjustUserRole(address account, bytes32 role) public override onlyAdmin {
		_userRole[account] = role;
		emit RoleAdjusted(account, address(this), role);
	}
}