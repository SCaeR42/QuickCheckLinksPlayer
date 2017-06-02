-- default
select( 2, ... ).L = setmetatable( {
  WPLINK = "Link to wowprogress.com",
  WPLINKCOLOR = "Link to |CFFCC33FFwowprogress.com|r: ",
  ARMORYLINK = "Link to armory",
  LANGUAGE = "en",
}, {
	__index = function ( self, Key )
		if ( Key ~= nil ) then
			rawset( self, Key, Key )
			return Key
		end
	end
} )