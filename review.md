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
2. Floating pragma in contracts.
3. Consider use exact imports over the wildcard imports.
4. Using custom errors in require statements rather than error strings.
5. `SaleNFT` uses `ITaexNFT` interface to interact with `TaexNFT` and `TaexNFT1155`. However interface is not inherited by the NFT contracts.
 
### Security assumptions

1. `transferFrom` in `SaleNFT.sol`
    `primarySale` & `secondarySale` functions  

### Optimizations