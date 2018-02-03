-- default
select(2, ...).L = setmetatable({
    WPLINK = "Link to wowprogress.com",
    WPLINKCOLOR = "Link to |CFFF8B70Awowprogress.com|r ",
    ARMORYLINK = "Link to armory",
    ARMORYLINKCOLOR = "Link to |CFFF8B70Aarmory|r ",
    RAIDERIOLINK = "Link to raider.io",
    RAIDERIOLINKCOLOR = "Link to |CFFF8B70Araider.io|r ",
    ADDONNAMECOLOR = "|CFF7AC491QuickCheckLinksPlayer|r",
    LANGUAGE = "en",
}, {
    __index = function(self, Key)
        if (Key ~= nil) then
            rawset(self, Key, Key)
            return Key
        end
    end
})