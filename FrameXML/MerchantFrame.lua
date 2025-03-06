MERCHANT_ITEMS_PER_PAGE = 10;
BUYBACK_ITEMS_PER_PAGE = 12;
MAX_ITEM_COST = 3;
BACKPACK_WAS_OPEN = nil;

function MoneyFrame_SetMaxDisplayWidth(moneyFrame, width)
	moneyFrame.maxDisplayWidth = width;
end

function MerchantFrame_OnLoad(self)
	self:RegisterEvent("MERCHANT_UPDATE");
	self:RegisterEvent("MERCHANT_CLOSED");
	self:RegisterEvent("MERCHANT_SHOW");
	self:RegisterEvent("GUILDBANK_UPDATE_MONEY");
	self:RegisterForDrag("LeftButton");
	self.page = 1;
	-- Tab Handling code

	MoneyFrame_SetMaxDisplayWidth(MerchantMoneyFrame, 160);

	PanelTemplates_SetNumTabs(self, 2);
	PanelTemplates_SetTab(self, 1);

	MerchantExtraCurrencyInset:Hide();
	MerchantExtraCurrencyBg:Hide();


	MerchantMoneyFrame:SetPoint("BOTTOMRIGHT", -4, 8);
	MerchantMoneyFrame:Show();
end

function MerchantFrame_OnEvent(self, event, ...)
	if ( event == "MERCHANT_UPDATE" ) then
		if ( self:IsVisible() ) then
			MerchantFrame_Update();
		end
	elseif ( event == "MERCHANT_CLOSED" ) then
		HideUIPanel(self);
	elseif ( event == "MERCHANT_SHOW" ) then
		ShowUIPanel(self);
		if ( not self:IsShown() ) then
			CloseMerchant();
			return;
		end
		self.page = 1;
		MerchantFrame_Update();
	elseif ( event == "PLAYER_MONEY" or event == "GUILDBANK_UPDATE_MONEY" or event == "GUILDBANK_UPDATE_WITHDRAWMONEY" ) then
		MerchantFrame_UpdateCanRepairAll();
		MerchantFrame_UpdateRepairButtons();
	end
end

function MerchantFrame_OnShow()
	BACKPACK_WAS_OPEN = OpenBackpack();

	-- Update repair all button status
	MerchantFrame_UpdateCanRepairAll();
	MerchantFrame_UpdateGuildBankRepair();
	PanelTemplates_SetTab(MerchantFrame, 1);
	MerchantFrame_Update();

	PlaySound("igCharacterInfoOpen");
end

function MerchantFrame_OnHide()
	CloseMerchant();
	if ( not BACKPACK_WAS_OPEN ) then
		CloseBackpack();
	end
	ResetCursor();

	StaticPopup_Hide("CONFIRM_PURCHASE_TOKEN_ITEM");
	StaticPopup_Hide("CONFIRM_REFUND_TOKEN_ITEM");
	StaticPopup_Hide("CONFIRM_REFUND_MAX_HONOR");
	StaticPopup_Hide("CONFIRM_REFUND_MAX_ARENA_POINTS");
	PlaySound("igCharacterInfoClose");
end

function MerchantFrame_Update()
	if ( MerchantFrame.lastTab ~= MerchantFrame.selectedTab ) then
		MerchantFrame_CloseStackSplitFrame();
		MerchantFrame.lastTab = MerchantFrame.selectedTab;
	end
	if ( MerchantFrame.selectedTab == 1 ) then
		MerchantFrame_UpdateMerchantInfo();
	else
		MerchantFrame_UpdateBuybackInfo();
	end
end

