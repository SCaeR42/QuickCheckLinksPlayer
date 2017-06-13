-- Author      : CaSPeR

local addonName, addonTable, CURRENT_NAME, CURRENT_SERVER = ...
local L = addonTable.L
local LRI = LibStub:GetLibrary("LibRealmInfo");

-- wp link
UnitPopupButtons["QCLP_LINK_WP"] = {
    text = L.WPLINK,
    dist = 0,
    disabledInKioskMode = true,
};
-- armory link
UnitPopupButtons["QCLP_LINK_ARMORY"] = {
    text = L.ARMORYLINK,
    dist = 0,
    disabledInKioskMode = true,
};
-- Unit popup menu addon section dropdown
UnitPopupButtons["QCLP_MENU"] = {
    text = addonName,
    dist = 0,
    nested = 1,
    disabledInKioskMode = true,
    color = { r = 0.04, g = 0.95, b = 0 }, -- green e.q.: treangle mark
};
-- Second level menus
UnitPopupMenus["QCLP_MENU"] = {
    'QCLP_LINK_WP',
    'QCLP_LINK_ARMORY',
};

table.insert(UnitPopupMenus["PARTY"], #(UnitPopupMenus["PARTY"]), "QCLP_MENU");
table.insert(UnitPopupMenus["PLAYER"], #(UnitPopupMenus["PLAYER"]), "QCLP_MENU");
table.insert(UnitPopupMenus["RAID_PLAYER"], #(UnitPopupMenus["RAID_PLAYER"]), "QCLP_MENU");
table.insert(UnitPopupMenus["GUILD"], #(UnitPopupMenus["GUILD"]), "QCLP_MENU");
table.insert(UnitPopupMenus["GUILD_OFFLINE"], #(UnitPopupMenus["GUILD_OFFLINE"]), "QCLP_MENU");
table.insert(UnitPopupMenus["FRIEND"], #(UnitPopupMenus["FRIEND"]), "QCLP_MENU");
table.insert(UnitPopupMenus["FRIEND_OFFLINE"], #(UnitPopupMenus["FRIEND_OFFLINE"]), "QCLP_MENU");
table.insert(UnitPopupMenus["CHAT_ROSTER"], #(UnitPopupMenus["CHAT_ROSTER"]), "QCLP_MENU");

---------------------------------
-- Support functions
---------------------------------

-- Get realm info
local function GetRealm(server)
    if not server or server == "" then server = GetRealmName() end
    local _, realm, _, _, _, _, region = LRI:GetRealmInfo(server)
    realm = realm:gsub("'", "");
    realm = realm:gsub(" ", "-");
    return realm, region
end

-- Default type link
local function getType(type)
    if not type then type = 'wp' end
    return type;
end

-- build url to wp site
local function constructUrlWp(name, server)
    if not name or name == "" then return end
    --    url = "//www.wowprogress.com/search?type=char&q=" .. name .. "";
    local realm, region, url;
    realm, region = GetRealm(server);

    name = string.lower(name);
    region = string.lower(region);
    realm = string.lower(realm);

    url = '//www.wowprogress.com/character/' .. region .. '/' .. realm .. '/' .. name .. "";

    return url;
end

-- build url to armory site
local function constructUrlArmory(name, server)
    if not name or name == "" then return end
    local realm, region, url;
    realm, region = GetRealm(server);
    url = "//" .. region .. ".battle.net/wow/" .. L.LANGUAGE .. "/character/" .. realm .. "/" .. name .. "/advanced";
    return url;
end

---------------------------------
-- core func
---------------------------------

-- Sgow link
local function ShowUrl(name, server, type)
    if not name then return end
    type = getType(type);
    local url;
    if type == "wp" then
        url = constructUrlWp(name, server);
    elseif type == "armory" then
        url = constructUrlArmory(name, server);
    end
    if url then
        local edit_box = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(edit_box)
        if url then
            edit_box:Insert(url);
            edit_box:HighlightText();
        end
    end
end


--[[

-- settings
local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "QuickCheckLinksPlayer" then
        -- Our saved variables are ready at this point. If there are none, both variables will set to nil.
        if HaveWeMetCount == nil then
            HaveWeMetCount = 0; -- This is the first time this addon is loaded; initialize the count to 0.
        end
        if HaveWeMetBool then
            print("Hello again, " .. UnitName("player") .. "!");
        else
            HaveWeMetCount = HaveWeMetCount + 1; -- It's a new character.
            print("Hi; what is your name?");
        end
    elseif event == "PLAYER_LOGOUT" then
        HaveWeMetBool = true; -- We've met; commit it to memory.
    end
end
frame:SetScript("OnEvent", frame.OnEvent);

SLASH_QCLP1 = '/qclp';
-- slash commands whis regexp
-- e.q.: /qclp add testValue
local function handler(msg, editbox)
    local command, rest = msg:match("^(%S*)%s*(.-)$");
    DEFAULT_CHAT_FRAME:AddMessage("Command: " .. msg)
    DEFAULT_CHAT_FRAME:AddMessage("Command: '" .. rest .. "'")
    -- Any leading non-whitespace is captured into command;
    -- the rest (minus leading whitespace) is captured into rest.
    if command == "add" and rest ~= "" then
        -- Handle adding of the contents of rest... to something.
        print("Handle adding of the contents of rest... to something.");
    elseif command == "remove" and rest ~= "" then
        -- Handle removing of the contents of rest... to something.
        print("Handle removing of the contents of rest... to something.");
    else
        -- If not handled above, display some sort of help message
        print("Syntax: /yourcmd (add\|remove) someIdentifier");
    end
    print("HaveWeMet has met " .. HaveWeMetCount .. " characters.");
end
SlashCmdList["QCLP"] = handler;
]]

-- open popup menu
hooksecurefunc("UnitPopup_ShowMenu", function(self, which)
    if --[[which == "FRIEND" and ]] UIDROPDOWNMENU_MENU_LEVEL == 1 then
        CURRENT_NAME, CURRENT_SERVER = self.name, self.server
    end
end)

-- open on popup menu item
hooksecurefunc("UnitPopup_OnClick", function(self)
    local name, server = UIDROPDOWNMENU_INIT_MENU.name, UIDROPDOWNMENU_INIT_MENU.server
    local realm, region;
    if name == CURRENT_NAME and not server then server = CURRENT_SERVER end
    if self.value == "QCLP_LINK_WP" then
        if realm == '' then realm = 'Not realm found' end
        ShowUrl(name, server);
    end
    if self.value == "QCLP_LINK_ARMORY" then
        ShowUrl(name, server, 'armory');
    end

--    local realm, region;
--    realm, region = GetRealm(server);
--    DEFAULT_CHAT_FRAME:AddMessage("User name is: " .. name)
--    DEFAULT_CHAT_FRAME:AddMessage("User realm name is: " .. realm)
end)

---------------------------------
-- for LFG
---------------------------------

-- Show url for LFG
local function ShowUrlLFG(name, type)
    local realm, region, uName, uServer;
    if not name then return end
    uName = gsub(name, "%-[^|]+", "")
    uServer = gsub(name, "[^|]+%-", "")
    if uName == uServer then
        uServer = ''
    end
    ShowUrl(uName, uServer, type);
--    realm, region = GetRealm(uServer);
--    DEFAULT_CHAT_FRAME:AddMessage("User name is: " .. uName)
--    DEFAULT_CHAT_FRAME:AddMessage("User realm name is: " .. realm)
end

-- Поиск участников группы
local LFG_LIST_APPLICANT_MEMBER_MENU = {
    {
        text = nil, --Player name goes here
        isTitle = true,
        notCheckable = true,
    },
    {
        text = WHISPER,
        func = function(_, name) ChatFrame_SendTell(name); end,
        notCheckable = true,
        arg1 = nil, --Player name goes here
        disabled = nil, --Disabled if we don't have a name yet
    },
    {
        text = addonName,
        hasArrow = true,
        notCheckable = true,
        menuList = {
            -- Link to WP menu utem
            {
                text = L.WPLINK,
                func = function(_, name) ShowUrlLFG(name); end,
                notCheckable = true,
                arg1 = nil, --Player name goes here
                disabled = nil, --Disabled if we don't have a name yet
            },
            -- Link to Armory menu utem
            {
                text = L.ARMORYLINK,
                func = function(_, name) ShowUrlLFG(name, 'armory'); end,
                notCheckable = true,
                arg1 = nil, --Player name goes here
                disabled = nil, --Disabled if we don't have a name yet
            },
        },
    },
    {
        text = LFG_LIST_REPORT_FOR,
        hasArrow = true,
        notCheckable = true,
        menuList = {
            {
                text = LFG_LIST_BAD_PLAYER_NAME,
                notCheckable = true,
                func = function(_, id, memberIdx) C_LFGList.ReportApplicant(id, "badplayername", memberIdx); end,
                arg1 = nil, --Applicant ID goes here
                arg2 = nil, --Applicant Member index goes here
            },
            {
                text = LFG_LIST_BAD_DESCRIPTION,
                notCheckable = true,
                func = function(_, id) C_LFGList.ReportApplicant(id, "lfglistappcomment"); end,
                arg1 = nil, --Applicant ID goes here
            },
        },
    },
    {
        text = IGNORE_PLAYER,
        notCheckable = true,
        func = function(_, name, applicantID) AddIgnore(name); C_LFGList.DeclineApplicant(applicantID); end,
        arg1 = nil, --Player name goes here
        arg2 = nil, --Applicant ID goes here
        disabled = nil, --Disabled if we don't have a name yet
    },
    {
        text = CANCEL,
        notCheckable = true,
    },
};

function LFGListUtil_GetApplicantMemberMenu(applicantID, memberIdx)
    local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx);
    local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo(applicantID);
    LFG_LIST_APPLICANT_MEMBER_MENU[1].text = name or " ";
    LFG_LIST_APPLICANT_MEMBER_MENU[2].arg1 = name;
    LFG_LIST_APPLICANT_MEMBER_MENU[2].disabled = not name or (status ~= "applied" and status ~= "invited");
    LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[1].arg1 = name;
    LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[1].disabled = not name or (status ~= "applied" and status ~= "invited");
    LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[2].arg1 = name;
    LFG_LIST_APPLICANT_MEMBER_MENU[3].menuList[2].disabled = not name or (status ~= "applied" and status ~= "invited");
    LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg1 = applicantID;
    LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[1].arg2 = memberIdx;
    LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].arg1 = applicantID;
    LFG_LIST_APPLICANT_MEMBER_MENU[4].menuList[2].disabled = (comment == "");
    LFG_LIST_APPLICANT_MEMBER_MENU[5].arg1 = name;
    LFG_LIST_APPLICANT_MEMBER_MENU[5].arg2 = applicantID;
    LFG_LIST_APPLICANT_MEMBER_MENU[5].disabled = not name;
    return LFG_LIST_APPLICANT_MEMBER_MENU;
end
