local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50
local BodyGyro, BodyVelocity
local flyConnection
local goingUp = false
local goingDown = false

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedJumpFlyGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 260)
Frame.Position = UDim2.new(0.5, -125, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Visible = false

local function createTextBox(placeholder, posY)
    local box = Instance.new("TextBox", Frame)
    box.PlaceholderText = placeholder
    box.Size = UDim2.new(0, 230, 0, 30)
    box.Position = UDim2.new(0, 10, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.ClearTextOnFocus = false
    box.Text = ""
    box.TextScaled = true
    box.TextWrapped = true
    return box
end

local SpeedBox = createTextBox("WalkSpeed (ex: 1000)", 10)
local JumpBox = createTextBox("JumpPower (ex: 500)", 50)
local FlySpeedBox = createTextBox("Fly Speed (ex: 50)", 90)

local ApplyBtn = Instance.new("TextButton", Frame)
ApplyBtn.Text = "Aplicar Speed/Jump"
ApplyBtn.Size = UDim2.new(0, 230, 0, 30)
ApplyBtn.Position = UDim2.new(0, 10, 0, 130)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ApplyBtn.TextColor3 = Color3.new(1, 1, 1)
ApplyBtn.TextScaled = true

local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Text = "Ativar Fly"
FlyBtn.Size = UDim2.new(0, 230, 0, 30)
FlyBtn.Position = UDim2.new(0, 10, 0, 170)
FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FlyBtn.TextColor3 = Color3.new(1, 1, 1)
FlyBtn.TextScaled = true

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

local UpBtn = Instance.new("TextButton", ScreenGui)
UpBtn.Size = UDim2.new(0, 60, 0, 60)
UpBtn.Position = UDim2.new(0, 10, 1, -130)
UpBtn.Text = "↑"
UpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
UpBtn.TextColor3 = Color3.new(1, 1, 1)
UpBtn.Visible = false
UpBtn.TextScaled = true

local DownBtn = Instance.new("TextButton", ScreenGui)
DownBtn.Size = UDim2.new(0, 60, 0, 60)
DownBtn.Position = UDim2.new(0, 80, 1, -130)
DownBtn.Text = "↓"
DownBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
DownBtn.TextColor3 = Color3.new(1, 1, 1)
DownBtn.Visible = false
DownBtn.TextScaled = true

UpBtn.TouchStarted:Connect(function()
    goingUp = true
end)
UpBtn.TouchEnded:Connect(function()
    goingUp = false
end)

DownBtn.TouchStarted:Connect(function()
    goingDown = true
end)
DownBtn.TouchEnded:Connect(function()
    goingDown = false
end)

local function startFly()
    humanoid.PlatformStand = true

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = hrp.CFrame
    BodyGyro.Parent = hrp

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = hrp

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local moveVec = cam.CFrame.LookVector
        local vertical = 0
        if goingUp then vertical = 1 elseif goingDown then vertical = -1 end
        local velocity = (moveVec * flySpeed) + Vector3.new(0, vertical * flySpeed, 0)
        BodyVelocity.Velocity = velocity
        BodyGyro.CFrame = cam.CFrame
    end)
end

local function stopFly()
    humanoid.PlatformStand = false
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

ApplyBtn.MouseButton1Click:Connect(function()
    local speed = tonumber(SpeedBox.Text)
    local jump = tonumber(JumpBox.Text)
    if speed then humanoid.WalkSpeed = speed end
    if jump then humanoid.JumpPower = jump end
end)

FlyBtn.MouseButton1Click:Connect(function()
    local fspeed = tonumber(FlySpeedBox.Text)
    if fspeed and fspeed > 0 then flySpeed = fspeed end

    flying = not flying
    FlyBtn.Text = flying and "Desativar Fly" or "Ativar Fly"

    UpBtn.Visible = flying
    DownBtn.Visible = flying

    if flying then
        startFly()
    else
        stopFly()
    end
end)