function MerchantFrame_UpdateMerchantInfo()
	MerchantNameText:SetText(UnitName("NPC"));
	SetPortraitTexture(MerchantFramePortrait, "NPC");

	local numMerchantItems = GetMerchantNumItems();

	MerchantPageText:SetFormattedText(MERCHANT_PAGE_NUMBER, MerchantFrame.page, math.ceil(numMerchantItems / MERCHANT_ITEMS_PER_PAGE));

	local name, texture, price, quantity, numAvailable, isUsable, extendedCost;
	for i=1, MERCHANT_ITEMS_PER_PAGE, 1 do
		local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i);
		local itemButton = _G["MerchantItem"..i.."ItemButton"];
		local merchantButton = _G["MerchantItem"..i];
		local merchantMoney = _G["MerchantItem"..i.."MoneyFrame"];
		local merchantAltCurrency = _G["MerchantItem"..i.."AltCurrencyFrame"];
		if ( index <= numMerchantItems ) then
			name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index);
			_G["MerchantItem"..i.."Name"]:SetText(name);
			SetItemButtonCount(itemButton, quantity);
			SetItemButtonStock(itemButton, numAvailable);
			SetItemButtonTexture(itemButton, texture);

			local itemLink = GetMerchantItemLink(index)
			local honorPoints, arenaPoints = GetMerchantItemCostInfo(index);
			local requirementType, requiredRating = C_Item.GetRequiredPVPRating(itemLink, honorPoints, arenaPoints)

			if requirementType == Enum.ItemRequirementType.Removed then
				isUsable = true
			elseif requirementType == Enum.ItemRequirementType.Battleground then
				local _, _, _, _, rating = GetRatedBattlegroundRankInfo()
				if rating >= requiredRating then
					isUsable = true
				end
			elseif requirementType == Enum.ItemRequirementType.Arena then
				local rating = math.max(GetArenaRating(1), GetArenaRating(2))
				if rating >= requiredRating then
					isUsable = true
				end
			end

			if ( extendedCost and (price <= 0) ) then
				itemButton.price = nil;
				itemButton.extendedCost = true;
				itemButton.link = itemLink;
				itemButton.texture = texture;
				MerchantFrame_UpdateAltCurrency(index, i);
				merchantAltCurrency:ClearAllPoints();
				merchantAltCurrency:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 31);
				merchantMoney:Hide();
				merchantAltCurrency:Show();
			elseif ( extendedCost and (price > 0) ) then
				itemButton.price = price;
				itemButton.extendedCost = true;
				itemButton.link = itemLink;
				itemButton.texture = texture;
				MerchantFrame_UpdateAltCurrency(index, i);
				MoneyFrame_Update(merchantMoney:GetName(), price);
				merchantAltCurrency:ClearAllPoints();
				merchantAltCurrency:SetPoint("LEFT", merchantMoney:GetName(), "RIGHT", -14, 0);
				merchantAltCurrency:Show();
				merchantMoney:Show();
			else
				itemButton.price = price;
				itemButton.extendedCost = nil;
				itemButton.link = itemLink;
				itemButton.texture = texture;
				MoneyFrame_Update(merchantMoney:GetName(), price);
				merchantAltCurrency:Hide();
				merchantMoney:Show();
			end

			itemButton.hasItem = true;
			itemButton:SetID(index);
			itemButton:Show();
			if ( numAvailable == 0 ) then
				-- If not available and not usable
				if ( not isUsable ) then
					SetItemButtonNameFrameVertexColor(merchantButton, 0.5, 0, 0);
					SetItemButtonSlotVertexColor(merchantButton, 0.5, 0, 0);
					SetItemButtonTextureVertexColor(itemButton, 0.5, 0, 0);
					SetItemButtonNormalTextureVertexColor(itemButton, 0.5, 0, 0);
				else
					SetItemButtonNameFrameVertexColor(merchantButton, 0.5, 0.5, 0.5);
					SetItemButtonSlotVertexColor(merchantButton, 0.5, 0.5, 0.5);
					SetItemButtonTextureVertexColor(itemButton, 0.5, 0.5, 0.5);
					SetItemButtonNormalTextureVertexColor(itemButton,0.5, 0.5, 0.5);
				end

			elseif ( not isUsable ) then
				SetItemButtonNameFrameVertexColor(merchantButton, 1.0, 0, 0);
				SetItemButtonSlotVertexColor(merchantButton, 1.0, 0, 0);
				SetItemButtonTextureVertexColor(itemButton, 0.9, 0, 0);
				SetItemButtonNormalTextureVertexColor(itemButton, 0.9, 0, 0);
			else
				SetItemButtonNameFrameVertexColor(merchantButton, 0.5, 0.5, 0.5);
				SetItemButtonSlotVertexColor(merchantButton, 1.0, 1.0, 1.0);
				SetItemButtonTextureVertexColor(itemButton, 1.0, 1.0, 1.0);
				SetItemButtonNormalTextureVertexColor(itemButton, 1.0, 1.0, 1.0);
			end
		else
			itemButton.price = nil;
			itemButton.hasItem = nil;
			itemButton:Hide();
			SetItemButtonNameFrameVertexColor(merchantButton, 0.5, 0.5, 0.5);
			SetItemButtonSlotVertexColor(merchantButton,0.4, 0.4, 0.4);
			_G["MerchantItem"..i.."Name"]:SetText("");
			_G["MerchantItem"..i.."MoneyFrame"]:Hide();
			_G["MerchantItem"..i.."AltCurrencyFrame"]:Hide();
		end
	end

	-- Handle repair items
	MerchantFrame_UpdateRepairButtons();

	-- Handle vendor buy back item
	local buybackName, buybackTexture, buybackPrice, buybackQuantity, buybackNumAvailable, buybackIsUsable = GetBuybackItemInfo(GetNumBuybackItems());
	if ( buybackName ) then
		MerchantBuyBackItemName:SetText(buybackName);
		SetItemButtonCount(MerchantBuyBackItemItemButton, buybackQuantity);
		SetItemButtonStock(MerchantBuyBackItemItemButton, buybackNumAvailable);
		SetItemButtonTexture(MerchantBuyBackItemItemButton, buybackTexture);
		MerchantBuyBackItemMoneyFrame:Show();
		MoneyFrame_Update("MerchantBuyBackItemMoneyFrame", buybackPrice);
		MerchantBuyBackItem:Show();

	else
		MerchantBuyBackItemName:SetText("");
		MerchantBuyBackItemMoneyFrame:Hide();
		SetItemButtonTexture(MerchantBuyBackItemItemButton, "");
		SetItemButtonCount(MerchantBuyBackItemItemButton, 0);
		-- Hide the tooltip upon sale
		if ( GameTooltip:IsOwned(MerchantBuyBackItemItemButton) ) then
			GameTooltip:Hide();
		end
	end

	-- Handle paging buttons
	if ( numMerchantItems > MERCHANT_ITEMS_PER_PAGE ) then
		if ( MerchantFrame.page == 1 ) then
			MerchantPrevPageButton:Disable();
		else
			MerchantPrevPageButton:Enable();
		end
		if ( MerchantFrame.page == ceil(numMerchantItems / MERCHANT_ITEMS_PER_PAGE) or numMerchantItems == 0) then
			MerchantNextPageButton:Disable();
		else
			MerchantNextPageButton:Enable();
		end
		MerchantPageText:Show();
		MerchantPrevPageButton:Show();
		MerchantNextPageButton:Show();
	else
		MerchantPageText:Hide();
		MerchantPrevPageButton:Hide();
		MerchantNextPageButton:Hide();
	end

	-- Show all merchant related items
	MerchantBuyBackItem:Show();
	MerchantFrameBottomLeftBorder:Show();
	MerchantFrameBottomRightBorder:Show();

	-- Hide buyback related items
	MerchantItem11:Hide();
	MerchantItem12:Hide();
	BuybackBG:Hide();

	-- Position merchant items
	MerchantItem3:SetPoint("TOPLEFT", "MerchantItem1", "BOTTOMLEFT", 0, -8);
	MerchantItem5:SetPoint("TOPLEFT", "MerchantItem3", "BOTTOMLEFT", 0, -8);
	MerchantItem7:SetPoint("TOPLEFT", "MerchantItem5", "BOTTOMLEFT", 0, -8);
	MerchantItem9:SetPoint("TOPLEFT", "MerchantItem7", "BOTTOMLEFT", 0, -8);
