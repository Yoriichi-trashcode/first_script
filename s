local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
-- At the top, inside your required services definitions:
local Lighting = game:GetService("Lighting")

-- Function to toggle fullbright:
local fullbrightEnabled = false
local originalLightingProps = {}

local function toggleFullbright()
    if not fullbrightEnabled then
        -- Save the original lighting settings
        originalLightingProps = {
            Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            ClockTime = Lighting.ClockTime,
        }
        -- Apply fullbright settings
        Lighting.Brightness = 2      -- Max brightness
        Lighting.Ambient = Color3.new(1, 1, 1)         -- Pure white ambient
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)  -- Pure white outdoor ambient
        Lighting.ClockTime = 12      -- Optimal daylight
        fullbrightEnabled = true
    else
        -- Restore original settings
        Lighting.Brightness = originalLightingProps.Brightness
        Lighting.Ambient = originalLightingProps.Ambient
        Lighting.OutdoorAmbient = originalLightingProps.OutdoorAmbient
        Lighting.ClockTime = originalLightingProps.ClockTime
        fullbrightEnabled = false
    end
end


local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateAdminPanel"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 380)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -190)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 40, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 40))
}
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 14, 1, 14)
shadow.Position = UDim2.new(0, -7, 0, -7)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.ImageTransparency = 0.85
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local titleGradient = Instance.new("Frame")
titleGradient.Size = UDim2.new(1, 0, 1, 0)
titleGradient.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleGradient.BackgroundTransparency = 0
titleGradient.Parent = titleBar

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleGradient

local titleBarGradient = Instance.new("UIGradient")
titleBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 72, 110)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(56, 56, 92))
}
titleBarGradient.Rotation = 90
titleBarGradient.Parent = titleGradient

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -46, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ULTIMATE ADMIN PANEL"
title.TextColor3 = Color3.fromRGB(240,240,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 36, 0, 24)
closeButton.Position = UDim2.new(1, -42, 0.5, -12)
closeButton.BackgroundColor3 = Color3.fromRGB(235,80,80)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(215,60,60)}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(235,80,80)}):Play()
end)
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)


local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Name = "TabButtons"
tabButtonsFrame.Size = UDim2.new(1, -20, 0, 36)
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 40)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local function makeTabButton(name, posScale, defaultColor)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.5, -8, 1, 0)
    btn.Position = UDim2.new(posScale, posScale==0 and 0 or 8, 0, 0)
    btn.BackgroundColor3 = defaultColor
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = tabButtonsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

local movementTabButton = makeTabButton("MovementTabButton", 0, Color3.fromRGB(70,70,100))
movementTabButton.Text = "MOVEMENT"

local flingTabButton = makeTabButton("FlingTabButton", 0.5, Color3.fromRGB(50,50,80))
flingTabButton.Text = "FLING TOOL"

local function setupButtonHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = normalColor}):Play()
    end)
end

setupButtonHover(movementTabButton, Color3.fromRGB(70,70,100), Color3.fromRGB(90,90,130))
setupButtonHover(flingTabButton, Color3.fromRGB(50,50,80), Color3.fromRGB(70,70,110))


local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 1, -100)
tabContainer.Position = UDim2.new(0, 10, 0, 80)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local movementTab = Instance.new("Frame")
movementTab.Name = "MovementTab"
movementTab.Size = UDim2.new(1, 0, 1, 0)
movementTab.BackgroundTransparency = 1
movementTab.Visible = true
movementTab.Parent = tabContainer


local speedSection = Instance.new("Frame")
speedSection.Name = "SpeedSection"
speedSection.Size = UDim2.new(1, 0, 0, 110)
speedSection.Position = UDim2.new(0, 0, 0, 0)
speedSection.BackgroundColor3 = Color3.fromRGB(40,40,60)
speedSection.BackgroundTransparency = 0.35
speedSection.Parent = movementTab

local speedSectionCorner = Instance.new("UICorner")
speedSectionCorner.CornerRadius = UDim.new(0, 8)
speedSectionCorner.Parent = speedSection

