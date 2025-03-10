MAX_SPELLS = 1024
MAX_SKILLLINE_TABS = 8
SPELLS_PER_PAGE = 12
MAX_SPELL_PAGES = ceil(MAX_SPELLS / SPELLS_PER_PAGE)

BOOKTYPE_SPELL = "spell"
BOOKTYPE_PET = "pet"
BOOKTYPE_MOUNT = "mount";
BOOKTYPE_COMPANION = "companions";
BOOKTYPE_PROFESSION = "professions"

local MaxSpellBookTypes = 5
SPELLBOOK_PAGENUMBERS = {}

local CastSpell = CastSpell;
local CastSpellByID = CastSpellByID

local tutorialSpellBook = {}

SIRUS_SPELLBOOK_SPELL = {}
SIRUS_SPELLBOOK_SKILLLINE = {}

local spellbookCustomRender = {}
local spellbookCustomHiddenChatSpell = {305310, 305355}

local TECHNICAL_SKILL_LINES = {
	[SKILLNAME_COLLECTION_TOYS] = true,
	[SKILLNAME_COLLECTION_HEIRLOOM] = true,
	[SKILLNAME_COLLECTION_ILLUSIONS] = true,
}

local SPECIAL_SKILL_LINES = {
	[SKILLNAME_GUILD_BONUSES] = 0,
	[SKILLNAME_EQUIP_SPELLS] = 1,
}

local shapeshiftIgnoreSpell = {9634, 1066, 768, 783, 40120, 2457, 71, 2458, 465, 643, 1032, 7294, 10290, 10291, 10292, 10293, 10298, 10299, 10300, 10301, 19746, 19876, 19888, 19891, 19895, 19896, 19897, 19898, 19899, 19900, 27149, 27150, 27151, 27152, 27153, 27733, 30515, 30519, 32223, 35126, 40803, 41106, 42184, 48263, 48265, 48266, 48941, 48942, 48943, 48945, 48947, 54043, 55357, 55366, 63510, 63514, 63531, 63611, 260024, 260025, 302768}
local spellbookCustomHiddenSpell = {305495, 305036, 305037, 305038, 305039, 305040, 305041, 305042, 305043, 305044, 305045, 305046, 305047, 305048, 305049, 305050, 305051, 305052, 305053, 305054, 305055, 305056, 305057, 305058, 305059, 305060, 305061, 305062, 305063, 305064, 305065, 305066, 305067, 305068, 305069, 305070, 305071,
	317619,
	373391,
	374135,
	 -- proffesion
	2259,
	3101,
	3464,
	11611,
	28596,
	51304,
	28677,
	28675,
	28672,
	2018,
	29844,
	51300,
	3538,
	3100,
	9785,
	9788,
	17039,
	17040,
	17041,
	9787,
	7411,
	7412,
	7413,
	13920,
	28029,
	51313,
	4036,
	4037,
	4038,
	12656,
	30350,
	51306,
	20222,
	20219,
	2366,
	2368,
	3570,
	11993,
	28695,
	50300,
	45357,
	45358,
	45359,
	45360,
	45361,
	45363,
	25229,
	25230,
	28894,
	28895,
	28897,
	51311,
	2108,
	3104,
	3811,
	10662,
	32549,
	51302,
	10656,
	10660,
	10658,
	2575,
	2576,
	3564,
	10248,
	29354,
	50310,
	8613,
	8617,
	8618,
	10768,
	32678,
	50305,
	3908,
	3909,
	3910,
	12180,
	26790,
	51309,
	26798,
	26797,
	26801,
	2550,
	3102,
	3413,
	18260,
	33359,
	51296,
	3273,
	3274,
	7924,
	10846,
	27028,
	45542,
	7620,
	7731,
	7732,
	18248,
	33095,
	51294,
	62734,
	13262,
	51005,
	31252,
	2656,
	818,
	-- Mount
	305072,
	305073,
	305074,
	305075,
	-- raid marks
	306647,
	306648,
	306649,
	306650,
	306651,
	306652,
	306653,
	306654,
}
local spellbookCustomMountSpell = {
	{
		spellID = 305072,
		spellLevel = 20
	},
	{
		spellID = 305073,
		spellLevel = 40
	},
	{
		spellID = 305074,
		spellLevel = 60
	},
	{
		spellID = 305075,
		spellLevel = 70
	},
	{
		spellID = 54197,
		spellLevel = 77 -- bug #2892
	},
}

local spellbookSecondaryProfessionData = {
	[PROFESSION_FISHING] = {
		["Up"] = nil,
		["Down"] = {7620, 7731, 7732, 18248, 33095, 51294, 321750},
		isLearned = false,
		skillIndex = nil,
		skillName = nil,
		skillRank = nil,
		skillMaxRank = nil,
		index = 1,
		downSpell = nil,
	},
	[PROFESSION_COOKING] = {
		["Up"] = 818,
		["Down"] = {2550, 3102, 3413, 18260, 33359, 51296, 371933},
		isLearned = false,
		skillIndex = nil,
		skillName = nil,
		skillRank = nil,
		skillMaxRank = nil,
		index = 2,
		downSpell = nil,
	},
	[PROFESSION_FIRST_AID] = {
		["Up"] = nil,
		["Down"] = {3273, 3274, 7924, 10846, 27028, 45542, 318621},
		isLearned = false,
		skillIndex = nil,
		skillName = nil,
		skillRank = nil,
		skillMaxRank = nil,
		index = 3,
		downSpell = nil,
	},
}

local spellbookMainProfessionValue = {}
local spellbookMainProfessionData = {
	[TRADESKILL_ALCHEMY] = {
		["Up"] = nil,
		["Down"] = {2259, 3101, 3464, 11611, 28596, 51304, 28677, 28675, 28672, 321607}
	},
	[TRADESKILL_BLACKSMITHING] = {
		["Up"] = nil,
		["Down"] = {2018, 29844, 51300, 3538, 3100, 9785, 9788, 9787, 318625},
		["Down2"] = {17039, 17040, 17041}
	},
	[TRADESKILL_ENCHANTING] = {
		["Up"] = 13262,
		["Down"] = {7411, 7412, 7413, 13920, 28029, 51313, 318463}
	},
	[TRADESKILL_ENGINEERING] = {
		["Up"] = nil,
		["Down"] = {4036, 4037, 4038, 12656, 30350, 51306, 20222, 20219, 371826}
	},
	[TRADESKILL_HERBALISM] = {
		["Up"] = nil,
		["Down"] = {2366, 2368, 3570, 11993, 28695, 50300, 321987}
	},
	[TRADESKILL_INSCRIPTION] = {
		["Up"] = 51005,
		["Down"] = {45357, 45358, 45359, 45360, 45361, 45363, 371613}
	},
	[TRADESKILL_JEWELCRAFTING] = {
		["Up"] = 31252,
		["Down"] = {25229, 25230, 28894, 28895, 28897, 51311, 321990}
	},
	[TRADESKILL_LEATHERWORKING] = {
		["Up"] = nil,
		["Down"] = {2108, 3104, 3811, 10662, 32549, 51302, 10656, 10660, 10658, 321816}
	},
	[TRADESKILL_MINING] = {
		["Up"] = nil,
		["Down"] = {2656, 321744}
	},
	[TRADESKILL_SKINNING] = {
		["Up"] = nil,
		["Down"] = {8613, 8617, 8618, 10768, 32678, 50305, 321751}
	},
	[TRADESKILL_TAILORING] = {
		["Up"] = nil,
		["Down"] = {3908, 3909, 3910, 12180, 26790, 51309, 26798, 26797, 26801, 321754}
	},
}
local professionNameOverride = {
	[(GetSpellInfo(2656))] = TRADESKILL_MINING,
}
local professionIconOverride = {
	[TRADESKILL_MINING] = [[Interface\Icons\Trade_Mining]],
}

local ceil = ceil
local strlen = strlen
local tinsert = tinsert
local tremove = tremove

local function HelpPlate_Hide( data )
	if data then
		NPE_TutorialPointerFrame:Hide(data)
		data = nil
	end
end

function GetNumProfessions()
	return tCount(spellbookMainProfessionValue)
end

function ToggleSpellBook( bookType )
	local isShown = SpellBookFrame:IsShown()

	if ( bookType == BOOKTYPE_MOUNT and GetNumCompanions(bookType) == 0 ) then
		bookType = BOOKTYPE_SPELL
	end

	if ( isShown and (SpellBookFrame.bookType == bookType) ) then
		HideUIPanel(SpellBookFrame)
		return
	elseif isShown then
		SpellBookFrame_PlayOpenSound()
		SpellBookFrame.bookType = bookType
		SpellBookFrame.secureBookType = bookType
		SpellBookFrame_Update()
		UpdateSpells()
	else
		SpellBookFrame.bookType = bookType
		securecall(ShowUIPanel, SpellBookFrame)
	end

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_307810_1") and (tutorialSpellBook.spellLearnData and tutorialSpellBook.spellLearnData[1]) then
		NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_307810_1", true)
	end

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_308230_1") and (tutorialSpellBook.spellLearnData and tutorialSpellBook.spellLearnData[2]) then
		NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_308230_1", true)
	end

	HelpPlate_Hide(tutorialSpellBook.spellLearn)
end

function SpellBookFrame_OnLoad(self)
	self.TopTileStreaks:Hide()

	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("SKILL_LINES_CHANGED")
	self:RegisterEvent("VARIABLES_LOADED")

	SpellBookFrame.bookType = BOOKTYPE_SPELL
	-- Init page nums
	for i = 1, 14 do
		SPELLBOOK_PAGENUMBERS[i] = 1
	end
	SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] = 1

	-- Set to the first tab by default
	SpellBookSkillLineTab_OnClick(nil, 1)

	-- Initialize tab flashing
	SpellBookFrame.flashTabs = nil

	SetPortraitToTexture(self.portrait, "Interface\\Spellbook\\Spellbook-Icon")
	SpellBookFrame_UpdateSpellRender()

	for _, spellID in ipairs(spellbookCustomHiddenChatSpell) do
		FilterOutSpellLearn(spellID)
	end
end

