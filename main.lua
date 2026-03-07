-- 🔥 HẢI 8A HUB V36 FIX 🔥

getgenv().ScriptTitle = "Hải 8A Hub"
getgenv().ScriptSubTitle = "V36"
getgenv().ScriptAuthorName = "Hải 8A"

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local correctKey = "haideptrai"
local unlocked = player:GetAttribute("H8A_Key") or false

local flying = false
local speed = 80
local minSpeed = 20
local maxSpeed = 200

local flyConnection, rainbowConnection, noclipConnection

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

--------------------------------------------------
-- NÚT hảikk (DI CHUYỂN ĐƯỢC)
--------------------------------------------------

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,70,0,70)
openBtn.Position = UDim2.new(0,20,0.5,-35)
openBtn.Text = "hảikk"
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(255,215,0)
openBtn.TextColor3 = Color3.fromRGB(0,0,0)
openBtn.Active = true
openBtn.Draggable = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

--------------------------------------------------
-- MENU GIỮ GIỮA
--------------------------------------------------

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,340)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.new(0.5,0,0.5,0)
main.BackgroundColor3 = Color3.fromRGB(255,215,0)
main.Visible = false
Instance.new("UICorner", main)

openBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

--------------------------------------------------
-- KEY SYSTEM
--------------------------------------------------

local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0,300,0,200)
keyFrame.AnchorPoint = Vector2.new(0.5,0.5)
keyFrame.Position = UDim2.new(0.5,0,0.5,0)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,0,0)
Instance.new("UICorner", keyFrame)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1,0,0,40)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔑 NHẬP KEY"
keyTitle.TextScaled = true
keyTitle.TextColor3 = Color3.new(1,1,1)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Nhập key..."
keyBox.TextScaled = true

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.6,0,0,40)
keyBtn.Position = UDim2.new(0.2,0,0.65,0)
keyBtn.Text = "XÁC NHẬN"
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn)

--------------------------------------------------
-- FLY BUTTON
--------------------------------------------------

local flyBtn = Instance.new("TextButton", main)
flyBtn.Size = UDim2.new(0.8,0,0,50)
flyBtn.Position = UDim2.new(0.1,0,0.15,0)
flyBtn.Text = "BẬT BAY"
flyBtn.TextScaled = true
flyBtn.BackgroundColor3 = Color3.fromRGB(255,200,0)
flyBtn.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", flyBtn)

--------------------------------------------------
-- SPEED SLIDER
--------------------------------------------------

local speedText = Instance.new("TextLabel", main)
speedText.Size = UDim2.new(1,0,0,30)
speedText.Position = UDim2.new(0,0,0.33,0)
speedText.BackgroundTransparency = 1
speedText.Text = "⚡ Speed: "..speed
speedText.TextScaled = true
speedText.TextColor3 = Color3.new(0,0,0)

local slider = Instance.new("Frame", main)
slider.Size = UDim2.new(0.8,0,0,40)
slider.Position = UDim2.new(0.1,0,0.42,0)
slider.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", slider)

local sliderBtn = Instance.new("TextButton", slider)
sliderBtn.Size = UDim2.new(0,20,1,0)
sliderBtn.Position = UDim2.new((speed-minSpeed)/(maxSpeed-minSpeed),-10,0,0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
sliderBtn.Text = ""

local dragging = false

sliderBtn.MouseButton1Down:Connect(function()
	dragging = true
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		local percent = math.clamp(
			(input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
			0,1
		)
		sliderBtn.Position = UDim2.new(percent,-10,0,0)
		speed = math.floor(minSpeed + (maxSpeed-minSpeed) * percent)
		speedText.Text = "⚡ Speed: "..speed
	end
end)

--------------------------------------------------
-- FLY SYSTEM (FIX BAY LÊN TRỜI)
--------------------------------------------------

local function stopFly()
	flying = false
	if flyConnection then flyConnection:Disconnect() end
	if rainbowConnection then rainbowConnection:Disconnect() end
	if noclipConnection then noclipConnection:Disconnect() end
	
	local char = player.Character
	if not char then return end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	
	if hrp then
		for _,v in pairs(hrp:GetChildren()) do
			if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
				v:Destroy()
			end
		end
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
	bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	
	local bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
	bg.P = 10000
	
	hum.PlatformStand = true
	flying = true
	
	noclipConnection = RunService.Stepped:Connect(function()
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end)
	
	local hue = 0
	rainbowConnection = RunService.RenderStepped:Connect(function()
		hue += 0.01
		if hue > 1 then hue = 0 end
		local color = Color3.fromHSV(hue,1,1)
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Color = color
			end
		end
	end)
	
	flyConnection = RunService.RenderStepped:Connect(function()

		local moveDir = hum.MoveDirection
		local y = 0

		-- PC
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			y = speed
		elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			y = -speed
		end

		-- Mobile giữ nút nhảy
		if hum.Jump then
			y = speed
		end

		local direction = (moveDir * speed) + Vector3.new(0,y,0)

		bv.Velocity = direction
		bg.CFrame = camera.CFrame

	end)
	
	flyBtn.Text = "TẮT BAY"
end

flyBtn.MouseButton1Click:Connect(function()
	if flying then stopFly() else startFly() end
end)

--------------------------------------------------
-- KEY CHECK
--------------------------------------------------

keyBtn.MouseButton1Click:Connect(function()
	if string.lower(keyBox.Text) == correctKey then
		player:SetAttribute("H8A_Key", true)
		keyFrame.Visible = false
		main.Visible = true
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Sai key!"
	end
end)

if unlocked then
	keyFrame.Visible = false
	main.Visible = true
end

player.CharacterAdded:Connect(function()
	stopFly()
end)