local speedSectionTitle = Instance.new("TextLabel")
speedSectionTitle.Name = "SpeedSectionTitle"
speedSectionTitle.Size = UDim2.new(1, -20, 0, 24)
speedSectionTitle.Position = UDim2.new(0, 10, 0, 6)
speedSectionTitle.BackgroundTransparency = 1
speedSectionTitle.Text = "PLAYER SPEED"
speedSectionTitle.TextColor3 = Color3.fromRGB(220,220,255)
speedSectionTitle.Font = Enum.Font.GothamBold
speedSectionTitle.TextSize = 13
speedSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
speedSectionTitle.Parent = speedSection


local speedSlider = Instance.new("TextButton")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(1, -140, 0, 22)
speedSlider.Position = UDim2.new(0, 10, 0, 34)
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,90)
speedSlider.AutoButtonColor = false
speedSlider.Text = ""
speedSlider.Parent = speedSection

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 6)
speedSliderCorner.Parent = speedSlider

local speedFill = Instance.new("Frame")
speedFill.Name = "SpeedFill"
speedFill.Size = UDim2.new(0.5, 0, 1, 0) 
speedFill.BackgroundColor3 = Color3.fromRGB(100,150,255)
speedFill.Parent = speedSlider

local speedFillCorner = Instance.new("UICorner")
speedFillCorner.CornerRadius = UDim.new(0, 6)
speedFillCorner.Parent = speedFill

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedBox"
speedBox.Size = UDim2.new(0, 100, 0, 22)
speedBox.Position = UDim2.new(1, -110, 0, 34)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,80)
speedBox.BorderSizePixel = 0
speedBox.Text = "16"
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedSection

local speedBoxCorner = Instance.new("UICorner")
speedBoxCorner.CornerRadius = UDim.new(0, 6)
speedBoxCorner.Parent = speedBox

local changeSpeedButton = Instance.new("TextButton")
changeSpeedButton.Name = "ChangeSpeedButton"
changeSpeedButton.Size = UDim2.new(0.5, -15, 0, 26)
changeSpeedButton.Position = UDim2.new(0, 10, 0, 64)
changeSpeedButton.BackgroundColor3 = Color3.fromRGB(80,120,200)
changeSpeedButton.AutoButtonColor = false
changeSpeedButton.Text = "CHANGE SPEED"
changeSpeedButton.TextColor3 = Color3.fromRGB(255,255,255)
changeSpeedButton.Font = Enum.Font.GothamBold
changeSpeedButton.TextSize = 12
changeSpeedButton.Parent = speedSection

local changeSpeedCorner = Instance.new("UICorner")
changeSpeedCorner.CornerRadius = UDim.new(0, 6)
changeSpeedCorner.Parent = changeSpeedButton

local normalSpeedButton = Instance.new("TextButton")
normalSpeedButton.Name = "NormalSpeedButton"
normalSpeedButton.Size = UDim2.new(0.5, -15, 0, 26)
normalSpeedButton.Position = UDim2.new(0.5, 5, 0, 64)
normalSpeedButton.BackgroundColor3 = Color3.fromRGB(120,80,80)
normalSpeedButton.AutoButtonColor = false
normalSpeedButton.Text = "NORMAL SPEED"
normalSpeedButton.TextColor3 = Color3.fromRGB(255,255,255)
normalSpeedButton.Font = Enum.Font.GothamBold
normalSpeedButton.TextSize = 12
normalSpeedButton.Parent = speedSection

local normalSpeedCorner = Instance.new("UICorner")
normalSpeedCorner.CornerRadius = UDim.new(0, 6)
normalSpeedCorner.Parent = normalSpeedButton

setupButtonHover(changeSpeedButton, Color3.fromRGB(80,120,200), Color3.fromRGB(100,140,220))
setupButtonHover(normalSpeedButton, Color3.fromRGB(120,80,80), Color3.fromRGB(140,100,100))


