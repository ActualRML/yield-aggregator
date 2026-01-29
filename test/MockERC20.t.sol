// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/mocks/MockERC20.sol";

contract MockERC20Test is Test {
    MockERC20 token;

    address alice;
    address bob;

    function setUp() public {
        alice = makeAddr("alice");
        bob   = makeAddr("bob");

        token = new MockERC20("Mock Token", "MOCK");
    }

    // MINT

    function testMintIncreasesBalanceAndTotalSupply() public {
        token.mint(alice, 100 ether);

        assertEq(token.balanceOf(alice), 100 ether);
        assertEq(token.totalSupply(), 100 ether);
    }

    function testMintEmitTransferEvent() public {
        vm.expectEmit(true, true, false, true);
        emit MockERC20.Transfer(address(0), alice, 50 ether);

        token.mint(alice, 50 ether);
    }

    // TRANSFER

    function testTransferSuccess() public {
        token.mint(alice, 100 ether);

        vm.prank(alice);
        bool ok = token.transfer(bob, 40 ether);

        assertTrue(ok);
        assertEq(token.balanceOf(alice), 60 ether);
        assertEq(token.balanceOf(bob), 40 ether);
    }

    function testTransferFailInsufficientBalance() public {
        vm.prank(alice);
        vm.expectRevert("insufficient balance");
        token.transfer(bob, 10 ether);
    }

    // APPROVE

    function testApproveSetsAllowance() public {
        vm.prank(alice);
        bool ok = token.approve(bob, 25 ether);

        assertTrue(ok);
        assertEq(token.allowance(alice, bob), 25 ether);
    }

    // TRANSFER FROM

    function testTransferFromSuccess() public {
        token.mint(alice, 100 ether);

        vm.prank(alice);
        token.approve(bob, 50 ether);

        vm.prank(bob);
        bool ok = token.transferFrom(alice, bob, 30 ether);

        assertTrue(ok);
        assertEq(token.balanceOf(alice), 70 ether);
        assertEq(token.balanceOf(bob), 30 ether);
        assertEq(token.allowance(alice, bob), 20 ether);
    }

    function testTransferFromFailAllowanceExceeded() public {
        token.mint(alice, 100 ether);

        vm.prank(bob);
        vm.expectRevert("allowance exceeded");
        token.transferFrom(alice, bob, 10 ether);
    }
}
