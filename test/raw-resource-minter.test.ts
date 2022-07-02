import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { Contract, ContractFactory } from 'ethers';
import { ethers } from 'hardhat';

describe('RawResourceMinter', function () {
  let RawResourceMinter: ContractFactory;
  let rawResourceMinter: Contract;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    RawResourceMinter = await ethers.getContractFactory('RawResourceMinter');
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    rawResourceMinter = await RawResourceMinter.deploy(
      addr1.address,
      addr2.address,
      owner.address,
    );
  });

  describe('Some test.', function () {
    it('returns expected owner', async function () {
      expect(await rawResourceMinter.owner()).to.equal(owner.address);
    });
  });
});
