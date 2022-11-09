# NebulAuth - Decentralized authentication system through Web3

*This documentation and the current implementations of the authentication page are still in progress! Do not use it in production until a stable version is available!*

## What is NebulAuth

NebulAuth is an authentication protocol, allowing your users to register and login using their web3 wallet.

## How it works

You offer your users to register or identify themselves using NebulAuth, in a similar way to OAuth implementations.

NebulAuth will require to your user to get an NFT (it's a one-time process for a customer, and this NFT is usable for any website implementing the NebulAuth protocol)

By making this choice, your users are redirected to a decentralized web page (stored on the IPFS network), which will then ask their web3 wallet (MetaMask, ...), to digitally sign a connection request. Then answer to a callback URL of your website a payload and the associated signature.

Your website will then contact the NebulAuth smartcontract to confirm the validity of the signature, the payload, and provide you the verified wallet address of your user.

If everything is in order, you can proceed with the connection/registration of your user.

## Pricing

It's free for website/... to implement and use this protocol!

The cost is only 10$US for an user (paid through USDT, USDC or BUSD tokens on Ethereum network), and this user keep this NFT forever, so paying 10$ allow him to use our protocol to register or login himself on any website using NebulAuth with the default settings.

Eventually, the implementation will cost you the communication with ETH network if your website is massively used, as ETH API providers (like Alchemy or Infura) can be restrict by their free tiers.

However, you can also host yourself an Ethereum node, then use it for you own usage if your website is hosted on a powerful enough machine.

## Differences with other protocols

The market knows other protocols, NebulAuth is inspired by some but also tends to distinguish itself.

### OAuth / OpenID

Most common technologies, and massively adopt by corporations, this is mainly known to be an efficient and secure protocol, but most of the time it is use with a third-party centralized (some GAFAM companies, ...)

### IndieAuth

Decentralized implementation of OAuth 2.0, it is a standard from IndieWeb community, but rarely used and usage is not very accessible for now, there is plugins for some CMS like WordPress and Drupal.

### WebID-TLS

Similar in the way that any client can bring it's own keys (like wallets) to sign their identity, the interaction is browser-native but not user-friendly. Also identity can be self-signed, and protect your service against spam/bot is more difficult.

### Web3Auth

Also related to blockchain and web3, this protocol offer 2 flavors, one is "plug-and-play" but require an account through their services and require a subscription, the other one is a self-hosted solution, a bit less accessible.
The advantage of this protocol is to come with multiples additional features like 2FA, and it isn't dependant of the blockchain states...

### NebulAuth

The OAuth logic was an inspiration to make NebulAuth, the main ideas were:

- The protocol should be free to implement
    - You can use your own Ethereum node, it doesn't need to be an archive node, but must be sync.
    - You can use third-party API instead (be careful and know their free plans limits/...)
- The protocol must block bots, multi-accounts harassement, ...
    - By the requirement to buy an unique non-transferable NFT on each address use, we make it non-profitable for spam bots to target you and for banned users to strikeback on your service.
- The sign-in process using NebulAuth smartcontract must not incur additional costs per action (except due to third-party API providers)
    - The interaction with NebulAuth smartcontract doesn't require any gas for sign-in checks!
- The protocol need to be secure
    - By using web3 standards [EIP-712](https://eips.ethereum.org/EIPS/eip-712) and OpenZeppelin libraries on our smartcontract, we take advantage to the blockchain security in NebulAuth.
    - Our contract and codes are open-source under MIT license, it can be audited by anyone.
    - Before signing the user is confident thanks to features like an anti-phishing code, wallet signature displaying target domain so the user isn't signing to an unexpected website.
- The protocol must be easy to implement
    - By providing modules for NodeJS and PHP, you can easily implement this protocol into your custom-code plateform.
    - By giving an easily understandable documentations to make your own implementation in other languages.
- The protocol must be user-friendly
    - Using metamask interfaces is user-friendly, however web3 and blockchains technologies require to be careful against threats. Dealing with this conditions we must give a protocol usable with the less complexity possible.
