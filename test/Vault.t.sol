// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Vault {
    IERC20 public immutable asset;
    address public owner;
    address public strategy;

    uint256 public totalShares;
    mapping(address => uint256) public shares;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address _asset) {
        asset = IERC20(_asset);
        owner = msg.sender;
    }

    /* =========================
            VIEW
    ========================= */

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    /* =========================
            CORE
    ========================= */

    function deposit(uint256 assets) external returns (uint256 sharesMinted) {
        require(assets > 0, "zero assets");

        if (totalShares == 0) {
            // first depositor 1:1
            sharesMinted = assets;
        } else {
            sharesMinted = (assets * totalShares) / totalAssets();
        }

        totalShares += sharesMinted;
        shares[msg.sender] += sharesMinted;

        asset.transferFrom(msg.sender, address(this), assets);
    }

    function withdraw(uint256 sharesAmount) external returns (uint256 assetsOut) {
        require(shares[msg.sender] >= sharesAmount, "not enough shares");

        assetsOut = (sharesAmount * totalAssets()) / totalShares;

        shares[msg.sender] -= sharesAmount;
        totalShares -= sharesAmount;

        asset.transfer(msg.sender, assetsOut);
    }

    /* =========================
        ADMIN
    ========================= */

    function setStrategy(address _strategy) external onlyOwner {
        strategy = _strategy;
    }
}
