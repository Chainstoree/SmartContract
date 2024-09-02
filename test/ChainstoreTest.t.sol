// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Chainstore} from "../src/Chainstore.sol";

contract ChainstoreTest is Test {
    Chainstore public chainStore;
    address public owner = address(0xABC);
    address public buyer = address(0x123);

    function setUp() public { 
        chainStore = new Chainstore("Chainstore", "CHS", owner);

    } 

    function testProductPrice() public {
        vm.deal(buyer, 1 ether);

        vm.prank(buyer);
        chainStore.buyProduct{value: 0.01 ether}("ipfs://example_token_uri", 0.01 ether);
        
        assertEq(chainStore.s_productPrice(), 0.01 ether);
    }

    function testSuccesfulPurchase() public {
        vm.deal(buyer , 1 ether);

        vm.prank(buyer);
        chainStore.buyProduct{value: 0.01 ether}("ipfs://example_token_uri", 0.01 ether);


        assertEq(chainStore.ownerOf(1), buyer);

    }
    function testUnsuccefullPurchase() public {
        vm.deal(buyer, 1 ether);
        
        vm.expectRevert(Chainstore.Chainstore_NotEnoughETh.selector);
        
        vm.prank(buyer);
        chainStore.buyProduct{value: 0.001 ether}("ipfs://example_token_uri", 0.01 ether);

    }

    function testWithdraw() public {
        vm.deal(buyer, 1 ether);

        vm.prank(buyer);
        chainStore.buyProduct{value: 0.01 ether}("ipfs://example_token_uri", 0.01 ether);

        uint256 initialOwnerBalance = owner.balance;
        uint256 chainStoreBalance = address(chainStore).balance;

        assertEq(chainStoreBalance, 0.01 ether);

        vm.prank(owner);
        chainStore.withdraw();

        assertEq(owner.balance, initialOwnerBalance + chainStoreBalance);
    }
}