local mason_status, mason = pcall(require, "mason")
if not mason_status then
 vim.notify("没有找到 mason")
 return
end

local nlsp_status, nvim_lsp = pcall(require, "lspconfig")
if not nlsp_status then
 vim.notify("没有找到 lspconfig")
 return
end

local mlsp_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mlsp_status then
 vim.notify("没有找到 mason-lspconfig")
 return
end

mason.setup()
mason_lspconfig.setup({
    automatic_installation = true,
    ensure_installed = { "lua_ls" },
})

function LspKeybind(client, bufnr)
	-- 禁用格式化功能，交给专门插件插件处理
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	-- 绑定快捷键
	require("keybindings").mapLSP(buf_set_keymap)
end

function GoLspKeybind(client, bufnr)
	client.server_capabilities.semanticTokensProvider = {
		full = {
			delta = false,
		},
		legend = {
			-- from https://github.com/golang/tools/blob/master/gopls/internal/lsp/semantic.go#L981
			tokenTypes = {
				"namespace",
				"type",
				"class",
				"enum",
				"interface",
				"struct",
				"typeParameter",
				"parameter",
				"variable",
				"property",
				"enumMember",
				"event",
				"function",
				"method",
				"macro",
				"keyword",
				"modifier",
				"comment",
				"string",
				"number",
				"regexp",
				"operator",
			},
			tokenModifiers = {
				"declaration",
				"definition",
				"readonly",
				"static",
				"deprecated",
				"abstract",
				"async",
				"modification",
				"documentation",
				"defaultLibrary",
			},
		},
		range = true,
	}
	-- 禁用格式化功能，交给专门插件插件处理
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	-- 绑定快捷键
	require("keybindings").mapLSP(buf_set_keymap)
end
local util = require("lspconfig/util")


nvim_lsp.lua_ls.setup({
    on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
            checkThirdParty = false,
            library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
        }
    })
    end,
    settings = {
        Lua = {}
    },
    on_attach = LspKeybind,
})

nvim_lsp.gopls.setup({
    cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
		semanticTokens = true,
	},
	on_attach = GoLspKeybind,
})

nvim_lsp.tsserver.setup({
	on_attach = LspKeybind,
	filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
})

nvim_lsp.volar.setup{
  on_attach = LspKeybind,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
