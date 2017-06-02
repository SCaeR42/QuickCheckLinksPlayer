if GetLocale() ~= "ruRU" then return end

select( 2, ... ).L = setmetatable( {
  WPLINK = "Ссылка на wowprogress.com",
  WPLINKCOLOR = "Ссылка на |CFFCC33FFwowprogress.com|r: ",
  ARMORYLINK = "Ссылка на armory",
  LANGUAGE = "ru",
}, { __index = select( 2, ... ).L })