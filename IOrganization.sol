// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


interface IOrganization {
    	event TokenAdded(address indexed token);
        event RoleAdjusted(address indexed account, address indexed organization, bytes32 indexed role);
        function registerToken(address token, bytes32 tokenId) external;
        function isAdmin(address) external returns (bool);
        function userRole(address) external returns (bytes32);
        function hasToken(address token) external  returns (bool);
        function getTokensCount() external returns (uint256);
        function getTokenAt(uint256 index) external returns (address, bytes32);
        function mint(address, address, uint256) external;
        function adjustUserRole(address , bytes32 ) external;
}
