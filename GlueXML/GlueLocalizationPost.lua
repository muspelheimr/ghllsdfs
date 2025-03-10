RUSSIAN_DECLENSION_PATTERNS = 5;

RUSSIAN_DECLENSION_TAB_LIST = {};
RUSSIAN_DECLENSION_TAB_LIST[1] = "DeclensionFrameDeclension1Edit";
RUSSIAN_DECLENSION_TAB_LIST[2] = "DeclensionFrameDeclension2Edit";
RUSSIAN_DECLENSION_TAB_LIST[3] = "DeclensionFrameDeclension3Edit";
RUSSIAN_DECLENSION_TAB_LIST[4] = "DeclensionFrameDeclension4Edit";
RUSSIAN_DECLENSION_TAB_LIST[5] = "DeclensionFrameDeclension5Edit";

function DeclensionFrame_OnEvent(self, event, ...)
	if ( event == "FORCE_DECLINE_CHARACTER" ) then
		local name, declensions = ...;
		self.name = name;
		if ( declensions ) then
			self.names = { select(2, ...) };
		end

		local errors = ...;
		if ( errors ) then
			PlaySound(SOUNDKIT.GS_TITLE_OPTIONS)
			if errors == "CHAR_NAME_RESERVED" then
				GlueDialog:ShowDialog("DECLINE_FAILED", DECLENSION_NAME_RESERVED);
			else
				GlueDialog:ShowDialog("DECLINE_FAILED", _G[errors]);
			end
		else
			self:Show();
		end
	end
end

function DeclensionFrame_Update()
	local declensionButton, exampleButton, declensionBox;
	local declension, example, declension;
	local backdropColor = DEFAULT_TOOLTIP_COLOR;

	local name, race, class, level, zone, fileString, gender, ghost = GetCharacterInfo(GetCharIDFromIndex(CharacterSelect.selectedIndex));
	DeclensionFrameNominative:SetText(name);

	local count = GetNumDeclensionSets(name, gender);
	local set = DeclensionFrame.set;

	if ( not set ) then
		set = 1;
	end

	-- Save the count value so we know our max pages.
	DeclensionFrame.count = count;

	-- Hide the paging tool if there is only one set
	if ( count > 1 ) then
		DeclensionFrameSetPage:SetText(format(DECLENSION_SET, set, count));
		DeclensionFrame:SetHeight(480);
		DeclensionFrameSet:Show();
		if ( set == 1 and set < count ) then
			DeclensionFrameSetNext:Enable();
			DeclensionFrameSetPrev:Disable();
		elseif ( set == count and set ~= 1 ) then
			DeclensionFrameSetNext:Disable();
			DeclensionFrameSetPrev:Enable();
		elseif ( set == count - 1 and set ~= 1 ) then
			DeclensionFrameSetNext:Enable();
			DeclensionFrameSetPrev:Enable();
		end
	else
		DeclensionFrame:SetHeight(460);
		DeclensionFrameSet:Hide();
	end

	local names;
	if ( DeclensionFrame.names ) then
		names = DeclensionFrame.names;
		DeclensionFrame.names = nil;
	else
		names = { DeclineName(name, nil, set) };
	end

	for i=1, RUSSIAN_DECLENSION_PATTERNS do
		declensionButton = _G["DeclensionFrameDeclension"..i.."Type"];
		exampleButton = _G["DeclensionFrameDeclension"..i.."Example"];
		declensionBox = _G["DeclensionFrameDeclension"..i.."Edit"];
		-- declensionBox:SetBackdropBorderColor(backdropColor[1], backdropColor[2], backdropColor[3]);
		-- declensionBox:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
		declensionBox:SetText(names[i]);
		declensionButton:SetFormattedText("%s:", _G["RUSSIAN_DECLENSION_"..i]);
		exampleButton:SetFormattedText("прим. %s", string.format(_G["RUSSIAN_DECLENSION_EXAMPLE_"..i], string.format("|cffffc100%s|r", names[i])));
	end
end

function DeclensionFrame_OnOkay()
	local valid;
	local names = {};
	for i=1, RUSSIAN_DECLENSION_PATTERNS do
		names[i] = _G["DeclensionFrameDeclension"..i.."Edit"]:GetText();
		if ( names[i] ) then
			valid = 1;
		else
			valid = nil;
		end
	end
	if ( valid ) then
		DeclensionFrame:Hide();
		DeclineCharacter(GetCharIDFromIndex(CharacterSelect.selectedIndex), names[1], names[2], names[3], names[4], names[5]);
	end
end

function DeclensionFrame_OnCancel()
	DeclensionFrame.set = 1;
	DeclensionFrame:Hide();
end

function DeclensionFrame_Next()
	local set = DeclensionFrame.set;
	local count = DeclensionFrame.count;
	if ( not set ) then
		set = 1;
	end

	set = set + 1;
	DeclensionFrame.set = set;
	DeclensionFrame_Update();
end

function DeclensionFrame_Prev()
	local set = DeclensionFrame.set;
	local count = DeclensionFrame.count;
	if ( not set ) then
		set = 1;
	end

	set = set - 1;
	DeclensionFrame.set = set;
	DeclensionFrame_Update();
end
