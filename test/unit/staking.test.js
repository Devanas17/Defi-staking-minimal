const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat");
const { developmentChains } = require("../../helper-hardhat-config");

const SECONDS_IN_A_DAY = 86400;
const SECONDS_IN_A_YEAR = 31449600;

!developmentChains.includes(network.name)
  ? describe.skip
  : describe("Staking Unit Tests", function () {
      let staking, rewardToken, deployer, dai, stakeAmount;
      beforeEach(async () => {
        const accounts = await ethers.getSigners();
        deployer = accounts[0];
        await deployments.fixture(["mocks", "rewardtoken", "staking"]);
        staking = await ethers.getContractAt("Staking");
        rewardToken = await ethers.getContract("RewardToken");
        stakeAmount = ethers.utils.parseEther("100000");
      });

      describe("constructor", () => {
        it("sets the rewards token address correctly", async () => {
          const response = await staking.s_rewardsToken();
          assert.equal(response, rewardToken.address);
        });
      });
    });
