# Review of the `taex_contracts` repository

## Content

- [Review of the `taex_contracts` repository](#review-of-the-taex_contracts-repository)
  - [Content](#content)
  - [Process](#process)
    - [Follow best practices](#follow-best-practices)
      - [1. The tests coverage is poor. Consider increasing at it at least to 85%.](#1-the-tests-coverage-is-poor-consider-increasing-at-it-at-least-to-85)
      - [2. Floating pragma in contracts](#2-floating-pragma-in-contracts)
      - [3. Consider use exact imports over the wildcard imports.](#3-consider-use-exact-imports-over-the-wildcard-imports)
      - [4. Using custom errors in require statements rather than error strings.](#4-using-custom-errors-in-require-statements-rather-than-error-strings)
      - [5. `TaexNFT` and `TaexNFT1155` should implement the `ITaexNFT` interface](#5-taexnft-and-taexnft1155-should-implement-the-itaexnft-interface)
      - [6. Add NatSpec documentation to the contract code](#6-add-natspec-documentation-to-the-contract-code)
      - [7. Use new version of the OZ contracts](#7-use-new-version-of-the-oz-contracts)
    - [Security assumptions](#security-assumptions)
      - [1. `transferFrom` in `SaleNFT.sol`](#1-transferfrom-in-salenftsol)
      - [2. The fees values can block sales if set incorrectly.](#2-the-fees-values-can-block-sales-if-set-incorrectly)
      - [3. Use higher decimals for fees representation. And make them constants instead of literals.](#3-use-higher-decimals-for-fees-representation-and-make-them-constants-instead-of-literals)
      - [4. Add events for the owner setters.](#4-add-events-for-the-owner-setters)
      - [5. `_taexNFT` parameter in `primarySale` and `secondarySale` function is not guaranteed to be exact implementation of `TaexNFT` and `TaexNFT1155`](#5-_taexnft-parameter-in-primarysale-and-secondarysale-function-is-not-guaranteed-to-be-exact-implementation-of-taexnft-and-taexnft1155)
    - [Optimizations](#optimizations)
      - [1. Change mapping structure](#1-change-mapping-structure)
      - [2. Use lower uint values for the fee representation](#2-use-lower-uint-values-for-the-fee-representation)
      - [3. Use immutable for the following variables to save gas](#3-use-immutable-for-the-following-variables-to-save-gas)
      - [4. Multiple externals calls to retrieve data from contract](#4-multiple-externals-calls-to-retrieve-data-from-contract)
      - [5. Redundant checks](#5-redundant-checks)
      - [6. Using less indexed topics may save gas](#6-using-less-indexed-topics-may-save-gas)
    - [Recommended flow of next steps](#recommended-flow-of-next-steps)


## Process

During the review process, contracts goes through the following procedures:

1. Generating and running the reports of the static analyzer tools.

    Slither and Aderyn static analyzer tools was used to generate the following reports:

    - [Slither report](./slither_run.md)
    - [Aderyn report](./report.md)

2. Manual review of the contracts.

### Follow best practices

This chapter describes some upper-level flaws in the code that may lead to bugs and steps that should be considered to increase code quality.

#### 1. The tests coverage is poor. Consider increasing at it at least to 85%.

   By now coverage report is following:

   ```bash
    >>> npx hardhat coverage

    ....


    TaexNFT
        1) "before each" hook for "check if deploy initialized correctly"


    0 passing (33ms)
    1 failing


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

#### 2. Floating pragma in contracts

Consider using the fixed version of Solidity, rather than floating

```diff
-   pragma solidity ^0.8.20;
+   pragma solidity 0.8.20;
```

#### 3. Consider use exact imports over the wildcard imports.

```diff
-    import "@openzeppelin/contracts/access/Ownable.sol";
+    import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
```

#### 4. Using custom errors in require statements rather than error strings.

```diff
...
-    require(owner != address(0), "SaleNFT: zero address");
...
+    error SaleNFT_ZeroAddress();
+    require(owner != address(0), SaleNFT_ZeroAddress());
```

#### 5. `TaexNFT` and `TaexNFT1155` should implement the `ITaexNFT` interface

`SaleNFT` uses `ITaexNFT` interface to interact with `TaexNFT` and `TaexNFT1155`. However interface is not inherited by the NFT contracts. Consider 

#### 6. Add NatSpec documentation to the contract code

(Check documentation of OZ or other top tier projects as examples(1inch, Uniswap, AAVE etc.))

#### 7. Use new version of the OZ contracts

Using newer version of OZ library helps to decrease gas costs by using the transition storage and other improvements of newer versions of Solidity and EVM.

### Security assumptions

#### 1. `transferFrom` in `SaleNFT.sol`  

`primarySale` & `secondarySale` functions uses `transferFrom`, however it's recommended to use  `safeTransferFrom`. Also in `TaexNFT1155.sol` `safeTransferFrom` is wrapped by `transferFrom` method which is not good for code understanding.

#### 2. The fees values can block sales if set incorrectly.

There is no mechanism in `TaexNFT.sol` and `TaexNFT1155.sol` сontracts to guarantee that `tokenPrimaryArtistFee` and `tokenSecondaryArtistFee` + `tokenSecondaryTaexFee` will be less or equal to 100 %; Setting this  values higher than 100 % intentionally or accidentally will block execution of the `primarySale` & `secondarySale` functions in `SaleNFT.sol` contract.

#### 3. Use higher decimals for fees representation. And make them constants instead of literals.

For example: L147 in `SaleNFT.sol`:

```diff
-    uint256 secondaryArtistFeeAmount = (price * secondaryArtistFee) / 100;
+ uint256 constant FEE_DECIMALS = 1e5;
+ uint256 secondaryArtistFeeAmount = (price * secondaryArtistFee) / FEE_DECIMALS;
```

#### 4. Add events for the owner setters.

**`TaexNFT.sol`**
    - `setBaseURI`
    - `setPrimaryPrice`

**`TaexNFT1155.sol`**
    - `setBaseURI`
    - `setPrimaryPrice`

**`SaleNFT.sol`**
    - `setArtistTreasury`
    - `setTaexTreasury`

#### 5. `_taexNFT` parameter in `primarySale` and `secondarySale` function is not guaranteed to be exact implementation of `TaexNFT` and `TaexNFT1155`

The malicious user may pass any contract instead of actual one. despite the fact, that there is no direct effect on the funds locked in the contract, it's recommended to add mechanism to check that the contract is valid and trusted.

### Optimizations

#### 1. Change mapping structure

Following "mapping to value" mappings: `isListedForSale`, `tokenPrice`, `tokenPrimaryArtistFee`, `tokenSecondaryArtistFee`, `tokenSecondaryTaexFee`; can be changed to one "mapping to struct" mappings to pack values and save gas;

#### 2. Use lower uint values for the fee representation

By now fee variables uses uint256, however the lower values like uint32 or uint16 can be used to pack values in the struct and save gas. In existing implementation value should be able to represent 100 as value, which is equivalent to using uint8. In case if considered to use higher values the following values is enough:
uint16 - up to 3 decimal places - 1.125 %
uint32 - up to 7 decimal places - 1.1250001 %

#### 3. Use immutable for the following variables to save gas

**`TaexNFT.sol`**

- `primaryArtistFee`
- `secondaryArtistFee`
- `secondaryTaexFee`

**`TaexNFT1155.sol`**

- `primaryArtistFee`
- `secondaryArtistFee`
- `secondaryTaexFee`

#### 4. Multiple externals calls to retrieve data from contract

In the `SaleNFT.sol` contract in functions `primarySale` . `secondarySale` there is a bunch of calls to the `_taexNFT` contract to retrive data from the contract. This calls can be grouped together to save gas costs.

For example:

```solidity
    contract A { 
        function getA(uint _id) external returns(uint) {
            // function code
            . . .
        }

        function getB(uint _id) external returns(address) {
            // function code
            . . .
        }

        function getData(uint _id) external returns(uint, address) {
            // function code
            . . .
        }
    }

    contract B {
        function doSomething(address _a, uint _id) external {
            // Instead of following code:
            // uint a = _a.getA(_id);
            // address b = _a.getB(_id);
            // Do this:
            (uint a, address b) = _a.getData(id);
            . . .
        }
    }

```

#### 5. Redundant checks

- `isNotZeroAddress` modifier on `_taexNFT` argument in `primarySale` and `secondarySale` functions in `SaleNFT` contract. If address is zero calls will be failed.
- Some checks in contract constructors and owner functions can be removed as far as contract owner is responsible actor and checks parameters before calls.
  - isNotZeroAddress in SaleNFT constructor
  - isNotZeroAddress in `setArtistTreasury` & `setTaexTreasury` functions in SaleNFT contract.

#### 6. Using less indexed topics may save gas

`PrimarySale` & `SecondarySale` events uses 3 indexed topics, which is maximum number of indexed topics in event. In case if it's not planned to use filter on each topic of the event, it's recommended to use only necessary one. `Indexed` for each topic costs 375 gas.

### Recommended flow of next steps

1. Update the contracts code according to the recommendation described above. Security -> Optimization -> Best practices
2. Increase the coverage of the code.
3. Test the contracts on the testnet.
4. Go through multistage audit procedure before deployment.
