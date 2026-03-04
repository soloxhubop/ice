-- ================================================
-- MELOSKA ANTI LAG - BRAINROT STOPPER EDITION
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================================================
-- MAIN GUI (CENTRATA E OTTIMIZZATA PER MOBILE)
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

-- Titolo
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Meloska ANTI LAG"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Bottoni (Dettaglio Anim Off rimosso)
local UltraButton = Instance.new("TextButton", MainFrame)
UltraButton.Size = UDim2.new(0.9, 0, 0, 30)
UltraButton.Position = UDim2.new(0.05, 0, 0, 35)
UltraButton.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
UltraButton.Text = "AntiLag🥵" -- Testo pulito come richiesto
UltraButton.Font = Enum.Font.GothamBold
UltraButton.TextSize = 9
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
-- FUNZIONI POTENZIATE
-- ================================================

local function StopAllAnimations()
    -- Ferma ogni animazione presente nel gioco (NPC e Players)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") then
            -- Rimuove l'oggetto Animator (blocca nuove animazioni)
            local animator = obj:FindFirstChildOfClass("Animator")
            if animator then animator:Destroy() end
            
            -- Forza lo stop immediato di quelle in corso
            for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
        end
        
        -- Blocca gli script di movimento tipici dei Brainrot
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            if obj.Name == "Animate" or obj.Name == "AnimationHandler" or obj.Name == "Mover" then
                obj.Disabled = true
            end
        end
    end
    
    -- Ottimizzazione materiali per recuperare FPS
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") then
            pcall(function() v:Destroy() end)
        end
    end
end

local function UltraFPSBoost()
    -- Impostazioni estreme per Mobile
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    -- Rimuove decorazioni del cielo e atmosfera pesante
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
            v:Destroy()
        end
    end
    
    -- Abbassa la fedeltà delle Mesh
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") then
            v.RenderFidelity = Enum.RenderFidelity.Low
            v.Reflectance = 0
        end
    end
end

-- ================================================
-- HANDLERS & DRAG (MOBILE FRIENDLY)
-- ================================================

UltraButton.MouseButton1Click:Connect(function()
    UltraButton.Text = "FREEZING EVERYTHING..."
    task.spawn(function()
        StopAllAnimations()
        UltraButton.Text = "ALL FROZEN ✓"
        task.wait(2)
        UltraButton.Text = "AntiLag🥵"
    end)
end)

FPSButton.MouseButton1Click:Connect(function()
    FPSButton.Text = "MAX BOOSTING..."
    task.spawn(function()
        UltraFPSBoost()
        FPSButton.Text = "MAX PERFORMANCE ✓"
        task.wait(2)
        FPSButton.Text = "ULTRA FPS BOOSTER"
    end)
end)

-- Sistema di trascinamento compatibile con il Touch dei telefoni
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

print("Meloska Anti-Lag (No-Detail Version) Loaded!")
