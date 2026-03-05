return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "astyle" },
        cpp = { "astyle" },
        java = { "astyle" },
        haskell = { "fourmolu" },
      },
    },
  },
}
