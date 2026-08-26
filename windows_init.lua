vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8

vim.g.mapleader = " "

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.colorcolumn = "100"

vim.opt.mouse = "a"

vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true

vim.filetype.add({
    extension = {
        glsl = "glsl",
        vert = "glsl",
        frag = "glsl",
        geom = "glsl",
        comp = "glsl",
        tesc = "glsl",
        tese = "glsl",
    },
})

vim.pack.add({
    -- plugins
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/benomahony/youtube.nvim",

    -- themes
    "https://github.com/rmehri01/onenord.nvim",
    "https://github.com/shaunsingh/nord.nvim",
    "https://github.com/scottmckendry/cyberdream.nvim",
})

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
    keymap = {
        preset = "super-tab",
    },
})

local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

require("oil").setup()

require("youtube").setup({
    keymap = false,
    player_cmd = { "cmd", "/c", "start", "" },
})

require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "lua",
        "odin",
        "glsl",
    },
    callback = function()
        vim.treesitter.start()
    end,
})

vim.lsp.config("lua_ls", {
    cmd = {
        "C:\\ProgramData\\chocolatey\\lib\\lua-language-server\\tools\\x64\\bin\\lua-language-server.exe",
    },
    cmd_cwd = "C:\\ProgramData\\chocolatey\\lib\\lua-language-server\\tools\\x64",
    filetypes = { "lua" },
    capabilities = lsp_capabilities,
})

vim.lsp.config("clangd", {
    cmd = {
        "C:\\Program Files\\LLVM\\bin\\clangd.exe",
        "--background-index",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = {
        "compile_commands.json",
        ".clangd",
        ".git",
    },
    capabilities = lsp_capabilities,
})

vim.lsp.config("ols", {
    cmd = { "ols.exe" },
    filetypes = { "odin" },
    root_markers = {
        "ols.json",
        ".git",
    },
    capabilities = lsp_capabilities,
    init_options = {
        enable_hover = true,
        enable_snippets = true,
        enable_document_symbols = true,
        enable_format = true,
    },
})

vim.lsp.config("glsl_analyzer", {
    cmd = { "glsl_analyzer.exe" },
    filetypes = { "glsl" },
    root_markers = {
        ".git",
    },
    capabilities = lsp_capabilities,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("ols")
vim.lsp.enable("glsl_analyzer")

vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "gd", vim.lsp.buf.definition)

vim.keymap.set("n", "gr", vim.lsp.buf.references)

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)

vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

local function project_layout()
    vim.cmd("only")

    vim.cmd("vsplit")

    vim.cmd("wincmd h")
    vim.cmd("belowright split")
    vim.cmd("resize 12")
    vim.cmd("terminal cmd /k")
    vim.cmd("stopinsert")

    vim.cmd("wincmd l")
    vim.cmd("belowright split")
    vim.cmd("resize 12")
    vim.cmd("terminal codex")
    vim.cmd("stopinsert")

    vim.cmd("wincmd h")
    vim.cmd("wincmd k")
end

local function youtube_layout()
    project_layout()

    vim.cmd("wincmd l")
    vim.cmd("YouTube")
end

local function music_layout()
    vim.cmd("only")

    vim.cmd("vsplit")

    vim.cmd("wincmd l")
    vim.cmd("terminal spotify_player")
    vim.cmd("stopinsert")

    vim.cmd("belowright split")
    vim.cmd("resize 12")
    vim.cmd("terminal codex")
    vim.cmd("stopinsert")

    vim.cmd("wincmd h")
    vim.cmd("belowright split")
    vim.cmd("resize 12")
    vim.cmd("terminal cmd /k")
    vim.cmd("stopinsert")

    vim.cmd("wincmd k")
end

vim.keymap.set("n", "<leader>ms", music_layout, { desc = "Project layout with Spotify" })

vim.keymap.set("n", "<leader>wl", project_layout, { desc = "Project window layout" })
vim.keymap.set("n", "<leader>yt", youtube_layout, { desc = "Project layout with YouTube" })

local current_theme_index = 1

local themes = {
    "onenord",
    "nord",
    "cyberdream",
}

local function set_theme(theme)
    if theme == "onenord" then
        require("onenord").setup({
            borders = true,
            fade_nc = false,
        })
    elseif theme == "nord" then
        vim.g.nord_contrast = true
        vim.g.nord_borders = true
        vim.g.nord_italic = false
        vim.g.nord_bold = true
        require("nord").set()
    elseif theme == "cyberdream" then
        require("cyberdream").setup({
            variant = "default",
            transparent = false,
        })
        vim.cmd.colorscheme("cyberdream")
    end

    vim.notify("Theme: " .. theme)
end

local function next_theme()
    current_theme_index = current_theme_index + 1

    if current_theme_index > #themes then
        current_theme_index = 1
    end

    set_theme(themes[current_theme_index])
end

set_theme("onenord")

vim.keymap.set("n", "<leader>t1", function()
    current_theme_index = 1
    set_theme("onenord")
end, { desc = "Theme OneNord" })

vim.keymap.set("n", "<leader>t2", function()
    current_theme_index = 2
    set_theme("nord")
end, { desc = "Theme Nord" })

vim.keymap.set("n", "<leader>t3", function()
    current_theme_index = 3
    set_theme("cyberdream")
end, { desc = "Theme Cyberdream" })

vim.keymap.set("n", "<leader>tn", next_theme, { desc = "Next Theme "})