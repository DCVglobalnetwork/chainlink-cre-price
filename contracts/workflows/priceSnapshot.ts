import { Workflow } from "@chainlink/cre";
import { ethers } from "ethers";

const FEED = "0x694AA1769357215DE4FAC081bf1f309aDC325306";

const abi = [
  "function latestRoundData() view returns (uint80,int256,uint256,uint256,uint80)"
];

export const workflow = new Workflow({
  name: "priceSnapshot",

  trigger: async (ctx) => {
    return ctx.request.body;
  },

  run: async (ctx, input) => {

    const provider = ctx.evm.provider("sepolia");

    const feed = new ethers.Contract(FEED, abi, provider);

    const data = await feed.latestRoundData();

    const price = data[1];
    const blockNumber = await provider.getBlockNumber();

    const contract = ctx.evm.contract({
      address: process.env.SNAPSHOT_CONTRACT!,
      abi: [
        "function snapshot(string,uint256,uint256) external"
      ],
      chain: "sepolia"
    });

    await contract.write.snapshot([
      input.token,
      price.toString(),
      blockNumber
    ]);

    return { token: input.token, price: price.toString(), blockNumber };
  }
});
