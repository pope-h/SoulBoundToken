// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import "../src/interface/IW3BCXISoulboundToken.sol";

contract InteractionScript is Script {
    IW3BCXISoulboundToken public W3BCXISBT;

    function setUp() public {
        address W3BCXISBTContractAddress = 0x27e28cF55A319E6aF0b7a23D8b623b8bc2c50485;
        W3BCXISBT = IW3BCXISoulboundToken(W3BCXISBTContractAddress);
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address[] memory addresses = new address[](2);
        addresses[0] = 0xbf4EE65FE67C291DfC34ffe2455ecA9d97DF9148;
        addresses[1] = 0xb7B943fFbA78e33589971e630AD6EB544252D88C;

        W3BCXISBT.addToWhitelist(addresses);

        vm.stopBroadcast();
    }
}
