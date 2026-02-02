
local function SmuggleScripts(of: Instance): ()
	for _, instance in of:QueryDescendants("LuaSourceContainer") do
		assert(instance:IsA("LocalScript") or instance:IsA("Script") or instance:IsA("ModuleScript"))

		local smuggled = Instance.new("Configuration")
		smuggled.Name = instance.Name

		for k, v in instance:GetAttributes() do
			smuggled:SetAttribute(k, v)
		end

		for _, tag in instance:GetTags() do
			smuggled:AddTag(tag)
		end

		smuggled:AddTag("Smuggled-Script")
		smuggled:SetAttribute("Smuggled-Source", instance.Source)
		smuggled:SetAttribute("Smuggled-Class", instance.ClassName)

		if instance:IsA("BaseScript") then
			smuggled:SetAttribute("Smuggled-RunContext", instance.RunContext)
			smuggled:SetAttribute("Smuggled-Enabled", instance.Enabled)
		end

		smuggled.Parent = instance.Parent
		instance.Parent = nil
	end
end

return SmuggleScripts