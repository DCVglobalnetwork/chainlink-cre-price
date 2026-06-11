export async function handler(request: any) {
  const token = request.body.token;

  // STEP 1: EVM READ (Chainlink Data Feed)
  const priceData = await EVM.read({
    address: "0x694AA1769357215DE4FAC081bf1f309aDC325306", // ETH/USD Sepolia
    function: "latestRoundData"
  });

  const price = priceData.answer;
  const blockNumber = priceData.updatedAt;

  // STEP 2: EVM WRITE (your contract)
  const result = await EVM.write({
    address: "0x84d76c5880Bc136815EB7c2BfC31A0A316024FAa",
    function: "snapshot",
    args: [token, price, blockNumber]
  });

  return {
    success: true,
    token,
    price,
    blockNumber,
    tx: result.txHash
  };
}
