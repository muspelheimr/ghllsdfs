RAID_NOTICE_DEFAULT_HOLD_TIME = 10.0;
RAID_NOTICE_FADE_IN_TIME = 0.2;
RAID_NOTICE_FADE_OUT_TIME = 3.0;

function RaidNotice_FadeInit( slotFrame )
	FadingFrame_OnLoad(slotFrame);
	FadingFrame_SetFadeInTime(slotFrame, RAID_NOTICE_FADE_IN_TIME);
	FadingFrame_SetHoldTime(slotFrame, RAID_NOTICE_DEFAULT_HOLD_TIME);
	FadingFrame_SetFadeOutTime(slotFrame, RAID_NOTICE_FADE_OUT_TIME);
end

function RaidNotice_AddMessage( noticeFrame, textString, colorInfo, displayTime )
	if ( not noticeFrame or not noticeFrame.slot1 or not noticeFrame.slot2 or not textString ) then
		return;
	end

	if (not displayTime or displayTime == 0) then
		displayTime = RAID_NOTICE_DEFAULT_HOLD_TIME;
	else
		displayTime = displayTime - RAID_NOTICE_FADE_OUT_TIME;
		displayTime = max(displayTime, 1.0);
	end

	noticeFrame:Show();
	if ( not noticeFrame.slot1:IsShown() ) then
		noticeFrame.slot1_text = textString;
		RaidNotice_SetSlot( noticeFrame.slot1, noticeFrame.slot1_text, colorInfo, noticeFrame.timings["RAID_NOTICE_MIN_HEIGHT"], displayTime );
		noticeFrame.slot1.scrollTime = 0;
	else
		if ( noticeFrame.slot2:IsShown() ) then
			noticeFrame.slot1_text = noticeFrame.slot2_text;
			RaidNotice_SetSlot( noticeFrame.slot1, noticeFrame.slot1_text, colorInfo, noticeFrame.timings["RAID_NOTICE_MIN_HEIGHT"] );
			noticeFrame.slot1.scrollTime = noticeFrame.slot2.scrollTime;
			FadingFrame_CopyTimes(noticeFrame.slot2, noticeFrame.slot1);
		end

		noticeFrame.slot2_text = textString;
		RaidNotice_SetSlot( noticeFrame.slot2, noticeFrame.slot2_text, colorInfo, noticeFrame.timings["RAID_NOTICE_MIN_HEIGHT"], displayTime );
		noticeFrame.slot2.scrollTime = 0;
	end
end

function RaidNotice_SetSlot( slotFrame, textString, colorInfo, minHeight, displayTime )
	slotFrame:SetText( textString );
	slotFrame:SetTextColor( colorInfo.r, colorInfo.g, colorInfo.b, 1.0 )
	slotFrame:SetTextHeight(minHeight);
	FadingFrame_SetHoldTime(slotFrame, displayTime or RAID_NOTICE_DEFAULT_HOLD_TIME );
	FadingFrame_Show( slotFrame );
end

function RaidNotice_OnUpdate( noticeFrame, elapsedTime )
	if ( not noticeFrame or not noticeFrame.slot1 or not noticeFrame.slot2 ) then
		return;
	end

	local inUse = false;
	if ( noticeFrame.slot1:IsShown() ) then
		RaidNotice_UpdateSlot( noticeFrame.slot1, noticeFrame.timings, elapsedTime, true );
		inUse = true;
	end

	if ( noticeFrame.slot2:IsShown() ) then
		RaidNotice_UpdateSlot( noticeFrame.slot2, noticeFrame.timings, elapsedTime, true );
		inUse = true;
	end

	if ( not inUse ) then
		noticeFrame:Hide();
	end
end

function RaidNotice_Clear( noticeFrame )
	RaidNotice_ClearSlot(noticeFrame.slot1);
	RaidNotice_ClearSlot(noticeFrame.slot2);
end

function RaidNotice_ClearSlot( slotFrame )
	slotFrame.scrollTime = nil;
	slotFrame:Hide();
end

