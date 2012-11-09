-- Aura plugin
local ADDON_NAME, Engine = ...
if not Engine.Enabled then return end
local UI = Engine.UI

-- ONLY ON PTR
--if not Engine.IsPTR() then return end

local ToClock = Engine.ToClock
local CheckSpec = Engine.CheckSpec

--
local plugin = Engine:NewPlugin("AURABAR")

-- own methods
function plugin:Update(elapsed)
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
	if self.timeSinceLastUpdate > 0.2 then
		if self.settings.duration == true then
			local timeLeft = self.expirationTime - GetTime()
			if timeLeft > 0 then
				self.bar.durationText:SetText(ToClock(timeLeft))
			else
				self.bar.durationText:SetText("")
			end
		end
	end
end

function plugin:UpdateVisibilityAndValue(event)
--print("AURABAR:UpdateVisibilityAndValue")
	local inCombat = true
	if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
		inCombat = true
	else
		inCombat = false
	end
	local visible = false
	if (self.settings.autohide == false or inCombat) and CheckSpec(self.settings.specs) then
		local name, _, _, stack, _, _, expirationTime, unitCaster = UnitAura(self.settings.unit, self.auraName, nil, self.settings.filter)
		if name == self.auraName and unitCaster == "player" and stack > 0 then
			self.bar.status:SetValue(stack)
			if self.settings.text == true then
				self.bar.valueText:SetText(tostring(stack).."/"..tostring(self.settings.count))
			end
			self.expirationTime = expirationTime -- save to use in Update
			visible = true
		end
	end
	if visible then
		self.bar:Show()
		self.timeSinceLastUpdate = GetTime()
		self:RegisterUpdate(plugin.Update)
	else
		self.bar:Hide()
		self:UnregisterUpdate()
	end
end

function plugin:UpdateGraphics()
	--
	local bar = self.bar
	if not bar then
		bar = CreateFrame("Frame", self.name, UI.PetBattleHider)
		bar:SetTemplate()
		bar:SetFrameStrata("BACKGROUND")
		bar:Hide()
		self.bar = bar
	end
	bar:ClearAllPoints()
	bar:Point(unpack(self.settings.anchor))
	bar:Size(self.settings.width, self.settings.height)
	--
	if not bar.status then
		bar.status = CreateFrame("StatusBar", nil, bar)
		bar.status:SetStatusBarTexture(UI.NormTex)
		bar.status:SetFrameLevel(6)
		bar.status:Point("TOPLEFT", bar, "TOPLEFT", 2, -2)
		bar.status:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
	end
	bar.status:SetStatusBarColor(unpack(self.settings.color))
	bar.status:SetMinMaxValues(0, self.settings.count)
	--
	if self.settings.text == true and not bar.valueText then
		bar.valueText = UI.SetFontString(bar.status, 12)
		bar.valueText:Point("CENTER", bar.status)
	end
	if bar.valueText then bar.valueText:SetText("") end
	--
	if self.settings.duration == true and not bar.durationText then
		bar.durationText = UI.SetFontString(bar.status, 12)
		bar.durationText:Point("RIGHT", bar.status)
	end
	if bar.durationText then bar.durationText:SetText("") end
end

-- overridden methods
function plugin:Initialize()
	--
	self.auraName = GetSpellInfo(self.settings.spellID)
	--
	self:UpdateGraphics()
end

function plugin:Enable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", plugin.UpdateVisibilityAndValue)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", plugin.UpdateVisibilityAndValue)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", plugin.UpdateVisibilityAndValue)
	if self.settings.unit == "focus" then self:RegisterEvent("PLAYER_FOCUS_CHANGED", plugin.UpdateVisibilityAndValue) end
	if self.settings.unit == "target" then self:RegisterEvent("PLAYER_TARGET_CHANGED", plugin.UpdateVisibilityAndValue) end
	if self.settings.unit == "pet" then self:RegisterUnitEvent("UNIT_PET", "player", plugin.UpdateVisibilityAndValue) end
	self:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player", plugin.UpdateVisibilityAndValue)
	self:RegisterUnitEvent("UNIT_AURA", self.settings.unit, plugin.UpdateVisibilityAndValue)
end

function plugin:Disable()
	self:UnregisterAllEvents()
	self:UnregisterUpdate()

	self.bar:Hide()
end

function plugin:SettingsModified()
	--
	self:Disable()
	--
	self.auraName = GetSpellInfo(self.settings.spellID)
	--
	self:UpdateGraphics()
	--
	if self.settings.enable == true then
		self:Enable()
		self:UpdateVisibilityAndValue()
	end
end

-- ----------------------------------------------
-- -- test
-- ----------------------------------------------
-- local C = Engine.Config
-- local settings = C[UI.MyClass]
-- if not settings then return end
-- for i, pluginSettings in ipairs(settings) do
	-- if pluginSettings.kind == "AURABAR" then
		-- local setting = Engine.DeepCopy(pluginSettings)
		-- setting.anchor = {"CENTER", UIParent, "CENTER", 0, i*30}
		-- setting.specs = {"any"}
		-- setting.enable = true
		-- setting.autohide = false
		-- setting.unit = setting.unit or "player"
		-- setting.text = true
		-- setting.duration = true
		-- setting.filter = setting.filter or "HELPFUL"
		-- local instance = Engine:NewPluginInstance("AURABAR", "AURABAR"..tostring(i), setting)
		-- instance:Initialize()
		-- if setting.enable then
			-- instance:Enable()
		-- end
	-- end
-- end