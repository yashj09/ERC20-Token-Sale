// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenSale is Ownable, ReentrancyGuard {
    IERC20 public token;
    uint256 public price;
    uint256 public saleStart;
    uint256 public saleEnd;
    uint256 public constant TRANSFER_LIMIT_DURATION = 1 hours;
    uint256 public constant TRANSFER_LIMIT_AMOUNT = 1000000 * 10 ** 18;

    mapping(address => uint256) private _lastPurchaseTimestamp;
    mapping(address => uint256) private _purchasedAmount;

    event TokensPurchased(address buyer, uint256 amount);

    constructor(
        IERC20 _token,
        uint256 _price,
        uint256 _saleStart,
        uint256 _saleEnd
    ) Ownable(msg.sender) {
        require(_saleEnd > _saleStart, "Sale end must be after sale start");
        token = _token;
        price = _price;
        saleStart = _saleStart;
        saleEnd = _saleEnd;
    }

    function buyTokens() public payable nonReentrant {
        require(
            block.timestamp >= saleStart && block.timestamp <= saleEnd,
            "Sale is not active"
        );
        require(msg.value > 0, "Must send ETH to buy tokens");
        uint256 tokenAmount = (msg.value * 10 ** 18) / price;
        require(
            _canPurchase(msg.sender, tokenAmount),
            "Purchase limit exceeded"
        );
        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "Not enough tokens in the contract"
        );

        bool sent = token.transfer(msg.sender, tokenAmount);
        require(sent, "Token transfer failed");

        emit TokensPurchased(msg.sender, tokenAmount);
    }

    function _canPurchase(
        address buyer,
        uint256 amount
    ) internal returns (bool) {
        if (
            block.timestamp - _lastPurchaseTimestamp[buyer] >=
            TRANSFER_LIMIT_DURATION
        ) {
            _lastPurchaseTimestamp[buyer] = block.timestamp;
            _purchasedAmount[buyer] = amount;
        } else {
            _purchasedAmount[buyer] += amount;
        }
        return _purchasedAmount[buyer] <= TRANSFER_LIMIT_AMOUNT;
    }

    function withdrawFunds() public onlyOwner {
        uint256 balance = address(this).balance;
        (bool sent, ) = payable(owner()).call{value: balance}("");
        require(sent, "Failed to send Ether");
    }

    function withdrawUnsoldTokens() public onlyOwner {
        require(block.timestamp > saleEnd, "Sale has not ended yet");
        uint256 balance = token.balanceOf(address(this));
        bool sent = token.transfer(owner(), balance);
        require(sent, "Token transfer failed");
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function setSalePeriod(
        uint256 _saleStart,
        uint256 _saleEnd
    ) public onlyOwner {
        require(_saleEnd > _saleStart, "Sale end must be after sale start");
        saleStart = _saleStart;
        saleEnd = _saleEnd;
    }
}
