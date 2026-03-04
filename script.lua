-- ================================================
-- MELOSKA ANTI LAG - PERPETUAL FREEZE EDITION
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local FrozenActive = false -- Variabile per gestire il loop

-- ================================================
-- MAIN GUI
-- ================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeloskaAntiLag_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 255, 255)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Meloska ANTI LAG"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local UltraButton = Instance.new("TextButton", MainFrame)
UltraButton.Size = UDim2.new(0.9, 0, 0, 30)
UltraButton.Position = UDim2.new(0.05, 0, 0, 35)
UltraButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
UltraButton.Text = "AntiLag🌌"
UltraButton.Font = Enum.Font.GothamBold
UltraButton.TextSize = 8
UltraButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local FPSButton = Instance.new("TextButton", MainFrame)
FPSButton.Size = UDim2.new(0.9, 0, 0, 30)
FPSButton.Position = UDim2.new(0.05, 0, 0, 72)
FPSButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
FPSButton.Text = "ULTRA FPS BOOSTER"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 9
FPSButton.TextColor3 = Color3.fromRGB(255, 255, 255)

Instance.new("UICorner", UltraButton).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", FPSButton).CornerRadius = UDim.new(0, 6)

-- ================================================
-- FUNZIONE DI FREEZE PERPETUO
-- ================================================

local function FreezeObject(obj)
    if obj:IsA("Humanoid") then
        -- Distrugge animator per bloccare nuove animazioni
        local animator = obj:FindFirstChildOfClass("Animator")
        if animator then animator:Destroy() end
        
        -- Stoppa quelle attive
        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end
    
    -- Disabilita script di movimento (Animate, Mover, etc)
    if obj:IsA("LocalScript") or obj:IsA("Script") then
        local name = obj.Name:lower()
        if name == "animate" or name:find("anim") or name == "mover" then
            obj.Disabled = true
        end
    end
end

local function StartPerpetualFreeze()
    if FrozenActive then return end
    FrozenActive = true
    
    -- 1. Pulisce tutto quello che esiste già
    for _, v in ipairs(workspace:GetDescendants()) do
        FreezeObject(v)
    end
    
    -- 2. Controlla ogni secondo se sono apparsi nuovi Brainrot/Giocatori
    task.spawn(function()
        while FrozenActive do
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") or v:IsA("Script") or v:IsA("LocalScript") then
                    FreezeObject(v)
                end
            end
            task.wait(1) -- Controllo ogni secondo per non laggare
        end
    end)
    
    -- Ottimizzazione materiali una tantum
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end
end

local function UltraFPSBoost()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then v:Destroy() end
    end
    
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") then
            v.RenderFidelity = Enum.RenderFidelity.Low
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v:Destroy()
        end
    end
end

-- ================================================
-- HANDLERS
-- ================================================

UltraButton.MouseButton1Click:Connect(function()
    UltraButton.Text = "FREEZING EVERYTHING..."
    UltraButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    task.spawn(function()
        StartPerpetualFreeze()
        UltraButton.Text = "AntiLag🌌 ON ✓"
    end)
end)

FPSButton.MouseButton1Click:Connect(function()
    FPSButton.Text = "MAX BOOSTING..."
    task.spawn(function()
        UltraFPSBoost()
        FPSButton.Text = "FPS MAXED ✓"
        task.wait(2)
        FPSButton.Text = "ULTRA FPS BOOSTER"
    end)
end)

-- Draggable (Mobile)
local dragging, mousePos, framePos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
