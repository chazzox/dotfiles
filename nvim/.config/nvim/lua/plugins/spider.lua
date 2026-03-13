return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "w",
      "<cmd>lua require('spider').motion('w', {skipInsignificantPunctuation = false})<cr>",
      mode = { "n", "o", "x" },
    },
    {
      "e",
      "<cmd>lua require('spider').motion('e', {skipInsignificantPunctuation = false})<cr>",
      mode = { "n", "o", "x" },
    },
    {
      "b",
      "<cmd>lua require('spider').motion('b', {skipInsignificantPunctuation = false})<cr>",
      mode = { "n", "o", "x" },
    },
  },
}
