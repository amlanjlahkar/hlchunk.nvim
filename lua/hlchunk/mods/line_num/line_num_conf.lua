local class = require("hlchunk.utils.class")
local BaseConf = require("hlchunk.mods.base_mod.base_conf")

---@class UserLineNumConf : UserBaseConf
---@field use_treesitter? boolean

---@class LineNumConf : BaseConf
---@field use_treesitter boolean
---@overload fun(conf?: table): ChunkConf
local LineNumConf = class(BaseConf, function(self, conf)
    local default_conf = {
        style = "#806d9c",
        priority = 10,
        use_treesitter = false,
    }
    conf = vim.tbl_deep_extend("force", default_conf, conf or {}) --[[@as LineNumConf]]
    BaseConf.init(self, conf)

    self.style = conf.style
    self.use_treesitter = conf.use_treesitter
end)

return LineNumConf
