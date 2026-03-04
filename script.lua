-- ================================================
-- MELOSKA ANTI LAG - CLEANED & BALANCED VERSION
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================================
-- CONFIG (BILANCIATA PER NON BLOCCARE IL GAMEPLAY)
-- ================================================
local CONFIG = {
    FPS_TARGET = 60,
    DESTROY_VFX = true,           -- Disabilita effetti particellari
    DESTROY_ANIMATIONS = false,   -- FALSO: Necessario per rubare/interagire
    DESTROY_UNUSED_MODELS = true, 
    OPTIMIZE_RENDER = true,       
    DISABLE_SHADOWS = true,       
}

-- ================================================
-- MAIN GUI (FIXED PER MOBILE & TABLET)
-- ================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeloskaAntiLag_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"

-- FIX POSIZIONE: AnchorPoint e Position centrata (50%)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 

MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Parent = MainFrame

-- Title: Meloska ANTI LAG
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Meloska ANTI LAG"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Parent = MainFrame

-- Bottoni
local UltraButton = Instance.new("TextButton")
UltraButton.Size = UDim2.new(0.9, 0, 0, 30)
UltraButton.Position = UDim2.new(0.05, 0, 0, 35)
UltraButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
UltraButton.Text = "BALANCED ANTI-LAG"
UltraButton.Font = Enum.Font.GothamBold
UltraButton.TextSize = 10
UltraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UltraButton.Parent = MainFrame

local FPSButton = Instance.new("TextButton")
FPSButton.Size = UDim2.new(0.9, 0, 0, 30)
FPSButton.Position = UDim2.new(0.05, 0, 0, 72)
FPSButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
FPSButton.Text = "LIGHT FPS BOOST"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 10
FPSButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSButton.Parent = MainFrame

Instance.new("UICorner", UltraButton).CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", FPSButton).CornerRadius = UDim.new(0, 6)

-- ================================================
-- TRASCINAMENTO (MOBILE FRIENDLY)
-- ================================================
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

-- ================================================
-- FUNZIONI DI OTTIMIZZAZIONE (DEPOTENZIATE)
-- ================================================

local function BalancedOptimize()
    -- Disabilita Ombre e post-processing
    game:GetService("Lighting").GlobalShadows = false
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Sostituzione materiali (più veloce ma sicuro)
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        -- Disabilita particelle invece di distruggerle
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        -- Rimuove decalcomanie pesanti
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj:Destroy() end)
        end
    end
    
    -- Qualità rendering minima
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    print("[Meloska] Ottimizzazione Bilanciata Eseguita!")
end

-- ================================================
-- BUTTON HANDLERS
-- ================================================
UltraButton.MouseButton1Click:Connect(function()
    UltraButton.Text = "CLEANING..."
    UltraButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    task.spawn(function()
        BalancedOptimize()
        UltraButton.Text = "READY ✓"
        task.wait(2)
        UltraButton.Text = "BALANCED ANTI-LAG"
        UltraButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    end)
end)

FPSButton.MouseButton1Click:Connect(function()
    FPSButton.Text = "BOOSTING..."
    FPSButton.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
    task.spawn(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        FPSButton.Text = "BOOSTED ✓"
        task.wait(2)
        FPSButton.Text = "LIGHT FPS BOOST"
        FPSButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    end)
end)

-- ================================================
-- AUTO-START
-- ================================================
task.spawn(function()
    task.wait(3)
    print("Meloska ANTI LAG caricato correttamente!")
end)
