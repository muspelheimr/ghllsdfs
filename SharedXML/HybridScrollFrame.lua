--[[-----------------------------------------------------------------------------------------------
	For a hybrid scroll frame with buttons of varying size, set .dynamic on the scroll frame
	to be a function which will take the offset and return:
		1. how many buttons the offset is completely past
		2. how many pixels the offset is into the topmost button
	So with buttons of size 20, .dynamic(0) should return 0,0 and .dynamic(34) should return 1,14
-----------------------------------------------------------------------------------------------]]--

local round = function (num) return math.floor(num + .5); end

function HybridScrollFrame_OnLoad (self)
	self:EnableMouse(true);
end

function HybridScrollFrameScrollUp_OnLoad (self)
	self:GetParent():GetParent().scrollUp = self;
	self:Disable();
	self:RegisterForClicks("LeftButtonUp", "LeftButtonDown");
	self.direction = 1;
end

function HybridScrollFrameScrollDown_OnLoad (self)
	self:GetParent():GetParent().scrollDown = self;
	self:Disable();
	self:RegisterForClicks("LeftButtonUp", "LeftButtonDown");
	self.direction = -1;
end

function HybridScrollFrame_OnValueChanged (self, value)
	HybridScrollFrame_SetOffset(self:GetParent(), value);
	HybridScrollFrame_UpdateButtonStates(self:GetParent(), value);
end

function HybridScrollFrame_UpdateButtonStates (self, currValue)
	if ( not currValue ) then
		currValue = self.scrollBar:GetValue();
	end

	self.scrollUp:Enable();
	self.scrollDown:Enable();

	local minVal, maxVal = self.scrollBar:GetMinMaxValues();
	if ( currValue >= maxVal ) then
		self.scrollBar.thumbTexture:Show();
		if ( self.scrollDown ) then
			self.scrollDown:Disable()
		end
	end
	if ( currValue <= minVal ) then
		self.scrollBar.thumbTexture:Show();
		if ( self.scrollUp ) then
			self.scrollUp:Disable();
		end
	end
end

function HybridScrollFrame_OnMouseWheel (self, delta, stepSize)
	if ( not self.scrollBar:IsVisible() or self.scrollBar:IsEnabled() ~= 1 ) then
		return;
	end

	local minVal, maxVal = 0, self.range;
	stepSize = stepSize or self.stepSize or self.buttonHeight;
	if ( delta == 1 ) then
		self.scrollBar:SetValue(max(minVal, self.scrollBar:GetValue() - stepSize));
	else
		self.scrollBar:SetValue(min(maxVal, self.scrollBar:GetValue() + stepSize));
	end
end

function HybridScrollFrameScrollButton_OnUpdate (self, elapsed)
	self.timeSinceLast = self.timeSinceLast + elapsed;
	if ( self.timeSinceLast >= ( self.updateInterval or 0.08 ) ) then
		if ( not IsMouseButtonDown("LeftButton") ) then
			self:SetScript("OnUpdate", nil);
		elseif ( self:IsMouseOver() ) then
			local parent = self.parent or self:GetParent():GetParent();
			HybridScrollFrame_OnMouseWheel (parent, self.direction, (self.stepSize or parent.buttonHeight/3));
			self.timeSinceLast = 0;
		end
	end
end

function HybridScrollFrameScrollButton_OnClick (self, button, down)
	local parent = self.parent or self:GetParent():GetParent();

	if ( down ) then
		if IsMouseButtonDown then
			self.timeSinceLast = (self.timeToStart or -0.2);
			self:SetScript("OnUpdate", HybridScrollFrameScrollButton_OnUpdate);
		end
		HybridScrollFrame_OnMouseWheel (parent, self.direction);
		PlaySound("UChatScrollButton");
	else
		self:SetScript("OnUpdate", nil);
	end
end

function HybridScrollFrame_SetPercentageHeight(self, percentageHeight)
	local offset = percentageHeight * (self.totalHeight or 0);
	HybridScrollFrame_SetOffset(self, offset);
end

