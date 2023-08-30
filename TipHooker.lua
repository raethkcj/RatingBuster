local _, addon = ...

local handler
local enabled = false

local OnTooltipSetItem = function(tooltip)
	if not tooltip.GetItem then return end
	local name, link = tooltip:GetItem()
	if not name then return end

	if enabled then
		handler(tooltip, name, link)
	end
end

local TooltipList = {
	"GameTooltip",
	"ItemRefTooltip",
	"ShoppingTooltip",
	"LinkWrangler",
	"AtlasLootTooltip",
}

local initialized = false
local function InitializeHook()
	local frame = EnumerateFrames()
	while frame do
	    if frame.GetObjectType and frame:GetObjectType() == "GameTooltip" then
	        local name = frame:GetName()
	        if name then
		        for _, v in ipairs(TooltipList) do
		        	if strfind(name, v) then
						frame:HookScript("OnTooltipSetItem", OnTooltipSetItem)
						break
					end
		        end
		    end
	    end
	    frame = EnumerateFrames(frame)
	end
	initialized = true
end

local variablesLoaded = false
EventRegistry:RegisterFrameEventAndCallbackWithHandle("VARIABLES_LOADED", function()
	variablesLoaded = true
	if handler and not initialized then
		InitializeHook()
	end
end)

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