// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/Vault.sol";
import "../src/mocks/MockERC20.sol" as MockERC20;
import "../src/mocks/MockStrategy.sol" as MockStrategy;

contract Deploy is Script {
    function run() external {
        // ambil private key dari env
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);

        vm.startBroadcast(deployerKey);

        // 1. Deploy MockERC20
        MockERC20.MockERC20 asset = new MockERC20.MockERC20("Mock USD", "mUSD");

        // 2. Deploy Vault
        Vault vault = new Vault(address(asset));

        // 3. Deploy MockStrategy
        MockStrategy.MockStrategy strategy = new MockStrategy.MockStrategy(
            address(vault),
            address(asset)
        );

        // 4. Set strategy ke vault
        vault.setStrategy(address(strategy));

        // 5. Mint token ke deployer (demo liquidity)
        asset.mint(deployer, 1_000 ether);

        vm.stopBroadcast();

        console.log("MockERC20 deployed at:", address(asset));
        console.log("Vault deployed at:", address(vault));
        console.log("Strategy deployed at:", address(strategy));
        console.log("Deployer:", deployer);
    }
}
