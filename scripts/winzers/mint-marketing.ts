import { randomizeWinzerLogically } from '@winzeland/winzer/dist';
import { ethers, getNamedAccounts } from 'hardhat';

async function main() {
  const { deployer } = await getNamedAccounts();
  const airdroper = await ethers.getContract('WinzerMarketingAirdrop');

  const traits = randomizeWinzerLogically();

  const dna = {
    race: traits.race,
    sex: traits.sex,
    skin: traits.skinTone,
    head: traits.head,
    ears: traits.ears,
    hair: traits.hair,
    beard: traits.beard,
    mouth: traits.mouth,
    eyes: traits.eyes,
    eyebrows: traits.eyebrows,
    nose: traits.nose,
    scars: traits.scars,
  };

  const mint = await airdroper.mint(deployer, dna);

  const tx = await mint.wait();

  console.log('tx', tx.transactionHash);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
