const fs = require("fs");
const path = require("path");

const prettierOptions = JSON.parse(
  fs.readFileSync(path.resolve(__dirname, ".prettierrc"), "utf8")
);

module.exports = {
  env: {
    browser: false,
    es2021: true,
    mocha: true,
    node: true,
  },
  plugins: ["@typescript-eslint", "prettier"],
  extends: ["standard", "plugin:prettier/recommended"],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: 12,
  },
  rules: {
    "node/no-unsupported-features/es-syntax": [
      "error",
      { ignores: ["modules"] },
    ],
  },
  overrides: [
    {
      files: ["**/*.ts?(x)", "**/*.js?{x}"],
      rules: { "prettier/prettier": ["warn", prettierOptions] },
    },
    {
      files: ["contracts/**/*.sol"],
      rules: { "prettier/prettier": ["warn", prettierOptions] },
    },
  ],
};
