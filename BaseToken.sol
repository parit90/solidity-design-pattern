// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


import "./IOrganization.sol";
import "./IBaseToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "./SafeMath.sol";
// import "./SafeCast.sol";

import "hardhat/console.sol";


contract BaseToken is IBaseToken, ERC20{
    IOrganization private _organization;
	// using SafeMath for uint256;
	
	modifier onlyAdmin() {
		require(
			organization() == _msgSender() || _organization.isAdmin(_msgSender()),
			"ERC20: caller is not authorized"
		);
		_;
	}

	struct RoleAccounting {
		int256 minted;
		int256 burned;
		int256 spendIn;
		int256 spendOut;
		int256 adjustIn;
		int256 adjustOut;
	}

	// Accounting data for the whole contract
	struct GlobalAccounting {
		int256 minted;
		int256 burned;
	}
	GlobalAccounting public _globalAccounting;
	mapping(bytes32 => RoleAccounting) public _roleAccounting;
	//"BaseToken1", "BT", 2, 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47
	constructor(string memory _name, string memory _symbol, uint8 _decimals, address _org) ERC20(_name, _symbol) {
		console.log("BaseToken Call");
		// _setupDecimals(_decimals);
		_organization = IOrganization(_org);
	}

	function mint(address account, uint256 amount) public override onlyAdmin returns (bool) {
		_mint(account, amount);
		return true;
	}

	function _mint(address account, uint256 amount) internal override {
		super._mint(account, amount);

		bytes32 accRole = _userRole(account);
		_globalAccounting.minted = _globalAccounting.minted + int256(amount);
		_roleAccounting[accRole].minted = _roleAccounting[accRole].minted + int256(amount);
	}

	function organization() public view override returns (address) {
		return address(_organization);
	}

	function _userRole(address _account) internal returns (bytes32) {
		console.log("_UserRole in BaseToken .....",_account);
		if (_account == address(0x0)) {
			return bytes32(0x0);
		}
		return _organization.userRole(_account);
	}
}