local flySection = Instance.new("Frame")
flySection.Name = "FlySection"
flySection.Size = UDim2.new(1, 0, 0, 150)
flySection.Position = UDim2.new(0, 0, 0, 120)
flySection.BackgroundColor3 = Color3.fromRGB(40,40,60)
flySection.BackgroundTransparency = 0.35
flySection.Parent = movementTab

local flySectionCorner = Instance.new("UICorner")
flySectionCorner.CornerRadius = UDim.new(0, 8)
flySectionCorner.Parent = flySection

local flySectionTitle = Instance.new("TextLabel")
flySectionTitle.Name = "FlySectionTitle"
flySectionTitle.Size = UDim2.new(1, -20, 0, 24)
flySectionTitle.Position = UDim2.new(0, 10, 0, 6)
flySectionTitle.BackgroundTransparency = 1
flySectionTitle.Text = "FLY CONTROLS"
flySectionTitle.TextColor3 = Color3.fromRGB(220,220,255)
flySectionTitle.Font = Enum.Font.GothamBold
flySectionTitle.TextSize = 13
flySectionTitle.TextXAlignment = Enum.TextXAlignment.Left
flySectionTitle.Parent = flySection

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Name = "FlySpeedLabel"
flySpeedLabel.Size = UDim2.new(1, -20, 0, 20)
flySpeedLabel.Position = UDim2.new(0, 10, 0, 36)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Fly Speed: 50"
flySpeedLabel.TextColor3 = Color3.fromRGB(240,240,240)
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 13
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flySection

local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Name = "FlySpeedBox"
flySpeedBox.Size = UDim2.new(0.5, -15, 0, 22)
flySpeedBox.Position = UDim2.new(0, 10, 0, 60)
flySpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,80)
flySpeedBox.BorderSizePixel = 0
flySpeedBox.Text = "50"
flySpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
flySpeedBox.Font = Enum.Font.Gotham
flySpeedBox.TextSize = 14
flySpeedBox.ClearTextOnFocus = false
flySpeedBox.Parent = flySection

local flySpeedCorner = Instance.new("UICorner")
flySpeedCorner.CornerRadius = UDim.new(0, 6)
flySpeedCorner.Parent = flySpeedBox

local changeFlySpeedButton = Instance.new("TextButton")
changeFlySpeedButton.Name = "ChangeFlySpeedButton"
changeFlySpeedButton.Size = UDim2.new(0.5, -15, 0, 22)
changeFlySpeedButton.Position = UDim2.new(0.5, 5, 0, 60)
changeFlySpeedButton.BackgroundColor3 = Color3.fromRGB(80,80,120)
changeFlySpeedButton.AutoButtonColor = false
changeFlySpeedButton.Text = "CHANGE"
changeFlySpeedButton.TextColor3 = Color3.fromRGB(255,255,255)
changeFlySpeedButton.Font = Enum.Font.GothamBold
changeFlySpeedButton.TextSize = 12
changeFlySpeedButton.Parent = flySection

local changeFlyCorner = Instance.new("UICorner")
changeFlyCorner.CornerRadius = UDim.new(0, 6)
changeFlyCorner.Parent = changeFlySpeedButton

