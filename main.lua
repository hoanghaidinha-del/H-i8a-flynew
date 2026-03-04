-- 🔥 hải8A FLY MENU FINAL + SPEED SLIDER 🔥

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local correctKey = "haideptrainhat8a"
local speed = 70
local minSpeed = 20
local maxSpeed = 200
local flying = false
local flyConnection = nil

local unlocked = player:GetAttribute("Hai8A_KeyUnlocked") or false

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Open Button
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,60,0,60)
openBtn.Position = UDim2.new(0,20,0.5,-30)
openBtn.Text = "h8A"
openBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.Draggable = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- Key Frame
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0,300,0,180)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-90)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,0,0)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,40)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔑 Nhập Key"
keyTitle.TextColor3 = Color3.new(1,1,1)
keyTitle.TextScaled = true

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.4,0)
keyBox.PlaceholderText = "Nhập key..."
keyBox.TextScaled = true

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.6,0,0,40)
keyBtn.Position = UDim2.new(0.2,0,0.7,0)
keyBtn.Text = "XÁC NHẬN"
keyBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
keyBtn.TextColor3 = Color3.new(1,1,1)
keyBtn.TextScaled = true

if unlocked then keyFrame:Destroy() end

-- Main Menu
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,280,0,260)
main.Position = UDim2.new(0.5,-140,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(20,0,0)
main.Visible = false

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)

local flyBtn = Instance.new("TextButton", main)
flyBtn.Size = UDim2.new(0.8,0,0,45)
flyBtn.Position = UDim2.new(0.1,0,0.25,0)
flyBtn.Text = "BẬT BAY"
flyBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.TextScaled = true

-- Speed Label
local speedLabel = Instance.new("TextLabel", main)
speedLabel.Size = UDim2.new(1,0,0,25)
speedLabel.Position = UDim2.new(0,0,0.48,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Speed: "..speed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextScaled = true

-- Slider
local sliderFrame = Instance.new("Frame", main)
sliderFrame.Size = UDim2.new(0.8,0,0,40)
sliderFrame.Position = UDim2.new(0.1,0,0.6,0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(40,0,0)

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(1,0,0,6)
sliderBar.Position = UDim2.new(0,0,0.5,-3)
sliderBar.BackgroundColor3 = Color3.fromRGB(100,0,0)

local sliderButton = Instance.new("TextButton", sliderFrame)
sliderButton.Size = UDim2.new(0,20,0,40)
sliderButton.Position = UDim2.new((speed-minSpeed)/(maxSpeed-minSpeed),-10,0,0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
sliderButton.Text = ""

local dragging = false

sliderButton.MouseButton1Down:Connect(function() dragging = true end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		
		local relativeX = math.clamp(
			(input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X,
			0,1
		)
		
		sliderButton.Position = UDim2.new(relativeX,-10,0,0)
		speed = math.floor(minSpeed + (maxSpeed-minSpeed) * relativeX)
		speedLabel.Text = "⚡ Speed: "..speed
	end
end)

-- Fly System
local function stopFly()
	flying = false
	if flyConnection then flyConnection:Disconnect() flyConnection=nil end
	
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	
	if hrp then
		local bv = hrp:FindFirstChild("BV")
		local bg = hrp:FindFirstChild("BG")
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
	
	if hum then hum.PlatformStand = false end
	flyBtn.Text = "BẬT BAY"
end

local function startFly()
	stopFly()
	local char = player.Character
	if not char then return end
	
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	
	local bv = Instance.new("BodyVelocity", hrp)
	bv.Name = "BV"
	bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	
	local bg = Instance.new("BodyGyro", hrp)
	bg.Name = "BG"
	bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
	bg.P = 10000
	
	hum.PlatformStand = true
	flying = true
	
	flyConnection = RunService.RenderStepped:Connect(function()
		if flying then
			bg.CFrame = camera.CFrame
			bv.Velocity = camera.CFrame.LookVector * speed
		end
	end)
	
	flyBtn.Text = "TẮT BAY"
end

flyBtn.MouseButton1Click:Connect(function()
	if flying then stopFly() else startFly() end
end)

keyBtn.MouseButton1Click:Connect(function()
	if string.lower(keyBox.Text) == correctKey then
		player:SetAttribute("Hai8A_KeyUnlocked", true)
		unlocked = true
		keyFrame:Destroy()
		main.Visible = true
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Sai key!"
	end
end)

openBtn.MouseButton1Click:Connect(function()
	if unlocked then main.Visible = not main.Visible end
end)

closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)

player.CharacterAdded:Connect(function()
	stopFly()
end)
