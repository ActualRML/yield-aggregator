// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "./interfaces/IERC20.sol";

interface IStrategy {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function totalAssets() external view returns (uint256);
}

contract Vault {
    address public immutable ASSET;
    uint256 public totalShares;
    mapping(address => uint256) public shares;
    address public strategy;

    address public owner;
    bool private locked;

    event Deposit(address indexed from, uint256 assets, uint256 sharesMinted);
    event Withdraw(address indexed to, uint256 assets, uint256 sharesBurned);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "reentrancy");
        locked = true;
        _;
        locked = false;
    }

    constructor(address _asset) {
        require(_asset != address(0), "invalid asset");
        ASSET = _asset;
        owner = msg.sender;
    }

    /// @notice Total assets managed by vault (vault + strategy)
    function totalAssets() public view returns (uint256) {
        uint256 vaultBal = IERC20(ASSET).balanceOf(address(this));

        if (strategy == address(0)) {
            return vaultBal;
        }

        return vaultBal + IStrategy(strategy).totalAssets();
    }

    function deposit(uint256 assets)
        external
        nonReentrant
        returns (uint256 sharesMinted)
    {
        require(assets > 0, "assets = 0");

        uint256 _totalAssets = totalAssets();
        uint256 _totalShares = totalShares;

        if (_totalShares == 0) {
            sharesMinted = assets;
        } else {
            sharesMinted = (assets * _totalShares) / _totalAssets;
        }

        require(sharesMinted > 0, "no share minted");

        require(
            IERC20(ASSET).transferFrom(msg.sender, address(this), assets),
            "transfer failed"
        );

        shares[msg.sender] += sharesMinted;
        totalShares += sharesMinted;

        // deploy funds to strategy if set
        if (strategy != address(0)) {
            IERC20(ASSET).approve(strategy, assets);
            IStrategy(strategy).deposit(assets);
        }

        emit Deposit(msg.sender, assets, sharesMinted);
    }

    function withdraw(uint256 sharesBurn)
        external
        nonReentrant
        returns (uint256 assetsOut)
    {
        require(sharesBurn > 0, "shares = 0");
        require(shares[msg.sender] >= sharesBurn, "not enough shares");

        uint256 _totalShares = totalShares;
        uint256 _totalAssets = totalAssets();

        assetsOut = (sharesBurn * _totalAssets) / _totalShares;
        require(assetsOut > 0, "no asset");

        shares[msg.sender] -= sharesBurn;
        totalShares -= sharesBurn;

        uint256 vaultBal = IERC20(ASSET).balanceOf(address(this));

        // pull from strategy if vault balance insufficient
        if (vaultBal < assetsOut) {
            uint256 need = assetsOut - vaultBal;
            IStrategy(strategy).withdraw(need);
        }

        require(
            IERC20(ASSET).transfer(msg.sender, assetsOut),
            "transfer failed"
        );

        emit Withdraw(msg.sender, assetsOut, sharesBurn);
    }

    /// @notice Set strategy address (owner only)
    function setStrategy(address _strategy) external onlyOwner {
        require(_strategy != address(0), "invalid strategy");
        strategy = _strategy;
    }
}