setupButtonHover(changeFlySpeedButton, Color3.fromRGB(80,80,120), Color3.fromRGB(100,100,140))

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0.5, -15, 0, 26)
flyButton.Position = UDim2.new(0, 10, 0, 94)
flyButton.BackgroundColor3 = Color3.fromRGB(60,150,60)
flyButton.AutoButtonColor = false
flyButton.Text = "FLY"
flyButton.TextColor3 = Color3.fromRGB(255,255,255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 14
flyButton.Parent = flySection

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

local unflyButton = Instance.new("TextButton")
unflyButton.Name = "UnflyButton"
unflyButton.Size = UDim2.new(0.5, -15, 0, 26)
unflyButton.Position = UDim2.new(0.5, 5, 0, 94)
unflyButton.BackgroundColor3 = Color3.fromRGB(150,60,60)
unflyButton.AutoButtonColor = false
unflyButton.Text = "UNFLY"
unflyButton.TextColor3 = Color3.fromRGB(255,255,255)
unflyButton.Font = Enum.Font.GothamBold
unflyButton.TextSize = 14
unflyButton.Parent = flySection

local unflyCorner = Instance.new("UICorner")
unflyCorner.CornerRadius = UDim.new(0, 6)
unflyCorner.Parent = unflyButton

local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoclipButton"
noclipButton.Size = UDim2.new(1, 0, 0, 34)
noclipButton.Position = UDim2.new(0, 0, 0, 280)
noclipButton.BackgroundColor3 = Color3.fromRGB(100,60,150)
noclipButton.AutoButtonColor = false
noclipButton.Text = "NOCLIP"
noclipButton.TextColor3 = Color3.fromRGB(255,255,255)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 14
noclipButton.Parent = movementTab

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipButton

setupButtonHover(noclipButton, Color3.fromRGB(100,60,150), Color3.fromRGB(120,80,170))

local flingTab = Instance.new("Frame")
flingTab.Name = "FlingTab"
flingTab.Size = UDim2.new(1, 0, 1, 0)
flingTab.BackgroundTransparency = 1
flingTab.Visible = false
flingTab.Parent = tabContainer

local flingLabel = Instance.new("TextLabel")
flingLabel.Name = "FlingLabel"
flingLabel.Size = UDim2.new(1, -20, 0, 24)
flingLabel.Position = UDim2.new(0, 10, 0, 0)
flingLabel.BackgroundTransparency = 1
flingLabel.Text = "FLING TOOL(DOES NOT WORK. FIXING SOON)"
flingLabel.TextColor3 = Color3.fromRGB(240,240,255)
flingLabel.Font = Enum.Font.GothamBold
flingLabel.TextSize = 13
flingLabel.TextXAlignment = Enum.TextXAlignment.Left
flingLabel.Parent = flingTab

local playerListFrame = Instance.new("Frame")
playerListFrame.Name = "PlayerListFrame"
playerListFrame.Size = UDim2.new(1, -20, 1, -110)
playerListFrame.Position = UDim2.new(0, 10, 0, 40)
playerListFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
playerListFrame.Parent = flingTab

local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 8)
playerListCorner.Parent = playerListFrame

local playerListLabel = Instance.new("TextLabel")
playerListLabel.Name = "PlayerListLabel"
playerListLabel.Size = UDim2.new(1, -10, 0, 20)
playerListLabel.Position = UDim2.new(0, 5, 0, 5)
playerListLabel.BackgroundTransparency = 1
playerListLabel.Text = "Players:"
playerListLabel.TextColor3 = Color3.fromRGB(240,240,255)
playerListLabel.Font = Enum.Font.Gotham
playerListLabel.TextSize = 14
playerListLabel.TextXAlignment = Enum.TextXAlignment.Left
playerListLabel.Parent = playerListFrame

local playerList = Instance.new("ScrollingFrame")
playerList.Name = "PlayerList"
playerList.Size = UDim2.new(1, -10, 1, -30)
playerList.Position = UDim2.new(0, 5, 0, 30)
playerList.BackgroundTransparency = 1
playerList.ScrollBarThickness = 6
playerList.Parent = playerListFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 4)
playerListLayout.Parent = playerList

local flingButton = Instance.new("TextButton")
flingButton.Name = "FlingButton"
flingButton.Size = UDim2.new(1, -20, 0, 36)
flingButton.Position = UDim2.new(0, 10, 1, -70)
flingButton.AnchorPoint = Vector2.new(0, 0)
flingButton.BackgroundColor3 = Color3.fromRGB(150,60,60)
flingButton.Text = "FLING SELECTED"
flingButton.Font = Enum.Font.GothamBold
flingButton.TextSize = 14
flingButton.TextColor3 = Color3.fromRGB(255,255,255)
flingButton.Parent = flingTab

