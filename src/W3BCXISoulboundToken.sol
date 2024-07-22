// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract W3BCXISoulboundToken is ERC20, Ownable {
    mapping(address => bool) private _whitelist;
    mapping(address => bool) private _hasMinted;

    uint256 public constant TOKENS_PER_MINT = 1 * 10**18;
    string public constant NAME = "WEB3CXI";
    string public constant SYMBOL = "W3CXI";

    constructor() ERC20(NAME, SYMBOL) Ownable(msg.sender) {}

    function addToWhitelist(address[] memory addresses) external onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            _whitelist[addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address[] memory addresses) external onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            _whitelist[addresses[i]] = false;
        }
    }

    function mint() external {
        require(_whitelist[msg.sender], "Address is not whitelisted");
        require(!_hasMinted[msg.sender], "Address has already minted");

        _hasMinted[msg.sender] = true;
        _mint(msg.sender, TOKENS_PER_MINT);
    }

    function batchMint(address[] memory addresses) external onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            address recipient = addresses[i];
            require(_whitelist[recipient], "Address is not whitelisted");
            require(!_hasMinted[recipient], "Address has already minted");

            _hasMinted[recipient] = true;
            _mint(recipient, TOKENS_PER_MINT);
        }
    }

    function _update(address from, address to, uint256 amount)
        internal
        override
    {
        require(from == address(0) || to == address(0), "This token is not transferable");
        super._update(from, to, amount);
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelist[account];
    }

    function hasMinted(address account) public view returns (bool) {
        return _hasMinted[account];
    }
}