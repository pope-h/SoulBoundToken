// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IW3BCXISoulboundToken {

    function addToWhitelist(address[] memory addresses) external;

    function removeFromWhitelist(address[] memory addresses) external;

    function mint() external;

    function batchMint(address[] memory addresses) external;

    function isWhitelisted(address account) external view returns (bool);

    function hasMinted(address account) external view returns (bool);
}