// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MockStrategy
/// @notice Simulasi strategy untuk testing & demo Vault
/// @dev BUKAN untuk production

import "../interfaces/IERC20.sol";

contract MockStrategy {
    address public immutable vault;
    address public immutable asset;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event YieldSimulated(uint256 amount);

    modifier onlyVault() {
        require(msg.sender == vault, "not vault");
        _;
    }

    constructor(address _vault, address _asset) {
        require(_vault != address(0), "vault=0");
        require(_asset != address(0), "asset=0");
        vault = _vault;
        asset = _asset;
    }

    function deposit(uint256 amount) external onlyVault {
        require(amount > 0, "zero amount");
        require(
            IERC20(asset).transferFrom(vault, address(this), amount),
            "transfer failed"
        );
        emit Deposit(amount);
    }

    function withdraw(uint256 amount) external onlyVault {
        require(amount > 0, "zero amount");
        require(
            IERC20(asset).transfer(vault, amount),
            "transfer failed"
        );
        emit Withdraw(amount);
    }

    function totalAssets() external view returns (uint256) {
        return IERC20(asset).balanceOf(address(this));
    }

    function simulateYield(uint256 amount) external {
        require(amount > 0, "zero amount");
        require(
            IERC20(asset).transferFrom(msg.sender, address(this), amount),
            "transfer failed"
        );
        emit YieldSimulated(amount);
    }
}
