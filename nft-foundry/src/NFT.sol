// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/src/tokens/ERC721.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/access/Ownable.sol";

// 当用户尝试铸造 NFT 时，如果支付的金额不足，就会触发此错误。
error MintPriceNotPaid();
// 当用户尝试铸造 NFT 时，如果超过最大供应量，就会触发此错误。
error MaxSupply();
// 当用户尝试获取不存在的 Token URI(NFT元数据) 时，会触发此错误。
error NonExistentTokenURI();

contract NFT is ERC721, Ownable {
    using Strings for uint256;
    // 定义合约的基础 URI，用于获取 NFT 的元数据。
    string public baseURI;
    /* 
    引入一个变量，主要作用记录当前的NF_ID；
    每铸造一个NFT，currentTokenId就会增加1，指向下一个即将被铸造的 NFT 的 TokenId；
    这样，我们就能确保每个 NFT 都拥有唯一的编号；
     */
    uint256 public currentTokenId;
    uint256 public constant MAX_CAPACITY = 10_000;
    // 铸造NFT需要支付0.05 ETH
    uint256 public constant MINT_PRICE = 0.05 ether;

    // 初始化ERC721合约
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
        ) ERC721(_name, _symbol) Ownable(msg.sender) {
            baseURI = _baseURI;
    }

    // 根据给定的铸造地址来铸造一个 NFT，并在合约中记录，使其与 TokenId 一一对应
    function mintTo(address recipient) public payable returns(uint256) {
         if (recipient == address(0)) {
            revert("INVALID_RECIPIENT");
        }
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }

        uint256 newItemId = ++currentTokenId;

         if (newItemId > MAX_CAPACITY) {
            revert MaxSupply();
        }

        _safeMint(recipient, newItemId);
        return newItemId;
    }
    
    // 通过实现 tokenURI 函数，可以灵活地控制每个 NFT 的元数据如何存储和检索。
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {

        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }

        if (bytes(baseURI).length > 0) {
            return string(abi.encodePacked(baseURI, tokenId.toString()));
        } else {
            return "";
        }
        
    }

}