-- Violet UI Library (Rayfield Style) - УЛУЧШЕННАЯ ВЕРСИЯ
local VioletUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

-- Configuration
VioletUI.Theme = {
    Primary = Color3.fromRGB(128, 0, 255),
    Secondary = Color3.fromRGB(100, 0, 200),
    Dark = Color3.fromRGB(20, 10, 30),
    Light = Color3.fromRGB(40, 20, 60),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(180, 80, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Warning = Color3.fromRGB(255, 215, 0),
    Error = Color3.fromRGB(255, 69, 58),
    Info = Color3.fromRGB(0, 191, 255)
}

-- Notification system
VioletUI.Notifications = {
    ActiveNotifications = {},
    MaxNotifications = 5
}

function VioletUI:Notify(title, message, type, duration)
    duration = duration or 5
    type = type or "info"
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("VioletUINotifications")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "VioletUINotifications"
        ScreenGui.Parent = game:GetService("CoreGui")
        ScreenGui.ResetOnSpawn = false
    end
    
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 300, 0, 80)
    Notification.Position = UDim2.new(1, -320, 1, -100 - (#self.Notifications.ActiveNotifications * 90))
    Notification.BackgroundColor3 = self.Theme.Dark
    Notification.BorderSizePixel = 0
    Notification.ClipsDescendants = true
    Notification.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notification
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = self.Theme[type:upper()] or self.Theme.Info
    Stroke.Thickness = 2
    Stroke.Parent = Notification
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Position = UDim2.new(0, 15, 0, 15)
    Icon.BackgroundTransparency = 1
    Icon.Text = type == "success" and "✓" or type == "warning" and "⚠" or type == "error" and "✗" or "ℹ"
    Icon.TextColor3 = self.Theme[type:upper()] or self.Theme.Info
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 18
    Icon.Parent = Notification
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 0, 20)
    TitleLabel.Position = UDim2.new(0, 50, 0, 15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(1, -60, 0, 35)
    MessageLabel.Position = UDim2.new(0, 50, 0, 35)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = message
    MessageLabel.TextColor3 = self.Theme.Text
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 12
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.TextWrapped = true
    MessageLabel.Parent = Notification
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BackgroundColor3 = self.Theme[type:upper()] or self.Theme.Info
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = Notification
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 2)
    ProgressCorner.Parent = ProgressBar
    
    -- Animation
    Notification.Position = UDim2.new(1, 300, 1, -100 - (#self.Notifications.ActiveNotifications * 90))
    TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -100 - (#self.Notifications.ActiveNotifications * 90))
    }):Play()
    
    table.insert(self.Notifications.ActiveNotifications, Notification)
    
    -- Progress animation
    local progressTween = TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    progressTween:Play()
    
    -- Auto remove
    task.delay(duration, function()
        if Notification and Notification.Parent then
            TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, 300, Notification.Position.Y.Scale, Notification.Position.Y.Offset)
            }):Play()
            task.wait(0.3)
            Notification:Destroy()
            
            for i, notif in ipairs(self.Notifications.ActiveNotifications) do
                if notif == Notification then
                    table.remove(self.Notifications.ActiveNotifications, i)
                    break
                end
            end
            
            -- Update positions of remaining notifications
            for i, notif in ipairs(self.Notifications.ActiveNotifications) do
                TweenService:Create(notif, TweenInfo.new(0.2), {
                    Position = UDim2.new(1, -320, 1, -100 - ((i-1) * 90))
                }):Play()
            end
        end
    end)
    
    -- Click to close
    Notification.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Notification and Notification.Parent then
                TweenService:Create(Notification, TweenInfo.new(0.3), {
                    Position = UDim2.new(1, 300, Notification.Position.Y.Scale, Notification.Position.Y.Offset)
                }):Play()
                task.wait(0.3)
                Notification:Destroy()
                
                for i, notif in ipairs(self.Notifications.ActiveNotifications) do
                    if notif == Notification then
                        table.remove(self.Notifications.ActiveNotifications, i)
                        break
                    end
                end
            end
        end
    end)
    
    return Notification
end

-- Enhanced animation functions
local function enhancedButtonHoverAnimation(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = VioletUI.Theme.Accent,
            Size = button.Size + UDim2.new(0, 4, 0, 4)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = VioletUI.Theme.Primary,
            Size = button.Size - UDim2.new(0, 4, 0, 4)
        }):Play()
    end)
end

local function enhancedButtonClickAnimation(button)
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = button.Size - UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = VioletUI.Theme.Secondary
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = button.Size + UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = VioletUI.Theme.Primary
        }):Play()
    end)
end

-- Create main UI (остальной код остается таким же, но с улучшенными анимациями)
function VioletUI:CreateWindow(name)
    local VioletLib = {}
    local dragging = false
    local dragInput, dragStart, startPos
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VioletUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame with glow effect
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = VioletUI.Theme.Dark
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(1, 20, 1, 20)
    Glow.Position = UDim2.new(0, -10, 0, -10)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://4996893970"
    Glow.ImageColor3 = VioletUI.Theme.Primary
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(49, 49, 450, 450)
    Glow.Parent = MainFrame
    
    -- Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    -- Остальной код остается таким же, но заменяем:
    -- buttonHoverAnimation на enhancedButtonHoverAnimation
    -- buttonClickAnimation на enhancedButtonClickAnimation

    -- В конце функции добавляем:
    function VioletLib:Notify(title, message, type, duration)
        return VioletUI:Notify(title, message, type, duration)
    end

    return VioletLib
end

-- Error handling wrapper
function VioletUI:CreateSafeWindow(name)
    local success, result = pcall(function()
        return self:CreateWindow(name)
    end)
    
    if not success then
        self:Notify("Ошибка", "Не удалось создать окно: " .. result, "error", 5)
        return nil
    end
    
    return result
end

return VioletUI
