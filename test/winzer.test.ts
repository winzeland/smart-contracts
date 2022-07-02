import { expect } from 'chai';
import { Contract, ContractFactory } from 'ethers';
import { ethers, getNamedAccounts } from 'hardhat';
import { buildBaseNftMetadataUrl } from '../utils/url-helpers';

const winzerUrl = buildBaseNftMetadataUrl('matic', '/meta/winzer/');
const contractUrl = buildBaseNftMetadataUrl('matic', '/meta/contract/winzers');

describe('WinzerERC721', function () {
  let WinzerERC721: ContractFactory;
  let winzer: Contract;
  let deployer: string;

  beforeEach(async function () {
    WinzerERC721 = await ethers.getContractFactory('WinzerERC721');
    const { deployer: _deployer } = await getNamedAccounts();

    deployer = _deployer;

    winzer = await WinzerERC721.deploy(deployer, winzerUrl, contractUrl);
  });

  describe('Deployment', function () {
    it('owner is deployer', async function () {
      expect(await winzer.owner()).to.equal(deployer);
    });
  });
});
