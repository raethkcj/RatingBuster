local _, addon = ...

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

local function HandleTooltipSetItem(tooltip)
	local owner = tooltip:GetOwner()
	if (owner and owner.GetObjectType and owner:GetObjectType() == "GameTooltip") then
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
						frame:HookScript("OnTooltipSetItem", HandleTooltipSetItem)
						frame:HookScript("OnUpdate", HandleUpdate)
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