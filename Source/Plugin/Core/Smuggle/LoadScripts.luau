
local function load(smuggled: Instance): Instance
	smuggled:RemoveTag("Smuggled-Script")

	local class = smuggled:GetAttribute("Smuggled-Class")
	assert(typeof(class) == "string", "Invalid Smuggled-Class")
	smuggled:SetAttribute("Smuggled-Class", nil)

	local source = smuggled:GetAttribute("Smuggled-Source")
	assert(typeof(source) == "string", "Invalid Smuggled-Source")
	smuggled:SetAttribute("Smuggled-Source", nil)

	local instance = Instance.new(class)
	assert(instance:IsA("ModuleScript") or instance:IsA("LocalScript") or instance:IsA("Script"), "Invalid Smuggled-Class")

	instance.Name = smuggled.Name
	instance.Source = source

	if instance:IsA("Script") then
		local runContext = smuggled:GetAttribute("Smuggled-RunContext")
		assert(typeof(runContext) == "EnumItem" and runContext.EnumType == Enum.RunContext, "Invalid Smuggled-RunContext")
		smuggled:SetAttribute("Smuggled-RunContext", nil)

		instance.RunContext = runContext :: Enum.RunContext
	end

	if instance:IsA("BaseScript") then
		local enabled = smuggled:GetAttribute("Smuggled-Enabled")
		assert(typeof(enabled) == "boolean", "Invalid Smuggled-Enabled")
		smuggled:SetAttribute("Smuggled-Enabled", nil)

		instance.Enabled = enabled
	end

	for k, v in smuggled:GetAttributes() do
		instance:SetAttribute(k, v)
	end

	for _, tag in smuggled:GetTags() do
		instance:AddTag(tag)
	end

	for _, child in smuggled:GetChildren() do
		child.Parent = instance
	end

	instance.Parent = smuggled.Parent
	smuggled.Parent = nil

	return instance
end

local function LoadScripts(of: Instance): Instance
	if of:HasTag("Smuggled-Script") then
		of = load(of)
	end

	for _, smuggled in of:QueryDescendants(".Smuggled-Script") do
		load(smuggled)
	end

	return of
end

return LoadScripts