local M = {}

local pairs_table = {
    ['('] = ')',
    ['{'] = '}',
    ['['] = ']',
    ['"'] = '"',
    ["'"] = "'",
}

function M.setup()
    vim.api.nvim_set_keymap('i', '<CR>', '<CR>:lua require("autopair").handle_enter()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<BS>', '<BS>:lua require("autopair").handle_backspace()<CR>', { noremap = true, silent = true })

    vim.api.nvim_exec([[
        augroup PairedAutocomplete
            autocmd!
            autocmd InsertCharPre * lua require('autopair').handle_char()
        augroup END
    ]], false)
end

function M.handle_char()
    local col = vim.fn.col('.') - 1
    local line = vim.fn.getline('.')
    local char_before_cursor = line:sub(col, col)

    if pairs_table[char_before_cursor] then
        vim.api.nvim_feedkeys(pairs_table[char_before_cursor], 'n', true)
    end
end

function M.handle_enter()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    local char_before_cursor = line:sub(col - 1, col - 1)

    if pairs_table[char_before_cursor] then
        vim.api.nvim_feedkeys("\n" .. pairs_table[char_before_cursor]:sub(1, -2), 'n', true)
    else
        vim.fn.feedkeys("<CR>", "n")
    end
end

function M.handle_backspace()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    local char_before_cursor = line:sub(col - 1, col - 1)

    if pairs_table[char_before_cursor] then
        vim.api.nvim_feedkeys("<BS>" .. pairs_table[char_before_cursor]:sub(1, -2), 'n', true)
    else
        vim.fn.feedkeys("<BS>", "n")
    end
end

return M

