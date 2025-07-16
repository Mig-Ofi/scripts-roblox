--[[ GUI de Speed, Jump e Fly com botões, fly customizável e sem limite ]]--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variáveis do fly
local flying = false
local flySpeed = 10
local BodyGyro, BodyVelocity
local hrp = character:WaitForChild("HumanoidRootPart")

-- Criar botões subir e descer para mobile
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlyControlsGUI"
ScreenGui.ResetOnSpawn = false

local UpBtn = Instance.new("TextButton", ScreenGui)
UpBtn.Size = UDim2.new(0, 60, 0, 60)
UpBtn.Position = UDim2.new(0, 10, 1, -130)
UpBtn.Text = "↑"
UpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
UpBtn.TextColor3 = Color3.new(1,1,1)
UpBtn.Visible = false

local DownBtn = Instance.new("TextButton", ScreenGui)
DownBtn.Size = UDim2.new(0, 60, 0, 60)
DownBtn.Position = UDim2.new(0, 80, 1, -130)
DownBtn.Text = "↓"
DownBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
DownBtn.TextColor3 = Color3.new(1,1,1)
DownBtn.Visible = false

local goingUp = false
local goingDown = false

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

-- Função para iniciar o fly
local flyConnection
local function startFly()
    BodyGyro = Instance.new("BodyGyro", hrp)
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = hrp.CFrame

    BodyVelocity = Instance.new("BodyVelocity", hrp)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0,0,0)

    flyConnection = RunService.RenderStepped:Connect(function()
        if flying then
            local cam = workspace.CurrentCamera
            local moveVec = cam.CFrame.LookVector
            local vertical = 0
            if goingUp then vertical = 1 elseif goingDown then vertical = -1 else vertical = 0 end
            local velocity = (moveVec * flySpeed) + Vector3.new(0, vertical * flySpeed, 0)
            BodyVelocity.Velocity = velocity
            BodyGyro.CFrame = cam.CFrame
        end
    end)
end

local function stopFly()
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- Botão para ativar/desativar fly (integre ao seu script GUI)
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
