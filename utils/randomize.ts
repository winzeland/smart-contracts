import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import assert from 'assert';
import { ethers } from 'hardhat';

export const random = (min: number, max: number) =>
  Math.floor(Math.random() * (max - min)) + min;

// @dev randomize all land traits exept for coordinates
// @see https://docs.google.com/spreadsheets/d/1CN5K9db8xS7Z0skwBEqCKQd0NDUPSoSIUNYa6fq0GB8/edit#gid=0
export const randomizeLandTraits = (x: number, y: number) => [
  x,
  y,
  random(0, 4), // climate
  random(0, 3), // landType
  random(0, 8), // resource1
  random(0, 8), // resource2
  random(0, 8), // resource3
  random(0, 8), // resource4
  random(0, 8), // resourceLevel1
  random(0, 8), // resourceLevel2
  random(0, 8), // resourceLevel3
  random(0, 8), // resourceLevel4
];

export const getRandomLandAndSign = async (
  signer: SignerWithAddress,
  x: number,
  y: number,
) => {
  const traits = randomizeLandTraits(x, y);
  const hash = ethers.utils.solidityKeccak256(
    [
      'int8',
      'int8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
      'uint8',
    ],
    traits,
  );

  const bytes = ethers.utils.arrayify(hash);
  const signature = await signer.signMessage(bytes);

  assert(
    ethers.utils.verifyMessage(bytes, signature) === signer.address,
    'signature does not match.',
  );

  return {
    traits,
    hash,
    signature,
  };
};
