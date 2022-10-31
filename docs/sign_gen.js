const iNebulAuth = await NebulAuth.deployed();
const method = 'eth_signTypedData_v4';
const from = await web3.eth.getAccounts();
const params = [
    '0xb2AF24e5249479C3160b10b15eDc1192dc1171C8',
    {
        domain: {
          chainId: 11155111,
          name: 'NebulAuth',
          verifyingContract: '0x0eb0D003e2Fc99cf2f273Bdf0D846F86c44285cc',
          version: '1'
        },
        message: {
          websiteDomain: 'google.com',
          currentBlock: 9,
          uniqueToken: '0x31323334353637383930313233343536373839'
        },
        types: {
            EIP712Domain: [
              { name: 'name', type: 'string' },
              { name: 'version', type: 'string' },
              { name: 'chainId', type: 'uint256' },
              { name: 'verifyingContract', type: 'address' }
            ],
            Authorizer: [
              { name: 'websiteDomain', type: 'string' },
              { name: 'currentBlock', type: 'uint256' },
              { name: 'uniqueToken', type: 'bytes32' }
            ]
        },
        primaryType: 'Authorizer'
    }
];

web3.currentProvider.send(
  {
    method,
    params,
    from: from[0],
  },
  (err, res) => {
    if (err) {
      console.error(err);
    } else {
      console.log(res);
    }
  }
);

// may need all lowercase address...
// result: '0x6b10a4e4010eec912205e604dafcff30a4204dd50f158ffd24d3f95a5b85dd2a2db3af256aac3a04a06c4e45eb606bfc3f3b7a4e0be24b796794a675f75c11411b'

await iNebulAuth.DEBUG_recover('google.com', 9, '0x31323334353637383930313233343536373839', '');