local unflingButton = Instance.new("TextButton")
unflingButton.Name = "UnflingButton"
unflingButton.Size = UDim2.new(1, -20, 0, 36)
unflingButton.Position = UDim2.new(0, 10, 1, -30)
unflingButton.AnchorPoint = Vector2.new(0, 0)
unflingButton.BackgroundColor3 = Color3.fromRGB(60,150,60)
unflingButton.Text = "UNFLING ALL"
unflingButton.Font = Enum.Font.GothamBold
unflingButton.TextSize = 14
unflingButton.TextColor3 = Color3.fromRGB(255,255,255)
unflingButton.Parent = flingTab

movementTabButton.MouseButton1Click:Connect(function()
    movementTab.Visible = true
    flingTab.Visible = false
    TweenService:Create(movementTabButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(70,70,100)}):Play()
    TweenService:Create(flingTabButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(50,50,80)}):Play()
end)

flingTabButton.MouseButton1Click:Connect(function()
    movementTab.Visible = false
    flingTab.Visible = true
    TweenService:Create(movementTabButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(50,50,80)}):Play()
    TweenService:Create(flingTabButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(70,70,100)}):Play()
end)

local defaultWalkSpeed = 16
local currentWalkSpeed = defaultWalkSpeed


local function setPlayerWalkSpeed(speed)
    currentWalkSpeed = speed
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end


speedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local value = tonumber(speedBox.Text)
    if value then

        local fillFrac = math.clamp(value / 100, 0, 1)
        speedFill:TweenSize(UDim2.new(fillFrac, 0, 1, 0), "Out", "Quad", 0.12, true)
    end
end)


local sliding = false
local function updateSliderFromInput(input)
    local absPos = speedSlider.AbsolutePosition.X
    local absSize = speedSlider.AbsoluteSize.X
    local mouseX = input.Position.X
    local rel = math.clamp((mouseX - absPos) / absSize, 0, 1)
    speedFill.Size = UDim2.new(rel, 0, 1, 0)
    local speedVal = math.floor(rel * 100)
    speedBox.Text = tostring(speedVal)
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = true
        updateSliderFromInput(input)
    end
end)

speedSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSliderFromInput(input)
    end
end)

changeSpeedButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(speedBox.Text)
    if not newSpeed then

        speedBox.Text = tostring(currentWalkSpeed)
        return
    end
    setPlayerWalkSpeed(newSpeed)


    TweenService:Create(changeSpeedButton, TweenInfo.new(0.08), {Size = UDim2.new(0.5, -20, 0, 24)}):Play()
    delay(0.08, function()
        TweenService:Create(changeSpeedButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, -15, 0, 26)}):Play()
    end)
end)

normalSpeedButton.MouseButton1Click:Connect(function()
    setPlayerWalkSpeed(defaultWalkSpeed)
    speedBox.Text = tostring(defaultWalkSpeed)

    TweenService:Create(normalSpeedButton, TweenInfo.new(0.08), {Size = UDim2.new(0.5, -20, 0, 24)}):Play()
    delay(0.08, function()
        TweenService:Create(normalSpeedButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, -15, 0, 26)}):Play()
    end)
end)


player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = currentWalkSpeed
end)


local flySpeed = 50
local bodyVelocity, bodyGyro, flyConnection

changeFlySpeedButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(flySpeedBox.Text)
    if newSpeed and newSpeed > 0 then
        flySpeed = newSpeed
        flySpeedLabel.Text = "Fly Speed: " .. tostring(flySpeed)
    else
        flySpeedBox.Text = tostring(flySpeed)
    end

    TweenService:Create(changeFlySpeedButton, TweenInfo.new(0.08), {Size = UDim2.new(0.5, -20, 0, 20)}):Play()
    delay(0.08, function()
        TweenService:Create(changeFlySpeedButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, -15, 0, 22)}):Play()
    end)
end)

local function cleanupFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end