function SpellBookFrame_OnEvent(self, event, ...)
	if ( event == "SPELLS_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" or event == "UPDATE_SHAPESHIFT_FORM" ) then
		if ( SpellBookFrame:IsShown() ) then
			SpellBookFrame_UpdateSpellRender()
			SpellButton_UpdateButton()
			SpellBookFrame_Update()
		end
	elseif ( event == "SKILL_LINES_CHANGED" ) then
		PrimaryProfession_Update()
	elseif ( event == "LEARNED_SPELL_IN_TAB" ) then
		SpellBook_UpdateTutorial()

		local arg1 = ...
		local flashFrame = _G["SpellBookSkillLineTab"..arg1.."Flash"]
		if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
			return
		else
			if ( flashFrame ) then
				flashFrame:Show()
				SpellBookFrame.flashTabs = 1
			end
		end
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		for i = 1, SPELLS_PER_PAGE do
			SpellButton_UpdateBorderOverlay(_G["SpellButton"..i])
		end
	elseif event == "PET_BAR_UPDATE" then
		if self.bookType == BOOKTYPE_PET then
			SpellBookFrame_UpdateSpellRender()
			SpellButton_UpdateButton()
		end
	elseif event == "VARIABLES_LOADED" then
		SpellBook_UpdateTutorial()
	end
end

function SpellBook_UpdateTutorial()
	HelpPlate_Hide(tutorialSpellBook.spellLearn)

	if C_Hardcore.IsFeatureAvailable(Enum.Hardcore.Features.VIP) then
		return
	end

	local spellForbsIsland
	local spellVipSelect
	local tutorialText

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_307810_1") then
		spellForbsIsland = IsSpellKnown(307810)
	end
	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_308230_1") then
		spellVipSelect = IsSpellKnown(308230)
	end

	if spellForbsIsland and spellVipSelect then
		tutorialText = FORBS_ISLAND_TUTORIAL_1 .. "\n\n" .. VIP_SELECTED_TUTORIAL_1
	elseif spellForbsIsland then
		tutorialText = FORBS_ISLAND_TUTORIAL_1
	elseif spellVipSelect then
		tutorialText = VIP_SELECTED_TUTORIAL_1
	end

	if tutorialText and tutorialSpellBook.spellTutorialText ~= tutorialText then
		tutorialSpellBook.spellTutorialText = tutorialText
		tutorialSpellBook.spellLearnData = {spellForbsIsland, spellVipSelect}

		local blockedTutorialID

		local onClose = function()
			C_TutorialManager.ClearOwner("MainMenuBar", "SpellBook_TutorialPoint")

			NPE_TutorialPointerFrame:Hide(tutorialSpellBook.spellLearn)
			tutorialSpellBook.spellLearn = nil

			if tutorialSpellBook.spellLearnData[1] then
				NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_307810_1", true)
			end
			if tutorialSpellBook.spellLearnData[2] then
				NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_308230_1", true)
			end
		end
		local onRelease = function(tutorialPointerID)
			if blockedTutorialID ~= tutorialPointerID then
				C_TutorialManager.ClearOwner("MainMenuBar", "SpellBook_TutorialPoint")
			end
		end

		if tutorialSpellBook.callbackRegistered then
			EventRegistry:UnregisterCallback("TutorialManager.OwnerFreed", tutorialSpellBook)
			tutorialSpellBook.callbackRegistered = nil
		end

		if C_TutorialManager.IsOwnerEmpty("MainMenuBar")
		or tutorialSpellBook.spellLearn -- in case popup already shown, we update it
		then
			if tutorialSpellBook.spellLearn then -- close old one for update of content
				blockedTutorialID = tutorialSpellBook.spellLearn
				NPE_TutorialPointerFrame:Hide(tutorialSpellBook.spellLearn)
				blockedTutorialID = nil
			end

			tutorialSpellBook.spellLearn = NPE_TutorialPointerFrame:Show(tutorialText, "DOWN", SpellbookMicroButton, 0, 0, nil, nil, nil, nil, onClose, onRelease)

			if tutorialSpellBook.spellLearn and tutorialSpellBook.spellLearn ~= 0 then
				C_TutorialManager.MarkOwnerUsed("MainMenuBar", "SpellBook_TutorialPoint")
			else
				tutorialSpellBook.spellLearn = nil
				tutorialSpellBook.spellLearnData = nil
				tutorialSpellBook.spellTutorialText = nil
			end
		else
			tutorialSpellBook.callbackRegistered = true

			EventRegistry:RegisterCallback("TutorialManager.OwnerFreed", function(this, owner)
				if owner == "MainMenuBar" then
					EventRegistry:UnregisterCallback("TutorialManager.OwnerFreed", this)
					tutorialSpellBook.callbackRegistered = nil

					tutorialSpellBook.spellLearn = NPE_TutorialPointerFrame:Show(tutorialText, "DOWN", SpellbookMicroButton, 0, 0, nil, nil, nil, nil, onClose, onRelease)

					if tutorialSpellBook.spellLearn and tutorialSpellBook.spellLearn ~= 0 then
						C_TutorialManager.MarkOwnerUsed("MainMenuBar", "SpellBook_TutorialPoint")
					else
						tutorialSpellBook.spellLearn = nil
						tutorialSpellBook.spellLearnData = nil
						tutorialSpellBook.spellTutorialText = nil
					end
				end
			end, tutorialSpellBook)
		end
	end
end

local SpellBookClosedTime
function SpellBookFrame_OnShow(self)
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:RegisterEvent("PET_BAR_UPDATE")
	self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

	local currentTime = time()

	if ( not SpellBookClosedTime or currentTime - SpellBookClosedTime >= S_RESET_FRAME_STATE_TIME ) then
		SpellBookFrame.secureBookType = nil
	end

	SpellBookFrame.bookType = SpellBookFrame.secureBookType or BOOKTYPE_SPELL
	SpellBookFrame_Update(1)

	-- If there are tabs waiting to flash, then flash them... yeah..
	if ( self.flashTabs ) then
		UIFrameFlash(SpellBookTabFlashFrame, 0.5, 0.5, 30, nil)
	end

	-- Show multibar slots
	securecall(MultiActionBar_ShowAllGrids)

	UpdateMicroButtons()

	SpellBookFrame_PlayOpenSound()

	PrimaryProfession_Update()

	EventRegistry:TriggerEvent("SpellBookFrame.OnShow")
end

function SpellBookFrame_OnHide(self)
	self:UnregisterEvent("SPELLS_CHANGED")
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:UnregisterEvent("PET_BAR_UPDATE")
	self:UnregisterEvent("ACTIONBAR_SLOT_CHANGED")

	SpellBookClosedTime = time()

	SpellBookFrame_PlayCloseSound()

	-- Stop the flash frame from flashing if its still flashing.. flash flash flash
	UIFrameFlashStop(SpellBookTabFlashFrame)
	-- Hide all the flashing textures
	for i=1, MAX_SKILLLINE_TABS do
		_G["SpellBookSkillLineTab"..i.."Flash"]:Hide()
	end

	-- Hide multibar slots
	securecall(MultiActionBar_HideAllGrids)

	-- Do this last, it can cause taint.
	UpdateMicroButtons()

	EventRegistry:TriggerEvent("SpellBookFrame.OnHide")
end

function SpellLinkToSpellID( link )
	if link then
		local spellID = string.match(link, "spell:(%d*)")
		if spellID then
			return tonumber(spellID)
		end
	end
	return nil
end

function IsSpellIgnore( spellID )
	if not spellID then
		error("IsSpellIgnore - not spellID")
	end

	if IsGMAccount() then
		return false
	end

	for _, floyutData in pairs(FLYOUT_STORAGE) do
		for _, flyoutSpellID in pairs(floyutData) do
			if flyoutSpellID == spellID then
				return true
			end
		end
	end

	return tContains(spellbookCustomHiddenSpell, spellID)
end

function SpellBook_GetSpellPage( spellID, skillline )
	if not spellbookCustomRender[skillline] then
		return
	end

	for spellIndex, spellData in pairs(spellbookCustomRender[skillline]) do
		if spellData.spellID == spellID then
			return math.ceil(spellIndex / 12)
		end
	end
end

function SpellBook_GetSpellIndex(spellID, bookType)
	if not spellID or not bookType then
		return;
	end

	local showAllSpellRanks = GetCVarBool("ShowAllSpellRanks");

	for tabIndex = 1, GetNumSpellTabs() do
		local _, _, offset, numSpells, highestRankOffset, highestRankNumSpells = GetSpellTabInfo(tabIndex);
		if not showAllSpellRanks then
			offset = highestRankOffset;
			numSpells = highestRankNumSpells;
		end

		for s = offset + 1, numSpells + offset do
			local spellIndex = (showAllSpellRanks or bookType == BOOKTYPE_PET) and s or GetKnownSlotFromHighestRankSlot(s);
			local spellLink = GetSpellLink(spellIndex, bookType);

			if spellLink and SpellLinkToSpellID(spellLink) == spellID then
				return spellIndex;
			end
		end
	end
end

local function SpellBook_SortSpells(a, b)
	if a.spellLevel ~= b.spellLevel then
		return a.spellLevel < b.spellLevel;
	else
		local aSpellName, bSpellName = GetSpellInfo(a.spellID) or "", GetSpellInfo(b.spellID) or "";
		return aSpellName < bSpellName;
	end
end

