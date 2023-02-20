const hre = require("hardhat");

async function main() {
  const DungeonsAndDragonsCharacter = await hre.ethers.getContractFactory(
    "DungeonsAndDragonsCharacter"
  );
  const dungeonsAndDragonsCharacter =
    await DungeonsAndDragonsCharacter.deploy();

  await dungeonsAndDragonsCharacter.deployed();

  console.log(` deployed to ${dungeonsAndDragonsCharacter.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
