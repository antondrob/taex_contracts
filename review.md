# Review of the taex_contracts repository

## Process

During the review process, contracts goes through the following procedures:

1. Generating and running the reports of the static analyzer tools.

    Slither and Aderyn static analyzer tools was used to generate the following reports:
        a. [Slither report](./slither_run.md)
        b. [Aderyn report](./report.md)

2. Manual review of the contracts.

### Not so good practices

1. The tests coverage is poor. Consider increasing at it at least to 85%.

   By now coverage report is following:

   ```bash
     npx hardhat coverage

    Version
    =======
    > solidity-coverage: v0.8.13

    Instrumenting for coverage...
    =============================

    > SaleNFT.sol
    > TaexNFT.sol
    > TaexNFT1155.sol

    Compilation:
    ============

    Compiled 22 Solidity files successfully (evm target: paris).

    Network Info
    ============
    > HardhatEVM: v2.22.10
    > network:    hardhat



    TaexNFT
        1) "before each" hook for "check if deploy initialized correctly"


    0 passing (33ms)
    1 failing

    1) TaexNFT
        "before each" hook for "check if deploy initialized correctly":
        Error: incorrect number of arguments to constructor
        at ContractFactory.getDeployTransaction (node_modules/ethers/src.ts/contract/factory.ts:87:19)
        at ContractFactory.deploy (node_modules/ethers/src.ts/contract/factory.ts:105:31)
        at Context.<anonymous> (test/TaexNFT.js:18:44)



    ------------------|----------|----------|----------|----------|----------------|
    | File               | % Stmts    | % Branch   | % Funcs    | % Lines    | Uncovered Lines  |
    | ------------------ | ---------- | ---------- | ---------- | ---------- | ---------------- |
    | contracts/         | 0          | 0          | 0          | 0          |                  |
    | SaleNFT.sol        | 0          | 0          | 0          | 0          | ... 191,200,210  |
    | TaexNFT.sol        | 0          | 0          | 0          | 0          | ... 132,147,160  |
    | TaexNFT1155.sol    | 0          | 0          | 0          | 0          | ... 163,169,184  |
    | ------------------ | ---------- | ---------- | ---------- | ---------- | ---------------- |
    | All files          | 0          | 0          | 0          | 0          |                  |
    | ------------------ | ---------- | ---------- | ---------- | ---------- | ---------------- |

    > Istanbul reports written to ./coverage/ and ./coverage.json
    Error in plugin solidity-coverage: ❌ 1 test(s) failed under coverage.
   ```

2. Floating pragma in contracts.
    Consider using the fixed version of Solidity, rather than floating

    ```diff
    -   pragma solidity ^0.8.20;
    +   pragma solidity 0.8.20;
    ```

3. Consider use exact imports over the wildcard imports.

    ```diff
    -    import "@openzeppelin/contracts/access/Ownable.sol";
    +    import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
    ```

4. Using custom errors in require statements rather than error strings.

    ```diff
    ...
    -    require(owner != address(0), "SaleNFT: zero address");
    ...
    +    error SaleNFT_ZeroAddress();
    +    require(owner != address(0), "SaleNFT: zero address");
    ```

5. `SaleNFT` uses `ITaexNFT` interface to interact with `TaexNFT` and `TaexNFT1155`. However interface is not inherited by the NFT contracts.

6. Add NatSpec documentation to the contract code.

### Security assumptions


1. `transferFrom` in `SaleNFT.sol` -> better use safeTransferFrom.  

    `primarySale` & `secondarySale` functions uses `transferFrom`, however it's recommended to use  `safeTransferFrom`. Also in `TaexNFT1155.sol` `safeTransferFrom` is wrapped by `transferFrom` method which is not good for code understanding.

2. The fees values can block sales if set incorrectly.

    There is no mechanism in `TaexNFT.sol` and `TaexNFT1155.sol` to guarantee that `tokenPrimaryArtistFee` and `tokenSecondaryArtistFee` + `tokenSecondaryTaexFee` will be less or equal to 100 %; Setting this  values higher than 100 % intentionally or accidentally will block execution of the `primarySale` & `secondarySale` functions

3. Use higher decimals for fees representation. And make them constants instead of literals.

4. Add events for the owner setters.

    **`TaexNFT.sol`**
      - `setBaseURI`
      - `setPrimaryPrice`
    **`TaexNFT1155.sol`**
      - `setBaseURI`
      - `setPrimaryPrice`
    **`SaleNFT.sol`**
      - `setArtistTreasury`
      - `setTaexTreasury`


### Optimizations

1. Following "mapping to value" mappings: `isListedForSale`, `tokenPrice`, `tokenPrimaryArtistFee`, `tokenSecondaryArtistFee`, `tokenSecondaryTaexFee`; can be changed to one "mapping to struct" mappings to pack values and save gas;

2. Use lower uint values for the fee representation.

   By now fee variables uses uint256, however the lower values like uint32 or uint16 can be used to pack values in the struct and save gas. In existing implementation value should be able to represent 100 as value, which is equivalent to using uint8. In case if considered to use higher values the following values is enough:
    uint16 - up to 3 decimal places - 1.125 %
    uint32 - up to 7 decimal places - 1.1250001 %

3. Use immutable for the following variables to save gas:

    **`TaexNFT.sol`**
    - `primaryArtistFee`
    - `secondaryArtistFee`
    - `secondaryTaexFee`
    **`TaexNFT1155.sol`**
    - `primaryArtistFee`
    - `secondaryArtistFee`
    - `secondaryTaexFee`

4. Multiple externals calls to retrieve data from contract

    In the `SaleNFT.sol` contract in functions `primarySale` there is a bunch of calls to the `_taexNFT` to retrive data from the contract. This calls can be grouped together to save gas costs.

5. Redundant checks

    TODO list all here


6. Indexed events? 