function SpellBookFrame_UpdateSpellRender()
	spellbookCustomRender = {}
	SpellBookFrame.selectedSkillLineOffset = {}
	SpellBookFrame.selectedSkillLineNumSpells = {}
	table.wipe(spellbookMainProfessionValue)

	for i = 1, GetNumSkillLines() do
		local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i)
		if isAbandonable and skillDescription ~= "" then
			if not spellbookMainProfessionValue[skillName] then
				spellbookMainProfessionValue[skillName] = {}
			end
			spellbookMainProfessionValue[skillName] = {skillIndex = i, skillName = skillName, skillRank = skillRank, skillMaxRank = skillMaxRank, skillModifier = skillModifier, downSpell = nil, upSpell = nil}
		end
		if spellbookSecondaryProfessionData[skillName] then
			spellbookSecondaryProfessionData[skillName].isLearned = true
			spellbookSecondaryProfessionData[skillName].skillIndex = i
			spellbookSecondaryProfessionData[skillName].skillName = skillName
			spellbookSecondaryProfessionData[skillName].skillRank = skillRank
			spellbookSecondaryProfessionData[skillName].skillMaxRank = skillMaxRank
			spellbookSecondaryProfessionData[skillName].skillModifier = skillModifier
		end
	end

	for i = 1, GetNumSpellTabs() do
		local temp, texture, offset, numSpells
		local spellLearned = {}
		local spellAllLearned = {}
		local spellMountLearned = {}

		if SpellBookFrame.bookType == BOOKTYPE_PET then
			temp, texture, offset, numSpells = nil, nil, 0, HasPetSpells() or 0
			spellbookCustomRender[1] = {}
		else
			temp, texture, offset, numSpells = SpellBook_GetTabInfo(i)
		end

		if not spellbookCustomRender[i] then
			spellbookCustomRender[i] = {}
		end

		for s = offset + 1, numSpells + offset do
			local spellLink
			local spellIndex

			if GetCVarBool("ShowAllSpellRanks") or SpellBookFrame.bookType == BOOKTYPE_PET then
				spellLink = GetSpellLink(s, SpellBookFrame.bookType)
				spellIndex = s
			else
				spellLink = GetSpellLink(GetKnownSlotFromHighestRankSlot(s), SpellBookFrame.bookType)
				spellIndex = GetKnownSlotFromHighestRankSlot(s)
			end

			if spellLink then
				if SpellBookFrame.bookType == BOOKTYPE_PET then
					local spellID = SpellLinkToSpellID(spellLink)
					if spellID and not IsSpellIgnore(spellID) then
						table.insert(spellbookCustomRender[1], {spellID = spellID, spellIndex = spellIndex})
					end
				else
					local spellID = SpellLinkToSpellID(spellLink)
					if spellID and not IsSpellIgnore(spellID) then
						table.insert(spellLearned, spellID)
						table.insert(spellbookCustomRender[i], {spellID = spellID, spellIndex = spellIndex})
					end

					if spellID then
						table.insert(spellAllLearned, spellID)
					end
				end
			end
		end

		local lineID

		for id, name in pairs(SIRUS_SPELLBOOK_SKILLLINE) do
			if temp == name then
				lineID = id
			end
		end

		if SIRUS_SPELLBOOK_SPELL and SIRUS_SPELLBOOK_SPELL[lineID] and #SIRUS_SPELLBOOK_SPELL[lineID] > 0 then
			table.sort(SIRUS_SPELLBOOK_SPELL[lineID], SpellBook_SortSpells);

			for q = 1, #SIRUS_SPELLBOOK_SPELL[lineID] do
				local data = SIRUS_SPELLBOOK_SPELL[lineID][q]
				if SpellBookFrame.bookType ~= BOOKTYPE_PET then
					if not tContains(spellLearned, data.spellID) and UnitLevel("player") < data.spellLevel then
						table.insert(spellbookCustomRender[i], {spellID = data.spellID, spellLevel = data.spellLevel})
					end
				end
			end
		end

		if i == 1 and SpellBookFrame.bookType ~= BOOKTYPE_PET then
			for k, v in pairs(spellbookCustomMountSpell) do
				if not tContains(spellAllLearned, v.spellID) then
					table.insert(spellbookCustomRender[1], {spellID = v.spellID, spellLevel = v.spellLevel, showTrain = true})
				elseif tContains(spellAllLearned, v.spellID) and v.spellID ~= 54197 then
					spellMountLearned = {spellID = v.spellID, v.spellLevel}
				end
			end

			if spellMountLearned.spellID then
				table.insert(spellbookCustomRender[1], {spellID = spellMountLearned.spellID, spellLevel = spellMountLearned.spellLevel, showTrain = false})
			end

			for r, t in pairs(spellbookMainProfessionData) do
				if spellbookMainProfessionValue[r] then
					for n = 1, #t["Down"] do
						local spellID = t["Down"][n]
						if tContains(spellAllLearned, spellID) then
							spellbookMainProfessionValue[r].downSpell = spellID
						end
					end
					if t["Up"] then
						local spellID = t["Up"]
						if tContains(spellAllLearned, spellID) then
							spellbookMainProfessionValue[r].upSpell = t["Up"]
						end
					end
					-- Fix for two specialization for Blacksmithing
					if t["Down2"] then
						for n = 1, #t["Down2"] do
							local spellID = t["Down2"][n]
							if tContains(spellAllLearned, spellID) then
								spellbookMainProfessionValue[r].downSpell = spellID
							end
						end
					end
				end
			end

			for _k, _v in pairs(spellbookSecondaryProfessionData) do
				for n = 1, #_v["Down"] do
					local spellID = _v["Down"][n]
					if tContains(spellAllLearned, spellID) then
						spellbookSecondaryProfessionData[_k].downSpell = spellID
					end
				end
			end
		end


		SpellBookFrame.selectedSkillLineOffset[i] = 1
		SpellBookFrame.selectedSkillLineNumSpells[i] = #spellbookCustomRender[i]
	end
	SpellBookFrame_UpdatePages()
end

function ProfessionButton_OnClick( self, ... )
	if ( IsModifiedClick() ) then
		if ( not self.data ) then
			return
		end
		if ( IsModifiedClick("CHATLINK") ) then
			if ( MacroFrame and MacroFrame:IsShown() ) then
				local spellName, subSpellName = GetSpellInfo(self.data)
				if ( spellName and not IsPassiveSpell(spellName) ) then
					if ( subSpellName and (strlen(subSpellName) > 0) ) then
						ChatEdit_InsertLink(spellName.."("..subSpellName..")")
					else
						ChatEdit_InsertLink(spellName)
					end
				end
				return
			else
				local spellLink, tradeSkillLink = GetSpellLink(self.data)
				if ( tradeSkillLink ) then
					ChatEdit_InsertLink(tradeSkillLink)
					elseif ( spellLink ) then
						ChatEdit_InsertLink(spellLink)
					end
					return
				end
			end
	else
		if self.data then
			local spell = self:GetAttribute("spell")
			CastSpellByID(spell)
		end
	end
end

function ProfessionButton_OnEnter( self, ... )
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if ( self.data and GameTooltip:SetHyperlink(GetSpellLink(self.data)) ) then
		self.UpdateTooltip = ProfessionButton_OnEnter
	else
		self.UpdateTooltip = nil
	end
end

function PrimaryProfession_Update()
	SpellBookFrame_UpdateSpellRender()

	for i = 1, 4 do
		local frame = _G["PrimaryProfession"..i]
		if frame then
			frame.Learn:Hide()
			frame.Missing:Show()
		end
	end

	local frameCount = 0
	for k, v in pairs(spellbookMainProfessionValue) do
		frameCount = frameCount + 1
		local frame = _G["PrimaryProfession"..frameCount]

		if frame then
			local _frame = frame.Learn
			local skillName = professionNameOverride[v.skillName] or v.skillName

			_frame.skillIndex = v.skillIndex
			_frame.skillName = skillName

			if v.downSpell then
				local downName, downSubName, downTexture = GetSpellInfo(v.downSpell)

				_frame.button1.data = v.downSpell
				_frame.button1:SetAttribute("spell", v.downSpell)
				_frame.button1:SetAttribute("name", downName)

				_frame.professionName:SetText(skillName)

				_frame.button1.iconTexture:SetTexture(downTexture)
				_frame.button1.spellString:SetText(downName)

				local icon = professionIconOverride[skillName] or downTexture
				SetPortraitToTexture(_frame.icon, icon)
			end

			if v.upSpell then
				local upName, upSubName, upTexture = GetSpellInfo(v.upSpell)

				_frame.button2.data = v.upSpell
				_frame.button2:SetAttribute("spell", v.upSpell)
				_frame.button2:SetAttribute("name", upName)

				_frame.button2.iconTexture:SetTexture(upTexture)
				_frame.button2.spellString:SetText(upName)

				_frame.button2:Show()
			else
				_frame.button2:Hide()
			end
			_frame.statusBar:SetMinMaxValues(1, v.skillMaxRank)
			_frame.statusBar:SetValue(v.skillRank)

			if v.skillRank == v.skillMaxRank then
				_frame.statusBar.capRight:Show()
			else
				_frame.statusBar.capRight:Hide()
			end

			SpellButton_UpdateSelection(_frame.button1)
			SpellButton_UpdateSelection(_frame.button2)

			_frame.statusBar.rankText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			_frame.statusBar.tooltip = nil

			if v.skillMaxRank > 1 and v.skillModifier and v.skillModifier > 0 then
				_frame.statusBar.rankText:SetFormattedText("%d (+%d)/%d", v.skillRank, v.skillModifier, v.skillMaxRank)
			else
				_frame.statusBar.rankText:SetFormattedText("%d/%d", v.skillRank, v.skillMaxRank)
			end

			frame.Learn:Show()
			frame.Missing:Hide()
		end
	end

	for d = 1, 3 do
		local frame = _G["SecondaryProfession"..d]
		if frame then
			frame.Learn:Hide()
			frame.Missing:Show()
		end
	end

	for n, c in pairs(spellbookSecondaryProfessionData) do
		local frame = _G["SecondaryProfession"..c.index]
		if frame and c.skillRank and c.skillName then
			local _frame = frame.Learn
			local skillName = professionNameOverride[c.skillName] or c.skillName

			_frame.skillIndex = c.skillIndex
			_frame.skillName = skillName

			if c.downSpell then
				local downName, downSubName, downTexture = GetSpellInfo(c.downSpell)

				_frame.button1.data = c.downSpell
				_frame.button1:SetAttribute("spell", c.downSpell)
				_frame.button1:SetAttribute("name", c.skillName)

				_frame.professionName:SetText(_frame.skillName)
				_frame.rank:SetText(downSubName)

				_frame.button1.iconTexture:SetTexture(downTexture)
				_frame.button1.spellString:SetText(downName)
			end

			if c["Up"] then
				local upName, upSubName, upTexture = GetSpellInfo(c["Up"])

				_frame.button2.data = c["Up"]

				_frame.button2.iconTexture:SetTexture(upTexture)
				_frame.button2.spellString:SetText(upName)
				_frame.button2:SetAttribute("spell", c["Up"])
				_frame.button2:SetAttribute("name", upName)

				_frame.button2:Show()
			else
				_frame.button2:Hide()
			end

			_frame.statusBar:SetMinMaxValues(1, c.skillMaxRank)
			_frame.statusBar:SetValue(c.skillRank)

			if c.skillRank == c.skillMaxRank then
				_frame.statusBar.capRight:Show()
			else
				_frame.statusBar.capRight:Hide()
			end

			SpellButton_UpdateSelection(_frame.button1)
			SpellButton_UpdateSelection(_frame.button2)

			_frame.statusBar.rankText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			_frame.statusBar.tooltip = nil

			if c.skillMaxRank > 1 and c.skillModifier and c.skillModifier > 0 then
				_frame.statusBar.rankText:SetFormattedText("%d (+%d)/%d", c.skillRank, c.skillModifier, c.skillMaxRank)
			else
				_frame.statusBar.rankText:SetFormattedText("%d/%d", c.skillRank, c.skillMaxRank)
			end

			frame.Learn:Show()
			frame.Missing:Hide()
		end
	end
