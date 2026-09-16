-- ════════════════════════════════════════════════════════════════════════════
-- LSP Keymaps (applied per-buffer on attach)
-- ════════════════════════════════════════════════════════════════════════════
local function setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buf = bufnr, desc = desc, silent = true })
  end

  -- Hover & Signature
  map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120 })
  end, "Hover")
  map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

  -- Smart Laravel & LSP Go to Definition
  map("n", "gd", function()
    -- Check if the laravel plugin is active and try jumping with it first
    local has_laravel, _ = pcall(require, "laravel")
    if has_laravel then
      local success, _ = pcall(vim.cmd, "LaravelGoto")
      if success then return end
    end
    -- If not inside a Laravel macro definition, fall back to standard native LSP
    vim.lsp.buf.definition()
  end, "Smart Go to Definition")

  -- gd, gD, gr, gi, gy handled by Snacks picker (snacks.lua)

  -- Diagnostics navigation
  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, "Prev Diagnostic")
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, "Next Diagnostic")

  -- <leader>c = Code
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
  map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostic")
  map("n", "<leader>cv", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Definition in Vsplit")

  -- <leader>l = LSP (using native :lsp command from 0.12)
  map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
  map("n", "<leader>lr", "<cmd>lsp restart<cr>", "LSP Restart")
  map("n", "<leader>lh", function()
    vim.lsp.inlay_hint.enable(
      not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
      { bufnr = bufnr }
    )
  end, "Toggle Inlay Hints")
end

-- ════════════════════════════════════════════════════════════════════════════
-- LspAttach Handler
-- ════════════════════════════════════════════════════════════════════════════
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    setup_keymaps(bufnr)

    -- Document highlight on cursor hold
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ════════════════════════════════════════════════════════════════════════════
-- Diagnostic Configuration
-- ════════════════════════════════════════════════════════════════════════════
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true, header = "", prefix = "" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

-- ════════════════════════════════════════════════════════════════════════════
-- LSP Server Configuration (native 0.12 API)
-- Server configs loaded from lsp/ directory, activated with vim.lsp.enable()
-- ════════════════════════════════════════════════════════════════════════════
vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- vim.lsp.enable({
--   "lua_ls",
--   "gopls",
--   "zls",
--   "ts_ls",
--   "rust_analyzer",
--   "intelephense",
--   "bashls",
--   "pyright",
--   "cssls",
--   "html",
--   "jsonls",
--   "yamlls",
--   "sourcekit",
--   "laravel_lsp",
-- })
vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "intelephense",
  "laravel_lsp",
  "cssls",
  "html",
  "jsonls",
  "vue_ls",
})
-- ════════════════════════════════════════════════════════════════════════════
-- Mason: auto-install LSP servers, formatters, and linters
-- ════════════════════════════════════════════════════════════════════════════
return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      automatic_installation = true,
      automatic_enable = false,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- ensure_installed = {
      --   -- Linters
      --   "eslint_d",
      --   "luacheck",
      --   "golangci-lint",
      --   "shellcheck",
      --   "markdownlint",
      --   "yamllint",
      --   "jsonlint",
      --   "htmlhint",
      --   "stylelint",
      --   "phpstan",
      --   "ruff",
      --   "mypy",
      --   -- Formatters
      --   "stylua",
      --   "goimports",
      --   "prettier",
      --   "black",
      --   "isort",
      --   "shfmt",
      --   "pint",
      -- },
      ensure_installed = {
        -- LSP servers (mason package names, not vim.lsp.config names)
        "lua-language-server",
        "typescript-language-server",
        "intelephense",
        "css-lsp",   -- provides vscode-css-language-server
        "html-lsp",  -- provides vscode-html-language-server
        "json-lsp",  -- provides vscode-json-language-server
        "vue-language-server",
        -- Linters (Only PHP, JS, and Markup)
        "eslint_d",
        "shellcheck",
        "markdownlint",
        "htmlhint",
        "phpstan",
        -- Formatters (Only tools you need)
        "stylua",
        "prettier",
        "pint", -- Laravel Code Formatter
      },
    },
  },
}
