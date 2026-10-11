-- find altar

-- player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- functions
local function FindChildWithAttr(parent, attr, expected)
	for _, item in parent:GetChildren() do
		local attribute = item:GetAttribute(attr)
		if attribute == nil then continue end
		if tostring(attribute) ~= tostring(expected) then continue end
		print("hi")
		return item
	end
	return
end

local function Teleport(destination, offset)
	local cframe = destination.CFrame + (offset or Vector3.new(0, 5, 0))
	Character:PivotTo(cframe)
end

local function LookAt(target)
	local rootpos = RootPart.Position
	local targetpos = target.Position
	local finalpos = Vector3.new(targetpos.X, rootpos.Y, targetpos.Z)

	RootPart.CFrame = CFrame.lookAt(rootpos, finalpos)
end

local function EquipGear(gear)
	local backpack = LocalPlayer.Backpack
	local backgear
	if not Character:FindFirstChild(gear) then
		backgear = backpack:WaitForChild(gear, 1)
		if not backgear then continue end
		backgear.Parent = Character
	else
		Character:FindFirstChild(gear).Parent = Character
	end
end

local function IsOwned(gear)
	return not not Character:FindFirstChild(gear) or LocalPlayer.Backpack:FindFirstChild(gear)
end

local function IsEquipped(gear)
	return not not Character:FindFirstChild(gear)
end

-- definitions
local objects = workspace.Map.Objects

local Altar = objects:FindFirstChild("Altar"):FindFirstChild("Root")
if not Altar then
	print("no altar.")
	return
end
local AngelModel = FindChildWithAttr(objects, "which", "AngelStatue")
if not AngelModel then
	print("no angel.")
	return
end
local AngelRoot = AngelModel:FindFirstChild("RootPart")
local AngelPrompt = AngelRoot:FindFirstChild("ProximityPrompt")

local Events = require(ReplicatedStorage.Communication.EventHandler)

if not IsOwned("AngelStatue") then
	Teleport(LocalPlayer, AngelRoot)
	task.wait(0.25)
	AngelPrompt:InputHoldBegin()
	task.wait(0.05)
	AngelPrompt:InputHoldEnd()
	task.wait(0.05)
end

if not IsEquipped("AngelStatue") then
	EquipGear("AngelStatue")
end

Teleport(LocalPlayer, Altar, Vector3.new(10, 0, 0))
LookAt(Altar)
