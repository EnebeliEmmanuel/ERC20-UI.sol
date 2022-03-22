const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  // const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  // console.log("Account balance: ", accountBalance.toString());

  const KokoTokenFactory = await hre.ethers.getContractFactory("KokoToken");
  const KokoToken = await KokoTokenFactory.deploy();
  await KokoToken.deployed();
  console.log("KokoToken address: ", KokoToken.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

runMain();