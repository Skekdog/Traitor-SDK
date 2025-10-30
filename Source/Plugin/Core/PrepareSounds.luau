
local function PrepareSounds(of: Instance): ()
	for _, sound in of:GetDescendants() do
		if sound:IsA("Sound") and sound.SoundId ~= "" then
			sound:SetAttribute("RobloxAvoidSoundId", sound.SoundId)
			sound.SoundId = ""
		end
	end
end

return PrepareSounds