end

function SpellBookCompanionButton_OnLoad(self)
	self:RegisterForDrag("LeftButton");
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function SpellBookCompanionsFrame_OnLoad(self)
	self:RegisterEvent("COMPANION_LEARNED");
	self:RegisterEvent("COMPANION_UNLEARNED");
	self:RegisterEvent("COMPANION_UPDATE");
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	self:RegisterEvent("UNIT_ENTERED_VEHICLE");
end

function SpellBook_UpdateCompanionCooldowns()
	local currentPage, maxPages = SpellBook_GetCurrentPage();
	if (currentPage) then
		currentPage = currentPage - 1;
	end
	local offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;

	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local button = _G["SpellBookCompanionButton"..i];
		local cooldown = _G[button:GetName().."Cooldown"];
		if ( button.creatureID ) then
			local start, duration, enable = GetCompanionCooldown(SpellBookCompanionsFrame.mode, offset + button:GetID());
			if ( start and duration and enable ) then
				CooldownFrame_SetTimer(cooldown, start, duration, enable);
			end
		else
			cooldown:Hide();
		end
	end
end

function SpellBookCompanionsFrame_UpdateCompanionPreview()
	local selected = SpellBookCompanionsFrame_FindCompanionIndex();

	if (selected) then
		local creatureID, creatureName = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
		if (SpellBookCompanionModelFrame.creatureID ~= creatureID) then
			SpellBookCompanionModelFrame.creatureID = creatureID;
			SpellBookCompanionModelFrame:SetCreature(creatureID);
			SpellBookCompanionSelectedName:SetText(creatureName);
		end
	end
end

