-- Vue (Volar / vue-language-server) for Inertia/Vue SFCs
local init_options = {}

local tsserver = vim.fn.exepath("typescript-language-server")
if tsserver ~= "" then
  init_options.typescript = { serverPath = tsserver }
end

return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json", "vite.config.ts", "vite.config.js", ".git" },
  init_options = init_options,
}