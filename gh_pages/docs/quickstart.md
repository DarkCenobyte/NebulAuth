# Quickstart

## Requirements

### Web configuration

- You *MUST* use HTTPS protocol on your website, with enforcement and secure configuration (TLS1.3, TLS1.2 well configured, no weak ciphers/...)
    - You can get free certificate for your domains using [Let's Encrypt](https://letsencrypt.org)
    - Unsafe configuration or HTTP protocol expose your user to MITM attack, and could lead to impersonation by malicious attacker.
- You need to be able to contact Ethereum blockchain
    - You can register to a provider like [Infura](https://www.infura.io/) or [Alchemy](https://www.alchemy.com/) and get an API Key.
    - You can host your own private RPC node and use it.
        - Consensus layer node: [Geth](https://geth.ethereum.org/), [Nethermind](https://nethermind.io/), [Erigon](https://github.com/ledgerwatch/erigon), [Besu](https://besu.hyperledger.org/en/stable/), ...
        - Beacon-node: [Prysm](https://docs.prylabs.network/docs/getting-started), [Lighthouse](https://lighthouse-book.sigmaprime.io/), [Teku](https://docs.teku.consensys.net/en/stable/), ...

## Quickstart with NodeJS

WIP

## Quickstart with PHP

TODO
