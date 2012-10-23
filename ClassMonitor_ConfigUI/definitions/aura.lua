local ADDON_NAME, Engine = ...

local L = Engine.Locales
local D = Engine.Definitions

D["AURA"] = {
	[1] = D.Helpers.Name,
	[2] = D.Helpers.Kind,
	[3] = D.Helpers.Enable,
	[4] = D.Helpers.Anchor,
	[5] = D.Helpers.Autohide,
	[6] = D.Helpers.Width,
	[7] = D.Helpers.Height,
	[8] = D.Helpers.Specs,
	[9] = D.Helpers.Unit,
	[10] = D.Helpers.SpellID,
	[11] = D.Helpers.SpellIcon,
	[12] = {
		key = "filter",
		name = "Filter",
		desc = "Helpful or harmful",
		type = "select",
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
		values = {
			["HELPFUL"] = "Helpful",
			["HARMFUL"] = "Harmful",
		},
	},
	[13] = {
		key = "count",
		name = "Count",
		desc = "Maximum stack count",
		type = "range",
		min = 1, max = 20, step = 1,
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
	},
	[14] = {
		key = "filled",
		name = "Filled",
		desc = "Stack filled or not",
		type = "toggle",
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
	},
	-- TODO: colors
}