function HybridScrollFrame_GetVisiblePercentage(self)
	local totalHeight = (self.totalHeight or 0);
	if totalHeight == 0 then
		return 0;
	end

	return self.scrollChild:GetHeight() / totalHeight;
end

function HybridScrollFrame_GetScrollPercentage(self)
	local scrollableHeight = (self.totalHeight or 0) - self.scrollChild:GetHeight();
	if scrollableHeight == 0 then
		return 0;
	end

	return (self.offset or 0) / scrollableHeight;
end

function HybridScrollFrame_Update (self, totalHeight, displayedHeight)
	local range = floor(totalHeight - self:GetHeight() + 0.5);
	if ( range > 0 and self.scrollBar ) then
		local minVal, maxVal = self.scrollBar:GetMinMaxValues();
		if ( math.floor(self.scrollBar:GetValue()) >= math.floor(maxVal) ) then
			self.scrollBar:SetMinMaxValues(0, range);
			if ( math.floor(self.scrollBar:GetValue()) ~= math.floor(range) ) then
				self.scrollBar:SetValue(range);
			else
				HybridScrollFrame_SetOffset(self, range); -- If we've scrolled to the bottom, we need to recalculate the offset.
			end
		else
			self.scrollBar:SetMinMaxValues(0, range)
		end
		self.scrollBar:Enable();
		HybridScrollFrame_UpdateButtonStates(self);
		self.scrollBar:Show();
	elseif ( self.scrollBar ) then
		self.scrollBar:SetValue(0);
		if ( self.scrollBar.doNotHide ) then
			self.scrollBar:Disable();
			self.scrollUp:Disable();
			self.scrollDown:Disable();
			self.scrollBar.thumbTexture:Hide();
		else
			self.scrollBar:Hide();
		end
	end

	self.range = range;
	self.totalHeight = totalHeight;
	self.scrollChild:SetHeight(displayedHeight);
	self:UpdateScrollChildRect();
end

function HybridScrollFrame_GetOffset (self)
	return math.floor(self.offset or 0), (self.offset or 0);
end

function HybridScrollFrameScrollChild_OnLoad (self)
	self:GetParent().scrollChild = self;
end

function HybridScrollFrame_ExpandButton (self, offset, height)
	self.largeButtonTop = round(offset);
	self.largeButtonHeight = round(height)
	HybridScrollFrame_SetOffset(self, self.scrollBar:GetValue());
end

function HybridScrollFrame_CollapseButton (self)
	self.largeButtonTop = nil;
	self.largeButtonHeight = nil;
end

function HybridScrollFrame_SetOffset (self, offset)
	local buttons = self.buttons
	local buttonHeight = self.buttonHeight;
	local element, overflow;

	local scrollHeight = 0;

	local largeButtonTop = self.largeButtonTop
	if ( self.dynamic ) then --This is for frames where buttons will have different heights
		if ( offset < buttonHeight ) then
			-- a little optimization
			element = 0;
			scrollHeight = offset;
		else
			element, scrollHeight = self.dynamic(offset);
		end
	elseif ( largeButtonTop and offset >= largeButtonTop ) then
		local largeButtonHeight = self.largeButtonHeight;
		-- Initial offset...
		element = largeButtonTop / buttonHeight;

		if ( offset >= (largeButtonTop + largeButtonHeight) ) then
			element = element + 1;

			local leftovers = (offset - (largeButtonTop + largeButtonHeight) );

			element = element + ( leftovers / buttonHeight );
			overflow = element - math.floor(element);
			scrollHeight = overflow * buttonHeight;
		else
			scrollHeight = math.abs(offset - largeButtonTop);
		end
	else
		element = offset / buttonHeight;
		overflow = element - math.floor(element);
		scrollHeight = overflow * buttonHeight;
	end

	if ( math.floor(self.offset or 0) ~= math.floor(element) and self.update ) then
		self.offset = element;
		self:update();
	else
		self.offset = element;
	end

	self:SetVerticalScroll(scrollHeight);
end

