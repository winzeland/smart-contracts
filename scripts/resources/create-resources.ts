import { ethers } from 'hardhat';
import { listAllResources } from '@winzeland/resources/dist';

async function main() {
  const items = await listAllResources();

  const resource = await ethers.getContract('ResourcesERC1155');

  for (const item of items) {
    if (await resource.registeredItems(item.id)) {
      console.log(`${item.id} - ${item.name} already registered.`);
      continue;
    }
    console.log(`${item.id} - ${item.name} registering...`);

    const tx = await resource.create({
      name: item.name,
      itemType: item.typeId,
    });
    console.log(item.name, tx.hash);
    await tx.wait();
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch(error => {
  console.error(error);
  process.exitCode = 1;
});
