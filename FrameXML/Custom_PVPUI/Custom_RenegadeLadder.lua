UIPanelWindows["RenegadeLadderFrame"] = { area = "left",	pushable = 0, whileDead = 1, xOffset = "15", yOffset = "-10", width = 593, height = 428 }

local CACHE_TIME_TO_LIFE = 300

enum:E_RENEGADE_KINGS {
    "NAME",
    "CLASSID",
    "KILLS",
    "AREAID"
}

RenegadeLadderFrameMixin = {}

function RenegadeLadderFrameMixin:OnLoad()
    self:RegisterHookListener()
    self:RegisterEventListener()

    self.factionIcons   = {
        [PLAYER_FACTION_GROUP.Horde]    = "right",
        [PLAYER_FACTION_GROUP.Alliance] = "left",
        [PLAYER_FACTION_GROUP.Renegade] = "Renegade",
    }

    RaiseFrameLevelByTwo(self.Shadows)

    C_FactionManager:RegisterFactionOverrideCallback(function()
        SetPortraitToTexture(self.Art.portrait, PVPUIFRAME_PORTRAIT_DATA[C_Unit.GetFactionID("player")])
    end, true)

	self.helpPlate = {
		FramePos = { x = 0, y = -24 },
		FrameSize = { width = 595, height = 402 },
		[1] = { ButtonPos = { x = 156, y = -50 }, HighLightBox = { x = 4, y = -34, width = 212, height = 80 }, ToolTipDir = "DOWN", ToolTipText = HEPLPLATE_RENEGADELADDERFRAME_TUTORIAL_1 },
		[2] = { ButtonPos = { x = 92, y = -224 }, HighLightBox = { x = 4, y = -124, width = 212, height = 274 }, ToolTipDir = "DOWN", ToolTipText = HEPLPLATE_RENEGADELADDERFRAME_TUTORIAL_2 },
		[3] = { ButtonPos = { x = 360, y = -194 }, HighLightBox = { x = 222, y = -34, width = 334, height = 318 }, ToolTipDir = "DOWN", ToolTipText = HEPLPLATE_RENEGADELADDERFRAME_TUTORIAL_3 },
		[4] = { ButtonPos = { x = 556, y = -48 }, HighLightBox = { x = 559, y = -51, width = 40, height = 40 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_RENEGADELADDERFRAME_TUTORIAL_4 },
		[5] = { ButtonPos = { x = 562, y = -227 }, HighLightBox = { x = 559, y = -101, width = 26, height = 300 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_RENEGADELADDERFRAME_TUTORIAL_5 },
	}
end

function RenegadeLadderFrameMixin:OnShow()
    PanelTemplates_SetTab(self, 4)
    UpdateMicroButtons()

    if UnitLevel("player") < 15 then
        PanelTemplates_DisableTab(self, 1)
    else
        PanelTemplates_EnableTab(self, 1)
    end

    self.Container.RightContainer.CentralContainer.ScrollFrame.update = function() self:UpdateLadderScrollFrame() end
    HybridScrollFrame_SetDoNotHideScrollBar(self.Container.RightContainer.CentralContainer.ScrollFrame, true)
    HybridScrollFrame_CreateButtons(self.Container.RightContainer.CentralContainer.ScrollFrame, "RenegadeLadderScrollPlayerButtonTemplate", 0, -2, nil, nil, nil, -2)

    self.Container.CategoryButton1:Click()
    self.Container.RightBigTab1:Click()

    self:UpdateLocalPlayerInfo()
    self:UpdateKingsFrame()

    -- TODO: Если будет нужно добавить кэширование +/- на 30 секунд, дабы не было флуда запросами на сервер.
    SendServerMessage("ACMSG_RENEGADE_KINGS")

	EventRegistry:TriggerEvent("RenegadeLadderFrame.OnShow")
end

function RenegadeLadderFrameMixin:OnHide()
	UpdateMicroButtons()
	LAST_FINDPARTY_FRAME = self

	HelpPlate_Hide(false)

	EventRegistry:TriggerEvent("RenegadeLadderFrame.OnHide")
end

function RenegadeLadderFrameMixin:ToggleTutorial()
	if not HelpPlate_IsShowing(self.helpPlate) then
		HelpPlate_Show(self.helpPlate, self, self.TutorialButton)
	else
		HelpPlate_Hide(true)
	end
end

function RenegadeLadderFrameMixin:VARIABLES_LOADED()
    UpdatePVPTabs(self)
end

---@param tabID number
function RenegadeLadderFrameMixin:SetActiveTab( tabID )
    self.activeTab = tabID
end

---@return number activeTab
function RenegadeLadderFrameMixin:GetActiveTab()
    return self.activeTab or 0
end

---@param key string
---@param value string | number | table
---@param isNeedTTL? boolean
function RenegadeLadderFrameMixin:SetCache( key, value, isNeedTTL )
    C_CacheInstance:Set(key, value, isNeedTTL and CACHE_TIME_TO_LIFE)
end

---@param key string
---@return string | number | table cache
function RenegadeLadderFrameMixin:GetCache( key, dafaultValue )
    return C_CacheInstance:Get(key, dafaultValue)
end

---@return table playerInfo
function RenegadeLadderFrameMixin:GetLocalPlayerInfo()
    local playerInfoCache = self:GetCache("RENEGADE_LADDER_PLAYER")

    if not playerInfoCache or #playerInfoCache == 0 then
        return
    end

    local playerInfo = playerInfoCache[1]

    playerInfo.raceInfo     = playerInfo.raceInfo or C_CreatureInfo.GetRaceInfo(playerInfo.raceID)

    local classLocalizedName, classFileString = GetClassInfo(playerInfo.classID)

    playerInfo.classInfo    = playerInfo.classInfo or {
        localizedName   = classLocalizedName,
        fileString      = classFileString
    }

    return playerInfo
end

---@param index number
function RenegadeLadderFrameMixin:GetKingInfo( index )
    local kingCache = self:GetCache("ASMSG_RENEGADE_KINGS")

    if (not kingCache or #kingCache == 0) or not kingCache[index] then
        return
    end

    local kingInfo = kingCache[index]

	kingInfo.areaLocalizedName = C_Map.GetAreaNameByID(kingInfo.areaID) or RENEGADE_LADDER_UNKNOWN_MAP

    return kingInfo
end

function RenegadeLadderFrameMixin:UpdateLocalPlayerInfo()
    local frame         = self.Container.RightContainer.BottomContainer
    local playerInfo    = self:GetLocalPlayerInfo()

    if playerInfo then
        frame.Number:SetText(playerInfo.rank)
        frame.PlayerName:SetText(playerInfo.name)
        frame.Rating:SetText(playerInfo.kills)

        frame.RaceIcon.Icon:SetTexture(string.format("Interface\\Custom\\RaceIcon\\RACE_ICON_%s%s", string.upper(playerInfo.raceInfo.clientFileString), S_GENDER_FILESTRING[playerInfo.gender]))
        frame.RaceIcon.raceName = playerInfo.raceInfo.raceName

        frame.ClassIcon.Icon:SetTexture("Interface\\Custom\\ClassIcon\\CLASS_ICON_"..string.upper(playerInfo.classInfo.fileString))
        frame.ClassIcon.classLocalizedName = playerInfo.classInfo.localizedName

		frame.FactionIcon.Icon:SetAtlas("objectivewidget-icon-"..self.factionIcons[playerInfo.factionID])
		frame.FactionIcon.factionName = _G["FACTION_"..string.upper(PLAYER_FACTION_GROUP[playerInfo.factionID])]

		if playerInfo.zodiacID then
			local _, zodiacName, zodiacDescription, zodiacIcon, zodiacAtlas = C_ZodiacSign.GetZodiacSignInfo(playerInfo.zodiacID)
			frame.ZodiacIcon.Icon:SetTexture(zodiacIcon)
			frame.ZodiacIcon.name = zodiacName
		end
    end

    frame.Number:SetShown(playerInfo)
    frame.PlayerName:SetShown(playerInfo)
    frame.Rating:SetShown(playerInfo)
    frame.RaceIcon:SetShown(playerInfo)
    frame.ClassIcon:SetShown(playerInfo)
    frame.FactionIcon:SetShown(playerInfo)
	frame.ZodiacIcon:SetShown(playerInfo and playerInfo.zodiacID)

    frame.PlayerNotRank:SetShown(not playerInfo)
    frame.Background:SetDesaturated(not playerInfo)
    frame.Border:SetDesaturated(not playerInfo)
end

function RenegadeLadderFrameMixin:UpdateKingsFrame()
    for index, frame in pairs(self.kingFrames) do
        local kingInfo = self:GetKingInfo(index)

        if kingInfo then
            frame:SetKing(kingInfo.name, kingInfo.classID, kingInfo.areaLocalizedName, kingInfo.kills)
        end

        frame:SetShown(kingInfo)
    end
end

function RenegadeLadderFrameMixin:ShowLoading()
    self.Container.RightContainer.CentralContainer.ScrollFrame.TextLabelFrame:Hide()
    self.Container.RightContainer.CentralContainer.ScrollFrame.Spinner:Show()
end

function RenegadeLadderFrameMixin:HideLoading()
    self.Container.RightContainer.CentralContainer.ScrollFrame.Spinner:Hide()
end

---@return number playerCache
function RenegadeLadderFrameMixin:GetLadderPlayerCount()
    local playerCache = self:GetCache("RENEGADE_LADDER_PLAYERS_CACHE_"..self:GetActiveTab())
    return playerCache and #playerCache or 0
end

---@param index number
---@return table playerInfo
function RenegadeLadderFrameMixin:GetLadderPlayerInfo( index )
    local playerCache = self:GetCache("RENEGADE_LADDER_PLAYERS_CACHE_"..self:GetActiveTab())

    if (not playerCache or playerCache == 0) or not playerCache[index] then
        return
    end

    local playerInfo  = playerCache[index]

    local classLocalizedName, classFileString = GetClassInfo(playerInfo.classID)

    playerInfo.classInfo = playerInfo.classInfo or {
        localizedName   = classLocalizedName,
        fileString      = classFileString,
        icon            = "Interface\\Custom\\ClassIcon\\CLASS_ICON_"..string.upper(classFileString)
    }

    playerInfo.raceInfo = playerInfo.raceInfo or C_CreatureInfo.GetRaceInfo(playerInfo.raceID)
    playerInfo.raceInfo.icon = playerInfo.raceInfo.icon or string.format("Interface\\Custom\\RaceIcon\\RACE_ICON_%s%s", string.upper(playerInfo.raceInfo.clientFileString), S_GENDER_FILESTRING[playerInfo.gender])

    playerInfo.factionInfo = playerInfo.factionInfo or {}
	playerInfo.factionInfo.name = _G["FACTION_"..string.upper(PLAYER_FACTION_GROUP[playerInfo.factionID])]
	playerInfo.factionInfo.iconAtlas = playerInfo.factionInfo.iconAtlas or ("objectivewidget-icon-"..self.factionIcons[playerInfo.factionID])

    playerInfo.index = index

    return playerInfo
end

function RenegadeLadderFrameMixin:UpdateLadderScrollFrame()
    local scrollFrame = self.Container.RightContainer.CentralContainer.ScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons
    local numButtons = buttons and #buttons or 0
    local button, index

    local playerCount = self:GetLadderPlayerCount()

    if playerCount == 0 then
        if self:GetActiveTab() == 2 then
            scrollFrame.TextLabelFrame.Text:SetText(RENEGADE_LADDER_SEARCH_TUTORIAL)
        else
            scrollFrame.TextLabelFrame.Text:SetText(PVP_LADDER_SEARCH_NOT_RESULT)
        end
    end

    scrollFrame.TextLabelFrame:SetShown(playerCount == 0)

    for i = 1, numButtons do
        button = buttons[i]
        index = offset + i

        if index <= playerCount then
            local playerInfo = self:GetLadderPlayerInfo(index)

            button.FontStringFrame.Number:SetText(playerInfo.rank)
            button.FontStringFrame.PlayerName:SetText(GetClassColorObj(playerInfo.classInfo.fileString):WrapTextInColorCode(playerInfo.name))

            button.RaceIcon.Icon:SetTexture(playerInfo.raceInfo.icon)
            button.RaceIcon.raceName = playerInfo.raceInfo.raceName

            button.ClassIcon.Icon:SetTexture(playerInfo.classInfo.icon)
            button.ClassIcon.classLocalizedName = playerInfo.classInfo.localizedName

            button.FactionIcon.Icon:SetAtlas(playerInfo.factionInfo.iconAtlas)
            button.FactionIcon.factionName = playerInfo.factionInfo.name
            button.FactionIcon:SetAlpha(playerInfo.factionInfo.name == FACTION_RENEGADE and 1 or 0.5)

			if playerInfo.zodiacID then
				local _, zodiacName, zodiacDescription, zodiacIcon, zodiacAtlas = C_ZodiacSign.GetZodiacSignInfo(playerInfo.zodiacID)
				button.ZodiacIcon.Icon:SetTexture(zodiacIcon)
				button.ZodiacIcon.name = zodiacName
				button.ZodiacIcon:Show()
			else
				button.ZodiacIcon:Hide()
			end

            button.FontStringFrame.Rating:SetText(playerInfo.kills)

            button.Background:SetShown(index % 2 ~= 0)

            button.index = index
            button:Show()
        else
            button:Hide()
        end
    end

    local totalHeight = playerCount * (buttons and buttons[1]:GetHeight() or 0) + (playerCount - 1) * 2
    HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight())
end

function RenegadeLadderFrameMixin:RENEGADE_LADDER_TOP(playerEntryList)
	if not playerEntryList then
        for _, tabButton in pairs(self.tabs) do
            self:SetCache("RENEGADE_LADDER_PLAYERS_CACHE_"..tabButton.buttonID, {}, true)
        end

        self:SetCache("RENEGADE_LADDER_PLAYER", {}, true)
    else
		self:SetCache("RENEGADE_LADDER_PLAYERS_CACHE_"..self:GetActiveTab(), playerEntryList, true)
    end

    self:HideLoading()
    self:UpdateLadderScrollFrame()
end

function RenegadeLadderFrameMixin:RENEGADE_LADDER_CLASS_TOP(playerEntryList)
	self:SetCache("RENEGADE_LADDER_PLAYERS_CACHE_"..self:GetActiveTab(), playerEntryList, true)

    self:HideLoading()
    self:UpdateLadderScrollFrame()
end

function RenegadeLadderFrameMixin:RENEGADE_LADDER_PLAYER(playerEntryList)
	self:SetCache("RENEGADE_LADDER_PLAYER", playerEntryList, true)
    self:UpdateLocalPlayerInfo()
end

function RenegadeLadderFrameMixin:RENEGADE_LADDER_SEARCH_RESULT(playerEntryList)
    self.Container.RightContainer.TopContainer.SearchFrame.SearchButton:StartDelay()
	self:RENEGADE_LADDER_CLASS_TOP(playerEntryList)
end

function RenegadeLadderFrameMixin:ASMSG_RENEGADE_KINGS( msg )
    local kingsData     = C_Split(msg, "|")
    local kingCache     = self:GetCache("ASMSG_RENEGADE_KINGS", {})

    if not kingsData or #kingsData == 0 then
        self:SetCache("ASMSG_RENEGADE_KINGS", {})
    end

    for index, data in pairs(kingsData) do
        local kingInfo = C_Split(data, ":")

        kingCache[index] = {
            name    = kingInfo[E_RENEGADE_KINGS.NAME],
            classID = tonumber(kingInfo[E_RENEGADE_KINGS.CLASSID]),
            kills   = tonumber(kingInfo[E_RENEGADE_KINGS.KILLS]),
            areaID  = tonumber(kingInfo[E_RENEGADE_KINGS.AREAID])
        }
    end

    self:UpdateKingsFrame()
end

RenegadeLadderTabsMixin = {}

function RenegadeLadderTabsMixin:OnLoad()
    local icon = self:GetAttribute("icon")
    local localizedClassName, className = GetClassInfo(self:GetID() - 2)

    if icon then
        self.Icon:SetTexture("Interface\\Icons\\"..icon)
    else
        self.Icon:SetTexture("Interface\\Custom\\ClassIcon\\CLASS_ICON_"..string.upper(className))
    end

    self:SetFrameLevel(self:GetParent():GetFrameLevel() + 3)

    self.localizedClassName = localizedClassName
    self.buttonID 			= self:GetID()

    self:GetParent():SetParentArray("tabs", self)
end

function RenegadeLadderTabsMixin:OnClick()
    local mainFrame = self:GetParent():GetParent()
	local playerCache, expiredTTL = mainFrame:GetCache("RENEGADE_LADDER_PLAYERS_CACHE_"..self.buttonID)

    if mainFrame:GetActiveTab() == self.buttonID then
        self:SetChecked(true)
		if not expiredTTL then
			return
		end
    end

    for _, button in pairs(mainFrame.tabs) do
        button:SetChecked(self == button)
    end

    mainFrame:SetActiveTab(self.buttonID)

    self:GetParent().RightContainer.TopContainer.SearchFrame:SetShown(self.buttonID == 2)
    self:GetParent().RightContainer.TopContainer.TitleFrame:SetShown(self.buttonID ~= 2)

    if self.buttonID == 1 then
        if not playerCache or #playerCache == 0 then
            SendServerMessage("ACMSG_PVP_LADDER_GET_TOP", E_LADDER_BRACKET.RENEGADE)
            mainFrame:ShowLoading()
            return
        end
    elseif self.buttonID == 2 then
        -- search tab
    else
        if not playerCache or #playerCache == 0 then
            SendServerMessage("ACMSG_PVP_LADDER_GET_CLASS_TOP", string.format("%d:%d", E_LADDER_BRACKET.RENEGADE, self.buttonID - 2))
            mainFrame:ShowLoading()
            return
        end
    end

    mainFrame:HideLoading()
    mainFrame:UpdateLadderScrollFrame()
end

RenegadeLadderKingsMixin = {}

function RenegadeLadderKingsMixin:OnLoad()
    self.Crown:SetAtlas("Renegade-Crown-2")
    self.Background:SetAtlas("titleprestige-title-bg")
    self.KillsBackground:SetAtlas("scoreboard-charactermodels-shadow")

    RenegadeLadderFrame.Container:SetParentArray("kingFrames", self)
end

function RenegadeLadderKingsMixin:SetKing(name, classID, location, kills)
    if not name or not classID or not location or not kills then
        self:Hide()
        return
    end

    local classInfo = C_CreatureInfo.GetClassInfo(classID)
    local r, g, b = GetClassColor(classInfo.classFile)

    self.Name:SetText(name)
    self.Name:SetTextColor(r, g, b)

    self.Location:SetText(location)
    self.Kills:SetText(kills)
end