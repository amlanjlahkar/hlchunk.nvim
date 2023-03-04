---@diagnostic disable: param-type-mismatch
local opts = require("hlchunk.options")
local M = {}

function M.get_pair_rows()
    local beg_row, end_row
    local base_flag = "nWz"
    local cur_row_val = vim.fn.getline(".")
    local cur_col = vim.fn.col(".")
    local cur_char = string.sub(cur_row_val, cur_col, cur_col)

    beg_row = vim.fn.searchpair("{", "", "}", base_flag .. "b" .. (cur_char == "{" and "c" or ""))
    end_row = vim.fn.searchpair("{", "", "}", base_flag .. (cur_char == "}" and "c" or ""))

    if beg_row <= 0 or end_row <= 0 then
        return { 0, 0 }
    end

    return { beg_row, end_row }
end

function M.get_rows_blank()
    local rows_blank = {}
    local beg_row = vim.fn.line("w0")
    local end_row = vim.fn.line("w$")

    if opts.config.hl_indent.use_treesitter then
        local ts_indent_status, ts_indent = pcall(require, "nvim-treesitter.indent")
        if not ts_indent_status then
            return {}
        end

        for i = beg_row, end_row do
            if #vim.fn.getline(i) == 0 then
                rows_blank[i] = -1
            else
                rows_blank[i] = math.min(ts_indent.get_indent(i) or 0, vim.fn.indent(i))
            end
        end
    else
        for i = beg_row, end_row do
            local row_str = vim.fn.getline(i)
            if #row_str == 0 then
                rows_blank[i] = -1
            else
                rows_blank[i] = vim.fn.indent(i)
            end
        end
    end

    return rows_blank
end

return M