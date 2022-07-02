import { expect } from 'chai';
import { Contract, ContractFactory } from 'ethers';
import { ethers } from 'hardhat';

describe('ERC2771', function () {
  let TrustedForwarderStorage: ContractFactory;
  let trustedForwarderStorage: Contract;

  beforeEach(async function () {
    TrustedForwarderStorage = await ethers.getContractFactory(
      'TrustedForwarderStorage',
    );

    trustedForwarderStorage = await TrustedForwarderStorage.deploy();
  });

  describe('Deployment', function () {
    it('owner is deployer', async function () {
      expect(await trustedForwarderStorage.owner()).to.equal(deployer);
    });
  });
});
