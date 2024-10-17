**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary
 - [arbitrary-send-erc20](#arbitrary-send-erc20) (2 results) (High)
 - [erc20-interface](#erc20-interface) (1 results) (Medium)
 - [shadowing-local](#shadowing-local) (5 results) (Low)
 - [events-maths](#events-maths) (2 results) (Low)
 - [reentrancy-events](#reentrancy-events) (1 results) (Low)
 - [solc-version](#solc-version) (1 results) (Informational)
 - [low-level-calls](#low-level-calls) (3 results) (Informational)
 - [naming-convention](#naming-convention) (27 results) (Informational)
 - [reentrancy-unlimited-gas](#reentrancy-unlimited-gas) (2 results) (Informational)
 - [immutable-states](#immutable-states) (6 results) (Optimization)
## arbitrary-send-erc20
Impact: High
Confidence: High
 - [ ] ID-0
[SaleNFT.primarySale(address,uint256)](contracts/SaleNFT.sol#L53-L101) uses arbitrary from in transferFrom: [ITaexNFT(_taexNFT).transferFrom(owner,msg.sender,_tokenId)](contracts/SaleNFT.sol#L71)

contracts/SaleNFT.sol#L53-L101


 - [ ] ID-1
[SaleNFT.secondarySale(address,uint256)](contracts/SaleNFT.sol#L103-L169) uses arbitrary from in transferFrom: [ITaexNFT(_taexNFT).transferFrom(owner,msg.sender,_tokenId)](contracts/SaleNFT.sol#L123)

contracts/SaleNFT.sol#L103-L169


## erc20-interface
Impact: Medium
Confidence: High
 - [ ] ID-2
[ITaexNFT](contracts/SaleNFT.sol#L7-L15) has incorrect ERC20 function interface:[ITaexNFT.transferFrom(address,address,uint256)](contracts/SaleNFT.sol#L14)

contracts/SaleNFT.sol#L7-L15


## shadowing-local
Impact: Low
Confidence: High
 - [ ] ID-3
[TaexNFT.constructor(string,string,string,uint256,uint256,uint256,uint256)._name](contracts/TaexNFT.sol#L40) shadows:
	- [ERC721._name](node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol#L23) (state variable)

contracts/TaexNFT.sol#L40


 - [ ] ID-4
[SaleNFT.primarySale(address,uint256).owner](contracts/SaleNFT.sol#L59) shadows:
	- [Ownable.owner()](node_modules/@openzeppelin/contracts/access/Ownable.sol#L56-L58) (function)

contracts/SaleNFT.sol#L59


 - [ ] ID-5
[SaleNFT.secondarySale(address,uint256).owner](contracts/SaleNFT.sol#L107) shadows:
	- [Ownable.owner()](node_modules/@openzeppelin/contracts/access/Ownable.sol#L56-L58) (function)

contracts/SaleNFT.sol#L107


 - [ ] ID-6
[TaexNFT1155.constructor(string,uint256,uint256,uint256,uint256)._uri](contracts/TaexNFT1155.sol#L46) shadows:
	- [ERC1155._uri](node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol#L28) (state variable)

contracts/TaexNFT1155.sol#L46


 - [ ] ID-7
[TaexNFT.constructor(string,string,string,uint256,uint256,uint256,uint256)._symbol](contracts/TaexNFT.sol#L41) shadows:
	- [ERC721._symbol](node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol#L26) (state variable)

contracts/TaexNFT.sol#L41


## events-maths
Impact: Low
Confidence: Medium
 - [ ] ID-8
[TaexNFT.setPrimaryPrice(uint256)](contracts/TaexNFT.sol#L104-L108) should emit an event for: 
	- [primaryPrice = _price](contracts/TaexNFT.sol#L107) 

contracts/TaexNFT.sol#L104-L108


 - [ ] ID-9
[TaexNFT1155.setPrimaryPrice(uint256)](contracts/TaexNFT1155.sol#L114-L118) should emit an event for: 
	- [primaryPrice = _price](contracts/TaexNFT1155.sol#L117) 

contracts/TaexNFT1155.sol#L114-L118


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-10
Reentrancy in [SaleNFT.withdrawETH(address)](contracts/SaleNFT.sol#L171-L179):
	External calls:
	- [(success,None) = address(to).call{value: balance}()](contracts/SaleNFT.sol#L175)
	Event emitted after the call(s):
	- [ETHWithdrawn(to,balance)](contracts/SaleNFT.sol#L178)

contracts/SaleNFT.sol#L171-L179


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-11
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess.
It is used by:
	- [^0.8.20](node_modules/@openzeppelin/contracts/access/Ownable.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/interfaces/draft-IERC6093.sol#L3)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC1155/IERC1155.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/Arrays.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/Context.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#L5)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/Strings.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/introspection/ERC165.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/introspection/IERC165.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/math/Math.sol#L4)
	- [^0.8.20](node_modules/@openzeppelin/contracts/utils/math/SignedMath.sol#L4)
	- [^0.8.20](contracts/SaleNFT.sol#L2)
	- [^0.8.20](contracts/TaexNFT.sol#L2)
	- [^0.8.20](contracts/TaexNFT1155.sol#L2)

node_modules/@openzeppelin/contracts/access/Ownable.sol#L4


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-12
Low level call in [SaleNFT.withdrawETH(address)](contracts/SaleNFT.sol#L171-L179):
	- [(success,None) = address(to).call{value: balance}()](contracts/SaleNFT.sol#L175)

contracts/SaleNFT.sol#L171-L179


 - [ ] ID-13
Low level call in [SaleNFT.secondarySale(address,uint256)](contracts/SaleNFT.sol#L103-L169):
	- [(successOwner,None) = address(owner).call{value: price - secondaryArtistFeeAmount - secondaryTaexFeeAmount}()](contracts/SaleNFT.sol#L138-L140)
	- [(successArtist,None) = address(artistTreasury).call{value: secondaryArtistFeeAmount}()](contracts/SaleNFT.sol#L144-L146)
	- [(successTaex,None) = address(taexTreasury).call{value: secondaryTaexFeeAmount}()](contracts/SaleNFT.sol#L154-L156)

contracts/SaleNFT.sol#L103-L169


 - [ ] ID-14
Low level call in [SaleNFT.primarySale(address,uint256)](contracts/SaleNFT.sol#L53-L101):
	- [(successArtist,None) = address(artistTreasury).call{value: primaryArtistFeeAmount}()](contracts/SaleNFT.sol#L79-L81)
	- [(successTaex,None) = address(taexTreasury).call{value: price - primaryArtistFeeAmount}()](contracts/SaleNFT.sol#L88-L90)

contracts/SaleNFT.sol#L53-L101


## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-15
Parameter [SaleNFT.primarySale(address,uint256)._taexNFT](contracts/SaleNFT.sol#L54) is not in mixedCase

contracts/SaleNFT.sol#L54


 - [ ] ID-16
Parameter [TaexNFT1155.mintWithSpecifiedFee(address,uint256,uint256,uint256)._secondaryArtistFee](contracts/TaexNFT1155.sol#L181) is not in mixedCase

contracts/TaexNFT1155.sol#L181


 - [ ] ID-17
Parameter [TaexNFT1155.adjustPrice(uint256,uint256)._price](contracts/TaexNFT1155.sol#L95) is not in mixedCase

contracts/TaexNFT1155.sol#L95


 - [ ] ID-18
Parameter [TaexNFT.setPrimaryPrice(uint256)._price](contracts/TaexNFT.sol#L105) is not in mixedCase

contracts/TaexNFT.sol#L105


 - [ ] ID-19
Parameter [TaexNFT.mintWithSpecifiedFee(address,uint256,uint256,uint256)._secondaryTaexFee](contracts/TaexNFT.sol#L143) is not in mixedCase

contracts/TaexNFT.sol#L143


 - [ ] ID-20
Parameter [TaexNFT1155.mintWithSpecifiedFee(address,uint256,uint256,uint256)._secondaryTaexFee](contracts/TaexNFT1155.sol#L182) is not in mixedCase

contracts/TaexNFT1155.sol#L182


 - [ ] ID-21
Parameter [TaexNFT1155.ownerOfToken(uint256)._tokenId](contracts/TaexNFT1155.sol#L59) is not in mixedCase

contracts/TaexNFT1155.sol#L59


 - [ ] ID-22
Parameter [TaexNFT1155.listForSale(uint256,uint256)._tokenId](contracts/TaexNFT1155.sol#L70) is not in mixedCase

contracts/TaexNFT1155.sol#L70


 - [ ] ID-23
Parameter [TaexNFT1155.unlistFromSale(uint256)._tokenId](contracts/TaexNFT1155.sol#L83) is not in mixedCase

contracts/TaexNFT1155.sol#L83


 - [ ] ID-24
Parameter [TaexNFT1155.adjustPrice(uint256,uint256)._tokenId](contracts/TaexNFT1155.sol#L95) is not in mixedCase

contracts/TaexNFT1155.sol#L95


 - [ ] ID-25
Parameter [TaexNFT.listForSale(uint256,uint256)._tokenId](contracts/TaexNFT.sol#L62) is not in mixedCase

contracts/TaexNFT.sol#L62


 - [ ] ID-26
Parameter [TaexNFT.ownerOfToken(uint256)._tokenId](contracts/TaexNFT.sol#L55) is not in mixedCase

contracts/TaexNFT.sol#L55


 - [ ] ID-27
Parameter [SaleNFT.setTaexTreasury(address)._taexTreasury](contracts/SaleNFT.sol#L193) is not in mixedCase

contracts/SaleNFT.sol#L193


 - [ ] ID-28
Parameter [TaexNFT1155.setPrimaryPrice(uint256)._price](contracts/TaexNFT1155.sol#L115) is not in mixedCase

contracts/TaexNFT1155.sol#L115


 - [ ] ID-29
Parameter [TaexNFT.adjustPrice(uint256,uint256)._price](contracts/TaexNFT.sol#L85) is not in mixedCase

contracts/TaexNFT.sol#L85


 - [ ] ID-30
Parameter [TaexNFT1155.mintWithSpecifiedFee(address,uint256,uint256,uint256)._primaryArtistFee](contracts/TaexNFT1155.sol#L180) is not in mixedCase

contracts/TaexNFT1155.sol#L180


 - [ ] ID-31
Parameter [SaleNFT.secondarySale(address,uint256)._tokenId](contracts/SaleNFT.sol#L105) is not in mixedCase

contracts/SaleNFT.sol#L105


 - [ ] ID-32
Parameter [SaleNFT.secondarySale(address,uint256)._taexNFT](contracts/SaleNFT.sol#L104) is not in mixedCase

contracts/SaleNFT.sol#L104


 - [ ] ID-33
Parameter [TaexNFT.mintWithSpecifiedFee(address,uint256,uint256,uint256)._secondaryArtistFee](contracts/TaexNFT.sol#L142) is not in mixedCase

contracts/TaexNFT.sol#L142


 - [ ] ID-34
Parameter [TaexNFT.unlistFromSale(uint256)._tokenId](contracts/TaexNFT.sol#L73) is not in mixedCase

contracts/TaexNFT.sol#L73


 - [ ] ID-35
Parameter [SaleNFT.setArtistTreasury(address)._artistTreasury](contracts/SaleNFT.sol#L185) is not in mixedCase

contracts/SaleNFT.sol#L185


 - [ ] ID-36
Parameter [TaexNFT1155.tokenURI(uint256)._tokenId](contracts/TaexNFT1155.sol#L123) is not in mixedCase

contracts/TaexNFT1155.sol#L123


 - [ ] ID-37
Parameter [TaexNFT.mintWithSpecifiedFee(address,uint256,uint256,uint256)._primaryArtistFee](contracts/TaexNFT.sol#L141) is not in mixedCase

contracts/TaexNFT.sol#L141


 - [ ] ID-38
Parameter [TaexNFT.listForSale(uint256,uint256)._price](contracts/TaexNFT.sol#L62) is not in mixedCase

contracts/TaexNFT.sol#L62


 - [ ] ID-39
Parameter [TaexNFT.adjustPrice(uint256,uint256)._tokenId](contracts/TaexNFT.sol#L85) is not in mixedCase

contracts/TaexNFT.sol#L85


 - [ ] ID-40
Parameter [SaleNFT.primarySale(address,uint256)._tokenId](contracts/SaleNFT.sol#L55) is not in mixedCase

contracts/SaleNFT.sol#L55


 - [ ] ID-41
Parameter [TaexNFT1155.listForSale(uint256,uint256)._price](contracts/TaexNFT1155.sol#L70) is not in mixedCase

contracts/TaexNFT1155.sol#L70


## reentrancy-unlimited-gas
Impact: Informational
Confidence: Medium
 - [ ] ID-42
Reentrancy in [SaleNFT.secondarySale(address,uint256)](contracts/SaleNFT.sol#L103-L169):
	External calls:
	- [address(msg.sender).transfer(msg.value - price)](contracts/SaleNFT.sol#L165)
	External calls sending eth:
	- [(successOwner,None) = address(owner).call{value: price - secondaryArtistFeeAmount - secondaryTaexFeeAmount}()](contracts/SaleNFT.sol#L138-L140)
	- [(successArtist,None) = address(artistTreasury).call{value: secondaryArtistFeeAmount}()](contracts/SaleNFT.sol#L144-L146)
	- [(successTaex,None) = address(taexTreasury).call{value: secondaryTaexFeeAmount}()](contracts/SaleNFT.sol#L154-L156)
	- [address(msg.sender).transfer(msg.value - price)](contracts/SaleNFT.sol#L165)
	Event emitted after the call(s):
	- [SecondarySale(_taexNFT,_tokenId,msg.sender)](contracts/SaleNFT.sol#L168)

contracts/SaleNFT.sol#L103-L169


 - [ ] ID-43
Reentrancy in [SaleNFT.primarySale(address,uint256)](contracts/SaleNFT.sol#L53-L101):
	External calls:
	- [address(msg.sender).transfer(msg.value - price)](contracts/SaleNFT.sol#L98)
	External calls sending eth:
	- [(successArtist,None) = address(artistTreasury).call{value: primaryArtistFeeAmount}()](contracts/SaleNFT.sol#L79-L81)
	- [(successTaex,None) = address(taexTreasury).call{value: price - primaryArtistFeeAmount}()](contracts/SaleNFT.sol#L88-L90)
	- [address(msg.sender).transfer(msg.value - price)](contracts/SaleNFT.sol#L98)
	Event emitted after the call(s):
	- [PrimarySale(_taexNFT,_tokenId,msg.sender)](contracts/SaleNFT.sol#L100)

contracts/SaleNFT.sol#L53-L101


## immutable-states
Impact: Optimization
Confidence: High
 - [x] ID-44
[TaexNFT1155.primaryArtistFee](contracts/TaexNFT1155.sol#L22) should be immutable 

contracts/TaexNFT1155.sol#L22


 - [x] ID-45
[TaexNFT1155.secondaryArtistFee](contracts/TaexNFT1155.sol#L23) should be immutable 

contracts/TaexNFT1155.sol#L23


 - [x] ID-46
[TaexNFT.primaryArtistFee](contracts/TaexNFT.sol#L16) should be immutable 

contracts/TaexNFT.sol#L16


 - [x] ID-47
[TaexNFT.secondaryArtistFee](contracts/TaexNFT.sol#L17) should be immutable 

contracts/TaexNFT.sol#L17


 - [x] ID-48
[TaexNFT1155.secondaryTaexFee](contracts/TaexNFT1155.sol#L24) should be immutable 

contracts/TaexNFT1155.sol#L24


 - [x] ID-49
[TaexNFT.secondaryTaexFee](contracts/TaexNFT.sol#L18) should be immutable 

contracts/TaexNFT.sol#L18