function SpellBookCompanionsFrame_OnEvent(self, event, ...)
	local arg1 = ...;
	if ( event == "SPELL_UPDATE_COOLDOWN" ) then
		if ( self:IsVisible() ) then
			SpellBook_UpdateCompanionCooldowns();
		end
	elseif ( event == "COMPANION_LEARNED" ) then
		if ( not SpellBookFrame:IsVisible() ) then
			-- MicroButtonPulse(SpellbookMicroButton, 60);
		end
		if (SpellBookFrame:IsVisible() ) then
			SpellBookFrame_Update();
		end
	elseif ( event == "COMPANION_UNLEARNED" and SpellBookCompanionsFrame.mode ) then
		local page;
		local numCompanions = GetNumCompanions(SpellBookCompanionsFrame.mode);
		if ( SpellBookCompanionsFrame.mode=="MOUNT" ) then
			page = SPELLBOOK_PAGENUMBERS[BOOKTYPE_MOUNT];
			if ( numCompanions > 0 ) then
				SpellBookCompanionsFrame.idMount = GetCompanionInfo("MOUNT", 1);
				SpellBookCompanionsFrame_UpdateCompanionPreview();
			else
				SpellBookCompanionsFrame.idMount = nil;
			end
		else
			page = SPELLBOOK_PAGENUMBERS[BOOKTYPE_COMPANION];
			if ( numCompanions > 0 ) then
				SpellBookCompanionsFrame.idCritter = GetCompanionInfo("CRITTER", 1);
				SpellBookCompanionsFrame_UpdateCompanionPreview();
			else
				SpellBookCompanionsFrame.idCritter = nil;
			end
		end
		if (SpellBookFrame:IsVisible()) then
			SpellBookFrame_Update();
		end
	elseif ( event == "COMPANION_UPDATE" ) then
		if ( not SpellBookCompanionsFrame.idMount ) then
			SpellBookCompanionsFrame.idMount = GetCompanionInfo("MOUNT", 1);
		end
		if ( not SpellBookCompanionsFrame.idCritter ) then
			SpellBookCompanionsFrame.idCritter = GetCompanionInfo("CRITTER", 1);
		end
		if (self:IsVisible()) then
			SpellBook_UpdateCompanionsFrame();
		end
	elseif ( (event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and (arg1 == "player")) then
		SpellBook_UpdateCompanionsFrame();
	end
end

function SpellBookCompanionsFrame_FindCompanionIndex(creatureID, mode)
	if ( not mode ) then
		mode = SpellBookCompanionsFrame.mode;
	end
	if (not creatureID ) then
		creatureID = (SpellBookCompanionsFrame.mode=="MOUNT") and SpellBookCompanionsFrame.idMount or SpellBookCompanionsFrame.idCritter;
	end
	for i=1,GetNumCompanions(mode) do
		if ( GetCompanionInfo(mode, i) == creatureID ) then
			return i;
		end
	end
	return nil;
end

function SpellBook_UpdateCompanionsFrame(type)
	local button, iconTexture, id;
	local creatureID, creatureName, spellID, icon, active;
	local offset, selected;

	if (type) then
		SpellBookCompanionsFrame.mode = type;
	end

	if (not SpellBookCompanionsFrame.mode) then
		return;
	end

	SpellBookFrame_UpdatePages();

	local currentPage, maxPages = SpellBook_GetCurrentPage();
	if (currentPage) then
		currentPage = currentPage - 1;
	end

	offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
	if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		selected = SpellBookCompanionsFrame_FindCompanionIndex(SpellBookCompanionsFrame.idCritter);
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		selected = SpellBookCompanionsFrame_FindCompanionIndex(SpellBookCompanionsFrame.idMount);
	end

	if (not selected) then
		selected = 1;
		creatureID = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
		if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
			SpellBookCompanionsFrame.idCritter = creatureID;
		elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
			SpellBookCompanionsFrame.idMount = creatureID;
		end
	end

	for i = 1, NUM_COMPANIONS_PER_PAGE do
		button = _G["SpellBookCompanionButton"..i];
		id = i + (offset or 0);
		creatureID, creatureName, spellID, icon, active = GetCompanionInfo(SpellBookCompanionsFrame.mode, id);
		button.creatureID = creatureID;
		button.spellID = spellID;
		button.active = active;
		if ( creatureID ) then
			button.IconTexture:SetTexture(icon);
			button.IconTexture:Show();
			button.SpellName:SetText(creatureName);
			button.SpellName:Show();
			button:Enable();
		else
			button:Disable();
			button.IconTexture:Hide();
			button.SpellName:Hide();
		end
		if ( (id == selected) and creatureID ) then
			button:SetChecked(true);
		else
			button:SetChecked(false);
		end

		if ( active ) then
			button.ActiveTexture:Show();
		else
			button.ActiveTexture:Hide();
		end
		if (SpellBookCompanionsFrame.mode == "CRITTER") then
			button.Background:SetTexCoord(0.71093750, 0.79492188, 0.00390625, 0.17187500);
		else
			button.Background:SetTexCoord(0.62304688, 0.70703125, 0.00390625, 0.17187500);
		end
	end

	if ( selected ) then
		creatureID, creatureName, spellID, icon, active = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
		if ( active and creatureID ) then
			SpellBookCompanionSummonButton:SetText(SpellBookCompanionsFrame.mode == "MOUNT" and BINDING_NAME_DISMOUNT or PET_DISMISS);
		else
			SpellBookCompanionSummonButton:SetText(SpellBookCompanionsFrame.mode == "MOUNT" and MOUNT or SUMMON);
		end
	end

	SpellBook_UpdateCompanionCooldowns();
end

function SpellBookCompanionButton_OnClick(self, button)
	local selectedID;
	if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
		selectedID = SpellBookCompanionsFrame.idCritter;
	elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
		selectedID = SpellBookCompanionsFrame.idMount;
	end

	if ( button ~= "LeftButton" or ( selectedID == self.creatureID) ) then
		local currentPage, maxPages = SpellBook_GetCurrentPage();
		if (currentPage) then
			currentPage = currentPage - 1;
		end

		local offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
		local index = self:GetID() + offset;
		if ( self.active ) then
			DismissCompanion(SpellBookCompanionsFrame.mode);
		else
			CallCompanion(SpellBookCompanionsFrame.mode, index);
		end
	else
		if ( SpellBookCompanionsFrame.mode == "CRITTER" ) then
			SpellBookCompanionsFrame.idCritter = self.creatureID;
			SpellBookCompanionsFrame_UpdateCompanionPreview();
		elseif ( SpellBookCompanionsFrame.mode == "MOUNT" ) then
			SpellBookCompanionsFrame.idMount = self.creatureID;
			SpellBookCompanionsFrame_UpdateCompanionPreview();
		end
	end

	SpellBook_UpdateCompanionsFrame();
end

function SpellBookCompanionButton_OnEnter(self)
	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	end

	if ( GameTooltip:SetHyperlink("spell:"..self.spellID) ) then
		self.UpdateTooltip = CompanionButton_OnEnter;
	else
		self.UpdateTooltip = nil;
	end

	GameTooltip:Show()
end

function SpellBookCompanionSummonButton_OnClick()
	local selected = SpellBookCompanionsFrame_FindCompanionIndex();
	local creatureID, creatureName, spellID, icon, active = GetCompanionInfo(SpellBookCompanionsFrame.mode, selected);
	if ( active ) then
		DismissCompanion(SpellBookCompanionsFrame.mode);
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		CallCompanion(SpellBookCompanionsFrame.mode, selected);
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
end

function SpellBookCompanionButton_OnModifiedClick(self)
	local id = self.spellID;
	if ( IsModifiedClick("CHATLINK") ) then
		if ( MacroFrame and MacroFrame:IsShown() ) then
			local spellName = GetSpellInfo(id);
			ChatEdit_InsertLink(spellName);
		else
			local spellLink = GetSpellLink(id)
			ChatEdit_InsertLink(spellLink);
		end
	elseif ( IsModifiedClick("PICKUPACTION") ) then
		SpellBookCompanionButton_OnDrag(self);
	end
end

function SpellBookCompanionButton_OnDrag(self)
	local currentPage, maxPages = SpellBook_GetCurrentPage();
	if (currentPage) then
		currentPage = currentPage - 1;
	end

	local offset = (currentPage or 0)*NUM_COMPANIONS_PER_PAGE;
	local dragged = self:GetID() + offset;
	PickupCompanion( SpellBookCompanionsFrame.mode, dragged );
end

function SpellBookFrame_GetLastNonSpecialTabIndex()
	for tabIndex = GetNumSpellTabs(), 1, -1 do
		local name = GetSpellTabInfo(tabIndex)
		if not SPECIAL_SKILL_LINES[name] and not TECHNICAL_SKILL_LINES[name] then
			return tabIndex
		end
	end
end

function SpellBookFrame_Update(showing)
	-- Hide all tabs
	SpellBookFrameTabButton1:Hide()
	SpellBookFrameTabButton2:Hide()
	SpellBookFrameTabButton3:Hide()
	SpellBookFrameTabButton4:Hide()

	-- Setup skillline tabs
	if ( showing ) then
		SpellBookSkillLineTab_OnClick(nil, SpellBookFrame.selectedSkillLine)
		UpdateSpells()
	end

	local numSkillLineTabs = GetNumSpellTabs()

	for tabIndex = #SpellBookSideTabsFrame.tabs + 1, numSkillLineTabs do
		local button = CreateFrame("CheckButton", string.format("SpellBookSkillLineTab%i", tabIndex), SpellBookSideTabsFrame, "SpellBookSkillLineTabTemplate")
		button:SetID(tabIndex)
		button:Hide()
		SpellBookSideTabsFrame.tabs[tabIndex] = button

		local flash = SpellBookTabFlashFrame:CreateTexture(string.format("SpellBookSkillLineTab%iFlash", tabIndex), "OVERLAY")
		flash:SetSize(64, 64)
		flash:SetPoint("CENTER", button, "CENTER", 0, 0)
		flash:SetTexture([[Interface\Buttons\CheckButtonGlow]])
		flash:SetBlendMode("ADD")
	end

	local lastButton
	for tabIndex, skillLineTab in ipairs(SpellBookSideTabsFrame.tabs) do
		if ( tabIndex <= numSkillLineTabs and SpellBookFrame.bookType == BOOKTYPE_SPELL) then
			local name, texture = GetSpellTabInfo(tabIndex)

			skillLineTab:SetNormalTexture(texture)
			skillLineTab:SetChecked(SpellBookFrame.selectedSkillLine == tabIndex)

			skillLineTab.tooltip = name

			if SPECIAL_SKILL_LINES[name] then
				skillLineTab:ClearAllPoints()
				skillLineTab:SetPoint("BOTTOMLEFT", SpellBookSideTabsFrame, "BOTTOMRIGHT", 0, 100 + SPECIAL_SKILL_LINES[name] * 50)
				skillLineTab:Show()
			else
				if TECHNICAL_SKILL_LINES[name] then
					_G["SpellBookSkillLineTab"..tabIndex.."Flash"]:Hide()
					skillLineTab:Hide()
					skillLineTab:ClearAllPoints()
					skillLineTab:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -17)
				else
					if lastButton then
						skillLineTab:ClearAllPoints()
						skillLineTab:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -17)
					end

					_G["SpellBookSkillLineTab"..tabIndex.."Flash"]:Show()
					skillLineTab:Show()

					lastButton = skillLineTab
				end
			end
		else
			_G["SpellBookSkillLineTab"..tabIndex.."Flash"]:Hide()
			skillLineTab:Hide()
		end
	end

	if SpellBookFrame.selectedSkillLine and not SpellBookSideTabsFrame.tabs[SpellBookFrame.selectedSkillLine]:IsShown() then
		if SpellBookFrame.selectedSkillLine ~= 1 then
			SpellBookSkillLineTab_OnClick(nil, 1)
		end
	end

	SpellBookFrameTabButton1:Show();
	SpellBookFrameTabButton1.bookType = BOOKTYPE_SPELL;
	SpellBookFrameTabButton1.binding = "TOGGLESPELLBOOK";
	SpellBookFrameTabButton1:SetText(SPELLBOOK)

	SpellBookFrameTabButton2:Show();
	SpellBookFrameTabButton2.bookType = BOOKTYPE_PROFESSION;
	SpellBookFrameTabButton2.binding = TOGGLEPROFESSIONBOOK;
	SpellBookFrameTabButton2:SetText(TRADE_SKILLS)

	local tabIndex = 3

	for s = 3, 5 do
		local frame = _G["SpellBookFrameTabButton"..s]
		if frame and frame:IsShown() then
			frame:Hide()
		end
	end

	local hasPetSpells, petToken = HasPetSpells();
	SpellBookFrame.petTitle = nil;
	if ( hasPetSpells ) then
		SpellBookFrame.petTitle = _G["PET_TYPE_"..petToken];
		local nextTab = _G["SpellBookFrameTabButton"..tabIndex];
		nextTab:Show();
		nextTab.bookType = BOOKTYPE_PET;
		nextTab.binding = "TOGGLEPETBOOK";
		nextTab:SetText(PET);
		tabIndex = tabIndex+1;
	elseif (SpellBookFrame.bookType == BOOKTYPE_PET) then
		SpellBookFrame.bookType = _G["SpellBookFrameTabButton"..tabIndex-1].bookType;
	end

	if ( GetNumCompanions("MOUNT") > 0  ) then
		local nextTab = _G["SpellBookFrameTabButton"..tabIndex];
		nextTab:Show();
		nextTab.bookType = BOOKTYPE_MOUNT;
		nextTab.binding = "TOGGLEMOUNTBOOK";
		nextTab:SetText(MOUNTS);
		tabIndex = tabIndex+1;
	elseif (SpellBookFrame.bookType == BOOKTYPE_MOUNT) then
		SpellBookFrame.bookType = _G["SpellBookFrameTabButton"..tabIndex-1].bookType;
	end

	 if ( GetNumCompanions("CRITTER") > 0  ) then
		local nextTab = _G["SpellBookFrameTabButton"..tabIndex];
		nextTab:Show();
		nextTab.bookType = BOOKTYPE_COMPANION;
		nextTab.binding = "TOGGLECOMPANIONBOOK";
		nextTab:SetText(COMPANIONS);
		tabIndex = tabIndex+1;
	elseif (SpellBookFrame.bookType == BOOKTYPE_COMPANION) then
		SpellBookFrame.bookType = _G["SpellBookFrameTabButton"..tabIndex-1].bookType;
	end

	for i=1,MaxSpellBookTypes do
		local tab = _G["SpellBookFrameTabButton"..i];
		if ( tab.bookType == SpellBookFrame.bookType ) then
			SpellBookFrame.currentTab = tab;
			tab:Disable()
		else
			tab:Enable()
		end
	end

	SpellBookSpellIconsFrame:Hide()
	-- SpellBookSpellIconsFrame:SetShown(SpellBookFrame.bookType == BOOKTYPE_SPELL or SpellBookFrame.bookType == BOOKTYPE_PET)
	SpellBookSideTabsFrame:SetShown(SpellBookFrame.bookType == BOOKTYPE_SPELL or SpellBookFrame.bookType == BOOKTYPE_PET)

	SpellBookCompanionsFrame:SetShown(SpellBookFrame.bookType == BOOKTYPE_MOUNT or SpellBookFrame.bookType == BOOKTYPE_COMPANION)

	SpellBookProfessionFrame:SetShown(SpellBookFrame.bookType == BOOKTYPE_PROFESSION)

	SpellBookPage1:SetTexture("Interface\\Spellbook\\Spellbook-Page-1")
	SpellBookPage2:SetTexture("Interface\\Spellbook\\Spellbook-Page-2")

	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		SpellBookFrame.TitleText:SetText(SPELLBOOK)
		SpellBookSpellIconsFrame:Show()
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		SpellBookFrame.TitleText:SetText(SpellBookFrame.petTitle)
		SpellBookSpellIconsFrame:Show()
	elseif ( SpellBookFrame.bookType == BOOKTYPE_MOUNT ) then
		SpellBook_UpdateCompanionsFrame("MOUNT")
		SpellBookCompanionsFrame_UpdateCompanionPreview()

		SpellBookFrame.TitleText:SetText(MOUNTS)
	elseif ( SpellBookFrame.bookType == BOOKTYPE_COMPANION ) then
		SpellBook_UpdateCompanionsFrame("CRITTER")
		SpellBookCompanionsFrame_UpdateCompanionPreview()

		SpellBookFrame.TitleText:SetText(COMPANIONS)
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PROFESSION ) then
		SpellBookFrame.TitleText:SetText(TRADE_SKILLS)

		SpellBookPage1:SetTexture("Interface\\Spellbook\\Professions-Book-Left")
		SpellBookPage2:SetTexture("Interface\\Spellbook\\Professions-Book-Right")
	end

	ShowUnassignedSpellBorderCheckBox:SetShown(SpellBookFrame.bookType == BOOKTYPE_SPELL)

	SpellBookFrame_UpdatePages()

	local needShow = SpellBookFrame.bookType ~= BOOKTYPE_PROFESSION
	SpellBookPageNavigationFrame:SetShown(needShow)

	SpellBookSearchBoxFrame:SetShown(SpellBookFrame.bookType == BOOKTYPE_SPELL or SpellBookFrame.bookType == BOOKTYPE_PET)

	if SpellBookFrame.selectedSkillLine == 1 and not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_307810_2") then
		HelpPlate_Hide(tutorialSpellBook.spellForbsIslandOnEnter)
		HelpPlate_Hide(tutorialSpellBook.openPage)

		local page = SpellBook_GetSpellPage(307810, 1)

		if page and page ~= SpellBook_GetCurrentPage() then
			if not C_Hardcore.IsFeatureAvailable(Enum.Hardcore.Features.VIP) then
				local onClose = function()
					NPE_TutorialPointerFrame:Hide(tutorialSpellBook.openPage)
					tutorialSpellBook.openPage = nil
					NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_307810_1", true)
				end
				tutorialSpellBook.openPage = NPE_TutorialPointerFrame:Show(string.format(FORBS_ISLAND_TUTORIAL_2, page), "LEFT", SpellBookNextPageButton, 0, 0, nil, nil, nil, nil, onClose)
			end
		end
	end

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_308230_2") then
		local page = SpellBook_GetSpellPage(308230, 1)

		if page and page ~= SpellBook_GetCurrentPage() then
			HelpPlate_Hide(tutorialSpellBook.spellVipSelectOnEnter)
		end
	end