end

function MerchantFrame_UpdateAltCurrency(index, i)
	local itemTexture, itemValue, button;
	local honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index);
	local frameName = "MerchantItem"..i.."AltCurrencyFrame";
	local frameAnchor = AltCurrencyFrame_PointsUpdate( frameName, honorPoints, arenaPoints );

	-- update Alt Currency Frame with itemValues
	if ( itemCount > 0 ) then
		for i=1, MAX_ITEM_COST, 1 do
			button = _G[frameName.."Item"..i];
			button.index = index;
			button.item = i;

			itemTexture, itemValue, button.itemLink = GetMerchantItemCostItem(index, i);

			AltCurrencyFrame_Update(frameName.."Item"..i, itemTexture, itemValue);
			-- Anchor items based on how many item costs there are.

			if ( i > 1 ) then
				button:SetPoint("LEFT", frameName.."Item"..i-1, "RIGHT", 4, 0);
			elseif ( i == 1 and ( arenaPoints == 0 and honorPoints == 0 ) ) then
				button:SetPoint("LEFT", frameAnchor, "LEFT", 0, 0);
			else
				button:SetPoint("LEFT", frameAnchor, "RIGHT", 4, 0);
			end
			if ( not itemTexture ) then
				button:Hide();
			else
				button:Show();
			end
		end
	else
		for i=1, MAX_ITEM_COST, 1 do
			_G[frameName.."Item"..i]:Hide();
		end
	end
