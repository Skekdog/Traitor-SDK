local Navigation = require("@self/Navigation")
local GetPlugin = require("../Lib/GetPlugin")
local Frame = require("../Lib/UI/Components/Frame")

local Widget = {}

local widget = GetPlugin:CreateDockWidgetPluginGui("TraitorSDK", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	600,
	400,
	600,
	400
	)
)

widget.Name = "Traitor! SDK"
widget.Title = "Traitor! SDK"
widget.ResetOnSpawn = false
widget.Enabled = false

local frame = Frame({
	Parent = widget,
	IsContainer = true,

	Padding = {
		Left = 5,
		Right = 5,
		Top = 5,
		Bottom = 5,
	},
})

local pages = Frame({
	Name = "Pages",
	Parent = frame,
	LayoutOrder = 2,

	Padding = {
		Top = 5,
	},

	IsContainer = true,
})

Navigation.NavBar.Parent = frame

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = frame
end

function Widget.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

Widget.Widget = widget
Widget.Frame = frame
Widget.Pages = pages

return Widget