end

function SpellBookFrame_HideSpells ()
	for i = 1, SPELLS_PER_PAGE do
		_G["SpellButton" .. i]:Hide()
	end

	for i = 1, MAX_SKILLLINE_TABS do
		_G["SpellBookSkillLineTab" .. i]:Hide()
	end

	SpellBookPrevPageButton:Hide()
	SpellBookNextPageButton:Hide()
	-- SpellBookPageText:Hide()
end

function SpellBookFrame_UpdateSpellState()
	for i = 1, SPELLS_PER_PAGE do
		local spellButton = _G["SpellButton" .. i]
		if (spellButton.data and SpellBookFrame.searchText) and not string.find(string.upper(GetSpellInfo(spellButton.data)), SpellBookFrame.searchText, 1, true) then
			spellButton:SetAlpha(0.4)
		else
			spellButton:SetAlpha(1)
		end
	end
end

function SpellBookFrame_UpdatePages()
	local currentPage, maxPages = SpellBook_GetCurrentPage();

	if ( maxPages == nil or maxPages == 0 ) then
		return;
	end

	if ( currentPage > maxPages ) then
		if (SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
			SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = maxPages;
		else
			SPELLBOOK_PAGENUMBERS[SpellBookFrame.bookType] = maxPages;
		end
		currentPage = maxPages;
		if ( currentPage == 1 ) then
			SpellBookPrevPageButton:Disable();
		else
			SpellBookPrevPageButton:Enable();
		end
		if ( currentPage == maxPages ) then
			SpellBookNextPageButton:Disable();
		else
			SpellBookNextPageButton:Enable();
		end
	end
	if ( currentPage == 1 ) then
		SpellBookPrevPageButton:Disable();
	else
		SpellBookPrevPageButton:Enable();
	end
	if ( currentPage == maxPages ) then
		SpellBookNextPageButton:Disable();
	else
		SpellBookNextPageButton:Enable();
	end
	SpellBookPageText:SetFormattedText(PAGE_NUMBER, currentPage);

	-- Hide spell rank checkbox if the player is a rogue or warrior
	local showSpellRanks
	if SpellBookFrame.bookType == BOOKTYPE_SPELL then
		local _, class = UnitClass("player")
		if class ~= "ROGUE" and class ~= "WARRIOR" then
			showSpellRanks = true
		end
	end
	ShowAllSpellRanksCheckBox:SetShown(showSpellRanks)
end

function SpellBookFrame_SetTabType(tabButton, bookType, token)
	if ( bookType == BOOKTYPE_SPELL ) then
		tabButton.bookType = BOOKTYPE_SPELL
		tabButton:SetText(SPELLBOOK)
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1)
		tabButton.binding = "TOGGLESPELLBOOK"
	elseif ( bookType == BOOKTYPE_PET ) then
		tabButton.bookType = BOOKTYPE_PET
		tabButton:SetText(PET)
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1)
		tabButton.binding = "TOGGLEPETBOOK"
		SpellBookFrame.petTitle = PET
	elseif ( bookType == BOOKTYPE_MOUNT ) then
		tabButton.bookType = BOOKTYPE_MOUNT
		tabButton:SetText(MOUNTS)
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 1)
		tabButton.binding = "TOGGLEMOUNTBOOK"
	else
		tabButton.bookType = INSCRIPTION
		tabButton:SetText(GLYPHS)
		tabButton:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 2)
		tabButton.binding = "TOGGLEINSCRIPTION"
	end
	if ( SpellBookFrame.bookType == bookType ) then
		tabButton:Disable()
	else
		tabButton:Enable()
	end
	tabButton:Show()
end

function SpellBookFrame_PlayOpenSound()
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		PlaySound("igSpellBookOpen")
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		-- Need to change to pet book open sound
		PlaySound("igAbilityOpen")
	else
		PlaySound("igSpellBookOpen")
	end
end

function SpellBookFrame_PlayCloseSound()
	if ( not SpellBookFrame.suppressCloseSound ) then
		if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
			PlaySound("igSpellBookClose")
		else
			-- Need to change to pet book close sound
			PlaySound("igAbilityClose")
		end
	end
end

function SpellButton_OnLoad(self)
	self:RegisterForDrag("LeftButton")
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end

function SpellButton_UpdateCooldown(self)
	local cooldown = _G[self:GetName().."Cooldown"];
	if ( self.data ) then
		local start, duration, enable = GetSpellCooldown(self.data);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
	end
end

function SpellButton_UpdateBorderOverlay(self)
	if SpellBookFrame.bookType == BOOKTYPE_SPELL and self.BorderOverlay then
		if GetCVarBool("ShowSpellUnassignedBorder") then
			if self.data and not self.isPassive and not self.isTrain and self.data ~= 6603 and not tContains(shapeshiftIgnoreSpell, self.data) then
				self.BorderOverlay:SetShown(not FindSpellActionButtons(self.data)[1] and IsSpellKnown(self.data))
			else
				self.BorderOverlay:Hide()
			end
		else
			self.BorderOverlay:Hide()
		end
	else
		if self.BorderOverlay then
			self.BorderOverlay:Hide()
		end
	end
end

