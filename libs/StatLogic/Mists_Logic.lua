local addonName, addon = ...
---@class StatLogic
local StatLogic = LibStub:GetLibrary(addonName)

-- Level 60 rating base
StatLogic.RatingBase = {}

StatLogic.GenericStatMap[StatLogic.Stats.HitRating] = {
	StatLogic.Stats.MeleeHitRating,
	StatLogic.Stats.RangedHitRating,
	StatLogic.Stats.SpellHitRating,
}
StatLogic.GenericStatMap[StatLogic.Stats.CritRating] = {
	StatLogic.Stats.MeleeCritRating,
	StatLogic.Stats.RangedCritRating,
	StatLogic.Stats.SpellCritRating,
}
StatLogic.GenericStatMap[StatLogic.Stats.HasteRating] = {
	StatLogic.Stats.MeleeHasteRating,
	StatLogic.Stats.RangedHasteRating,
	StatLogic.Stats.SpellHasteRating,
}

local NormalManaRegenPerSpi = function(level)
	return 0
end

local NormalManaRegenPerInt = function(level)
	return 0
end

-- Extracted from gtChanceToMeleeCrit.db2 or from gametables/chancetomeleecrit.txt via wow.tools or wago.tools
addon.CritPerAgi = {
	["WARRIOR"] = {
	},
	["PALADIN"] = {
	},
	["HUNTER"] = {
	},
	["ROGUE"] = {
	},
	["PRIEST"] = {
	},
	["DEATHKNIGHT"] = {
	},
	["SHAMAN"] = {
	},
	["MAGE"] = {
	},
	["WARLOCK"] = {
	},
	["DRUID"] = {
	},
}

-- Extracted from gtChanceToSpellCrit.db2 or from gametables/chancetospellcrit.txt via wow.tools or wago.tools
addon.SpellCritPerInt = {
	["WARRIOR"] = addon.zero,
	["PALADIN"] = {
	},
	["HUNTER"] = {
	},
	["ROGUE"] = addon.zero,
	["PRIEST"] = {
	},
	["DEATHKNIGHT"] = addon.zero,
	["SHAMAN"] = {
	},
	["MAGE"] = {
	},
	["WARLOCK"] = {
	},
	["DRUID"] = {
	},
}

addon.DodgePerAgi = {
	["WARRIOR"] = addon.zero,
	["PALADIN"] = addon.zero,
	["HUNTER"] = {
	},
	["ROGUE"] = {
	},
	["PRIEST"] = {
	},
	["DEATHKNIGHT"] = addon.zero,
	["SHAMAN"] = {
	},
	["MAGE"] = {
	},
	["WARLOCK"] = {
	},
	["DRUID"] = {
	},
}

addon.bonusArmorInventoryTypes = {
	["INVTYPE_WEAPON"] = true,
	["INVTYPE_2HWEAPON"] = true,
	["INVTYPE_WEAPONMAINHAND"] = true,
	["INVTYPE_WEAPONOFFHAND"] = true,
	["INVTYPE_HOLDABLE"] = true,
	["INVTYPE_RANGED"] = true,
	["INVTYPE_THROWN"] = true,
	["INVTYPE_RANGEDRIGHT"] = true,
	["INVTYPE_NECK"] = true,
	["INVTYPE_FINGER"] = true,
	["INVTYPE_TRINKET"] = true,
}

addon.baseArmorTable = {}

StatLogic.StatModTable = {}
if addon.class == "DRUID" then
	StatLogic.StatModTable["DRUID"] = {
	}
elseif addon.class == "DEATHKNIGHT" then
	StatLogic.StatModTable["DEATHKNIGHT"] = {
	}
elseif addon.class == "HUNTER" then
	StatLogic.StatModTable["HUNTER"] = {
	}
elseif addon.class == "MAGE" then
	StatLogic.StatModTable["MAGE"] = {
	}
elseif addon.class == "PALADIN" then
	StatLogic.StatModTable["PALADIN"] = {
	}
elseif addon.class == "PRIEST" then
	StatLogic.StatModTable["PRIEST"] = {
	}
elseif addon.class == "ROGUE" then
	StatLogic.StatModTable["ROGUE"] = {
	}
elseif addon.class == "SHAMAN" then
	StatLogic.StatModTable["SHAMAN"] = {
	}
elseif addon.class == "WARLOCK" then
	StatLogic.StatModTable["WARLOCK"] = {
	}
elseif addon.class == "WARRIOR" then
	StatLogic.StatModTable["WARRIOR"] = {
	}
end

if addon.playerRace == "Dwarf" then
	StatLogic.StatModTable["Dwarf"] = {
	}
elseif addon.playerRace == "Gnome" then
	StatLogic.StatModTable["Gnome"] = {
	}
elseif addon.playerRace == "Human" then
	StatLogic.StatModTable["Human"] = {
	}
elseif addon.playerRace == "Orc" then
	StatLogic.StatModTable["Orc"] = {
	}
elseif addon.playerRace == "Troll" then
	StatLogic.StatModTable["Troll"] = {
	}
end

StatLogic.StatModTable["ALL"] = {
}

-----------------------------------
-- Avoidance diminishing returns --
-----------------------------------
-- TODO: These are still Cata values
addon.K = {
	["WARRIOR"]     = 0.956,
	["PALADIN"]     = 0.956,
	["HUNTER"]      = 0.988,
	["ROGUE"]       = 0.988,
	["PRIEST"]      = 0.983,
	["DEATHKNIGHT"] = 0.956,
	["SHAMAN"]      = 0.988,
	["MAGE"]        = 0.983,
	["WARLOCK"]     = 0.983,
	["DRUID"]       = 0.972,
}
addon.C_p = {
	["WARRIOR"]     = 1/0.0152366,
	["PALADIN"]     = 1/0.0152366,
	["HUNTER"]      = 1/0.006870,
	["ROGUE"]       = 1/0.006870,
	["PRIEST"]      = 1/0.0152366,
	["DEATHKNIGHT"] = 1/0.0152366,
	["SHAMAN"]      = 1/0.006870,
	["MAGE"]        = 1/0.0152366,
	["WARLOCK"]     = 1/0.0152366,
	["DRUID"]       = 1/0.0152366,
}
addon.C_d = {
	["WARRIOR"]     = 1/0.0152366,
	["PALADIN"]     = 1/0.0152366,
	["HUNTER"]      = 1/0.006870,
	["ROGUE"]       = 1/0.006870,
	["PRIEST"]      = 1/0.006650,
	["DEATHKNIGHT"] = 1/0.0152366,
	["SHAMAN"]      = 1/0.006870,
	["MAGE"]        = 1/0.006650,
	["WARLOCK"]     = 1/0.006650,
	["DRUID"]       = 1/0.008555,
}

addon.C_m = setmetatable({}, { __index = function()
	return 16
end})

addon.ModAgiClasses = {
	["DRUID"] = true,
	["HUNTER"] = true,
	["ROGUE"] = true,
	["SHAMAN"] = true,
}