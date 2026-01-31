
local function NilClearChildren(instance: Instance): ()
	for _, child in instance:GetChildren() do
		child.Parent = nil
	end
end

return NilClearChildren