local tellTimer = 0
function SpellButton_OnEvent(self, event, ...)
	if ( event == "SPELL_UPDATE_COOLDOWN" ) then
		SpellButton_UpdateCooldown(self)
	elseif ( event == "CURRENT_SPELL_CAST_CHANGED" ) then
		SpellButton_UpdateSelection(self)
	elseif ( event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		SpellButton_UpdateSelection(self)
	end
end

function SpellButton_OnShow(self)
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	self:RegisterEvent("TRADE_SKILL_SHOW")
	self:RegisterEvent("TRADE_SKILL_CLOSE")

	if self:GetName() == "SpellButton1" then
		SpellButton_UpdateButton()
		SpellBookFrame_UpdateSpellState()
	end

	SpellButton_UpdateCooldown(self)
	SpellButton_UpdateBorderOverlay(self)

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_307810_2") then
		if self.data == 307810 and not C_Hardcore.IsFeatureAvailable(Enum.Hardcore.Features.VIP) then
			C_Timer:After(0.1, function()
				if not SpellBookFrame:IsShown() then
					return
				end

				if SpellBook_GetSpellPage(307810, 1) == SpellBook_GetCurrentPage() then
					HelpPlate_Hide(tutorialSpellBook.spellForbsIslandOnEnter)
					HelpPlate_Hide(tutorialSpellBook.openPage)

					local onClose = function()
						NPE_TutorialPointerFrame:Hide(tutorialSpellBook.spellForbsIslandOnEnter)
						tutorialSpellBook.spellForbsIslandOnEnter = nil
						NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_307810_2", true)
					end

					tutorialSpellBook.spellForbsIslandOnEnter = NPE_TutorialPointerFrame:Show(FORBS_ISLAND_TUTORIAL_3, "LEFT", self, 0, 0, nil, nil, nil, nil, onClose)
				end
			end)
		end
	end

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_308230_2") then
		if self.data == 308230 then
			C_Timer:After(0.1, function()
				if not SpellBookFrame:IsShown() then
					return
				end

				HelpPlate_Hide(tutorialSpellBook.spellVipSelectOnEnter)

				local onClose = function()
					NPE_TutorialPointerFrame:Hide(tutorialSpellBook.spellVipSelectOnEnter)
					tutorialSpellBook.spellVipSelectOnEnter = nil
					NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_308230_2", true)
				end

				tutorialSpellBook.spellVipSelectOnEnter = NPE_TutorialPointerFrame:Show(VIP_SELECTED_TUTORIAL_2, "LEFT", self, 0, 0, nil, nil, nil, nil, onClose)
			end)
		end
	end
end

function SpellButton_OnHide(self)
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
	self:UnregisterEvent("TRADE_SKILL_SHOW")
	self:UnregisterEvent("TRADE_SKILL_CLOSE")
end

function SpellButton_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	if ( self.data and GameTooltip:SetHyperlink(GetSpellLink(self.data)) ) then
		self.UpdateTooltip = SpellButton_OnEnter
	else
		self.UpdateTooltip = nil
	end

	UpdateOnBarHighlightMarksBySpell(self.data)

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_307810_2") and self.data == 307810 then
		HelpPlate_Hide(tutorialSpellBook.spellForbsIslandOnEnter)
		HelpPlate_Hide(tutorialSpellBook.openPage)

		NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_307810_2", true)
	end

	if not NPE_TutorialPointerFrame:GetKey("SpellBook_Learn_308230_2") and self.data == 308230 then
		HelpPlate_Hide(tutorialSpellBook.spellVipSelectOnEnter)

		NPE_TutorialPointerFrame:SetKey("SpellBook_Learn_308230_2", true)
	end
end

function SpellButton_OnLeave( self, ... )
	GameTooltip:Hide()
	ClearOnBarHighlightMarks()
end

function SpellButton_OnClick(self, button)
	if self.data and not self.Disabled then
		if ( button ~= "LeftButton" and SpellBookFrame.bookType == BOOKTYPE_PET ) then
			ToggleSpellAutocast(self.index, SpellBookFrame.bookType)
		else
			if GetFlyoutInfo(self.data) then
				SpellFlyout:Toggle(self.data, self, "RIGHT", 1, false, 0, true)
				SpellFlyout:SetBorderColor(0.70703125, 0.6328125, 0.3515625)
			elseif self.index then
				CastSpell(self.index, SpellBookFrame.bookType);
			end
			SpellButton_UpdateSelection(self)
		end
	end
end

function SpellButton_OnModifiedClick(self, button)
	if ( not self.data ) then
		return
	end
	if ( IsModifiedClick("CHATLINK") ) then
		if ( MacroFrame and MacroFrame:IsShown() ) then
			local spellName, subSpellName = GetSpellInfo(self.data)
			if ( spellName and not IsPassiveSpell(spellName) ) then
				if ( subSpellName and (strlen(subSpellName) > 0) ) then
					ChatEdit_InsertLink(spellName.."("..subSpellName..")")
				else
					ChatEdit_InsertLink(spellName)
				end
			end
			return
		else
			local spellLink, tradeSkillLink = GetSpellLink(self.data)
			if ( tradeSkillLink ) then
				ChatEdit_InsertLink(tradeSkillLink)
			elseif ( spellLink ) then
				ChatEdit_InsertLink(spellLink)
			end
			return
		end
	end
	if ( IsModifiedClick("PICKUPACTION") and not self.Disabled and self.index ) then
		PickupSpell(self.index, SpellBookFrame.bookType);
		return
	end
	if ( IsModifiedClick("SELFCAST") and not self.Disabled and self.index ) then
		CastSpell(self.index, SpellBookFrame.bookType, true);
		return
	end
end

function ProfessionButton_OnDrag( self, ... )
	if ( not self.data or not _G[self:GetName().."IconTexture"]:IsShown() ) then
		return
	end

	local spell = self:GetAttribute("name")
	PickupSpell(spell)
end

function SpellButton_OnDrag(self)
	if ( not self.data or not _G[self:GetName().."IconTexture"]:IsShown() ) then
		return
	end
	if not self.Disabled then
		self:SetChecked(0)

		if self.index then
			PickupSpell(self.index, SpellBookFrame.bookType)
		end
	end
end

function SpellButton_UpdateSelection(self)
	if not self.data then
		return
	end

	local spellname = GetSpellInfo(self.data)
	if ( IsSelectedSpell(spellname) ) then
		self:SetChecked(true);
	else
		self:SetChecked(false);
	end
end

function SpellButton_UpdateButton()
	if ( not SpellBookFrame.selectedSkillLine ) or ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		SpellBookFrame.selectedSkillLine = 1
	end

	if spellbookCustomRender and spellbookCustomRender[SpellBookFrame.selectedSkillLine] then
		for i = 1, 12 do
			local data

			if SpellBookFrame.bookType == BOOKTYPE_PET then
				data = spellbookCustomRender[1][i + 12 * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1)]
			else
				data = spellbookCustomRender[SpellBookFrame.selectedSkillLine][i + 12 * (SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] - 1)]
			end

			local self = _G["SpellButton"..i]

			if not self then
				return
			end

			local name = self:GetName()
			local iconTexture = _G[name.."IconTexture"]
			local spellString = _G[name.."SpellName"]
			local subSpellString = _G[name.."SubSpellName"]
			local cooldown = _G[name.."Cooldown"]
			local slotFrame = _G[name.."SlotFrame"]
			local autoCastableTexture = _G[name.."Autocast"]

			if data then
				local spellID = data.spellID

				if not spellID then
					return
				end

				if SpellFlyout:IsShown() and SpellFlyout:GetParent() == self then
					SpellFlyout:Hide()
				end

				local spellLevel = data.spellLevel
				self.data = spellID
				self.index = data.spellIndex
				self:Enable()

				local highlightTexture = _G[name.."Highlight"]
				local normalTexture = _G[name.."NormalTexture"]

				local spellName, subSpellName, texture, cost, isFunnel, powerType, castTime, minRage, maxRange = GetSpellInfo(spellID)
				local start, duration, enable = GetSpellCooldown(spellID)

				CooldownFrame_SetTimer(cooldown, start, duration, enable)
				if ( enable == 1 ) then
					iconTexture:SetVertexColor(1.0, 1.0, 1.0)
				else
					iconTexture:SetVertexColor(0.4, 0.4, 0.4)
				end

				autoCastableTexture:Hide()
				SpellBook_ReleaseAutoCastShine(self.shine)
				self.shine = nil

				if data.spellIndex and SpellBookFrame.bookType == BOOKTYPE_PET then
					local autoCastAllowed, autoCastEnabled = GetSpellAutocast(data.spellIndex, SpellBookFrame.bookType)
					autoCastableTexture:SetShown(autoCastAllowed)

					if ( autoCastEnabled and not self.shine ) then
						self.shine = SpellBook_GetAutoCastShine()
						self.shine:SetToplevel(true)
						self.shine:Show()
						self.shine:SetParent(self)
						self.shine:SetPoint("CENTER", self, "CENTER")
						AutoCastShine_AutoCastStart(self.shine)
					elseif ( autoCastEnabled ) then
						self.shine:SetToplevel(true)
						self.shine:Show()
						self.shine:SetParent(self)
						self.shine:SetPoint("CENTER", self, "CENTER")
						AutoCastShine_AutoCastStart(self.shine)
					elseif ( not autoCastEnabled ) then
						SpellBook_ReleaseAutoCastShine(self.shine)
						self.shine = nil
					end
				end

				local isPassive = IsPassiveSpell(spellName)
				self.isPassive = isPassive
				if ( isPassive ) then
					normalTexture:SetVertexColor(0, 0, 0)
					highlightTexture:SetTexture("Interface\\Buttons\\UI-PassiveHighlight")
					spellString:SetTextColor(PASSIVE_SPELL_FONT_COLOR.r, PASSIVE_SPELL_FONT_COLOR.g, PASSIVE_SPELL_FONT_COLOR.b)
				else
					normalTexture:SetVertexColor(1.0, 1.0, 1.0)
					highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
					spellString:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
				end

				if not texture or texture == "" then
					texture = GetSpellTexture(spellName)
				end

				iconTexture:SetTexture(texture)
				spellString:SetText(spellName)
				subSpellString:SetText(subSpellName)
				if ( subSpellName ~= "" ) then
					spellString:SetPoint("LEFT", self, "RIGHT", 4, 4)
				else
					spellString:SetPoint("LEFT", self, "RIGHT", 4, 2)
				end

				iconTexture:Show()
				spellString:Show()
				subSpellString:Show()

				if (not self.SpellName.shadowX) then
					self.SpellName.shadowX, self.SpellName.shadowY = self.SpellName:GetShadowOffset();
				end

				self.SeeTrainerString:Hide()
				self.TrainFrame:Hide()
				self.TrainTextBackground:Hide()
				self.TrainBook:Hide()

				if GetFlyoutInfo(spellID) then
					SetClampedTextureRotation(self.FlyoutArrow.Arrow, 90)
					self.FlyoutArrow:Show()
				else
					self.FlyoutArrow:Hide()
				end

				if (spellLevel and spellLevel > UnitLevel("player")) then
					slotFrame:Hide()
					self.IconTextureBg:Show()
					iconTexture:SetAlpha(0.5)
					iconTexture:SetDesaturated(1)
					self.RequiredLevelString:Show()
					self.RequiredLevelString:SetFormattedText(AVAILABLE_AT_LEVEL, spellLevel)
					self.UnlearnedFrame:Show()
					self.SpellName:SetTextColor(0.25, 0.12, 0)
					self.SpellName:SetShadowOffset(0, 0)
					self.SpellName:SetPoint("LEFT", self, "RIGHT", 8, 6)
					subSpellString:Hide()
					self.Disabled = true
				else
					self.Disabled = false
					subSpellString:Show()
					slotFrame:Show()
					self.UnlearnedFrame:Hide()
					self.IconTextureBg:Hide()
					iconTexture:SetAlpha(1)
					iconTexture:SetDesaturated(0)
					self.RequiredLevelString:Hide()
					self.SpellName:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
					self.SpellName:SetShadowOffset(self.SpellName.shadowX, self.SpellName.shadowY)
					self.SpellName:SetPoint("LEFT", self, "RIGHT", 8, 4)

					local isTrain = data.showTrain
					self.isTrain = isTrain
					if isTrain then
						slotFrame:Hide()
						self.IconTextureBg:Show()
						iconTexture:SetAlpha(0.5)
						iconTexture:SetDesaturated(1)
						self.Disabled = true
						self.SeeTrainerString:Show();
						self.RequiredLevelString:Hide();
						self.TrainFrame:Show();
						self.UnlearnedFrame:Hide();
						self.TrainTextBackground:Show();
						self.TrainBook:Show();
						self.SpellName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
						self.SpellName:SetShadowOffset(self.SpellName.shadowX, self.SpellName.shadowY);
						self.SpellName:SetPoint("LEFT", self, "RIGHT", 24, 8);
					end
				end

				SpellButton_UpdateSelection(self)
			else
				autoCastableTexture:Hide()
				self.data = nil
				self.TrainBook:Hide()
				self.TrainTextBackground:Hide()
				self.TrainFrame:Hide()
				self.SeeTrainerString:Hide()
				subSpellString:Show()
				iconTexture:SetAlpha(1)
				iconTexture:SetDesaturated(0)
				self.RequiredLevelString:Hide()
				self.IconTextureBg:Hide()
				self.FlyoutArrow:Hide()
				self.UnlearnedFrame:Hide()
				slotFrame:Show()
				self.Disabled = false
				self.SpellName:Hide()
				self:Disable()
				iconTexture:Hide()
				spellString:Hide()
				subSpellString:Hide()
				cooldown:Hide()
				SpellBook_ReleaseAutoCastShine(self.shine)
				self.shine = nil
				self:SetChecked(0)
				self.isPassive = nil
				self.isTrain = nil
				_G[name.."NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0)
			end
		end
	end
end

function SpellBookPrevPageButton_OnClick()
	local pageNum = SpellBook_GetCurrentPage() - 1;
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = pageNum;
	else
		-- Need to change to pet book pageturn sound
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[SpellBookFrame.bookType] = pageNum;
	end
	SpellBookFrame_Update();
end

function SpellBookNextPageButton_OnClick()
	local pageNum = SpellBook_GetCurrentPage() + 1;
	if ( SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = pageNum;
	else
		-- Need to change to pet book pageturn sound
		PlaySound("igAbiliityPageTurn");
		SPELLBOOK_PAGENUMBERS[SpellBookFrame.bookType] = pageNum;
	end
	SpellBookFrame_Update();
end

function SpellBookSkillLineTab_OnClick(self, id)
	local update
	if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then
		SpellBookPageNavigationFrame:Hide()
		return
	end
	if ( not id ) then
		update = 1
		id = self:GetID()
	end
	if ( SpellBookFrame.selectedSkillLine ~= id ) then
		PlaySound("igAbiliityPageTurn")
	end
	SpellBookPageNavigationFrame:Show()
	SpellBookFrame.selectedSkillLine = id
	SpellBook_UpdatePageArrows()
	SpellBookFrame_Update()
	SpellBookPageText:SetFormattedText(PAGE_NUMBER, SpellBook_GetCurrentPage())
	if ( update ) then
		UpdateSpells()
	end
	-- Stop tab flashing
	if ( self ) then
		local tabFlash = _G[self:GetName().."Flash"]
		if ( tabFlash ) then
			tabFlash:Hide()
		end
	end

	if id ~= 1 then
		if tutorialSpellBook.spellLearn then
			HelpPlate_Hide(tutorialSpellBook.spellLearn)
		end
		if tutorialSpellBook.openPage then
			HelpPlate_Hide(tutorialSpellBook.openPage)
		end
		if tutorialSpellBook.spellForbsIslandOnEnter then
			HelpPlate_Hide(tutorialSpellBook.spellForbsIslandOnEnter)
		end
		if tutorialSpellBook.spellVipSelectOnEnter then
			HelpPlate_Hide(tutorialSpellBook.spellVipSelectOnEnter)
		end
	end
end

function SpellBookFrameTabButton_OnClick(self)
	-- suppress the hiding sound so we don't play a hide and show sound simultaneously
	SpellBookFrame.suppressCloseSound = true
	ToggleSpellBook(self.bookType, true)
	SpellBookFrame.suppressCloseSound = false

	if self.bookType ~= BOOKTYPE_SPELL then
		if tutorialSpellBook.openPage then
			HelpPlate_Hide(tutorialSpellBook.openPage)
		end
	end

	EventRegistry:TriggerEvent("SpellBookFrame.SetTab", self.bookType)
end

function SpellBook_GetSpellID(id)
	if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		return id + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1))
	else
		local slot = id + SpellBookFrame.selectedSkillLineOffset[SpellBookFrame.selectedSkillLine] + ( SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] - 1))
		return slot, slot
	end
