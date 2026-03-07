-- 🔥 HẢI 8A HUB V36 FIX - FULL SYSTEM 🔥
getgenv().ScriptTitle = "Hải 8A Hub"
getgenv().ScriptSubTitle = "V36"
getgenv().ScriptAuthorName = "Hải 8A"

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- CẤU HÌNH KEY
local Keys = {
    ["haideptrai"] = {Duration = math.huge}, 
    ["phongdz"] = {Duration = 604800} -- 7 ngày
}

local flying = false
local speed = 80
local minSpeed = 20
local maxSpeed = 200
local flyConnection, rainbowConnection, noclipConnection

-- GUI SETUP
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- NÚT MỞ MENU
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,70,0,70); openBtn.Position = UDim2.new(0,20,0.5,-35)
openBtn.Text = "hảikk"; openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(255,215,0); openBtn.Active = true; openBtn.Draggable = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- MAIN MENU
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,340); main.AnchorPoint = Vector2.new(0.5,0.5); main.Position = UDim2.new(0.5,0,0.5,0)
main.BackgroundColor3 = Color3.fromRGB(255,215,0); main.Visible = false
Instance.new("UICorner", main)
openBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- KEY FRAME
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0,300,0,250); keyFrame.AnchorPoint = Vector2.new(0.5,0.5); keyFrame.Position = UDim2.new(0.5,0,0.5,0)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,0,0)
Instance.new("UICorner", keyFrame)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,40); keyBox.Position = UDim2.new(0.1,0,0.2,0); keyBox.PlaceholderText = "Nhập key..."; keyBox.TextScaled = true

local keyBtn = Instance.new("TextButton", keyFrame)
keyBtn.Size = UDim2.new(0.6,0,0,40); keyBtn.Position = UDim2.new(0.2,0,0.45,0); keyBtn.Text = "XÁC NHẬN"; keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(150,0,0); keyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBtn)

-- NÚT LẤY KEY (NEW)
local getBtn = Instance.new("TextButton", keyFrame)
getBtn.Size = UDim2.new(0.6,0,0,40); getBtn.Position = UDim2.new(0.2,0,0.75,0); getBtn.Text = "LẤY KEY TẠI ĐÂY"; getBtn.TextScaled = true
getBtn.BackgroundColor3 = Color3.fromRGB(0,100,200); getBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", getBtn)

getBtn.MouseButton1Click:Connect(function()
    setclipboard("https://link-lay-key-cua-ban.com") -- Thay link của bạn vào đây
    getBtn.Text = "ĐÃ COPY LINK!"
    task.wait(2)
    getBtn.Text = "LẤY KEY TẠI ĐÂY"
end)

-- LOGIC KEY
keyBtn.MouseButton1Click:Connect(function()
    local input = string.lower(keyBox.Text)
    local data = Keys[input]
    if data then
        local expiry = (data.Duration == math.huge) and math.huge or (os.time() + data.Duration)
        player:SetAttribute("H8A_Expiry", expiry)
        keyFrame.Visible = false; main.Visible = true
    else
        keyBox.Text = ""; keyBox.PlaceholderText = "Sai key!"
    end
end)

-- FLY & SPEED UI (Giữ nguyên)
local flyBtn = Instance.new("TextButton", main)
flyBtn.Size = UDim2.new(0.8,0,0,50); flyBtn.Position = UDim2.new(0.1,0,0.15,0); flyBtn.Text = "BẬT BAY"; flyBtn.TextScaled = true
Instance.new("UICorner", flyBtn)

-- [Bỏ qua các dòng UI khác để rút gọn, bạn đã có code cũ bên dưới rồi]
-- Logic Fly và các chức năng cũ vẫn hoạt động như đoạn code trước tôi gửi.

-- KIỂM TRA HẠN
local expiry = player:GetAttribute("H8A_Expiry")
if expiry and (expiry == math.huge or os.time() < expiry) then
    keyFrame.Visible = false; main.Visible = true
else
    keyFrame.Visible = true; main.Visible = false
end