end

function MerchantFrame_UpdateBuybackInfo()
	MerchantNameText:SetText(MERCHANT_BUYBACK);
	MerchantFramePortrait:SetTexture("Interface\\MerchantFrame\\UI-BuyBack-Icon");

	-- Show Buyback specific items
	MerchantItem11:Show();
	MerchantItem12:Show();
	-- BuybackFrameTopLeft:Show();
	-- BuybackFrameTopRight:Show();
	-- BuybackFrameBotLeft:Show();
	-- BuybackFrameBotRight:Show();

	-- Position buyback items
	MerchantItem3:SetPoint("TOPLEFT", "MerchantItem1", "BOTTOMLEFT", 0, -15);
	MerchantItem5:SetPoint("TOPLEFT", "MerchantItem3", "BOTTOMLEFT", 0, -15);
	MerchantItem7:SetPoint("TOPLEFT", "MerchantItem5", "BOTTOMLEFT", 0, -15);
	MerchantItem9:SetPoint("TOPLEFT", "MerchantItem7", "BOTTOMLEFT", 0, -15);

	local numBuybackItems = GetNumBuybackItems();
	local itemButton, buybackButton;
	local buybackName, buybackTexture, buybackPrice, buybackQuantity, buybackNumAvailable, buybackIsUsable;
	for i=1, BUYBACK_ITEMS_PER_PAGE do
		itemButton = _G["MerchantItem"..i.."ItemButton"];
		buybackButton = _G["MerchantItem"..i];
		_G["MerchantItem"..i.."AltCurrencyFrame"]:Hide();
		if ( i <= numBuybackItems ) then
			buybackName, buybackTexture, buybackPrice, buybackQuantity, buybackNumAvailable, buybackIsUsable = GetBuybackItemInfo(i);
			_G["MerchantItem"..i.."Name"]:SetText(buybackName);
			SetItemButtonCount(itemButton, buybackQuantity);
			SetItemButtonStock(itemButton, buybackNumAvailable);
			SetItemButtonTexture(itemButton, buybackTexture);
			_G["MerchantItem"..i.."MoneyFrame"]:Show();
			MoneyFrame_Update("MerchantItem"..i.."MoneyFrame", buybackPrice);
			itemButton:SetID(i);
			itemButton:Show();
			if ( not buybackIsUsable ) then
				SetItemButtonNameFrameVertexColor(buybackButton, 1.0, 0, 0);
				SetItemButtonSlotVertexColor(buybackButton, 1.0, 0, 0);
				SetItemButtonTextureVertexColor(itemButton, 0.9, 0, 0);
				SetItemButtonNormalTextureVertexColor(itemButton, 0.9, 0, 0);
			else
				SetItemButtonNameFrameVertexColor(buybackButton, 0.5, 0.5, 0.5);
				SetItemButtonSlotVertexColor(buybackButton, 1.0, 1.0, 1.0);
				SetItemButtonTextureVertexColor(itemButton, 1.0, 1.0, 1.0);
				SetItemButtonNormalTextureVertexColor(itemButton, 1.0, 1.0, 1.0);
			end
		else
			SetItemButtonNameFrameVertexColor(buybackButton, 0.5, 0.5, 0.5);
			SetItemButtonSlotVertexColor(buybackButton,0.4, 0.4, 0.4);
			_G["MerchantItem"..i.."Name"]:SetText("");
			_G["MerchantItem"..i.."MoneyFrame"]:Hide();
			itemButton:Hide();
		end
	end

	-- Hide all merchant related items
	MerchantRepairAllButton:Hide();
	MerchantRepairItemButton:Hide();
	MerchantBuyBackItem:Hide();
	MerchantPrevPageButton:Hide();
	MerchantNextPageButton:Hide();
	MerchantFrameBottomLeftBorder:Hide();
	MerchantFrameBottomRightBorder:Hide();
	MerchantRepairText:Hide();
	MerchantPageText:Hide();
	MerchantGuildBankRepairButton:Hide();
