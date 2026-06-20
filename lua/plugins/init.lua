-- lua/plugins/init.lua
local plugins = {}
local plugin_dir = vim.fn.stdpath "config" .. "/lua/plugins"

for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
  if file ~= "init.lua" and file:match "%.lua$" then
    local mod_name = "plugins." .. file:gsub("%.lua$", "")
    local ok, mod = pcall(require, mod_name)
    if ok then
      if type(mod) == "table" then
        if type(mod[1]) == "table" then
          vim.list_extend(plugins, mod)
        else
          table.insert(plugins, mod)
        end
      end
    else
      vim.notify("Plugin load error: " .. mod_name .. "\n" .. mod, vim.log.levels.WARN)
    end
  end
end

return plugins
