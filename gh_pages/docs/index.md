# NebulAuth - Decentralized authentication system through Web3

## What is NebulAuth

NebulAuth is an authentication protocol, allowing your users to register and login using their web3 wallet.

## How it works

You offer your users to register or identify themselves using NebulAuth, in a similar way to OAuth implementations.

NebulAuth will require to your user to get an NFT (it's a one-time process for a customer, and this NFT is usable for any website implementing the NebulAuth protocol)

By making this choice, your users are redirected to a decentralized web page (stored on the IPFS network), which will then ask their web3 wallet (MetaMask, ...), to digitally sign a connection request. Then answer to a callback URL of your website a payload and the associated signature.

Your website will then contact the NebulAuth smartcontract to confirm the validity of the signature, the payload, and provide you with the author of the signature.

If everything is in order, you can proceed with the connection/registration of your user.

## Pricing

It's free for website/... to implement and use this protocol!

The cost is only 10$US for an user (paid through USDT, USDC or BUSD tokens on Ethereum network), and this user keep this NFT forever, so paying 10$ allow him to use our protocol to register or login himself on any website using NebulAuth.

Eventually, the implementation will cost you the communication with ETH network if your website is massively used, as Alchemy/Infura API can be restrict by their free tiers.

However, you can also host yourself an Ethereum node, then use it for you own usage if your website is hosted on a powerful enough machine.