end

function MerchantPrevPageButton_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	MerchantFrame.page = MerchantFrame.page - 1;
	MerchantFrame_CloseStackSplitFrame();
	MerchantFrame_Update();
end

function MerchantNextPageButton_OnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	MerchantFrame.page = MerchantFrame.page + 1;
	MerchantFrame_CloseStackSplitFrame();
	MerchantFrame_Update();
end

function MerchantFrame_CloseStackSplitFrame()
	if ( StackSplitFrame:IsShown() ) then
		local numButtons = max(MERCHANT_ITEMS_PER_PAGE, BUYBACK_ITEMS_PER_PAGE);
		for i = 1, numButtons do
			if ( StackSplitFrame.owner == _G["MerchantItem"..i.."ItemButton"] ) then
				StackSplitFrameCancel_Click();
				return;
			end
		end
	end
end

function MerchantItemBuybackButton_OnLoad(self)
	self:RegisterEvent("MERCHANT_UPDATE");
	self:RegisterForClicks("LeftButtonUp","RightButtonUp");
	self:RegisterForDrag("LeftButton");

	self.SplitStack = function(button, split)
		if ( split > 0 ) then
			BuyMerchantItem(button:GetID(), split);
		end
	end
end

function MerchantItemButton_OnLoad(self)
	self:RegisterForClicks("LeftButtonUp","RightButtonUp");
	self:RegisterForDrag("LeftButton");

	self.SplitStack = function(button, split)
		if ( button.extendedCost ) then
			MerchantFrame_ConfirmExtendedItemCost(button, split)
		elseif ( split > 0 ) then
			BuyMerchantItem(button:GetID(), split);
		end
	end

	self.UpdateTooltip = MerchantItemButton_OnEnter;
end

MERCHANT_HIGH_PRICE_COST = 1500000;

function MerchantItemButton_OnClick(self, button)
	MerchantFrame.extendedCost = nil;

	if ( MerchantFrame.selectedTab == 1 ) then
		-- Is merchant frame
		if ( button == "LeftButton" ) then
			if ( MerchantFrame.refundItem ) then
				if ( ContainerFrame_GetExtendedPriceString(MerchantFrame.refundItem, MerchantFrame.refundItemEquipped)) then
					-- a confirmation dialog has been shown
					return;
				end
			end

			PickupMerchantItem(self:GetID());
			if ( self.extendedCost ) then
				MerchantFrame.extendedCost = self;
			end
		else
			if ( self.extendedCost ) then
				MerchantFrame_ConfirmExtendedItemCost(self);
			elseif ( self.price and self.price >= MERCHANT_HIGH_PRICE_COST ) then
				MerchantFrame_ConfirmHighCostItem(self);
			else
				BuyMerchantItem(self:GetID());
			end
		end
	else
		-- Is buyback item
		BuybackItem(self:GetID());
	end
end

function MerchantItemButton_OnModifiedClick(self, button)
	if ( MerchantFrame.selectedTab == 1 ) then
		-- Is merchant frame
		if ( HandleModifiedItemClick(GetMerchantItemLink(self:GetID())) ) then
			return;
		end
		if ( IsModifiedClick("SPLITSTACK") ) then
			local index = self:GetID()
			local maxStack = GetMerchantItemMaxStack(index);
			if ( self.price and (self.price > 0) ) then
				local canAfford = floor(GetMoney() / self.price);
				if ( canAfford < maxStack or maxStack == 1 ) then
					maxStack = canAfford;
				end
			end
			if self.extendedCost then
				local honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index)
				if honorPoints > 0 then
					local canAfford = math.floor((GetHonorCurrency() or 0) / honorPoints)
					if canAfford < maxStack or maxStack == 1 then
						maxStack = canAfford
					end
				end
				if arenaPoints > 0 then
					local canAfford = math.floor((GetArenaCurrency() or 0) / arenaPoints)
					if canAfford < maxStack or maxStack == 1 then
						maxStack = canAfford
					end
				end
				if itemCount > 0 then
					for i = 1, itemCount, 1 do
						local itemTexture, itemValue, itemLink = GetMerchantItemCostItem(index, i)
						local itemID = itemLink and tonumber(strmatch(itemLink, "item:(%d+)"))
						if itemValue and itemID then
							local canAfford = math.floor((GetItemCount(itemID) or 0) / itemValue)
							if canAfford < maxStack or maxStack == 1 then
								maxStack = canAfford
							end
						end
					end
				end
			end
			if maxStack > 1 then
				OpenStackSplitFrame(maxStack, self, "BOTTOMLEFT", "TOPLEFT");
			end
			return;
		end
	else
		HandleModifiedItemClick(GetBuybackItemLink(self:GetID()));
	end
