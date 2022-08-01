// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ITokenFactory {
	event ExpiringTokenCreated(address, address, string);
function newExpiringToken(
		bytes32,
        string calldata name,
		string calldata symbol,
		uint8 decimals,
		address
	) payable external;

	function newPerpetualToken(
		bytes32,
		string calldata name,
		string calldata symbol,
		uint8 decimals,
		address
	) external;

	function newUniqueToken(
        string calldata name,
		string calldata symbol,
		address
	) external;
}