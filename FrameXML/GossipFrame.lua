
NUMGOSSIPBUTTONS = 32;

function GossipFrame_OnLoad(self)
	self:RegisterEvent("GOSSIP_SHOW");
	self:RegisterEvent("GOSSIP_CLOSED");
	self:RegisterEvent("QUEST_LOG_UPDATE");
end

function GossipFrame_OnEvent(self, event, ...)
	if ( event == "GOSSIP_SHOW" ) then
		-- if there is only a non-gossip option, then go to it directly
		if ( (GetNumGossipAvailableQuests() == 0) and (GetNumGossipActiveQuests() == 0) and (GetNumGossipOptions() == 1) and not ForceGossip() ) then
			local text, gossipType = GetGossipOptions();
			if ( gossipType ~= "gossip" ) then
				SelectGossipOption(1);
				return;
			end
		end

		if ( not GossipFrame:IsShown() ) then
			ShowUIPanel(self);
			if ( not self:IsShown() ) then
				CloseGossip();
				return;
			end
		end
		GossipFrameUpdate();
	elseif ( event == "GOSSIP_CLOSED" ) then
		HideUIPanel(self);
	elseif ( event == "QUEST_LOG_UPDATE" and GossipFrame.hasActiveQuests and GossipFrame:IsShown() ) then
		GossipFrameUpdate();
	end
end

function GossipFrameUpdate()
	GossipFrame.buttonIndex = 1;
	GossipGreetingText:SetText(GetGossipText());
	GossipFrameAvailableQuestsUpdate(GetGossipAvailableQuests());
	GossipFrameActiveQuestsUpdate(GetGossipActiveQuests());
	GossipFrameOptionsUpdate(GetGossipOptions());
	for i=GossipFrame.buttonIndex, NUMGOSSIPBUTTONS do
		_G["GossipTitleButton" .. i]:Hide();
	end
	GossipFrameNpcNameText:SetText(UnitName("npc"));
	if ( UnitExists("npc") ) then
		SetPortraitTexture(GossipFramePortrait, "npc");
	else
		GossipFramePortrait:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon");
	end

	-- Set Spacer
	if ( GossipFrame.buttonIndex > 1 ) then
		GossipSpacerFrame:SetPoint("TOP", "GossipTitleButton"..GossipFrame.buttonIndex-1, "BOTTOM", 0, 0);
		GossipSpacerFrame:Show();
	else
		GossipSpacerFrame:Hide();
	end

	-- Update scrollframe
	GossipGreetingScrollFrame:SetVerticalScroll(0);
end

function GossipTitleButton_OnClick(self, button)
	if ( self.type == "Available" ) then
		SelectGossipAvailableQuest(self:GetID());
	elseif ( self.type == "Active" ) then
		SelectGossipActiveQuest(self:GetID());
	else
		SelectGossipOption(self:GetID());
	end
end

function GossipFrameAvailableQuestsUpdate(...)
	local titleIndex = 1;

	for i=1, select("#", ...), 5 do
		if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
			message("This NPC has too many quests and/or gossip options.");
		end
		local titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
		local titleButtonIcon = _G[titleButton:GetName() .. "GossipIcon"];
		local titleText, _, isTrivial, isDaily, isRepeatable = select(i, ...);
		if ( isDaily ) then
			titleButtonIcon:SetTexture("Interface\\GossipFrame\\DailyQuestIcon");
		elseif ( isRepeatable ) then
			titleButtonIcon:SetTexture("Interface\\GossipFrame\\DailyActiveQuestIcon");
		else
			titleButtonIcon:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon");
		end
		if ( isTrivial ) then
			titleButton:SetFormattedText(TRIVIAL_QUEST_DISPLAY, titleText);
			titleButtonIcon:SetVertexColor(0.5,0.5,0.5);
		else
			titleButton:SetFormattedText(NORMAL_QUEST_DISPLAY, titleText);
			titleButtonIcon:SetVertexColor(1,1,1);
		end
		titleButtonIcon:SetTexCoord(0, 1, 0, 1);
		GossipResize(titleButton);
		titleButton:SetID(titleIndex);
		titleButton.type="Available";
		GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
		titleIndex = titleIndex + 1;
		titleButton:Show();
	end
	if ( GossipFrame.buttonIndex > 1 ) then
		local titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
		titleButton:Hide();
		GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
	end
end

function GossipFrameActiveQuestsUpdate(...)
	local titleButton;
	local titleIndex = 1;
	local titleButtonIcon;
	local numActiveQuestData = select("#", ...);
	GossipFrame.hasActiveQuests = (numActiveQuestData > 0);
	for i=1, numActiveQuestData, 4 do
		if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
			message("This NPC has too many quests and/or gossip options.");
		end
		titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
		titleButtonIcon = _G[titleButton:GetName() .. "GossipIcon"];
		if ( select(i+2, ...) ) then
			titleButton:SetFormattedText(TRIVIAL_QUEST_DISPLAY, select(i, ...));
			titleButtonIcon:SetVertexColor(0.5,0.5,0.5);
		else
			titleButton:SetFormattedText(NORMAL_QUEST_DISPLAY, select(i, ...));
			titleButtonIcon:SetVertexColor(1,1,1);
		end
		GossipResize(titleButton);
		titleButton:SetID(titleIndex);
		titleButton.type="Active";
		if ( select(i+3, ...) ) then
			titleButtonIcon:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon");
		else
			titleButtonIcon:SetTexture("Interface\\GossipFrame\\IncompleteQuestIcon");
		end
		titleButtonIcon:SetTexCoord(0, 1, 0, 1);
		GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
		titleIndex = titleIndex + 1;
		titleButton:Show();
	end
	if ( titleIndex > 1 ) then
		titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
		titleButton:Hide();
		GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
	end
end

function GossipFrameOptionsUpdate(...)
	local titleButton;
	local titleIndex = 1;
	local titleText, titleButtonIcon;
	for i=1, select("#", ...), 2 do
		if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
			message("This NPC has too many quests and/or gossip options.");
		end
		titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
		titleText = select(i, ...)
		titleButton:SetText(titleText);
		GossipResize(titleButton);
		titleButton:SetID(titleIndex);
		titleButton.type="Gossip";
		titleButtonIcon = _G[titleButton:GetName() .. "GossipIcon"];
		if ( CUSTOM_GOSSIP_TEXTS[titleText] and CUSTOM_GOSSIP_ICONS[CUSTOM_GOSSIP_TEXTS[titleText]] ) then
			local customIcon = CUSTOM_GOSSIP_ICONS[CUSTOM_GOSSIP_TEXTS[titleText]];
			titleButtonIcon:SetTexture(customIcon[1]);
			titleButtonIcon:SetTexCoord(unpack(customIcon, 2, 5));
		else
			titleButtonIcon:SetTexture("Interface\\GossipFrame\\" .. select(i+1, ...) .. "GossipIcon");
			titleButtonIcon:SetTexCoord(0, 1, 0, 1);
		end
		titleButtonIcon:SetVertexColor(1, 1, 1, 1);
		GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
		titleIndex = titleIndex + 1;
		titleButton:Show();
	end
end

function GossipResize(titleButton)
	titleButton:SetHeight( titleButton:GetTextHeight() + 2);
end
