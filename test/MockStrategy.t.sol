// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/mocks/MockERC20.sol";
import "../src/mocks/MockStrategy.sol";

contract MockStrategyTest is Test {
    MockERC20 token;
    MockStrategy strategy;

    address vault;
    address alice;

    function setUp() public {
        vault = makeAddr("vault");
        alice = makeAddr("alice");

        token = new MockERC20("Mock Token", "MOCK");
        strategy = new MockStrategy(vault, address(token));

        // supply awal
        token.mint(vault, 1_000 ether);
        token.mint(alice, 500 ether);
    }

    /*//////////////////////////////////////////////////////////////
                                DEPOSIT
    //////////////////////////////////////////////////////////////*/

    function testDepositByVault() public {
        vm.startPrank(vault);
        token.approve(address(strategy), 200 ether);

        strategy.deposit(200 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(address(strategy)), 200 ether);
        assertEq(token.balanceOf(vault), 800 ether);
    }

    function testDepositFailIfNotVault() public {
        vm.prank(alice);
        vm.expectRevert("not vault");
        strategy.deposit(100 ether);
    }

    /*//////////////////////////////////////////////////////////////
                                WITHDRAW
    //////////////////////////////////////////////////////////////*/

    function testWithdrawByVault() public {
        vm.startPrank(vault);
        token.approve(address(strategy), 300 ether);
        strategy.deposit(300 ether);

        strategy.withdraw(150 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(address(strategy)), 150 ether);
        assertEq(token.balanceOf(vault), 850 ether);
    }

    function testWithdrawFailIfNotVault() public {
        vm.prank(alice);
        vm.expectRevert("not vault");
        strategy.withdraw(50 ether);
    }

    /*//////////////////////////////////////////////////////////////
                            TOTAL ASSETS
    //////////////////////////////////////////////////////////////*/

    function testTotalAssets() public {
        vm.startPrank(vault);
        token.approve(address(strategy), 100 ether);
        strategy.deposit(100 ether);
        vm.stopPrank();

        uint256 assets = strategy.totalAssets();
        assertEq(assets, 100 ether);
    }

    /*//////////////////////////////////////////////////////////////
                           SIMULATE YIELD
    //////////////////////////////////////////////////////////////*/

    function testSimulateYield() public {
        vm.startPrank(alice);
        token.approve(address(strategy), 50 ether);
        strategy.simulateYield(50 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(address(strategy)), 50 ether);
    }
}
