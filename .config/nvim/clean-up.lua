local pack_root = vim.fn.stdpath("data") .. "/site/pack/core/opt"

-- aktivni pluginovi
local active = {}

for _, plugin in pairs(vim.pack.get()) do
  local name = plugin.spec.name
  if name then
    active[name] = plugin.active
  end
end

-- prodji kroz sve instalirane
for name, type in vim.fs.dir(pack_root) do
  if type == "directory" then
    if not active[name] then
        vim.print(name)
      print("Removing unused plugin: " .. name)
      vim.fn.delete(pack_root .. "/" .. name, "rf")
    end
  end
end

print("Done cleaning plugins")
