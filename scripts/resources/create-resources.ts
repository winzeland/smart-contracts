import { ethers } from 'hardhat';
import { listAllResources } from '@winzeland/resources';

async function main() {
  const items = await listAllResources();

  const resource = await ethers.getContract('ResourcesERC1155');

  for (const item of items) {
    if (await resource.registered(item.id)) {
      console.log(`${item.id} - ${item.name} already registered.`);
      continue;
    }
    console.log(`${item.id} - ${item.name} registering...`);

    const tx = await resource.registerItem(item.id, {
      name: item.name,
      typeId: item.typeId,
      subTypeId: 0, // @todo: add subtype
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
