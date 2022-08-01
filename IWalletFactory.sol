// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IWalletFactory {
    	event ProxyWalletCreated(address indexed wallet, bytes32 indexed role);
        //function registrar() external view returns (address);
        function newWallet(bytes32 role) external;
}