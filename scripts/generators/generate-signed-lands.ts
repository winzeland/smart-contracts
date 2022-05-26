import { writeFileSync } from 'fs';
import { ethers, getNamedAccounts } from 'hardhat';
import { getRandomLandAndSign } from '../../utils/randomize';

const MAP_SIZE = 50;
const COORDINATE_END = Math.floor(MAP_SIZE / 2);
const COORDINATE_START = -COORDINATE_END;

async function main() {
  const { signer } = await getNamedAccounts();
  const provider = await ethers.getSigner(signer);

  console.log('signer', signer);

  let id = 1;
  const items = [];

  for (let x = COORDINATE_START; x < COORDINATE_END + 1; x++) {
    for (let y = COORDINATE_START; y < COORDINATE_END + 1; y++) {
      if (x === 0 && y === 0) {
        console.log(0, `x: ${x}; y: ${y}`);
        items.push({
          id: 0,
          traits: [0, 0, 0, 99, 1, 2, 3, 4, 10, 10, 10, 10],
          land: {
            x: 0,
            y: 0,
            climate: 0,
            landType: 99,
            resource1: 1,
            resource2: 2,
            resource3: 4,
            resource4: 5,
            resourceLevel1: 10,
            resourceLevel2: 10,
            resourceLevel3: 10,
            resourceLevel4: 10,
          },
        });
      } else {
        console.log(id, `x: ${x}; y: ${y}`);
        const { traits, land, hash, signature } = await getRandomLandAndSign(
          provider,
          x,
          y,
        );
        items.push({ id, traits, land, hash, signature });
        id++;
      }
    }
  }

  writeFileSync('./dist/lands.json', JSON.stringify(items, undefined, 2));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