flyButton.MouseButton1Click:Connect(function()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    cleanupFly()

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:WaitForChild("HumanoidRootPart")

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 1000
    bodyGyro.D = 100
    bodyGyro.Parent = rootPart

    humanoid.PlatformStand = true

    flyConnection = RunService.Heartbeat:Connect(function()
        if not bodyVelocity or not bodyGyro or not player.Character then
            cleanupFly()
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then return end
        local cf = camera.CFrame
        local direction = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0,1,0)
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit * flySpeed
        end

        bodyVelocity.Velocity = direction
        bodyGyro.CFrame = cf
    end)

 
    TweenService:Create(flyButton, TweenInfo.new(0.08), {Size = UDim2.new(0.5, -20, 0, 24)}):Play()
    delay(0.08, function()
        TweenService:Create(flyButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, -15, 0, 26)}):Play()
    end)
end)

unflyButton.MouseButton1Click:Connect(function()
    cleanupFly()
    TweenService:Create(unflyButton, TweenInfo.new(0.08), {Size = UDim2.new(0.5, -20, 0, 24)}):Play()
    delay(0.08, function()
        TweenService:Create(unflyButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, -15, 0, 26)}):Play()
    end)
end)


local noclip = false
local noclipConnection

local function noclipCharacter(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function unnoclipCharacter(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

noclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip

    if not player.Character then return end

    if noclip then
        noclipButton.Text = "UNNOCLIP"
        TweenService:Create(noclipButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(150,80,200)}):Play()
        noclipCharacter(player.Character)
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        noclipConnection = player.Character.DescendantAdded:Connect(function(part)
            if part and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end)
    else
        noclipButton.Text = "NOCLIP"
        TweenService:Create(noclipButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(100,60,150)}):Play()
        unnoclipCharacter(player.Character)
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    end


    TweenService:Create(noclipButton, TweenInfo.new(0.08), {Size = UDim2.new(1, -10, 0, 30)}):Play()
    delay(0.08, function()
        TweenService:Create(noclipButton, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 34)}):Play()
    end)
end)

player.CharacterAdded:Connect(function(character)
    if noclip then
        noclipCharacter(character)
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        noclipConnection = character.DescendantAdded:Connect(function(part)
            if part and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end)
    end
end)


local flingPlayers = {}
local selectedPlayer = nil

