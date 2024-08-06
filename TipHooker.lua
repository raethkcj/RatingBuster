local addonName, addon = ...

local handler
local enabled = false

local RunHandler = function(tooltip)
	if enabled then
		handler(tooltip)
	end
end

local queuedTooltips = {}

local function HandleUpdate(tooltip)
	if queuedTooltips[tooltip] then
		RunHandler(tooltip)
		queuedTooltips[tooltip] = nil
	end
end

local function QueueUpdate(tooltip)
	queuedTooltips[tooltip] = true
end

local directUpdateTypes = {
	["GameTooltip"] = true,
	["CheckButton"] = true,
}

local function HandleTooltipSetItem(tooltip)
	local owner = tooltip:GetOwner()
	-- Hacky workaround for ShoppingTooltip and InspectFrame,
	-- which fire OnUpdate before OnTooltipSetItem each frame
	if (owner and owner.GetObjectType and directUpdateTypes[owner:GetObjectType()]) or debugstack():find("OnUpdate") then
		RunHandler(tooltip)
	elseif owner then
		-- OnTooltipSetItem can be fired several times per frame,
		-- So we defer the actual update until OnUpdate
		QueueUpdate(tooltip)
		if not tooltip:GetScript("OnUpdate") then
			-- Workaround for ItemRefTooltip cannibalizing its OnUpdate handler
			tooltip:SetScript("OnUpdate", function(self)
				HandleUpdate(self)
				self:SetScript("OnUpdate", nil)
			end)
		end
	end
end

local tooltips = {
	["GameTooltip"] = true,
	["ShoppingTooltip1"] = true,
	["ShoppingTooltip2"] = true,
	["ItemRefTooltip"] = true,
	["ItemRefShoppingTooltip1"] = true,
	["ItemRefShoppingTooltip2"] = true,
	["AtlasLootTooltip"] = true,
}

local staticItemSetters = {
	["SetHyperlink"] = true,
	["SetItemByID"] = true,
}

local tooltipNeedsRepaint = {}

local initialized = false
local function InitializeHook()
	for tooltipName in pairs(tooltips) do
		local tooltip = _G[tooltipName]
		if tooltip then
			tooltip:HookScript("OnTooltipSetItem", HandleTooltipSetItem)
			tooltip:HookScript("OnUpdate", HandleUpdate)

			-- Tooltips set by location (bag slot, inventory slot, etc.)
			-- are usually automatically redrawn every TOOLTIP_UPDATE_TIME.
			-- Tooltips set by link or ID are not, so we manually repaint them.
			for functionName in pairs(staticItemSetters) do
				hooksecurefunc(tooltip, functionName, function(self)
					tooltipNeedsRepaint[self] = true
				end)
				tooltip:HookScript("OnHide", function(self)
					tooltipNeedsRepaint[self] = nil
				end)
			end
		end
	end
	initialized = true
end

local variablesLoaded = false
EventRegistry:RegisterFrameEventAndCallbackWithHandle("VARIABLES_LOADED", function()
	variablesLoaded = true
	if handler and not initialized then
		InitializeHook()
	end
	if LinkWrangler then
		LinkWrangler.RegisterCallback(addonName, RunHandler, "item", "refreshcomp");
	end
end)

function addon.RepaintStaticTooltips()
	---@type GameTooltip?
	for tooltip in pairs(tooltipNeedsRepaint) do
		if tooltip and tooltip.GetItem then
			local _, itemLink = tooltip:GetItem()
			if itemLink then
				tooltip:ClearLines()
				tooltip:SetHyperlink(itemLink)
			end
		end
	end
end

function addon:EnableHook(h)
	handler = h
	if variablesLoaded and not initialized then
		InitializeHook()
	end
	enabled = true
end

function addon:DisableHook()
	enabled = false
end