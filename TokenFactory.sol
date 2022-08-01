// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IOrganization.sol";
import "./ITokenFactory.sol";
import "./BaseToken.sol";
import "./ExpiringToken.sol";
import "./UniqueToken.sol";
import "hardhat/console.sol";

contract TokenFactory is ITokenFactory{

	modifier onlyOrgAdmin(address organization) {
		console.log("TokenFactory The organization onlyOrgAdmin modf.....", msg.sender);
		console.log("TokenFactory......",IOrganization(organization).isAdmin(msg.sender));
		require(IOrganization(organization).isAdmin(msg.sender), "TokenFactory: not an organization admin");
		_;
	}
	//0x5b610e8e1835afecdd154863369b91f55612defc17933f83f4425533c435a248, ExpTok, Ex1,2,0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d
    //0xe024e001b099b5b800bcb3a6ffdf2f2525808b14a5dc25c0c81bcc58907e1cb6, ExpTok2, Ex2,2
	constructor(){
        console.log("This is tokenFactory constructor");
        console.log("Address of Token Factory from Token Factory", address(this));
    }
	// @inheritdoc ITokenFactory
	function newExpiringToken(
		bytes32 tokenId,
		string calldata name,
		string calldata symbol,
		uint8 decimals,
		address organization
	) public payable override onlyOrgAdmin(organization){
		ExpiringToken token = new ExpiringToken(name, symbol, decimals, organization);
		IOrganization(organization).registerToken(address(token), tokenId);
		emit ExpiringTokenCreated(organization, address(token), symbol);

	}
//0x5b610e8e1835afecdd154863369b91f55612defc17933f83f4425533c435a248, "ExpToken", "ExpTk", 2, 0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47
	//0x5b610e8e1835afecdd154863369b91f55612defc17933f83f4425533c435a248,"ExpToken","ExpT1",2, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4


	// @inheritdoc ITokenFactory
	function newPerpetualToken(
		bytes32 tokenId,
		string calldata name,
		string calldata symbol,
		uint8 decimals,
		address organization
	) public override onlyOrgAdmin(organization){
		BaseToken token = new BaseToken(name, symbol, decimals, organization);
		IOrganization(organization).registerToken(address(token), tokenId);
	}

	// @inheritdoc ITokenFactory
	function newUniqueToken(
		string calldata name,
		string calldata symbol,
		address organization
	) public override onlyOrgAdmin(organization){
		UniqueToken token = new UniqueToken(name, symbol);
	}
}