local function updatePlayerList()


    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Name = plr.Name
            playerButton.Size = UDim2.new(1, -10, 0, 28)
            playerButton.BackgroundColor3 = Color3.fromRGB(50,50,70)
            playerButton.BorderSizePixel = 0
            playerButton.Text = plr.Name
            playerButton.TextColor3 = Color3.fromRGB(255,255,255)
            playerButton.Font = Enum.Font.Gotham
            playerButton.TextSize = 14
            playerButton.TextXAlignment = Enum.TextXAlignment.Left
            playerButton.Parent = playerList

            playerButton.MouseButton1Click:Connect(function()
                if selectedPlayer == plr then
                    selectedPlayer = nil
                    playerButton.BackgroundColor3 = Color3.fromRGB(50,50,70)
                else
                    for _, btn in ipairs(playerList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
                        end
                    end
                    selectedPlayer = plr
                    playerButton.BackgroundColor3 = Color3.fromRGB(90,90,130)
                end
            end)
        end
    end
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

local function flingPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    if not flingPlayers[targetPlayer] then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlingBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.P = 10000
        bv.Parent = targetRoot
        flingPlayers[targetPlayer] = bv
    end

    local randomVelocity = Vector3.new(
        math.random(-600, 600),
        math.random(150, 700),
        math.random(-600, 600)
    )
    flingPlayers[targetPlayer].Velocity = randomVelocity
end

local function unflingPlayer(targetPlayer)
    if not targetPlayer then return end
    if flingPlayers[targetPlayer] then
        flingPlayers[targetPlayer]:Destroy()
        flingPlayers[targetPlayer] = nil
    end
end

local function unflingAllPlayers()
    for plr, bv in pairs(flingPlayers) do
        if bv then
            bv:Destroy()
        end
    end
    flingPlayers = {}
end

flingButton.MouseButton1Click:Connect(function()
    if selectedPlayer then flingPlayer(selectedPlayer) end
end)

unflingButton.MouseButton1Click:Connect(function()
    unflingAllPlayers()
end)

gui.Destroying:Connect(function()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    unnoclipCharacter(player.Character)
    cleanupFly()
    unflingAllPlayers()
end)


speedBox.Text = tostring(defaultWalkSpeed)
speedFill.Size = UDim2.new(math.clamp(defaultWalkSpeed/100, 0, 1), 0, 1, 0)
flySpeedBox.Text = tostring(flySpeed)
flySpeedLabel.Text = "Fly Speed: " .. tostring(flySpeed)


-- ESP Button (add to movementTab in your existing code)
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Size = UDim2.new(1, -20, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 280) -- Position below noclip button
espButton.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
espButton.AutoButtonColor = false
espButton.Text = "ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 14
espButton.Parent = movementTab

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espButton

-- Button hover effect
setupButtonHover(espButton, Color3.fromRGB(150, 60, 60), Color3.fromRGB(170, 80, 80))

-- ESP functionality
local espEnabled = false
local espObjects = {}
local espColor = Color3.fromRGB(255, 50, 50)

local function createEsp(player)
    if espObjects[player] or player == game:GetService("Players").LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.FillColor = espColor
    highlight.OutlineColor = espColor
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    espObjects[player] = highlight
    
    -- Handle character changes
    player.CharacterAdded:Connect(function(newChar)
        if espObjects[player] then
            espObjects[player].Parent = nil
            task.wait() -- Small delay to ensure character is loaded
            highlight.Parent = newChar
        end
    end)
end

local function removeEsp(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

local function toggleEsp()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "ESP (ON)"
        game:GetService("TweenService"):Create(
            espButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(60, 150, 60)}
        ):Play()
        
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            createEsp(player)
        end
        
        -- Connect to new players
        game:GetService("Players").PlayerAdded:Connect(function(player)
            if espEnabled then
                createEsp(player)
            end
        end)
    else
        espButton.Text = "ESP"
        game:GetService("TweenService"):Create(
            espButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(150, 60, 60)}
        ):Play()
        
        for player, _ in pairs(espObjects) do
            removeEsp(player)
        end
    end
    
    -- Animate button click
    game:GetService("TweenService"):Create(
        espButton,
        TweenInfo.new(0.1),
        {Size = UDim2.new(1, -25, 0, 28)}
    ):Play()
    game:GetService("TweenService"):Create(
        espButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.1),
        {Size = UDim2.new(1, -20, 0, 30)}
    ):Play()
end

espButton.MouseButton1Click:Connect(toggleEsp)

-- Clean up ESP when GUI is closed
gui.Destroying:Connect(function()
    for player, _ in pairs(espObjects) do
        removeEsp(player)
    end
end)

-- Initialize ESP for existing players if needed
game:GetService("Players").PlayerAdded:Connect(function(player)
    if espEnabled then
        createEsp(player)
    end
end)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if espEnabled and player ~= game:GetService("Players").LocalPlayer then
        createEsp(player)
    end

-- Insert after the ESP section or wherever appropriate
local fullbrightButton = Instance.new("TextButton")
fullbrightButton.Name = "FullbrightButton"
fullbrightButton.Size = UDim2.new(1, -20, 0, 30)
fullbrightButton.Position = UDim2.new(0, 10, 0, 320) -- Adjust Y position as needed
fullbrightButton.BackgroundColor3 = Color3.fromRGB(150, 60, 150)
fullbrightButton.AutoButtonColor = false
fullbrightButton.Text = "Fullbright"
fullbrightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fullbrightButton.Font = Enum.Font.GothamBold
fullbrightButton.TextSize = 14
fullbrightButton.Parent = movementTab

local fullbrightCorner = Instance.new("UICorner")
fullbrightCorner.CornerRadius = UDim.new(0, 6)
fullbrightCorner.Parent = fullbrightButton

-- Hover effect (similar to others)
setupButtonHover(fullbrightButton, Color3.fromRGB(150, 60, 150), Color3.fromRGB(170, 80, 170))

-- Connect toggle function
fullbrightButton.MouseButton1Click:Connect(function()
    toggleFullbright()
    -- Optionally animate button as desired (like ESP)
end)

end
