// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Chainstore} from "../src/Chainstore.sol";

contract DeployChainstore is Script {
    function run() external returns (Chainstore) {
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");

        vm.startBroadcast();
        Chainstore chainStore = new Chainstore("Chainstore", "CHS", deployer);
        vm.stopBroadcast();
        
        return chainStore;
    }
}
