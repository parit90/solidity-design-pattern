// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBaseToken is IERC20 {
    	function mint(address account, uint256 amount) external returns (bool);
        function organization() external returns (address);
}