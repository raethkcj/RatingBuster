local L, StatLogic = {}, {}
L["mana regen %s per %s sec"] = {StatLogic.Stats.ManaRegen, false, }
L["%s health and mana every %s sec"] = {{StatLogic.Stats.HealthRegen, StatLogic.Stats.ManaRegen, }, false, }
L["alle %s sek. %s mana"] = {false, StatLogic.Stats.ManaRegen, }
