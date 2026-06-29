return {
  'lervag/vimtex',
  ft = 'tex',
  lazy = false,
  init = function()
    vim.g.vimtex_mappings_enabled = 1
    vim.g.vimtex_view_method = 'general'
    vim.g.vimtex_view_general_viewer = 'C:/Users/Mezbah/AppData/Local/SumatraPDF/SumatraPDF.exe'
    vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function()
        local servername = vim.v.servername
        if servername and servername ~= '' then
          local tempfile = os.getenv 'TEMP' .. '\\vimtexserver.txt'
          local ok, err = pcall(function()
            local f = io.open(tempfile, 'w')
            if f then
              f:write(servername)
              f:close()
            else
              print('Failed to open ' .. tempfile)
            end
          end)
          if not ok then
            print('Error writing servername: ' .. err)
          end
        end
        vim.keymap.set('n', '<leader>ce', '<plug>(vimtex-env-change)', { buffer = true })
      end,
    })
  end,
}
