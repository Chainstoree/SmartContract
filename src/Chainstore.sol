// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title A simple pay to earn NFT Contract
 * @author Daniel Nwachukwu (DevDanny)
 * @notice This contract is for Onboardig web2 stores to a web3 standard
 * @dev Impements Payment to NFT Mint
 */
contract Chainstore is ERC721URIStorage, Ownable {
    error Chainstore_NotEnoughETh();
    uint256 private s_tokenIds;
    uint256 public s_productPrice;

    constructor(string memory name, string memory symbol, address chainStoreOwner) ERC721(name, symbol) Ownable(chainStoreOwner){}

    function setProductPrice(uint256 _price) internal {
        s_productPrice = _price;
    }

    function buyProduct(string memory _tokenURI, uint256 _price) external payable {
        setProductPrice(_price);
        if(msg.value < s_productPrice){
            revert Chainstore_NotEnoughETh();

        }

        s_tokenIds += 1;
        uint256 newNftId = s_tokenIds;

        _mint(msg.sender, newNftId);
        _setTokenURI(newNftId, _tokenURI);

    }

    function _setTokenURI(uint256 _tokenId, string memory _tokenURI) internal virtual override{
        super._setTokenURI(_tokenId, _tokenURI);
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}