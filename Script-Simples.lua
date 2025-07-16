--[[ GUI de Speed, Jump e Fly com botões, fly customizável e sem limite ]]--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI base
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedJumpFlyGUI"
ScreenGui.ResetOnSpawn = false

-- Janela principal
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 220)
Frame.Position = UDim2.new(0.5, -125, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Visible = false

-- Caixa de WalkSpeed
local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.PlaceholderText = "WalkSpeed (ex: 1000)"
SpeedBox.Size = UDim2.new(0, 230, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 10)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.TextColor3 = Color3.new(1, 1, 1)

-- Caixa de JumpPower
local JumpBox = Instance.new("TextBox", Frame)
JumpBox.PlaceholderText = "JumpPower (ex: 500)"
JumpBox.Size = UDim2.new(0, 230, 0, 30)
JumpBox.Position = UDim2.new(0, 10, 0, 50)
JumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpBox.TextColor3 = Color3.new(1, 1, 1)

-- Caixa de velocidade do fly
local FlySpeedBox = Instance.new("TextBox", Frame)
FlySpeedBox.PlaceholderText = "Fly Speed (ex: 10)"
FlySpeedBox.Size = UDim2.new(0, 230, 0, 30)
FlySpeedBox.Position = UDim2.new(0, 10, 0, 90)
FlySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlySpeedBox.TextColor3 = Color3.new(1, 1, 1)

-- Botão aplicar
local ApplyBtn = Instance.new("TextButton", Frame)
ApplyBtn.Text = "Aplicar Speed/Jump"
ApplyBtn.Size = UDim2.new(0, 230, 0, 30)
ApplyBtn.Position = UDim2.new(0, 10, 0, 130)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ApplyBtn.TextColor3 = Color3.new(1, 1, 1)

-- Botão de fly
local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Text = "Ativar Fly"
FlyBtn.Size = UDim2.new(0, 230, 0, 30)
FlyBtn.Position = UDim2.new(0, 10, 0, 170)
FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FlyBtn.TextColor3 = Color3.new(1, 1, 1)

-- Botão de abrir/fechar
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.Text = "⚙"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Active = true
ToggleBtn.Draggable = true

ToggleBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- Aplicar valores
ApplyBtn.MouseButton1Click:Connect(function()
	local speed = tonumber(SpeedBox.Text)
	local jump = tonumber(JumpBox.Text)
	if speed then humanoid.WalkSpeed = speed end
	if jump then humanoid.JumpPower = jump end
end)

-- Sistema de FLY
local flying = false
local flySpeed = 10
local BodyGyro, BodyVelocity

function startFly()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	BodyGyro = Instance.new("BodyGyro", hrp)
	BodyGyro.P = 9e4
	BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.cframe = hrp.CFrame

	BodyVelocity = Instance.new("BodyVelocity", hrp)
	BodyVelocity.Velocity = Vector3.new(0, 0, 0)
	BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	RunService.RenderStepped:Connect(function()
		if flying and hrp and BodyGyro and BodyVelocity then
			local moveVec = Vector3.new(0, 0, 0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - workspace.CurrentCamera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - workspace.CurrentCamera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + workspace.CurrentCamera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0, 1, 0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - Vector3.new(0, 1, 0) end
			BodyVelocity.Velocity = moveVec.Unit * flySpeed
			BodyGyro.CFrame = workspace.CurrentCamera.CFrame
		end
	end)
end

function stopFly()
	if BodyGyro then BodyGyro:Destroy() end
	if BodyVelocity then BodyVelocity:Destroy() end
end

FlyBtn.MouseButton1Click:Connect(function()
	local fspeed = tonumber(FlySpeedBox.Text)
	if fspeed then flySpeed = fspeed end
	flying = not flying
	FlyBtn.Text = flying and "Desativar Fly" or "Ativar Fly"
	if flying then
		startFly()
	else
		stopFly()
	end
end)
