// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/W3BCXISoulboundToken.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        W3BCXISoulboundToken W3BCXISBT = new W3BCXISoulboundToken();
        console.log("W3BCXISoulboundToken Contract deployed to: ", address(W3BCXISBT));

        vm.stopBroadcast();
    }
}