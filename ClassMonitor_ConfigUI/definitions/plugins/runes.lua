local ADDON_NAME, Engine = ...

local L = Engine.Locales
local D = Engine.Definitions

local orientationValues = {
	["HORIZONTAL"] = "Horizontal",
	["VERTICAL"] = "Vertical",
}
local function GetOrientationValues()
	return orientationValues
end

local colors = D.Helpers.CreateColorsDefinition("colors", 4, {L.RunesBlood, L.RunesUnholy, L.RunesFrost, L.RunesDeath} )

local options = {
	[1] = D.Helpers.Name,
	[2] = D.Helpers.DisplayName,
	[3] = D.Helpers.Kind,
	[4] = D.Helpers.Enable,
	[5] = D.Helpers.Autohide,
	[6] = D.Helpers.WidthAndHeight,
	[7] = {
		key = "updatethreshold",
		name = L.Threshold,
		desc = L.RunesThresholdDesc,
		type = "range",
		min = 0.1, max = 1, step = 0.1,
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
		disabled = D.Helpers.IsPluginDisabled
	},
	[8] = {
		key = "orientation",
		name = L.RunesOrientation,
		desc = L.RunesOrientationDesc,
		type = "select",
		values = GetOrientationValues,
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
		disabled = D.Helpers.IsPluginDisabled
	},
	-- TODO: runemap
	[10] = colors,
	[11] = D.Helpers.Anchor,
	[12] = D.Helpers.AutoGridAnchor,
}

D.Helpers:NewPluginDefinition("RUNES", options, L.PluginShortDescription_RUNES, L.PluginDescription_RUNES)