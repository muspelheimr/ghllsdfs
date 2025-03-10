--Store all possible windows the HelpFrame will open.
HelpFrameWindows = {}

-- Side Navigation Table
HelpFrameNavTbl = {}
HelpFrameNavTbl[1] = {	text = KNOWLEDGE_BASE,
						icon = "Interface\\HelpFrame\\HelpIcon-KnowledgeBase",
						iconAtlas = "HelpSidebar-Icon-KnowledgeBase",
						frame = "kbase"
					};
HelpFrameNavTbl[2] = {	text = HELPFRAME_ACCOUNTSECURITY_TITLE,
						icon = "Interface\\HelpFrame\\HelpIcon-AccountSecurity",
						iconAtlas = "HelpSidebar-Icon-AccountSecurity",
						frame = "asec"
					};
HelpFrameNavTbl[3] = {	text = HELPFRAME_STUCK_TITLE,
						icon = "Interface\\HelpFrame\\HelpIcon-CharacterStuck",
						iconAtlas = "HelpSidebar-Icon-CharacterStuck",
						frame = "stuck"
					};
HelpFrameNavTbl[4] = {	text = HELPFRAME_CONTACTS_BUTTON,
						icon = "Interface\\HelpFrame\\ReportLagIcon-Chat",
						iconAtlas = "HelpSidebar-Icon-Contacts",
						frame = "contacts"
					};
HelpFrameNavTbl[5] = {	text = HELPFRAME_REPORT_PLAYER_TITLE,
						icon = "Interface\\HelpFrame\\HelpIcon-ReportAbuse",
						iconAtlas = "HelpSidebar-Icon-ReportAbuse",
						frame = "report"
					};
HelpFrameNavTbl[6] = {	text = HELP_TICKET_OPEN,
						icon = "Interface\\HelpFrame\\HelpIcon-OpenTicket",
						iconAtlas = "HelpSidebar-Icon-OpenTicket",
						frame = "ticket"
					};

--LAG REPORITNG BUTTONS
HelpFrameNavTbl[7] = {	icon = "Interface\\HelpFrame\\ReportLagIcon-Loot",
						tooltipTex = BUTTON_LAG_LOOT_TOOLTIP,
						newbieText = BUTTON_LAG_LOOT_NEWBIE
					};
HelpFrameNavTbl[8] = {	icon = "Interface\\HelpFrame\\ReportLagIcon-AuctionHouse",
						tooltipTex = BUTTON_LAG_AUCTIONHOUSE_TOOLTIP,
						newbieText = BUTTON_LAG_AUCTIONHOUSE_NEWBIE
					};
HelpFrameNavTbl[9] = {	icon = "Interface\\HelpFrame\\ReportLagIcon-Mail",
						tooltipTex = BUTTON_LAG_MAIL_TOOLTIP,
						newbieText = BUTTON_LAG_MAIL_NEWBIE
					};
HelpFrameNavTbl[10] = {	icon = "Interface\\HelpFrame\\ReportLagIcon-Chat",
						tooltipTex = BUTTON_LAG_CHAT_TOOLTIP,
						newbieText = BUTTON_LAG_CHAT_NEWBIE
					};
HelpFrameNavTbl[11] = {	icon = "Interface\\HelpFrame\\ReportLagIcon-Movement",
						tooltipTex = BUTTON_LAG_MOVEMENT_TOOLTIP,
						newbieText = BUTTON_LAG_MOVEMENT_NEWBIE
					};
HelpFrameNavTbl[12] = {	icon = "Interface\\HelpFrame\\ReportLagIcon-Spells",
						tooltipTex = BUTTON_LAG_SPELL_TOOLTIP,
						newbieText = BUTTON_LAG_SPELL_NEWBIE
					};
-- Open Ticket Buttons
HelpFrameNavTbl[13] = {	text = KBASE_TOP_ISSUES,
						icon = "Interface\\HelpFrame\\HelpIcon-HotIssues",
						frame = "kbase",
						func = "KnowledgeBase_GotoTopIssues",
					};
HelpFrameNavTbl[14] = {	text = HELP_TICKET_OPEN, -- HELP_TICKET_EDIT
						icon = "Interface\\HelpFrame\\HelpIcon-OpenTicket",
						iconAtlas = "HelpSidebar-Icon-OpenTicket",
						frame = "ticket"
					};

HelpFrameNavTbl[15] = {	text = HELP_TICKET_OPEN,
						icon = "Interface\\HelpFrame\\HelpIcon-OpenTicket",
						iconAtlas = "HelpSidebar-Icon-OpenTicket",
						frame = "GM_response"
					};

HelpFrameNavTbl[16] = {	text = HELPFRAME_SUPPORT_TITLE,
						icon = "Interface\\HelpFrame\\ReportLagIcon-AuctionHouse",
						iconAtlas = "HelpSidebar-Icon-Support",
						frame = "support"
					};
HelpFrameNavTbl[17]	= {	text = HELPFRAME_ACCOUNTSECURITY_BUTTON,
						icon = "Interface\\HelpFrame\\HelpIcon-AccountSecurity",
						iconAtlas = "HelpSidebar-Icon-AccountSecurity",
						func = function() StaticPopup_Show("EXTERNAL_URL_POPUP", nil, nil, "https://sirus.su/user/tfa/") end,
						noSelection = true,
					};
HelpFrameNavTbl[18]	= { text = HELPFRAME_SUBMIT_SUGGESTION_TITLE,
						icon = "Interface\\HelpFrame\\HelpIcon-Suggestion",
						iconAtlas = "HelpSidebar-Icon-Suggestion",
						func = function() StaticPopup_Show("EXTERNAL_URL_POPUP", nil, nil, "https://forum.sirus.su/forums/27/") end,
						noSelection = true,
					};
HelpFrameNavTbl[19]	= { text = HELPFRAME_ITEM_RESTORATION,
						icon = "Interface\\HelpFrame\\HelpIcon-ItemRestoration",
						iconAtlas = "HelpSidebar-Icon-ItemRestoration",
						func = function() StaticPopup_Show("EXTERNAL_URL_POPUP", nil, nil, "https://sirus.su/user/item-restoration/") end,
						noSelection = true,
					};
HelpFrameNavTbl[20]	= { text = HELPFRAME_REPORT_BUG_TITLE,
						icon = "Interface\\HelpFrame\\HelpIcon-Bug",
						iconAtlas = "HelpSidebar-Icon-Bug",
						func = function() StaticPopup_Show("EXTERNAL_URL_POPUP", nil, nil, "https://forum.sirus.su/forums/14/") end,
						noSelection = true,
					};

KBASE_BUTTON_HEIGHT = 28; -- This is button height plus the offset
KBASE_NUM_ARTICLES_PER_PAGE = 100; -- Obsolete


-- global data
GMTICKET_CHECK_INTERVAL = 600;		-- 10 Minutes

HELPFRAME_START_PAGE			= 1; -- KNOWLEDGE_BASE;
HELPFRAME_KNOWLEDGE_BASE		= 1;
HELPFRAME_ACCOUNT_SECURITY		= 2;
HELPFRAME_CARACTER_STUCK		= 3;
HELPFRAME_CONTACTS				= 4;
HELPFRAME_REPORT_ABUSE			= 5;
HELPFRAME_OPEN_TICKET			= 6;

HELPFRAME_SUBMIT_TICKET			= 14;
HELPFRAME_GM_RESPONSE			= 15;
HELPFRAME_SUPPORT				= 16;


-- local data
local refreshTime;
local ticketQueueActive = true;

local haveTicket = false;		-- true if the server tells us we have an open ticket
local haveResponse = false;		-- true if we got a GM response to a previous ticket
local needResponse = true;		-- true if we want a GM to contact us when we open a new ticket (Note:  This flag is always true right now)
local needMoreHelp = false;