end

function MerchantItemButton_OnEnter(button)
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
	if ( MerchantFrame.selectedTab == 1 ) then
		GameTooltip.merchantSlotIndex = button:GetID()
		GameTooltip:SetMerchantItem(button:GetID());
		GameTooltip_ShowCompareItem(GameTooltip);
		MerchantFrame.itemHover = button:GetID();
	else
		GameTooltip:SetBuybackItem(button:GetID());
		if ( IsModifiedClick("DRESSUP") and button.hasItem ) then
			ShowInspectCursor();
		else
			ShowBuybackSellCursor(button:GetID());
		end
	end
end

LIST_DELIMITER = ", "

function MerchantFrame_ConfirmExtendedItemCost(itemButton, quantity)
	quantity = (quantity or 1);
	local index = itemButton:GetID();
	local itemTexture, itemLink, itemsString;
	local pointsTexture, button;
	local honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index);
	if ( (honorPoints == 0) and (arenaPoints == 0) and (itemCount == 0) ) then
		BuyMerchantItem( itemButton:GetID(), quantity );
		return;
	end

	local count = itemButton.count or 1;
	honorPoints, arenaPoints, itemCount = (honorPoints or 0) * quantity, (arenaPoints or 0) * quantity, (itemCount or 0) * quantity;

	if ( honorPoints and honorPoints ~= 0 ) then
		local factionGroup = UnitFactionGroup("player");
		if ( factionGroup ) then
			pointsTexture = "Interface\\PVPFrame\\PVPCurrency-Honor1-"..factionGroup;
			itemsString = " |T" .. pointsTexture .. ":0:0:0:-1|t" .. format(MERCHANT_HONOR_POINTS, honorPoints);
		end
	end
	if ( arenaPoints and arenaPoints ~= 0 ) then
		local englishFaction = UnitFactionGroup("player")
		if ( itemsString ) then
			-- adding an extra space here because it looks nicer
			itemsString = itemsString .. "  |TInterface\\PVPFrame\\PVPCurrency-Conquest1-"..englishFaction..":0:0:0:-1|t" .. format(MERCHANT_ARENA_POINTS, arenaPoints);
		else
			itemsString = " |TInterface\\PVPFrame\\PVPCurrency-Conquest1-"..englishFaction..":0:0:0:-1|t" .. format(MERCHANT_ARENA_POINTS, arenaPoints);
		end
	end

	local maxQuality = 0;
	for i=1, MAX_ITEM_COST, 1 do
		itemTexture, itemCount, itemLink = GetMerchantItemCostItem(index, i);
		if ( itemLink ) then
			local _, _, itemQuality = GetItemInfo(itemLink);
			maxQuality = math.max(itemQuality, maxQuality);
			if ( itemsString ) then
				itemsString = itemsString .. LIST_DELIMITER .. format(ITEM_QUANTITY_TEMPLATE, (itemCount or 0) * quantity, itemLink);
			else
				itemsString = format(ITEM_QUANTITY_TEMPLATE, (itemCount or 0) * quantity, itemLink);
			end
		end
	end

	if ( honorPoints == 0 and arenaPoints == 0 and maxQuality <= ITEM_QUALITY_UNCOMMON ) then
		BuyMerchantItem( itemButton:GetID(), quantity );
		return;
	end

	MerchantFrame.itemIndex = index;
	MerchantFrame.count = quantity;

	if not itemButton.link then
		itemButton.link = GetMerchantItemLink(index)
	end

	if not itemButton.link then return end

	local itemName, _, itemQuality = GetItemInfo(itemButton.link)
	local r, g, b = GetItemQualityColor(itemQuality);
	local itemID = string.match(itemButton.link, "item:(%d+)")
	local itemData = {texture = itemButton.texture, name = itemName, color = {r, g, b, 1}, link = itemButton.link, index = index, count = count * quantity}

	if tonumber(itemID) == 104020 then
		StaticPopup_Show("CONFIRM_EXCHANGE_LEGENDARY_ITEM", itemsString, "", itemData);
	else
		StaticPopup_Show("CONFIRM_PURCHASE_TOKEN_ITEM", itemsString, "", itemData);
	end
