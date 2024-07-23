// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import "../src/interface/IW3BCXISoulboundToken.sol";

contract BatchDeployScript is Script {
    IW3BCXISoulboundToken public W3BCXISBT;

    function setUp() public {
        address W3BCXISBTContractAddress = 0x27e28cF55A319E6aF0b7a23D8b623b8bc2c50485;
        W3BCXISBT = IW3BCXISoulboundToken(W3BCXISBTContractAddress);
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Read addresses from CSV file
        string memory csvFile = vm.readFile("addresses.csv");
        address[] memory addresses = parseAddresses(csvFile);

        W3BCXISBT.addToWhitelist(addresses);
        W3BCXISBT.batchMint(addresses);

        vm.stopBroadcast();
    }

    function parseAddresses(string memory _csvFile) internal pure returns (address[] memory) {
        bytes memory csvData = bytes(_csvFile);
        uint256 addressCount = 1; // Start with 1 to account for the last line

        // Count number of addresses (newline characters)
        for (uint256 i = 0; i < csvData.length; i++) {
            if (csvData[i] == 0x0A) { // newline character
                addressCount++;
            }
        }

        address[] memory addresses = new address[](addressCount);
        uint256 addressIndex = 0;
        uint256 startIndex = 0;

        for (uint256 i = 0; i < csvData.length; i++) {
            if (csvData[i] == 0x0A || i == csvData.length - 1) { // newline or end of file
                uint256 endIndex = i == csvData.length - 1 ? i + 1 : i;
                bytes memory addressBytes = new bytes(endIndex - startIndex);
                for (uint256 j = startIndex; j < endIndex; j++) {
                    addressBytes[j - startIndex] = csvData[j];
                }
                addresses[addressIndex] = parseAddress(string(addressBytes));
                addressIndex++;
                startIndex = i + 1;
            }
        }

        return addresses;
    }

    function parseAddress(string memory _addressString) internal pure returns (address) {
        bytes memory stringBytes = bytes(_addressString);
        uint160 convertedAddress = 0;
        for (uint i = 0; i < 40; i++) {
            convertedAddress *= 16;
            uint8 b = uint8(stringBytes[i]);
            if (b >= 48 && b <= 57) {
                convertedAddress += (b - 48);
            } else if (b >= 65 && b <= 70) {
                convertedAddress += (b - 55);
            } else if (b >= 97 && b <= 102) {
                convertedAddress += (b - 87);
            } else {
                revert("Invalid address format");
            }
        }
        return address(convertedAddress);
    }
}