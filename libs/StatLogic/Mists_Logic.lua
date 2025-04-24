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