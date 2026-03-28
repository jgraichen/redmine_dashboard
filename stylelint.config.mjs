/** @type {import('stylelint').Config} */
export default {
  extends: [
    "stylelint-config-standard",
    "stylelint-no-unsupported-browser-features",
  ],
  rules: {
    "plugin/no-unsupported-browser-features": [true],
  },
};
