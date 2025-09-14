-- Violet UI Library (Rayfield Style)
local VioletUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Configuration
VioletUI.Theme = {
    Primary = Color3.fromRGB(128, 0, 255),
    Secondary = Color3.fromRGB(100, 0, 200),
    Dark = Color3.fromRGB(20, 10, 30),
    Light = Color3.fromRGB(40, 20, 60),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(180, 80, 255)
}

-- Create main UI
function VioletUI:CreateWindow(name)
    local VioletLib = {}
    local dragging = false
    local dragInput, dragStart, startPos
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VioletUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = VioletUI.Theme.Dark
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = VioletUI.Theme.Light
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = name
    Title.TextColor3 = VioletUI.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = VioletUI.Theme.Primary
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = VioletUI.Theme.Text
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    MinimizeBtn.BackgroundColor3 = VioletUI.Theme.Secondary
    MinimizeBtn.Text = "_"
    MinimizeBtn.TextColor3 = VioletUI.Theme.Text
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Parent = Header
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeBtn
    
    -- Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Size = UDim2.new(1, -20, 0, 30)
    TabsContainer.Position = UDim2.new(0, 10, 0, 50)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Parent = MainFrame
    
    -- Content Container
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Size = UDim2.new(1, -20, 1, -90)
    ContentContainer.Position = UDim2.new(0, 10, 0, 90)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ScrollBarThickness = 3
    ContentContainer.ScrollBarImageColor3 = VioletUI.Theme.Primary
    ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ContentContainer
    
    -- Animation functions
    local function buttonHoverAnimation(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = VioletUI.Theme.Accent}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = VioletUI.Theme.Primary}):Play()
        end)
    end
    
    local function buttonClickAnimation(button)
        local originalSize = button.Size
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize - UDim2.new(0, 4, 0, 4)}):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
        end)
    end
    
    -- Apply animations
    buttonHoverAnimation(CloseBtn)
    buttonClickAnimation(CloseBtn)
    buttonHoverAnimation(MinimizeBtn)
    buttonClickAnimation(MinimizeBtn)
    
    -- Dragging functionality
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                          startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close button functionality
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize button functionality
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 40)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 400)}):Play()
        end
    end)
    
    -- Tabs system
    local tabs = {}
    local currentTab = nil
    
    function VioletLib:CreateTab(name)
        local tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = VioletUI.Theme.Secondary
        TabButton.Text = name
        TabButton.TextColor3 = VioletUI.Theme.Text
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.Parent = TabsContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.Padding = UDim.new(0, 10)
        TabListLayout.Parent = TabContent
        
        -- Tab animations
        buttonHoverAnimation(TabButton)
        buttonClickAnimation(TabButton)
        
        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            TabContent.Visible = true
            currentTab = TabContent
            
            -- Highlight active tab
            for _, btn in pairs(TabsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = (btn == TabButton) and VioletUI.Theme.Primary or VioletUI.Theme.Secondary
                    }):Play()
                end
            end
        end)
        
        -- First tab is active by default
        if not currentTab then
            TabContent.Visible = true
            currentTab = TabContent
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = VioletUI.Theme.Primary
            }):Play()
        end
        
        function tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = VioletUI.Theme.Primary
            Button.Text = text
            Button.TextColor3 = VioletUI.Theme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            -- Animations
            buttonHoverAnimation(Button)
            buttonClickAnimation(Button)
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        function tab:CreateToggle(text, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 30)
            Toggle.BackgroundTransparency = 1
            Toggle.Parent = TabContent
            
            local ToggleText = Instance.new("TextLabel")
            ToggleText.Size = UDim2.new(0, 200, 1, 0)
            ToggleText.BackgroundTransparency = 1
            ToggleText.Text = text
            ToggleText.TextColor3 = VioletUI.Theme.Text
            ToggleText.Font = Enum.Font.Gotham
            ToggleText.TextSize = 14
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 25)
            ToggleButton.Position = UDim2.new(1, -50, 0, 2)
            ToggleButton.BackgroundColor3 = default and VioletUI.Theme.Primary or VioletUI.Theme.Secondary
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 12)
            ToggleCorner.Parent = ToggleButton
            
            local ToggleState = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = ToggleState and VioletUI.Theme.Primary or VioletUI.Theme.Secondary
                }):Play()
                
                if callback then
                    callback(ToggleState)
                end
            end)
            
            return Toggle
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, 60)
            Slider.BackgroundTransparency = 1
            Slider.Parent = TabContent
            
            local SliderText = Instance.new("TextLabel")
            SliderText.Size = UDim2.new(1, 0, 0, 20)
            SliderText.BackgroundTransparency = 1
            SliderText.Text = text .. ": " .. default
            SliderText.TextColor3 = VioletUI.Theme.Text
            SliderText.Font = Enum.Font.Gotham
            SliderText.TextSize = 14
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.Parent = Slider
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, 0, 0, 10)
            SliderTrack.Position = UDim2.new(0, 0, 0, 30)
            SliderTrack.BackgroundColor3 = VioletUI.Theme.Secondary
            SliderTrack.Parent = Slider
            
            local SliderTrackCorner = Instance.new("UICorner")
            SliderTrackCorner.CornerRadius = UDim.new(0, 5)
            SliderTrackCorner.Parent = SliderTrack
            
            local SliderThumb = Instance.new("Frame")
            SliderThumb.Size = UDim2.new(0, 20, 0, 20)
            SliderThumb.Position = UDim2.new((default - min) / (max - min), -10, 0, 25)
            SliderThumb.BackgroundColor3 = VioletUI.Theme.Primary
            SliderThumb.Parent = Slider
            
            local SliderThumbCorner = Instance.new("UICorner")
            SliderThumbCorner.CornerRadius = UDim.new(0, 10)
            SliderThumbCorner.Parent = SliderThumb
            
            local dragging = false
            
            SliderThumb.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderThumb.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    SliderThumb.Position = UDim2.new(pos, -10, 0, 25)
                    SliderText.Text = text .. ": " .. value
                    
                    if callback then
                        callback(value)
                    end
                end
            end)
            
            return Slider
        end
        
        return tab
    end
    
    -- Hotkeys
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.RightShift then
                MainFrame.Visible = not MainFrame.Visible
            elseif input.KeyCode == Enum.KeyCode.Insert then
                if isMinimized then
                    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 400)}):Play()
                    isMinimized = false
                else
                    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 40)}):Play()
                    isMinimized = true
                end
            end
        end
    end)
    
    return VioletLib
end

return VioletUI