local kbsetupLoaded = false;

--
-- HelpFrame
--


function HelpFrame_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("UPDATE_GM_STATUS");
	self:RegisterEvent("UPDATE_TICKET");
	self:RegisterEvent("GMSURVEY_DISPLAY");
	self:RegisterEvent("GMRESPONSE_RECEIVED");

	SetParentFrameLevel(self.leftInset)
	SetParentFrameLevel(self.mainInset)
	SetParentFrameLevel(self.kbase)

	self.leftInset.Bgs:SetAtlas("HelpSidebar-Background");

	self.header.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock", true, true);
	self.header.Bg:SetHorizTile(true);
	self.header.Bg:SetVertTile(true);

	self.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Rock", true, true);
	self.Bg:SetHorizTile(true);
	self.Bg:SetVertTile(true);

	self.helpPlate = {
		FramePos = { x = 12, y = -44 },
		FrameSize = { width = 949, height = 468 },
		[1] = { ButtonPos = { x = 166, y = 20 }, HighLightBox = { x = 6, y = 26, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_1 },
		[2] = { ButtonPos = { x = 166, y = -47 }, HighLightBox = { x = 6, y = -41, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_2 },
		[3] = { ButtonPos = { x = 166, y = -113 }, HighLightBox = { x = 6, y = -107, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_3 },
		[4] = { ButtonPos = { x = 166, y = -179 }, HighLightBox = { x = 6, y = -173, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_4 },
		[5] = { ButtonPos = { x = 166, y = -277 }, HighLightBox = { x = 6, y = -271, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_5 },
		[6] = { ButtonPos = { x = 166, y = -343 }, HighLightBox = { x = 6, y = -337, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_6 },
		[7] = { ButtonPos = { x = 166, y = -409 }, HighLightBox = { x = 6, y = -403, width = 184, height = 58 }, ToolTipDir = "RIGHT", ToolTipText = HEPLPLATE_KNOWLEDGEBASE_TUTORIAL_7 },
	}
end

function HelpFrame_OnShow(self)
	UpdateMicroButtons();
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
	GetGMStatus();
	-- hearthstone button events
	local button = HelpFrameCharacterStuckHearthstone;
	button:RegisterEvent("BAG_UPDATE_COOLDOWN");
	button:RegisterEvent("BAG_UPDATE");
	button:RegisterEvent("SPELL_UPDATE_USABLE");
	button:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");

	EventRegistry:TriggerEvent("HelpFrame.OnShow")
end

function HelpFrame_OnHide(self)
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
	UpdateMicroButtons();
	-- hearthstone button events
	local button = HelpFrameCharacterStuckHearthstone;
	button:UnregisterEvent("BAG_UPDATE_COOLDOWN");
	button:UnregisterEvent("BAG_UPDATE");
	button:UnregisterEvent("SPELL_UPDATE_USABLE");
	button:UnregisterEvent("SPELL_UPDATE_COOLDOWN");
	button:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED");

	StaticPopup_Hide("EXTERNAL_URL_POPUP")
	HelpPlate_Hide(false)
end

local function formatURL(url)
	return string.format("|cff71d5ff|H%s|h[%s]|h|r", url, url)
end

function HelpFrame_OnEvent(self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		GetGMTicket();
	elseif ( event == "UPDATE_GM_STATUS" ) then
		local status = ...;
		if ( status == GMTICKET_QUEUE_STATUS_ENABLED ) then
			ticketQueueActive = true;
		else
			ticketQueueActive = false;
			if ( status == GMTICKET_QUEUE_STATUS_DISABLED ) then
				StaticPopup_Show("HELP_TICKET_QUEUE_DISABLED");
			end
		end
	elseif ( event == "GMSURVEY_DISPLAY" ) then
		-- If there's a survey to display then fill out info and return
		TicketStatusTitleText:SetText(CHOSEN_FOR_GMSURVEY);
		TicketStatusTime:Hide();
		TicketStatusFrame:SetHeight(TicketStatusTitleText:GetHeight() + 20);
		TicketStatusFrame:Show();
		TicketStatusFrame.hasGMSurvey = true;
		haveResponse = false;
		haveTicket = false;
		UIFrameFlash(TicketStatusFrameIcon, 0.75, 0.75, 20);
	elseif ( event == "UPDATE_TICKET" ) then
		local category, ticketDescription, ticketAge, oldestTicketTime, updateTime, assignedToGM, openedByGM = ...;
		-- If there are args then the player has a ticket
		if ( category and ticketDescription ) then
			-- Has an open ticket
			TicketStatusTitleText:SetText(TICKET_STATUS);
			HelpFrameOpenTicketEditBox:SetText(ticketDescription);
			-- Setup estimated wait time
			--[[
			ticketAge - days
			oldestTicketTime - days
			updateTime - days
				How recent is the data for oldest ticket time, measured in days.  If this number 1 hour, we have bad data.
			assignedToGM - see GMTICKET_ASSIGNEDTOGM_STATUS_* constants
			openedByGM - see GMTICKET_OPENEDBYGM_STATUS_* constants
			]]
			local statusText;
			TicketStatusFrame.ticketTimer = nil;
			if ( openedByGM == GMTICKET_OPENEDBYGM_STATUS_OPENED ) then
				-- if ticket has been opened by a gm
				if ( assignedToGM == GMTICKET_ASSIGNEDTOGM_STATUS_ESCALATED ) then
					statusText = GM_TICKET_ESCALATED;
				else
					statusText = GM_TICKET_SERVICE_SOON;
				end
			else
				-- convert from days to seconds
				local estimatedWaitTime = (oldestTicketTime - ticketAge) * 24 * 60 * 60;
				if ( estimatedWaitTime < 0 ) then
					estimatedWaitTime = 0;
				end

				if ( oldestTicketTime < 0 or updateTime < 0 or updateTime > 0.042 ) then
					statusText = GM_TICKET_UNAVAILABLE;
				elseif ( estimatedWaitTime > 7200 ) then
					-- if wait is over 2 hrs
					statusText = GM_TICKET_HIGH_VOLUME;
				elseif ( estimatedWaitTime > 300 ) then
					-- if wait is over 5 mins
					statusText = format(GM_TICKET_WAIT_TIME, SecondsToTime(estimatedWaitTime, 1));
					TicketStatusFrame.ticketTimer = estimatedWaitTime;
				else
					statusText = GM_TICKET_SERVICE_SOON;
				end
			end
			if ( statusText ) then
				TicketStatusTime:Show();
				TicketStatusTime:SetText(statusText);
			end

			haveResponse = false;
			haveTicket = true;
		else
			-- the player does not have a ticket
			haveTicket = false;
			haveResponse = false;
			if ( not TicketStatusFrame.hasGMSurvey ) then
				TicketStatusFrame:Hide();
			end
		end
		HelpFrame_SetTicketEntry();
	elseif ( event == "GMRESPONSE_RECEIVED" ) then
		local ticketDescription, response = ...;

		haveResponse = true;
		-- i know this is a little confusing since you can have a ticket while you have a response, but having a response
		-- basically implies that you can't make a *new* ticket until you deal with the response...maybe it should be
		-- called haveNewTicket but that would probably be even more confusing
		haveTicket = false;

		response = string.gsub(response, "(%w+://%S*)", formatURL)

		TicketStatusTitleText:SetText(GM_RESPONSE_ALERT);
		TicketStatusTime:SetText("");
		TicketStatusTime:Hide();
		TicketStatusFrame:Show();
		TicketStatusFrame.hasGMSurvey = false;
		HelpFrame_SetTicketButtonText(GM_RESPONSE_POPUP_VIEW_RESPONSE);
		HelpFrameGMResponse_IssueText:SetText(ticketDescription);
		HelpFrameGMResponse_GMText:SetText(response);

		-- update if at a ticket panel
		if ( HelpFrame.selectedId == HELPFRAME_OPEN_TICKET or HelpFrame.selectedId == HELPFRAME_SUBMIT_TICKET ) then
			HelpFrame_SetFrameByKey(HELPFRAME_GM_RESPONSE);
			HelpFrame_SetSelectedButton(HelpFrameButton6);
		end
	end
end

function HelpFrame_ShowFrame(key)
	key = key or HelpFrame.selectedId or HELPFRAME_START_PAGE;
	if HelpFrameNavTbl[key].button and HelpFrameNavTbl[key].button:IsEnabled() then
		HelpFrameNavTbl[key].button:Click();
	else
		-- if the button was not enabled then it's not a user click so force the frame
		HelpFrame_SetFrameByKey(key);
	end

	if ( key == HELPFRAME_SUBMIT_TICKET ) then
		if ( not HelpFrame_IsGMTicketQueueActive() ) then
			-- Petition queue is down and we're trying to go to the OpenTicket frame, show a dialog instead
			HideUIPanel(HelpFrame);
			StaticPopup_Show("HELP_TICKET_QUEUE_DISABLED");
			return;
		end
	end

	ShowUIPanel(HelpFrame);
end

function HelpFrame_IsGMTicketQueueActive()
	return ticketQueueActive;
end

function HelpFrame_HaveGMTicket()
	return haveTicket;
end

function HelpFrame_HaveGMResponse()
	return haveResponse;
end

function HelpFrame_GMResponse_Acknowledge(markRead)
	haveResponse = false;
	HelpFrame_SetTicketEntry();
	if ( markRead ) then
		needMoreHelp = false;
		GMResponseResolve();
		HelpFrame_ShowFrame(HELPFRAME_OPEN_TICKET);
	else
		needMoreHelp = true;
		HelpFrame_ShowFrame(HELPFRAME_SUBMIT_TICKET);
	end
	if ( not TicketStatusFrame.hasGMSurvey and TicketStatusFrame:IsShown() ) then
		TicketStatusFrame:Hide();
	end
end

function HelpFrame_SetFrameByKey(key)
	-- if we're trying to open any ticket window and we have a GM response, override
	if ( haveResponse and ( key == HELPFRAME_OPEN_TICKET or key == HELPFRAME_SUBMIT_TICKET ) ) then
		key = HELPFRAME_GM_RESPONSE;
		HelpFrame_SetSelectedButton(HelpFrameButton6);
	elseif key == HELPFRAME_SUBMIT_TICKET then
		HelpFrame_SetSelectedButton(HelpFrameButton6);
	end
	local data = HelpFrameNavTbl[key];
	if data.frame then
		local showFrame = HelpFrame[data.frame];
		for a,frame in pairs(HelpFrameWindows) do
			if showFrame ~= frame then
				frame:Hide();
			end
		end
		showFrame:Show();

		if key == HELPFRAME_SUPPORT or key == HELPFRAME_OPEN_TICKET then
			GMChatOpenLog:SetParent(showFrame)
		end
	end
	if data.func then
		if ( type(data.func) == "function" ) then
			data.func();
		else
			_G[data.func]();
		end
	end
end

function HelpFrame_SetSelectedButton(button)
	button.selected:Show();
	if HelpFrame.disabledButton and HelpFrame.disabledButton ~= button then
		HelpFrame.disabledButton.selected:Hide();
		HelpFrame.disabledButton:Enable();
	end
	button:Disable();
	HelpFrame.disabledButton = button;
	HelpFrame.selectedId = button:GetID();
end

function HelpFrame_SetTicketButtonText(text)
	HelpFrame.button6:SetText(text);
end

function HelpFrame_SetTicketEntry()
	-- don't do anything if we have a response
	if ( not haveResponse ) then
		local self = HelpFrame;
		if ( haveTicket ) then
			self.ticket.submitButton:SetText(EDIT_TICKET);
			self.ticket.cancelButton:SetText(HELP_TICKET_ABANDON);
			self.ticket.title:SetText(HELPFRAME_OPENTICKET_EDITTEXT);
			HelpFrame_SetTicketButtonText(HELP_TICKET_EDIT);
		else
			HelpFrameOpenTicketEditBox:SetText("");
			self.ticket.submitButton:SetText(SUBMIT);
			self.ticket.cancelButton:SetText(CANCEL);
			self.ticket.title:SetText(HELPFRAME_SUBMIT_TICKET_TITLE);
			HelpFrame_SetTicketButtonText(HELP_TICKET_OPEN);
		end
	end
end

function HelpFrame_SetButtonEnabled(button, enabled)
	if ( enabled ) then
		button:Enable();
		button.icon:SetDesaturated(false);
		button.icon:SetVertexColor(1, 1, 1);
		button.text:SetFontObject(GameFontNormalMed3);
	else
		button:Disable();
		button.icon:SetDesaturated(true);
		button.icon:SetVertexColor(0.5, 0.5, 0.5);
		button.text:SetFontObject(GameFontDisableMed3);
	end
end

function HelpFrame_ToggleTutorial()
	if not HelpPlate_IsShowing(HelpFrame.helpPlate) then
		HelpPlate_Show(HelpFrame.helpPlate, HelpFrame, HelpFrame.TutorialButton)
	else
		HelpPlate_Hide(true)
	end
end

--
-- HelpFrameStuck
--

function HelpFrameStuckHearthstone_UpdateTooltip(self)
	self:GetScript("OnEnter")(self);
end

function HelpFrameStuckHearthstone_Update(self)
	local hearthstoneID = PlayerHasHearthstone();
	local cooldown = self.Cooldown;
	local start, duration, enable = GetItemCooldown(hearthstoneID or 0);
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
	if (not hearthstoneID or duration > 0 and enable == 0) then
		self.IconTexture:SetVertexColor(0.4, 0.4, 0.4);
	else
		self.IconTexture:SetVertexColor(1, 1, 1);
	end

	if (hearthstoneID) then
		self:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD");
		self.IconTexture:SetDesaturated(false);
		local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(hearthstoneID);
		self.IconTexture:SetTexture(texture);
	else
		self:SetHighlightTexture(nil);
		self.IconTexture:SetDesaturated(true);
		self.IconTexture:SetTexture("Interface\\Icons\\inv_misc_rune_01");
	end

	if (GameTooltip:GetOwner() == self) then
		self:UpdateTooltip();
	end
end

--
-- HelpFrameOpenTicket
--

function HelpFrameOpenTicketCancel_OnClick()
	GetGMTicket();
	if haveTicket then
		if not StaticPopup_Visible("HELP_TICKET_ABANDON_CONFIRM") then
			StaticPopup_Show("HELP_TICKET_ABANDON_CONFIRM");
		end
	else
		HelpFrame_ShowFrame(HELPFRAME_SUPPORT);
	end
end

function HelpFrameOpenTicketSubmit_OnClick()
	if ( needMoreHelp ) then
		GMResponseNeedMoreHelp(HelpFrameOpenTicketEditBox:GetText());
		needMoreHelp = false;
	else
		if ( haveTicket ) then
			UpdateGMTicket(HelpFrameOpenTicketEditBox:GetText());
		else
			NewGMTicket(HelpFrameOpenTicketEditBox:GetText(), needResponse);
		--	HelpOpenTicketButton.tutorial:Show();
		end
	end
	HideUIPanel(HelpFrame);
end



--
-- HelpFrameViewResponseButton
--

function HelpFrameViewResponseButton_OnLoad(self)
	local width = self:GetWidth() - 20;
	local deltaWidth = self:GetTextWidth() - width;
	if ( deltaWidth > 0 ) then
		self:SetWidth(width + deltaWidth + 40);
	end
end


--
-- HelpFrameViewResponseMoreHelp
--

function HelpFrameViewResponseMoreHelp_OnClick(self)
	StaticPopup_Show("GM_RESPONSE_NEED_MORE_HELP");
end


--
-- HelpFrameViewResponseIssueResolved
--

function HelpFrameViewResponseIssueResolved_OnClick(self)
	StaticPopup_Show("GM_RESPONSE_RESOLVE_CONFIRM");
end


--
-- HelpOpenTicketButton
--
--[[
function HelpOpenTicketButton_OnUpdate(self, elapsed)
	if ( haveTicket ) then
		-- Every so often, query the server for our ticket status
		if ( self.refreshTime ) then
			self.refreshTime = self.refreshTime - elapsed;
			if ( self.refreshTime <= 0 ) then
				self.refreshTime = GMTICKET_CHECK_INTERVAL;
				GetGMTicket();
			end
		end

		local timeText;
		if ( self.ticketTimer ) then
			self.ticketTimer = self.ticketTimer - elapsed;
			timeText.format(GM_TICKET_WAIT_TIME, SecondsToTime(self.ticketTimer, 1));
		end

		GameTooltip:SetOwner(self, "ANCHOR_TOP");
		GameTooltip:AddLine(self.titleText, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1);
		GameTooltip:AddLine(self.statusText);
		if (timeText) then
			GameTooltip:AddLine(timeText);
		end

		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(HELPFRAME_TICKET_CLICK_HELP, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1);
		GameTooltip:Show();
	elseif ( haveResponse ) then
		GameTooltip:SetOwner(self, "ANCHOR_TOP");
		GameTooltip:SetText(GM_RESPONSE_ALERT, nil, nil, nil, nil, 1);
	elseif ( TicketStatusFrame.hasGMSurvey ) then
		GameTooltip:SetOwner(self, "ANCHOR_TOP");
		GameTooltip:SetText(CHOSEN_FOR_GMSURVEY, nil, nil, nil, nil, 1);
	end
end

function HelpOpenTicketButton_OnEvent(self, event, ...)
	if ( event == "UPDATE_TICKET" ) then
		local category, ticketDescription, ticketOpenTime, oldestTicketTime, updateTime, assignedToGM, openedByGM = ...;
		-- ticketOpenTime,		time_t that this ticket was created
		-- oldestTicketTime,	time_t of the oldest unassigned ticket in the region.
		-- updateTime,			age in seconds (freshness) of our ticket wait time estimates from the GM dept
		if ( (category or TicketStatusFrame.hasGMSurvey) and (not GMChatStatusFrame or not GMChatStatusFrame:IsShown()) ) then
			self.haveTicket = true;
			self.haveResponse = false;
			self.titleText = TICKET_STATUS;
			self.ticketTimer = nil;
			if ( openedByGM == GMTICKET_OPENEDBYGM_STATUS_OPENED ) then
				-- if ticket has been opened by a gm
				if ( assignedToGM == GMTICKET_ASSIGNEDTOGM_STATUS_ESCALATED ) then
					self.statusText = GM_TICKET_ESCALATED;
				else
					self.statusText = GM_TICKET_SERVICE_SOON;
				end
			else
				local estimatedWaitTime = (oldestTicketTime - ticketOpenTime);
				if ( estimatedWaitTime < 0 ) then
					estimatedWaitTime = 0;
				end

				if ( oldestTicketTime < 0 or updateTime < 0 or updateTime > 3600 ) then
					self.statusText = GM_TICKET_UNAVAILABLE;
				elseif ( estimatedWaitTime > 7200 ) then
					-- if wait is over 2 hrs
					self.statusText = GM_TICKET_HIGH_VOLUME;
				elseif ( estimatedWaitTime > 300 ) then
					-- if wait is over 5 mins
					self.statusText = format(GM_TICKET_WAIT_TIME, SecondsToTime(estimatedWaitTime, 1));
				else
					self.statusText = GM_TICKET_SERVICE_SOON;
				end
			end
			self:Show();
		else
			-- the player does not have a ticket
			self.haveResponse = false;
			self.haveTicket = false;
			self:Hide();
		end
	end
end
--]]

--
-- TicketStatusFrame
--


function TicketStatusFrame_OnLoad(self)
	self:RegisterEvent("UPDATE_TICKET");
	self:RegisterEvent("GMRESPONSE_RECEIVED");
end

function TicketStatusFrame_OnEvent(self, event, ...)
	if ( event == "UPDATE_TICKET" ) then
		local category = ...;
		if ( category and (not GMChatStatusFrame or not GMChatStatusFrame:IsShown()) ) then
			self:Show();
			refreshTime = GMTICKET_CHECK_INTERVAL;
		else
			self:Hide();
		end
	elseif ( event == "GMRESPONSE_RECEIVED" ) then
		if ( not GMChatStatusFrame or not GMChatStatusFrame:IsShown() ) then
			self:Show();
		else
			self:Hide();
		end
	end
end

function TicketStatusFrame_OnUpdate(self, elapsed)
	if ( haveTicket ) then
		-- Every so often, query the server for our ticket status
		if ( refreshTime ) then
			refreshTime = refreshTime - elapsed;
			if ( refreshTime <= 0 ) then
				refreshTime = GMTICKET_CHECK_INTERVAL;
				GetGMTicket();
			end
		end
		if ( self.ticketTimer ) then
			self.ticketTimer = self.ticketTimer - elapsed;
			TicketStatusTime:SetFormattedText(GM_TICKET_WAIT_TIME, SecondsToTime(self.ticketTimer, 1));
		end
	end
end

function TicketStatusFrame_OnShow(self)
	ConsolidatedBuffs:SetPoint("TOPRIGHT", self:GetParent(), "TOPRIGHT", -205, (-self:GetHeight()));
	BuffFrame_UpdateAllBuffAnchors()
end

function TicketStatusFrame_OnHide(self)
	if( not GMChatStatusFrame or not GMChatStatusFrame:IsShown() ) then
		ConsolidatedBuffs:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -180, -13);
		BuffFrame_UpdateAllBuffAnchors()
	end
end


--
-- TicketStatusFrameButton
--

function TicketStatusFrameButton_OnLoad(self)
	self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);

	-- make sure this frame doesn't cover up the content in the parent
	self:SetFrameLevel(self:GetParent():GetFrameLevel() - 1);
end

function TicketStatusFrameButton_OnClick(self)
	if ( TicketStatusFrame.hasGMSurvey ) then
		GMSurveyFrame_LoadUI();
		ShowUIPanel(GMSurveyFrame);
		TicketStatusFrame:Hide();
	elseif ( StaticPopup_Visible("HELP_TICKET_ABANDON_CONFIRM") ) then
		StaticPopup_Hide("HELP_TICKET_ABANDON_CONFIRM");
	elseif ( StaticPopup_Visible("HELP_TICKET") ) then
		StaticPopup_Hide("HELP_TICKET");
	elseif ( StaticPopup_Visible("GM_RESPONSE_NEED_MORE_HELP") ) then
		StaticPopup_Hide("GM_RESPONSE_NEED_MORE_HELP");
	elseif ( StaticPopup_Visible("GM_RESPONSE_RESOLVE_CONFIRM") ) then
		StaticPopup_Hide("GM_RESPONSE_RESOLVE_CONFIRM");
	elseif ( StaticPopup_Visible("GM_RESPONSE_CANT_OPEN_TICKET") ) then
		StaticPopup_Hide("GM_RESPONSE_CANT_OPEN_TICKET");
	elseif ( haveResponse ) then
		HelpFrame_SetFrameByKey(HELPFRAME_OPEN_TICKET);
		if ( not HelpFrame:IsShown() ) then
			ShowUIPanel(HelpFrame);
		end
	elseif ( haveTicket ) then
		StaticPopup_Show("HELP_TICKET");
	end
end

function HelpReportLag(kind)
	HideUIPanel(HelpFrame);
	GMReportLag(STATIC_CONSTANTS[kind]);
	StaticPopup_Show("LAG_SUCCESS");
end

--
-------------- Knowledgebase Functions ------------------
--

function KnowledgeBase_OnLoad(self)
	self:RegisterCustomEvent("KNOWLEDGE_BASE_SETUP_LOAD_SUCCESS");
	self:RegisterCustomEvent("KNOWLEDGE_BASE_SETUP_LOAD_FAILURE");
	self:RegisterCustomEvent("KNOWLEDGE_BASE_QUERY_LOAD_SUCCESS");
	self:RegisterCustomEvent("KNOWLEDGE_BASE_QUERY_LOAD_FAILURE");
	self:RegisterCustomEvent("KNOWLEDGE_BASE_ARTICLE_LOAD_SUCCESS");
	self:RegisterCustomEvent("KNOWLEDGE_BASE_ARTICLE_LOAD_FAILURE");


	local homeData = {
		name = HOME,
		OnClick = KnowledgeBase_DisplayCategories,
		listFunc = KnowledgeBase_ListCategory,
	}
	self.navBar.textMaxWidth = 270;
	NavBar_Initialize(self.navBar, "HelpFrameNavButtonTemplate", homeData, self.navBar.home, self.navBar.overflow);

	--Scroll Frame
	self.scrollFrame.update = KnowledgeBase_UpdateArticles;
	self.scrollFrame.scrollBar.doNotHide = true;
	HybridScrollFrame_CreateButtons(self.scrollFrame, "KnowledgeBaseArticleTemplate", 8, -3, "TOPLEFT", "TOPLEFT", 0, -3);

	--Scroll Frame 2
	self.scrollFrame2.child:SetWidth(self.scrollFrame2:GetWidth());
	local childWidth = self.scrollFrame2.child:GetWidth();
	self.articleTitle:SetWidth(childWidth - 40);
	self.articleText:SetWidth(childWidth - 30);

	self.history = {}
end


function KnowledgeBase_OnShow(self)
	if ( not kbsetupLoaded ) then
		KnowledgeBase_DisplayCategories(true);
	end
end


function KnowledgeBase_OnEvent(self, event, ...)
	if ( event == "KNOWLEDGE_BASE_SETUP_LOAD_SUCCESS") then
		kbsetupLoaded = true;
		KnowledgeBase_SnapToTopIssues();
	elseif ( event == "KNOWLEDGE_BASE_SETUP_LOAD_FAILURE" ) then
		KnowledgeBase_ShowErrorFrame(self, KBASE_ERROR_LOAD_FAILURE);
		kbsetupLoaded = false;
	elseif ( event == "KNOWLEDGE_BASE_QUERY_LOAD_SUCCESS" ) then
		local totalArticleHeaderCount = Custom_KnowledgeBase.KBQuery_GetTotalArticleCount();

		if ( totalArticleHeaderCount > 0 ) then
			self.scrollFrame.ScrollBar:SetValue(0);
			self.totalArticleCount = totalArticleHeaderCount;
			self.dataFunc = Custom_KnowledgeBase.KBQuery_GetArticleHeaderData;
			KnowledgeBase_UpdateArticles();
			KnowledgeBase_HideErrorFrame(self, KBASE_ERROR_NO_RESULTS);
		else
			KnowledgeBase_ShowErrorFrame(self, KBASE_ERROR_NO_RESULTS);
		end
	elseif ( event == "KNOWLEDGE_BASE_QUERY_LOAD_FAILURE" ) then
		KnowledgeBase_ShowErrorFrame(self, KBASE_ERROR_LOAD_FAILURE);
	elseif ( event == "KNOWLEDGE_BASE_ARTICLE_LOAD_SUCCESS" ) then
		local id, subject, subjectAlt, text, keywords, languageId, isHot = Custom_KnowledgeBase.KBArticle_GetData();
		self.articleTitle:SetText(subject);
		self.articleText:SetText(text);
		self.articleId:SetFormattedText(KBASE_ARTICLE_ID, id);
		self.scrollFrame2.ScrollBar:SetValue(0);

		self.scrollFrame:Hide();
		self.scrollFrame2:Show();
	elseif ( event == "KNOWLEDGE_BASE_ARTICLE_LOAD_FAILURE" ) then
		KnowledgeBase_ShowErrorFrame(self, KBASE_ERROR_LOAD_FAILURE);
	end
end


function KnowledgeBase_Clearlist()
	local self = HelpFrame.kbase;
	local scrollFrame = self.scrollFrame;
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;

	for i = 1, numButtons do
		local button = buttons[i];
		button:Hide();
		button:SetScript("OnClick", nil);
	end

	scrollFrame.ScrollBar:SetValue(0);
	scrollFrame.update = KnowledgeBase_Clearlist;
end


function KnowledgeBase_UpdateArticles()
	local self = HelpFrame.kbase;
	local scrollFrame = self.scrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;

	self.scrollFrame2:Hide();
	self.scrollFrame:Show();

	for i = 1, numButtons do
		local button = buttons[i];
		local index = offset + i;
		if index <= self.totalArticleCount then
			local articleId, articleHeader, isArticleHot, isArticleUpdated = self.dataFunc(index);
			button.number:SetText(index .. ".");
			button.title:SetPoint("LEFT", button.number, "RIGHT", 5, 0);

			button.index = index;
			button.articleId = articleId;
			button.articleHeader = articleHeader;

			button.title:SetText(articleHeader)
			button.hotIcon:SetShown(isArticleHot)
			button.updatedIcon:SetShown(isArticleUpdated)

			button.title:ClearAllPoints()

			if isArticleUpdated then
				button.title:SetPoint("LEFT", button.updatedIcon, "RIGHT", 3, 0)

				button.updatedIcon:ClearAllPoints()
				if isArticleHot then
					button.updatedIcon:SetPoint("LEFT", button.hotIcon, "RIGHT", 3, 0)
				else
					button.updatedIcon:SetPoint("LEFT", button.number, "RIGHT", 5, 0)
				end
			elseif isArticleHot then
				button.title:SetPoint("LEFT", button.hotIcon, "RIGHT", 3, 0)
			else
				button.title:SetPoint("LEFT", button.number, "RIGHT", 5, 0)
			end

			button.title:SetPoint("RIGHT", -5, 0)

			button:SetScript("OnClick", KnowledgeBase_ArticleOnClick);

			button:Show();
		else
			button:Hide();
			button:SetScript("OnClick", nil);
		end
	end

	scrollFrame.update = KnowledgeBase_UpdateArticles;
	HybridScrollFrame_Update(scrollFrame, KBASE_BUTTON_HEIGHT*self.totalArticleCount, scrollFrame:GetHeight());
end


function KnowledgeBase_ResendArticleRequest(self)
	KnowledgeBase_Clearlist();

	Custom_KnowledgeBase.KBQuery_BeginLoading("",
		self.data.category,
		self.data.subcategory,
		KBASE_NUM_ARTICLES_PER_PAGE,
		0);

	HelpFrame.kbase.category = self.data.category;
	HelpFrame.kbase.subcategory = self.data.subcategory;

	KnowledgeBase_ClearSearch(HelpFrame.kbase.searchBox);
end


function KnowledgeBase_SendArticleRequest(categoryIndex, subcategoryIndex)
	KnowledgeBase_Clearlist();
	local buttonText = HELPFRAME_ALL_ARTICLES;
	if subcategoryIndex ~= 0 then
		buttonText = KnowledgeBase_ListSubCategory(nil, subcategoryIndex+1, categoryIndex);
	end

	local buttonData = {
		name = buttonText,
		OnClick = KnowledgeBase_ResendArticleRequest,
		category = categoryIndex,
		subcategory = subcategoryIndex,
	}
	NavBar_AddButton(HelpFrame.kbase.navBar, buttonData);

	Custom_KnowledgeBase.KBQuery_BeginLoading("",
		categoryIndex,
		subcategoryIndex,
		KBASE_NUM_ARTICLES_PER_PAGE,
		0);

	HelpFrame.kbase.category = categoryIndex;
	HelpFrame.kbase.subcategory = subcategoryIndex;

	KnowledgeBase_ClearSearch(HelpFrame.kbase.searchBox);
end


function KnowledgeBase_SelectCategory(self, index, navBar) -- Index could also be the button used
	if type(index) ~= "number" then
		local button = index
		index = self.index;

		if button == "LeftButton" then
			if KnowledgeBase_InsertLink(2, self.categoryID, self.title:GetText()) then
				return
			end
		end
	end
	HelpFrame.kbase.category = nil;

	if index == 1 then
		KnowledgeBase_SendArticleRequest(0,0);
		HelpFrame.kbase.category = 0
	elseif index == 2 then
		KnowledgeBase_GotoTopIssues();
	else
		KnowledgeBase_DisplaySubCategories(index-2);
		HelpFrame.kbase.category = index-2;
	end

	KnowledgeBase_ClearSearch(HelpFrame.kbase.searchBox);
end


function KnowledgeBase_SelectSubCategory(self, index, navBar) -- Index could also be the button used
	if type(index) ~= "number" then
		local button = index
		index = self.index;

		if button == "LeftButton" then
			if KnowledgeBase_InsertLink(3, self.subCategoryID, self.title:GetText()) then
				return
			end
		end
	end
	HelpFrame.kbase.subcategory = index-1;
	KnowledgeBase_SendArticleRequest(HelpFrame.kbase.category, index-1);

	KnowledgeBase_ClearSearch(HelpFrame.kbase.searchBox);
end


function KnowledgeBase_ListCategory(self, index)
	local categoryID, text;
	local numCata = Custom_KnowledgeBase.KBSetup_GetCategoryCount()+2;

	if index == 1 then
		categoryID = -1
		text = HELPFRAME_ALL_ARTICLES;
	elseif index == 2 then
		categoryID = -2
		text = KBASE_TOP_ISSUES;
	elseif index <= numCata then
		categoryID, text = Custom_KnowledgeBase.KBSetup_GetCategoryData(index-2);
	end

	return text, KnowledgeBase_SelectCategory, categoryID;
end


function KnowledgeBase_DisplayCategories(forceMainPage)
	if( not kbsetupLoaded ) then
		--never loaded the setup so load setup and go to top issues.
		KnowledgeBase_GotoTopIssues();
		if forceMainPage then
			NavBar_Reset(HelpFrame.kbase.navBar);
		else
			return;
		end
	end

	local self = HelpFrame.kbase;
	local scrollFrame = self.scrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local numCata = Custom_KnowledgeBase.KBSetup_GetCategoryCount()+2;
	KnowledgeBase_ClearSearch(HelpFrame.kbase.searchBox);

	HelpFrame.kbase.category = nil;
	HelpFrame.kbase.subcategory = nil;

	self.scrollFrame2:Hide();
	self.scrollFrame:Show();

	local showButton = false;
	for i = 1, numButtons do
		showButton = false;
		local button = buttons[i];
		local index = offset + i;
		local text, func, categoryID = KnowledgeBase_ListCategory(self, index);
		if text then
			button.number:SetText("");
			button.title:SetPoint("LEFT", 10, 0);
			button.title:SetText(text);
			button:SetScript("OnClick",	func);
			button.categoryID = categoryID;
			button.index = index;
			showButton = true;
		end

		if showButton then
			button.hotIcon:Hide()
			button.updatedIcon:Hide()
			button:Show();
		else
			button:Hide();
			button:SetScript("OnClick",	nil);
		end
	end

	scrollFrame.update = KnowledgeBase_DisplayCategories;
	HybridScrollFrame_Update(scrollFrame, KBASE_BUTTON_HEIGHT*(numCata), scrollFrame:GetHeight());
end


function KnowledgeBase_ListSubCategory(self, index, category)
	category = category or self.data.category;
	local subCategoryID, text;
	local numSubCata = Custom_KnowledgeBase.KBSetup_GetSubCategoryCount(category)+1;

	if index == 1 then
		subCategoryID = -1
		text = HELPFRAME_ALL_ARTICLES;
	elseif index <= numSubCata then
		subCategoryID, text = Custom_KnowledgeBase.KBSetup_GetSubCategoryData(category, index-1);
	end
	return text, KnowledgeBase_SelectSubCategory, subCategoryID;
end


function KnowledgeBase_DisplaySubCategories(category)
	HelpFrame.kbase.subcategory = nil;

	if category and type(category) == "number" then
		local _, cat_name = Custom_KnowledgeBase.KBSetup_GetCategoryData(category);
		local buttonData = {
			name = cat_name,
			OnClick = KnowledgeBase_DisplaySubCategories,
			listFunc = KnowledgeBase_ListSubCategory,
			category = category,
		}
		NavBar_AddButton(HelpFrame.kbase.navBar, buttonData);
		HelpFrame.kbase.category = category;
	else
		--Updating because of Scrolling
		category = HelpFrame.kbase.category;
	end

	local self = HelpFrame.kbase;
	local scrollFrame = self.scrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local numSubCata = Custom_KnowledgeBase.KBSetup_GetSubCategoryCount(category)+1;

	self.scrollFrame2:Hide();
	self.scrollFrame:Show();

	local showButton = false;
	for i = 1, numButtons do
		showButton = false;
		local button = buttons[i];
		local index = offset + i;
		local text, func, subCategoryID = KnowledgeBase_ListSubCategory(self, index, category);
		if text then
			button.number:SetText("");
			button.title:SetPoint("LEFT", 10, 0);
			button.title:SetText(text);
			button:SetScript("OnClick",	func);
			button.subCategoryID = subCategoryID;
			button.index = index;
			showButton = true;
		end

		if showButton then
			button.hotIcon:Hide()
			button.updatedIcon:Hide()
			button:Show();
		else
			button:Hide();
			button:SetScript("OnClick",	nil);
		end
	end

	scrollFrame.update = KnowledgeBase_DisplaySubCategories;
	HybridScrollFrame_Update(scrollFrame, KBASE_BUTTON_HEIGHT*(numSubCata), scrollFrame:GetHeight());
end


function KnowledgeBase_ShowErrorFrame(self, message)
	self.errorFrame.text:SetText(message);
	self.errorFrame:Show();
end

function KnowledgeBase_HideErrorFrame(self, message)
	if ( self.errorFrame.text:GetText() == message ) then
		self.errorFrame:Hide();
	end
end

---------------Kbase button functions--------------
---------------Kbase button functions--------------
---------------Kbase button functions--------------
function KnowledgeBase_SnapToTopIssues()
	KnowledgeBase_Clearlist();
	if( kbsetupLoaded ) then
		local totalArticleHeaderCount = Custom_KnowledgeBase.KBSetup_GetTotalArticleCount();

		if ( totalArticleHeaderCount > 0 ) then
			HelpFrame.kbase.totalArticleCount = totalArticleHeaderCount;
			HelpFrame.kbase.dataFunc = Custom_KnowledgeBase.KBSetup_GetArticleHeaderData;
			KnowledgeBase_UpdateArticles();
			KnowledgeBase_HideErrorFrame(HelpFrame.kbase, KBASE_ERROR_NO_RESULTS);
		else
			KnowledgeBase_ShowErrorFrame(HelpFrame.kbase, KBASE_ERROR_NO_RESULTS);
		end
	else
		Custom_KnowledgeBase.KBSetup_BeginLoading(KBASE_NUM_ARTICLES_PER_PAGE, 0);
	end
end

function KnowledgeBase_GotoTopIssues()
	HelpFrame_SetFrameByKey(HELPFRAME_KNOWLEDGE_BASE)
	HelpFrame_SetSelectedButton(HelpFrameNavTbl[1].button)

	NavBar_Reset(HelpFrame.kbase.navBar);
	KnowledgeBase_Clearlist();
	local buttonData = {
		name = KBASE_TOP_ISSUES,
		OnClick = KnowledgeBase_SnapToTopIssues,
	}
	NavBar_AddButton(HelpFrame.kbase.navBar, buttonData);
	KnowledgeBase_SnapToTopIssues();

	HelpFrame.kbase.historyBackButton:Hide()
end

function KnowledgeBase_ArticleIDOnClick(self, button)
	if button == "LeftButton" then
		if ChatEdit_GetActiveWindow() then
			KnowledgeBase_InsertLink(1, self.articleId, self.articleHeader, true)
		else
			ChatFrame_OpenChat(KnowledgeBase_CreateLink(1, self.articleId, self.articleHeader))
		end
	end
end

function KnowledgeBase_ArticleOnClick(self, button, ignoreModifier)
	if button == "LeftButton" and not ignoreModifier then
		if KnowledgeBase_InsertLink(1, self.articleId, self.articleHeader) then
			return
		end
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

	local buttonData = {
		name = self.articleHeader,
	}
	NavBar_AddButton(HelpFrame.kbase.navBar, buttonData);

	HelpFrame.kbase.scrollFrame2.child.ArticleLink.articleId = self.articleId
	HelpFrame.kbase.scrollFrame2.child.ArticleLink.articleHeader = self.articleHeader

	local articleId = self.articleId
	KnowledgeBase_Clearlist();
	local searchType = 1;
	Custom_KnowledgeBase.KBArticle_BeginLoading(articleId, searchType);
end


function KnowledgeBase_Search()
	KnowledgeBase_Clearlist();
	if ( not Custom_KnowledgeBase.KBSetup_IsLoaded() ) then
		return;
	end

	HelpFrame.kbase.category = 0;
	HelpFrame.kbase.subcategory = 0;

	local searchText = HelpFrame.kbase.searchBox:GetText();
	if HelpFrame.kbase.searchBox.inactive then
		searchText = "";
	end

	NavBar_Reset(HelpFrame.kbase.navBar);
	local buttonData = {
		name = KBASE_SEARCH_RESULTS,
		OnClick = KnowledgeBase_Search,
	}
	NavBar_AddButton(HelpFrame.kbase.navBar, buttonData);

	Custom_KnowledgeBase.KBQuery_BeginLoading(searchText,
		0,
		0,
		KBASE_NUM_ARTICLES_PER_PAGE,
		0);

	HelpFrame.kbase.hasSearch = true;
end

function KnowledgeBase_ClearSearch(self)
	EditBox_ClearFocus(self);
	self:SetText(SEARCH);
	self:SetFontObject("GameFontDisable");
	self.icon:SetVertexColor(0.6, 0.6, 0.6);
	self.inactive = true;
	self.clearButton:Hide();
	self:GetParent().searchButton:Disable();
	HelpFrame.kbase.hasSearch = false;
end

function KnowledgeBase_BackButton_OnHide(self)
	table.wipe(HelpFrame.kbase.history)
end

function KnowledgeBase_SetNavBarPath(articleID)
	NavBar_Reset(HelpFrame.kbase.navBar)

	local articlePath = Custom_KnowledgeBase.GetArticlePath(articleID)
	if articlePath then
		local categoryID
		for _, category in ipairs(articlePath) do
			local buttonData = {
				name = category.name,
			}

			if category.subcategory then
				buttonData.OnClick = KnowledgeBase_ResendArticleRequest
				buttonData.category = categoryID
				buttonData.subcategory = category.id

				HelpFrame.kbase.subcategory = category.id
			else
				buttonData.listFunc = KnowledgeBase_ListSubCategory
				buttonData.OnClick = KnowledgeBase_DisplaySubCategories
				buttonData.category = category.id

				HelpFrame.kbase.category = category.id
				categoryID = category.id
			end

			NavBar_AddButton(HelpFrame.kbase.navBar, buttonData)
		end
	end
end

function KnowledgeBase_BackButton_OnClick(self, button)
	if button ~= "LeftButton" then return end

	local entryData = table.remove(HelpFrame.kbase.history)
	if entryData then
		if entryData[1] == SIRUS_KNOWLEDGE_BASE_IDS.ROOT.ARTICLE then
			local entry = KNOWLEDGEBASE_ARTICLES[entryData[2]]
			if entry and (not entry.hidden or IsGMAccount()) then
				KnowledgeBase_SetNavBarPath(entry.articleID)
				KnowledgeBase_ArticleOnClick({
					articleId = entry.articleID,
					articleHeader = Custom_KnowledgeBase.GetArticleHeaderByID(entry.articleID),
				}, "LeftButton", true)
			end
		elseif entryData[1] == -1 then
			HelpFrame_SetFrameByKey(entryData[2])
		end
	end

	if #HelpFrame.kbase.history == 0 then
		self:Hide()
	end
end

local itemRefTypes = {
	item = 1,
	spell = 1,
	quest = 1,
--	achievement = 1,
	collection = 2,
	journal = 2,
--	kbase = 2,
	store = 2,
}
local hyperlinks = {
	item = true,
	spell = true,
	quest = true,
}
local hoverLinkInfo = {
	journal = ADVENTURE,
	kbase = KNOWLEDGE_BASE,
	store = GAMEMENU_BUTTON_STORE,
}

function KnowledgeBase_OnHyperlinkClick(self, link, text, button)
	if button ~= "LeftButton" then return end

	local linkType, linkData = string.split(":", link, 2)

	if itemRefTypes[linkType] then
		if itemRefTypes[linkType] == 2 then
			RunNextFrame(function()	-- workaround crash when clicking on a hyperlink that opens another UIPanel
				SetItemRef(link, text, button, self)
			end)
		else
			SetItemRef(link, text, button, self)
		end
	elseif linkType == "kbase" then
		local articleID = HelpFrame.kbase.scrollFrame2.child.ArticleLink.articleId

		RunNextFrame(function()	-- workaround block of SimpleHTML widget text change when hyperlink is clicked
			SetItemRef(link, text, button, self)

			if HelpFrame.kbase.scrollFrame2.child.ArticleLink.articleId ~= articleID then
				table.insert(HelpFrame.kbase.history, {1, articleID})
				HelpFrame.kbase.historyBackButton:Show()
				KnowledgeBase_OnHyperlinkLeave(self, link, text)
			end
		end)
	elseif linkType == "help" then
		local key = tonumber(linkData)
		if key and HelpFrameNavTbl[key] and HelpFrameNavTbl[key].frame then
			RunNextFrame(function()
				HelpFrame_SetFrameByKey(key)
				HelpFrame_SetSelectedButton(HelpFrameNavTbl[key].button)
			end)
		end
	elseif linkType == "http" then
		StaticPopup_Show("EXTERNAL_URL_POPUP", nil, nil, linkData)
	elseif linkType == "achievement" then
		local achievementLink = GetAchievementLink(tonumber(linkData))
		if achievementLink then
			SetItemRef(achievementLink, text, button, self)
		end
	elseif linkType == "showpanel" then
		RunNextFrame(function()
			ShowUIPanel(_G[linkData])
		end)
	end
end

function KnowledgeBase_ShowHyperlinkTooltip(self, link, data, isHyperlink)
	if not data then
		GMError(string.format("No link data for [%s]", link), 2)
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT", 10, 10)
	if isHyperlink then
		GameTooltip:SetHyperlink(data)
	else
		GameTooltip:AddLine(data, 1, 1, 1)
	end
	GameTooltip:Show()
end

function KnowledgeBase_OnHyperlinkEnter(self, link, text)
	local linkType, linkData = string.split(":", link, 2)

	if hyperlinks[linkType] then
		KnowledgeBase_ShowHyperlinkTooltip(self, link, link, true)
	elseif hoverLinkInfo[linkType] then
		KnowledgeBase_ShowHyperlinkTooltip(self, link, hoverLinkInfo[linkType])
	elseif linkType == "http" then
		KnowledgeBase_ShowHyperlinkTooltip(self, link, linkData)
		SetCursor("Interface/Cursor/Cast")
	elseif linkType == "help" then
		local key = tonumber(linkData)
		if key and HelpFrameNavTbl[key] and HelpFrameNavTbl[key].frame and HelpFrameNavTbl[key].text then
			KnowledgeBase_ShowHyperlinkTooltip(self, link, HelpFrameNavTbl[key].text)
		end
	elseif linkType == "achievement" then
		KnowledgeBase_ShowHyperlinkTooltip(self, link, GetAchievementLink(tonumber(linkData)), true)
	elseif linkType == "collection" then
		local _, itemID = string.split(":", link, linkData);
		KnowledgeBase_ShowHyperlinkTooltip(self, link, string.format("item:%s", itemID), true)
	elseif linkType == "showpanel" then
		KnowledgeBase_ShowHyperlinkTooltip(self, link, linkData)
	end
end

function KnowledgeBase_OnHyperlinkLeave(self, link, text)
	ResetCursor()
	GameTooltip:Hide()
end



local HELPFRAME_REQUEST_KEYWORDS = false
local HELPFRAME_NUM_SUGGESTIONS = 10

function HelpFrameTicket_OnLoad(self)
	tinsert(HelpFrameWindows, self)
	self.Content:SetText(HELPFRAME_OPENTICKET_TEXT)

	self.editbox = HelpFrameOpenTicketEditBox
	HelpFrameOpenTicketEditBox.submitButton = self.submitButton

	self.suggestionPool = CreateFramePool("Button", self, "KnowledgeBaseArticleSuggestionTemplate")
	self.suggestionButtons = {}
--	self:RegisterCustomEvent("KNOWLEDGE_BASE_SUGGESTIONS_PROGRESS")
	self:RegisterCustomEvent("KNOWLEDGE_BASE_SUGGESTIONS_AVAILABLE")
end

function HelpFrameTicket_OnShow(self)
	if self.editbox:GetNumLetters() > 0 then
		self.submitButton:Enable()

		local text = string.trim(self.editbox:GetText())
		if text ~= "" then
			Custom_KnowledgeBase.RequestSuggestions(text, HELPFRAME_REQUEST_KEYWORDS)
		end
	else
		self.submitButton:Disable()
	end
end

function HelpFrameTicket_OnHide(self)
	Custom_KnowledgeBase.AbortSuggestions()
	self.suggestionPool:ReleaseAll()
end

function HelpFrameTicket_OnEvent(self, event, ...)
	if event == "KNOWLEDGE_BASE_SUGGESTIONS_AVAILABLE" then
		local haveResults, suggestions, keywordsAvailable = Custom_KnowledgeBase.GetSuggestions(HELPFRAME_NUM_SUGGESTIONS)
		if haveResults and #suggestions > 0 then
			self.Suggestions.SuggestionScroll.suggestions = suggestions
			self.Suggestions.SuggestionScroll.keywordsAvailable = keywordsAvailable
			HelpFrameTicketSuggestionScroll_UpdateScroll(self.Suggestions.SuggestionScroll)
			self.Suggestions:Show()
		else
			self.Suggestions:Hide()
		end
	end
end

function KnowledgeBase_CreateLink(dataTypeIndex, entryID, text)
	return string.format("|cfff5e6bd|Hkbase:%i:%i|h[%s]|h|r", dataTypeIndex, entryID, text)
end

function KnowledgeBase_InsertLink(dataTypeIndex, entryID, text, ignoreModifier)
	if ignoreModifier or IsModifiedClick("CHATLINK") then
		return ChatEdit_InsertLink(KnowledgeBase_CreateLink(dataTypeIndex, entryID, text))
	end
	return false
end

function HelpFrameOpenTicketEditBox_OnTextChanged(self, userInput)
	local text = string.trim(self:GetText())
	if self:GetNumLetters() == 0 or text == "" then
		Custom_KnowledgeBase.AbortSuggestions()
		self:GetParent():GetParent().Suggestions:Hide()
		return
	end

	Custom_KnowledgeBase.RequestSuggestions(text, HELPFRAME_REQUEST_KEYWORDS)
end

function KnowledgeBaseArticleSuggestion_OnMouseUp(self, button)
	if button ~= "LeftButton" then return end

	HelpFrame_SetFrameByKey(HELPFRAME_KNOWLEDGE_BASE)
	HelpFrame_SetSelectedButton(HelpFrameNavTbl[1].button)

	KnowledgeBase_SetNavBarPath(self.article.articleID)
	KnowledgeBase_ArticleOnClick(self, button, true)

	table.insert(HelpFrame.kbase.history, {-1, 6})
	HelpFrame.kbase.historyBackButton:Show()
end

local KB_SUGGESTION_BUTTONS = 4
local KB_SUGGESTION_BUTTON_HIEGHT = 20
local KB_SUGGESTION_BUTTON_SPACING = 3

function HelpFrameTicketSuggestionScroll_OnLoad(self)
	self.buttons = {}

	local scollFrameLevel = self:GetFrameLevel()

	for i = 1, KB_SUGGESTION_BUTTONS do
		local button = CreateFrame("Button", string.format("$parentCategoryButton%i", i), self, "KnowledgeBaseArticleSuggestionTemplate")
		button:Hide()
		button:SetFrameLevel(scollFrameLevel + 2)

		if i == 1 then
			button:SetPoint("TOPLEFT", 6, -3)
		else
			button:SetPoint("TOPLEFT", self.buttons[i - 1], "BOTTOMLEFT", 0, -KB_SUGGESTION_BUTTON_SPACING)
		end

		self.buttons[i] = button
	end

	ScrollFrame_OnLoad(self)
end

function HelpFrameTicketSuggestionScroll_OnShow(self)
	self.ScrollBar:SetValue(0)
end

function HelpFrameTicketSuggestionScroll_OnVerticalScroll(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, KB_SUGGESTION_BUTTON_HIEGHT, HelpFrameTicketSuggestionScroll_UpdateScroll)
end

function HelpFrameTicketSuggestionScroll_UpdateScroll(self)
	local numSuggestions = #self.suggestions
	if not FauxScrollFrame_Update(self, numSuggestions, KB_SUGGESTION_BUTTONS, KB_SUGGESTION_BUTTON_HIEGHT, nil, nil, nil, nil, nil, nil, true) then
		self.ScrollBar:SetValue(0)
	end

	local offset = FauxScrollFrame_GetOffset(self)

	for index = 1, KB_SUGGESTION_BUTTONS do
		local button = self.buttons[index]
		local buttonIndex = index + offset

		if buttonIndex > numSuggestions then
			button:Hide()
		else
			if self.keywordsAvailable then
				button.article = self.suggestions[buttonIndex][1]
				button.keywordList = self.suggestions[buttonIndex][2]

				button.articleId = button.article.articleID
				button.articleHeader = button.article.articleHeader

				button.title:SetText(button.article.articleHeader)
				button.keywords:SetText(strconcat("[", table.concat(button.keywordList, ", "), "]"))
			else
				button.article = self.suggestions[buttonIndex]

				button.articleId = button.article.articleID
				button.articleHeader = button.article.articleHeader

				button.title:SetText(button.article.articleHeader)
				button.keywords:SetText("")
			end

			button:Show()
		end
	end
end