// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "./ERC721Frozen.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Usefull to read: https://gist.github.com/Ankarrr/6d14a2f73dd12cf889130946f0ef1629
// + https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/utils/cryptography/ECDSA.sol + https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/utils/cryptography/draft-EIP712.sol

contract NebulAuth is ERC721Frozen, EIP712, ReentrancyGuard {
    string public constant PAYLOAD_MSG_SIGNATURE = "message(string websiteDomain,uint256 currentBlock,bytes32 uniqueToken)";

    string private constant _baseTokenURI = "ipfs://bafkreiglvmyo6jjaj3etjtwvgf424z3mstb47zalatazf4q7jb5oxlnk34";
    uint256 public constant minimalWeight = 10; // minimal weight to pay at mint
    uint8 public constant blockTimeTolerance = 2;

    // private constant
    bytes32 private constant PAYLOAD_MSG_SIGNATURE_TYPEHASH = keccak256(abi.encodePacked(keccak256(bytes(PAYLOAD_MSG_SIGNATURE))));
    address private constant _fundsAddress = 0x62edbdDe4a140B3321969C573FCaCc0BEa3C7976;

    address private constant _paymentCurrencyContract1 = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // USDT
    uint8 private constant _paymentCurrencyContract1decimals = 6;
    address private constant _paymentCurrencyContract2 = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // USDC
    uint8 private constant _paymentCurrencyContract2decimals = 6;
    address private constant _paymentCurrencyContract3 = address(0);
    uint8 private constant _paymentCurrencyContract3decimals = 0;

    mapping(address => uint256) private _weight;

    // Events
    event IncreasedWeight(address indexed owner, uint256 indexed totalWeight, uint256 addedWeight, address currencyContract);

    // Constructor
    constructor(
        string memory name,
        string memory symbol,
        string memory version
    ) ERC721(name, symbol) EIP712(name, version) {}

    // Public functions
    function mint(uint256 weight, address paymentContract) external {
        mint(msg.sender, weight, paymentContract);
    }

    function mint(address to, uint256 weight, address paymentContract) nonReentrant public {
        require(balanceOf(to) == 0, "NebulAuth: This address already own a NebulAuth NFT");
        require(weight >= (minimalWeight * (10 ** _getDecimalForPaymentContract(paymentContract))), "NebulAuth: Unsufficient weight");

        _mint(to, _castAddressToUint256(to));
        _pay(weight, paymentContract);
        _weight[to] = weight;
        emit IncreasedWeight(to, weight, weight, paymentContract);
    }

    function increaseWeight(uint256 additionalWeight, address paymentContract) nonReentrant external {
        increaseWeight(msg.sender, additionalWeight, paymentContract);
    }

    function increaseWeight(address to, uint256 additionalWeight, address paymentContract) nonReentrant public {
        _requireOwnToken(to);
        _pay(additionalWeight, paymentContract);
        _weight[to] += additionalWeight;
        emit IncreasedWeight(to, _weight[to], additionalWeight, paymentContract);
    }

    function weightOf(address owner) external view returns (uint256 weight) {
        _requireOwnToken(owner);
        return _weight[owner];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireMinted(tokenId);
        return _baseTokenURI;
    }

    function checkSignAndMetadata(string memory websiteDomain, uint256 signCurrentBlock, bytes32 uniqueToken, bytes memory signature) external view returns (bool, address) {
        return (true, _checkSignAndAddress(websiteDomain, signCurrentBlock, uniqueToken, signature));
    }

    function checkSignAndMetadata(string memory websiteDomain, uint256 signCurrentBlock, bytes32 uniqueToken, bytes memory signature, uint256 expectedWeight) external view returns (bool, address) {
        address signerAddr = _checkSignAndAddress(websiteDomain, signCurrentBlock, uniqueToken, signature);
        return (expectedWeight <= _weight[signerAddr], signerAddr);
    }

    /*
        Payload JSON format:
        {
            domain: {
                name: "NebulAuth",
                version: "1",
                chainId: 1,
                verifyingContract: ''
            },
            message: {
                websiteDomain: '',
                currentBlock: '',
                uniqueToken: ''
            }
        }
    */
    // Private functions
    function _checkSignAndAddress(string memory websiteDomain, uint256 signCurrentBlock, bytes32 uniqueToken, bytes memory signature) private view returns (address) {
        require((block.number - signCurrentBlock) <= blockTimeTolerance, "NebulAuth: Request expired, signature block time out of tolerance range");
        address signerAddr = ECDSA.recover(_getDigest(websiteDomain, signCurrentBlock, uniqueToken), signature);
        _requireOwnToken(signerAddr);
        return signerAddr;
    }

    function _requireOwnToken(address addr) private view {
        require(balanceOf(addr) == 1, "NebulAuth: This address doesn't own a NebulAuth NFT");
    }

    function _pay(uint256 amount, address paymentContract) private {
        _requireValidPaymentContract(paymentContract);
        require(
            abi.decode(
                Address.functionCall(
                    paymentContract,
                    abi.encodeWithSignature(
                        "transferFrom(address,address,uint256)",
                        msg.sender,
                        _fundsAddress,
                        amount
                    )
                ),
                (bool)
            ) == true,
            "NebulAuth: Failure during payment"
        );
    }

    function _getDigest(string memory websiteDomain, uint256 signCurrentBlock, bytes32 uniqueToken) private view returns (bytes32) {
        return _hashTypedDataV4(
            _getStructHashFromPayloadMsg(websiteDomain, signCurrentBlock, uniqueToken)
        );
    }

    function _getStructHashFromPayloadMsg(string memory websiteDomain, uint256 signCurrentBlock, bytes32 uniqueToken) private pure returns (bytes32) {
        return keccak256(
            abi.encode(
                PAYLOAD_MSG_SIGNATURE_TYPEHASH, // "message(string websiteDomain,uint256 currentBlock,bytes32 uniqueToken)"
                keccak256(bytes(websiteDomain)),
                signCurrentBlock,
                uniqueToken
            )
        );
    }

    function _requireValidPaymentContract(address paymentContract) private pure {
        require(
            (paymentContract == _paymentCurrencyContract1 || paymentContract == _paymentCurrencyContract2 || paymentContract == _paymentCurrencyContract3) && paymentContract != address(0),
            "NebulAuth: Invalid payment contract selected"
        );
    }

    function _getDecimalForPaymentContract(address paymentContract) private pure returns (uint256) {
        if (paymentContract == _paymentCurrencyContract1) {
            return _paymentCurrencyContract1decimals;
        } else if (paymentContract == _paymentCurrencyContract2) {
            return _paymentCurrencyContract2decimals;
        } else if (paymentContract == _paymentCurrencyContract3) {
            return _paymentCurrencyContract3decimals;
        }
        revert("NebulAuth: Invalid payment contract selected");
    }

    function _castAddressToUint256(address addr) private pure returns (uint256) {
        return uint256(uint160(addr));
    }
}