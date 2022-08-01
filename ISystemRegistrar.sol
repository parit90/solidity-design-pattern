// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ITokenFactory.sol";
import "./IWalletFactory.sol";
import "./IOrganizationFactory.sol";
import "./SystemAccessControl.sol";

interface ISystemRegistrar {
    	function accessControl() external view returns (SystemAccessControl);
		function registerOrganization(address _ac, bytes32 label, address organization) external;
		function getOrganizationLength() external returns(uint256);
		function tokenFactory() external returns(ITokenFactory);
}