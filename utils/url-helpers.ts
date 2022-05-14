const baseUrlMap: Record<string, string> = {
  matic: "https://www.winzeland.com",
  mumbai: "https://testnet.winzeland.com",
  rinkeby: "https://rinkeby.winzeland.com",
};

export const buildBaseNftMetadataUrl = (network: string, path: string) => {
  const url = baseUrlMap[network] || baseUrlMap.matic;
  return `${url}${path}`;
};