end

function MerchantFrame_ResetRefundItem()
	MerchantFrame.refundItem = nil;
	MerchantFrame.refundItemEquipped = nil;
end

function MerchantFrame_SetRefundItem(item, isEquipped)
	MerchantFrame.refundItem = item;
	MerchantFrame.refundItemEquipped = isEquipped;
end

function MerchantFrame_ConfirmHighCostItem(itemButton, quantity)
	quantity = (quantity or 1);
	local index = itemButton:GetID();

	if not itemButton.price then
		itemButton.price = (select(3, GetMerchantItemInfo(index)))
	end

	if not itemButton.link then
		itemButton.link = GetMerchantItemLink(index)
	end


	MerchantFrame.itemIndex = index;
	MerchantFrame.count = quantity;
	MerchantFrame.price = itemButton.price or 0;

	StaticPopup_Show("CONFIRM_HIGH_COST_ITEM", itemButton.link);
end

function MerchantFrame_UpdateCanRepairAll()
	if ( MerchantRepairAllIcon ) then
		local repairAllCost, canRepair = GetRepairAllCost();
		if ( canRepair ) then
			SetDesaturation(MerchantRepairAllIcon, nil);
			MerchantRepairAllButton:Enable();
		else
			SetDesaturation(MerchantRepairAllIcon, 1);
			MerchantRepairAllButton:Disable();
		end
	end
end

function MerchantFrame_UpdateGuildBankRepair()
	local repairAllCost, canRepair = GetRepairAllCost();
	if ( canRepair ) then
		SetDesaturation(MerchantGuildBankRepairButtonIcon, nil);
		MerchantGuildBankRepairButton:Enable();
	else
		SetDesaturation(MerchantGuildBankRepairButtonIcon, 1);
		MerchantGuildBankRepairButton:Disable();
	end
end

function MerchantFrame_UpdateRepairButtons()
	if ( CanMerchantRepair() ) then
		--See if can guildbank repair
		if ( CanGuildBankRepair() ) then
			MerchantRepairAllButton:SetWidth(32);
			MerchantRepairAllButton:SetHeight(32);
			MerchantRepairItemButton:SetWidth(32);
			MerchantRepairItemButton:SetHeight(32);
			MerchantRepairItemButton:SetPoint("RIGHT", MerchantRepairAllButton, "LEFT", -4, 0);

			MerchantRepairAllButton:SetPoint("BOTTOMRIGHT", MerchantFrame, "BOTTOMLEFT", 100, 30);
			MerchantRepairText:ClearAllPoints();
			MerchantRepairText:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 80, 68);
			MerchantGuildBankRepairButton:Show();
			MerchantFrame_UpdateGuildBankRepair();
		else
			MerchantRepairAllButton:SetWidth(36);
			MerchantRepairAllButton:SetHeight(36);
			MerchantRepairItemButton:SetWidth(36);
			MerchantRepairItemButton:SetHeight(36);
			MerchantRepairItemButton:SetPoint("RIGHT", MerchantRepairAllButton, "LEFT", -2, 0);

			MerchantRepairAllButton:SetPoint("BOTTOMRIGHT", MerchantFrame, "BOTTOMLEFT", 160, 32);
			MerchantRepairText:ClearAllPoints();
			MerchantRepairText:SetPoint("BOTTOMLEFT", MerchantFrame, "BOTTOMLEFT", 14, 45);
			MerchantGuildBankRepairButton:Hide();
		end
		MerchantRepairText:Show();
		MerchantRepairAllButton:Show();
		MerchantRepairItemButton:Show();
		MerchantFrame_UpdateCanRepairAll();
	else
		MerchantRepairText:Hide();
		MerchantRepairAllButton:Hide();
		MerchantRepairItemButton:Hide();
		MerchantGuildBankRepairButton:Hide();
	end
end

function MerchantFrame_OnMouseWheel(self, delta)
	if delta > 0 then
		if MerchantPrevPageButton:IsShown() and MerchantPrevPageButton:IsEnabled() == 1 then
			MerchantPrevPageButton_OnClick()
		end
	else
		if MerchantNextPageButton:IsShown() and MerchantNextPageButton:IsEnabled() == 1 then
			MerchantNextPageButton_OnClick()
		end
	end
end