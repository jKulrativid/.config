local function get_vscode_settings()
    local settings_file = vim.fn.getcwd() .. '/.vscode/settings.json'
    if vim.fn.filereadable(settings_file) == 1 then
        local contents = vim.fn.readfile(settings_file)
        local settings = vim.fn.json_decode(table.concat(contents, '\n'))
        return settings
    end
    return {}
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/nvim-cmp", "b0o/schemastore.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local signs = { Error = "", Warn = "", Hint = "", Info = "" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            local lspconfig = require("lspconfig")
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            local vscode_settings = get_vscode_settings()
            if vscode_settings == nil then
                vscode_settings = {}
            end

            lspconfig.lua_ls.setup({
                capabilities = lsp_capabilities,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            version = "LuaJIT",
                            -- Setup your lua path
                            path = vim.split(package.path, ";"),
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { "vim" },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    })
                end,
                settings = {
                    Lua = {},
                },
            })

            lspconfig.robotcode.setup({
                capabilities = lsp_capabilities,
            })

            lspconfig.pyright.setup({
                capabilities = lsp_capabilities,
                cmd = { "pipenv", "run", "pyright-langserver", "--stdio" },
            })

            local gopls_settings = vscode_settings["gopls"] or {}

            lspconfig.gopls.setup {
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    gopls = {
                        analyses = gopls_settings["analyses"] or {
                            nilness = true,
                            unusedwrite = true,
                            useany = true,
                            unreachable = true,
                            unusedparams = true,
                            unusedvariable = true,
                        },
                        buildFlags = gopls_settings["buildFlags"] or {},
                        env = gopls_settings["env"] or {},
                        directoryFilters = gopls_settings["directoryFilters"] or {},
                        staticcheck = true,
                        gofumpt = true,
                        experimentalPostfixCompletions = true,
                    }
                }
            }

            lspconfig.html.setup({
                capabilities = lsp_capabilities,
            })

            lspconfig.cssls.setup({
                capabilities = lsp_capabilities,
            })
            lspconfig.cssmodules_ls.setup({
                capabilities = lsp_capabilities,
            })

            lspconfig.jsonls.setup({
                capabilities = lsp_capabilities,
            })

            lspconfig.yamlls.setup({
                capabilities = lsp_capabilities,
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = false,
                            url = "",
                        },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            })
        end,
        keys = function()
            -- stylua: ignore
            return {
                { "gd",         function() require("telescope.builtin").lsp_definitions() end,          desc = "Go to definition" },
                { "gi",         function() require("telescope.builtin").lsp_implementations() end,      desc = "Go to implementation" },
                { "gr",         function() require("telescope.builtin").lsp_references() end,           desc = "Go to references" },
                { "gt",         function() require("telescope.builtin").lsp_type_definitions() end,     desc = "Go to type definition" },

                { "K",          vim.lsp.buf.hover,                                                      desc = "Get information" },
                { "<leader>D",  function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "List diagnostics" },
                { "[d",         vim.diagnostic.goto_prev,                                               desc = "Previous diagnostic" },
                { "]d",         vim.diagnostic.goto_next,                                               desc = "Next diagnostic" },

                { "<leader>c",  "",                                                                     desc = "Code" },
                { "<leader>ca", vim.lsp.buf.code_action,                                                desc = "Action" },
                { "<leader>cr", vim.lsp.buf.rename,                                                     desc = "Rename" },
            }
        end,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            jsx_close_tag = {
                enable = true,
                filetypes = { "javascriptreact", "typescriptreact" },
            },
        },
    },
    {
        "maxandron/goplements.nvim",
        ft = "go",
        opts = {
            prefix = {
                interface = "impl by: ",
                struct = "impl: ",
            },
            display_package = true,
            namespace_name = "goplements",
            highlight = "Goplements",
        },
    },
}
