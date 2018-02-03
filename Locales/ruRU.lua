if GetLocale() ~= "ruRU" then return end

select(2, ...).L = setmetatable({
    WPLINK = "Ссылка на wowprogress.com",
    WPLINKCOLOR = "Ссылка на |CFFF8B70Awowprogress.com|r ",
    ARMORYLINK = "Ссылка на armory",
    ARMORYLINKCOLOR = "Ссылка на |CFFF8B70Aarmory|r ",
    RAIDERIOLINK = "Ссылка на raider.io",
    RAIDERIOLINKCOLOR = "Ссылка на |CFFF8B70Araider.io|r ",
    ADDONNAMECOLOR = "|CFF7AC491QuickCheckLinksPlayer|r",
    LANGUAGE = "ru",
}, { __index = select(2, ...).L })