function HybridScrollFrame_CreateButtons (self, buttonTemplate, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
	local scrollChild = self.scrollChild;
	local button, buttonHeight, buttons, numButtons;

	local parentName = self:GetName();
	local buttonName = parentName and (parentName .. "Button") or nil;

	initialPoint = initialPoint or "TOPLEFT";
	initialRelative = initialRelative or "TOPLEFT";
	point = point or "TOPLEFT";
	relativePoint = relativePoint or "BOTTOMLEFT";
	offsetX = offsetX or 0;
	offsetY = offsetY or 0;

	if ( self.buttons ) then
		buttons = self.buttons;
		buttonHeight = buttons[1]:GetHeight();
	else
		button = CreateFrame("BUTTON", buttonName and (buttonName .. 1) or nil, scrollChild, buttonTemplate);
		buttonHeight = button:GetHeight();
		button:SetPoint(initialPoint, scrollChild, initialRelative, initialOffsetX, initialOffsetY);
		buttons = {}
		tinsert(buttons, button);
	end

	self.buttonHeight = round(buttonHeight) - offsetY;

	local numButtons = math.ceil(self:GetHeight() / buttonHeight) + 1;

	for i = #buttons + 1, numButtons do
		button = CreateFrame("BUTTON", buttonName and (buttonName .. i) or nil, scrollChild, buttonTemplate);
		button:SetPoint(point, buttons[i-1], relativePoint, offsetX, offsetY);
		tinsert(buttons, button);
	end

	scrollChild:SetWidth(self:GetWidth())
	scrollChild:SetHeight(numButtons * buttonHeight);
	self:SetVerticalScroll(0);
	self:UpdateScrollChildRect();

	self.buttons = buttons;
	local scrollBar = self.scrollBar;
	scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
	scrollBar.buttonHeight = buttonHeight;
	scrollBar:SetValueStep(.005);
	scrollBar:SetValue(0);

end

function HybridScrollFrame_GetButtonIndex(self, button)
	return tIndexOf(self.buttons, button);
end

function HybridScrollFrame_GetButtons (self)
	return self.buttons;
end

function HybridScrollFrame_SetDoNotHideScrollBar (self, doNotHide)
	if not self.scrollBar or self.scrollBar.doNotHide == doNotHide then
		return;
	end

	self.scrollBar.doNotHide = doNotHide;
	HybridScrollFrame_Update(self, self.totalHeight or 0, self.scrollChild:GetHeight());
end

function HybridScrollFrame_ScrollToIndex(self, index, getHeightFunc)
	local totalHeight = 0;
	local scrollFrameHeight = self:GetHeight();
	for i = 1, index do
		local entryHeight = getHeightFunc(i);
		if i == index then
			local offset = 0;
			-- we don't need to do anything if the entry is fully displayed with the scroll all the way up
			if ( totalHeight + entryHeight > scrollFrameHeight ) then
				if ( entryHeight > scrollFrameHeight ) then
					-- this entry is larger than the entire scrollframe, put it at the top
					offset = totalHeight;
				else
					-- otherwise place it in the center
					local diff = scrollFrameHeight - entryHeight;
					offset = totalHeight - diff / 2;
				end
				-- because of valuestep our positioning might change
				-- we'll do the adjustment ourselves to make sure the entry ends up above the center rather than below
				local valueStep = self.scrollBar:GetValueStep();
				offset = offset + valueStep - mod(offset, valueStep);
				-- but if we ended up moving the entry so high up that its top is not visible, move it back down
				if ( offset > totalHeight ) then
					offset = offset - valueStep;
				end
			end
			self.scrollBar:SetValue(offset);
			break;
		end
		totalHeight = totalHeight + entryHeight;
	end
end

function HybridScrollBar_Disable(scrollBar)
	scrollBar:Disable();
	local scrollDownButton = scrollBar.ScrollDownButton or _G[scrollBar:GetName().."ScrollDownButton"];
	if scrollDownButton then
		scrollDownButton:Disable();
	end
	local scrollUpButton = scrollBar.ScrollUpButton or _G[scrollBar:GetName().."ScrollUpButton"];
	if scrollUpButton then
		scrollUpButton:Disable();
	end
end