function RaidNotice_UpdateSlot( slotFrame, timings, elapsedTime, hasFading )
	if ( slotFrame.scrollTime ) then
		slotFrame.scrollTime = slotFrame.scrollTime + elapsedTime;
		if ( slotFrame.scrollTime <= timings["RAID_NOTICE_SCALE_UP_TIME"] ) then
			slotFrame:SetTextHeight(floor(timings["RAID_NOTICE_MIN_HEIGHT"]+((timings["RAID_NOTICE_MAX_HEIGHT"]-timings["RAID_NOTICE_MIN_HEIGHT"])*slotFrame.scrollTime/timings["RAID_NOTICE_SCALE_UP_TIME"])));
		elseif ( slotFrame.scrollTime <= timings["RAID_NOTICE_SCALE_DOWN_TIME"] ) then
			slotFrame:SetTextHeight(floor(timings["RAID_NOTICE_MAX_HEIGHT"] - ((timings["RAID_NOTICE_MAX_HEIGHT"]-timings["RAID_NOTICE_MIN_HEIGHT"])*(slotFrame.scrollTime - timings["RAID_NOTICE_SCALE_UP_TIME"])/(timings["RAID_NOTICE_SCALE_DOWN_TIME"] - timings["RAID_NOTICE_SCALE_UP_TIME"]))));
		else
			slotFrame:SetTextHeight(timings["RAID_NOTICE_MIN_HEIGHT"]);
			slotFrame.scrollTime = nil;
		end
	end
	if ( hasFading ) then
		FadingFrame_OnUpdate(slotFrame);
	end
end





-----------  RAID WARNING
function RaidWarningFrame_OnLoad(self)
	self:RegisterEvent("CHAT_MSG_RAID_WARNING");
	self.slot1 = RaidWarningFrameSlot1;
	self.slot2 = RaidWarningFrameSlot2;
	RaidNotice_FadeInit( self.slot1 );
	RaidNotice_FadeInit( self.slot2 );
	self.timings = { };
	self.timings["RAID_NOTICE_MIN_HEIGHT"] = 20.0;
	self.timings["RAID_NOTICE_MAX_HEIGHT"] = 30.0;
	self.timings["RAID_NOTICE_SCALE_UP_TIME"] = 0.2;
	self.timings["RAID_NOTICE_SCALE_DOWN_TIME"] = 0.4;
end

function RaidWarningFrame_OnEvent(self, event, message)
	if ( event == "CHAT_MSG_RAID_WARNING" ) then

		--Task 21207: Add the ability to link raid icons to other players
		local term;
		for tag in string.gmatch(message, "%b{}") do
			term = strlower(string.gsub(tag, "[{}]", ""));
			if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
				-- Using 0 as the height to make the texture match the font height
				message = string.gsub(message, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
			end
		end

		RaidNotice_AddMessage( self, message, ChatTypeInfo["RAID_WARNING"] );
		PlaySound("RaidWarning");
	end
end


-----------  BOSS EMOTE
function RaidBossEmoteFrame_OnLoad(self)
	RaidNotice_FadeInit(self.slot1);
	RaidNotice_FadeInit(self.slot2);
	self.timings = { };
	self.timings["RAID_NOTICE_MIN_HEIGHT"] = 20.0;
	self.timings["RAID_NOTICE_MAX_HEIGHT"] = 30.0;
	self.timings["RAID_NOTICE_SCALE_UP_TIME"] = 0.2;
	self.timings["RAID_NOTICE_SCALE_DOWN_TIME"] = 0.4;

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE");
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER");
end

function RaidBossEmoteFrame_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if ( strsub(event,10,18) == "RAID_BOSS" ) then
		local mtype = strsub(event,10);
		local body = format(_G["CHAT_"..mtype.."_GET"]..arg1, arg2, arg2);	--No need for pflag, monsters can't be afk, dnd, or GMs.
		local info = ChatTypeInfo[mtype];
		RaidNotice_AddMessage( RaidBossEmoteFrame, body, info );
--		RaidNotice_AddMessage( RaidBossEmoteFrame, "This is a TEST of the MESSAGE!", ChatTypeInfo["RAID_BOSS_EMOTE"] );
		PlaySound("RaidBossEmoteWarning");
	end
end