end

function SpellBook_UpdatePageArrows()
	local currentPage, maxPages = SpellBook_GetCurrentPage()
	if ( currentPage == 1 ) then
		SpellBookPrevPageButton:Disable()
	else
		SpellBookPrevPageButton:Enable()
	end
	if ( currentPage == maxPages ) then
		SpellBookNextPageButton:Disable()
	else
		SpellBookNextPageButton:Enable()
	end
end

function SpellBook_GetCurrentPage()
	local currentPage, maxPages;
	local numPetSpells = HasPetSpells() or 0;
	if ( SpellBookFrame.bookType == BOOKTYPE_PROFESSION ) then
		currentPage, maxPages =  1, 1;
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		currentPage = SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET];
		maxPages = ceil(SpellBookFrame.selectedSkillLineNumSpells[1]/SPELLS_PER_PAGE);
	elseif ( SpellBookCompanionsFrame.mode and SpellBookFrame.bookType == BOOKTYPE_MOUNT or SpellBookFrame.bookType == BOOKTYPE_COMPANION) then
		currentPage = SPELLBOOK_PAGENUMBERS[SpellBookFrame.bookType] or 1;
		maxPages = ceil(GetNumCompanions(SpellBookCompanionsFrame.mode or "CRITTER")/NUM_COMPANIONS_PER_PAGE);
	elseif ( SpellBookFrame.bookType == BOOKTYPE_SPELL) then
		currentPage = SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine];
		if SpellBookFrame.selectedSkillLineNumSpells and SpellBookFrame.selectedSkillLineNumSpells[SpellBookFrame.selectedSkillLine] then
			maxPages = ceil(SpellBookFrame.selectedSkillLineNumSpells[SpellBookFrame.selectedSkillLine]/SPELLS_PER_PAGE);
		end
	end
	return currentPage, maxPages;
end

local maxShines = 1
shineGet = {}
function SpellBook_GetAutoCastShine ()
	local shine = shineGet[1]

	if ( shine ) then
		tremove(shineGet, 1)
	else
		shine = CreateFrame("FRAME", "AutocastShine" .. maxShines, SpellBookFrame, "SpellBookShineTemplate")
		maxShines = maxShines + 1
	end

	return shine
end

function SpellBook_ReleaseAutoCastShine (shine)
	if ( not shine ) then
		return
	end

	shine:Hide()
	AutoCastShine_AutoCastStop(shine)
	tinsert(shineGet, shine)
end

function SpellBook_GetTabInfo(skillLine)
	local name, texture, offset, numSpells, highestRankOffset, highestRankNumSpells = GetSpellTabInfo(skillLine)
	if ( not GetCVarBool("ShowAllSpellRanks")) then
		offset = highestRankOffset
		numSpells = highestRankNumSpells
	end
	return name, texture, offset, numSpells
end

function SpellBookFrame_OnMouseWheel( self, value, scrollBar )
	local currentPage, maxPages = SpellBook_GetCurrentPage()

	if(value > 0) then
		if(currentPage > 1) then
			SpellBookPrevPageButton_OnClick()
		end
	else
		if(currentPage < maxPages) then
			SpellBookNextPageButton_OnClick()
		end
	end
end

function SpellBook_GetSpellLocation( spellName )
	if spellbookCustomRender and #spellbookCustomRender > 0 then
		for skillLineID, skillLineData in pairs(spellbookCustomRender) do
			for spellIndex, spellData in pairs(skillLineData) do
				local _spellName = GetSpellInfo(spellData.spellID)

				if string.find(string.upper(_spellName), spellName, 1, true) then
					return skillLineID, math.ceil(spellIndex / 12), spellIndex, spellData.spellID
				end
			end
		end
	end
end

function SpellBookSearchBox_OnTextChanged( self )
	SearchBoxTemplate_OnTextChanged(self)
	local text = self:GetText()

	if text and strlenutf8(text) >= 2 then
		local searchText = string.upper(text);
		local skillLineID, page, spellIndex, spellID = SpellBook_GetSpellLocation(searchText)

		if skillLineID then
			if SpellBookFrame.selectedSkillLine and SpellBookFrame.selectedSkillLine ~= skillLineID then
				SpellBookSkillLineTab_OnClick(nil, skillLineID)
			end

			local currentPage = SpellBook_GetCurrentPage()

			SpellBookFrame.searchText = searchText

			if currentPage ~= page then
				SPELLBOOK_PAGENUMBERS[skillLineID] = page
				SpellBookFrame_Update()
				return
			end
		else
			SpellBookFrame.searchText = nil
		end
	else
		SpellBookFrame.searchText = nil
	end

	SpellBookFrame_UpdateSpellState()
end

function EventHandler:ASMSG_AUTOLEARN_SPELLS( msg )
	if msg and msg ~= "" then
		SIRUS_SPELLBOOK_SPELL = {}
		local split = {strsplit("|", msg)}

		for i = 1, #split do
			if split[i] then
				local skillLine, spellID, spellLevel = string.match(split[i], "(%d+):(%d+):(%d+)")
				if skillLine and spellID and spellLevel then
					skillLine = tonumber(skillLine)

					if not SIRUS_SPELLBOOK_SPELL[skillLine] then
						SIRUS_SPELLBOOK_SPELL[skillLine] = {}
					end

					table.insert(SIRUS_SPELLBOOK_SPELL[skillLine], {spellID = tonumber(spellID), spellLevel = tonumber(spellLevel)})
				end
			end
		end
		EventRegistry:TriggerEvent("LevelUpSpells.Received")
		SpellBookFrame_UpdateSpellRender()
	end
end

function EventHandler:ASMSG_AUTOLEARN_SKILL_NAMES( msg )
	if msg and msg ~= "" then
		SIRUS_SPELLBOOK_SKILLLINE = {}
		local split = {strsplit("|", msg)}

		for i = 1, #split do
			if split[i] then
				local skillLineID, skillLineName = string.match(split[i], "(%d+):(.*)")
				if skillLineID and skillLineName then
					SIRUS_SPELLBOOK_SKILLLINE[tonumber(skillLineID)] = skillLineName
				end
			end
		end
		SpellBookFrame_UpdateSpellRender()
	end
end

function IsLevelDataSpellsLoaded()
	return next(SIRUS_SPELLBOOK_SPELL) ~= nil
end

function GetCurrentLevelSpells(level)
	if not IsLevelDataSpellsLoaded() then
		return
	end

	local levelSpells = {}
	for skillLine, spellList in pairs(SIRUS_SPELLBOOK_SPELL) do
		for index, spell in ipairs(spellList) do
			if spell.spellLevel == level then
				table.insert(levelSpells, spell.spellID)
			end
		end
	end

	return unpack(levelSpells)
end

function ChatFrame_MessageSpellFilter( self, event, msg )
	for spellID, spellName in EnumSpellLearnFilters() do
		if msg == string.format(ERR_LEARN_SPELL_S, spellName) or msg == string.format(ERR_SPELL_UNLEARNED_S, spellName) then
			return true
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ChatFrame_MessageSpellFilter)