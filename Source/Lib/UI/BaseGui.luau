local Style = require("./Style")

export type Padding = {
	Left: UDim | number?,
	Right: UDim | number?,
	Top: UDim | number?,
	Bottom: UDim | number?,
}

export type SizeConstraints = {
	Min: Vector2?,
	Max: Vector2?,
}

export type AspectRatio = {
	Ratio: number,
	Type: Enum.AspectType?,
	Axis: Enum.DominantAxis?,
}

export type BaseGuiParams = {
	Name: string?,
	Parent: Instance | false,

	Transparency: number?,
	ZIndex: number?,
	Visible: boolean?,

	Position: UDim2?,
	AnchorPoint: Vector2?,
	LayoutOrder: number?,

	ClipsDescendants: boolean?,

	Size: UDim2?,
	AutomaticSize: Enum.AutomaticSize?,

	IsContainer: boolean?,
	CornerRadius: UDim | false?,
	NoStroke: boolean?,
	Padding: Padding?,

	SizeConstraints: SizeConstraints?,
	AspectRatio: AspectRatio?,

	Style: Style.Style | false?,
	[any]: never,
}

local function BaseGui<T>(gui: T & GuiObject, params: BaseGuiParams): T
	if params.IsContainer then
		params.Transparency = 1
		params.NoStroke = true
		params.CornerRadius = false
	end

	gui.Name = params.Name or gui.ClassName

	gui.BackgroundTransparency = params.Transparency or 0
	gui.ZIndex = params.ZIndex or 0

	gui.Visible = if typeof(params.Visible) == "boolean" then params.Visible else true

	gui.Position = params.Position or UDim2.new(0, 0, 0, 0)
	gui.AnchorPoint = params.AnchorPoint or Vector2.new(0, 0)
	gui.LayoutOrder = params.LayoutOrder or 0

	gui.ClipsDescendants = if typeof(params.ClipsDescendants) == "boolean" then params.ClipsDescendants else true

	if not params.Size then
		if params.AutomaticSize == Enum.AutomaticSize.Y then
			gui.Size = UDim2.fromScale(1, 0)
		elseif params.AutomaticSize == Enum.AutomaticSize.X then
			gui.Size = UDim2.fromScale(0, 1)
		elseif params.AutomaticSize == Enum.AutomaticSize.XY then
			gui.Size = UDim2.fromScale(0, 0)
		else
			gui.Size = UDim2.fromScale(1, 1)
		end
	else
		gui.Size = params.Size
	end

	gui.AutomaticSize = params.AutomaticSize or Enum.AutomaticSize.None

	if params.CornerRadius ~= false then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = params.CornerRadius or UDim.new(0, 8)
		corner.Parent = gui
	end

	if not params.NoStroke then
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 2
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = gui

		if params.Style ~= false then
			Style(stroke)
		end
	end

	if params.Padding then
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = if typeof(params.Padding.Left) == "number" then UDim.new(0, params.Padding.Left) else params.Padding.Left or UDim.new(0, 0)
		padding.PaddingRight = if typeof(params.Padding.Right) == "number" then UDim.new(0, params.Padding.Right) else params.Padding.Right or UDim.new(0, 0)
		padding.PaddingTop = if typeof(params.Padding.Top) == "number" then UDim.new(0, params.Padding.Top) else params.Padding.Top or UDim.new(0, 0)
		padding.PaddingBottom = if typeof(params.Padding.Bottom) == "number" then UDim.new(0, params.Padding.Bottom) else params.Padding.Bottom or UDim.new(0, 0)
		padding.Parent = gui
	end

	if params.SizeConstraints then
		local constraints = Instance.new("UISizeConstraint")
		constraints.MinSize = params.SizeConstraints.Min or Vector2.new(0, 0)
		constraints.MaxSize = params.SizeConstraints.Max or Vector2.new(math.huge, math.huge)
		constraints.Parent = gui
	end

	if params.AspectRatio then
		local aspectRatio = Instance.new("UIAspectRatioConstraint")
		aspectRatio.AspectRatio = params.AspectRatio.Ratio
		aspectRatio.AspectType = params.AspectRatio.Type or Enum.AspectType.ScaleWithParentSize
		aspectRatio.DominantAxis = params.AspectRatio.Axis or Enum.DominantAxis.Height
		aspectRatio.Parent = gui
	end

	if params.Style ~= false then
		Style(gui, params.Style)
	end

	if params.Parent then
		gui.Parent = params.Parent
	end

	return gui
end

return BaseGui