-- // IDELayout.lua - Example usage of the IDE components

-- // Xenon, this is where we put all our cool UI pieces together! It's gonna be a masterpiece!

local function safeRequire(path)
    local success, module = pcall(function()
        return loadstring(readfile(path))();
    end);
    if not success then
        warn("Failed to load " .. path .. ": " .. tostring(module));
        return nil;
    end;
    return module;
end;

-- // Load dependencies
local Component = safeRequire("src/Core/Component.lua");
local StyleManager = safeRequire("src/Core/StyleManager.lua");
local AnimationUtil = safeRequire("src/Core/AnimationUtil.lua");
local CodeEditor = safeRequire("src/Components/CodeEditor.lua");
local AIChatPanel = safeRequire("src/Components/AIChatPanel.lua");
local Button = safeRequire("src/Components/Button.lua");
local Tab = safeRequire("src/Components/Tab.lua");
local Toggle = safeRequire("src/Components/Toggle.lua");

if not (Component and StyleManager) then
    error("Failed to load core modules");
end;

local IDELayout = {};

function IDELayout.mount()
    -- // Create protected ScreenGui
    local gui = Instance.new("ScreenGui");
    gui.Name = "IDE_" .. tostring(math.random(1000, 9999));
    gui.ResetOnSpawn = false;
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    gui.DisplayOrder = 999; -- // Try to stay on top
    
    -- // Apply protection
    if syn and syn.protect_gui then
        syn.protect_gui(gui);
        gui.Parent = game:GetService("CoreGui");
    else
        local parent = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or game:GetService("CoreGui");
        gui.Parent = parent;
    end;

    -- // Create main container with safe zone padding
    local safeContainer = Instance.new("Frame");
    safeContainer.Name = "SafeContainer";
    safeContainer.Size = UDim2.new(1, 0, 1, 0);
    safeContainer.BackgroundTransparency = 1;
    safeContainer.Parent = gui;

    local mainContainer = Instance.new("Frame");
    mainContainer.Name = "MainContainer";
    mainContainer.Size = UDim2.new(0.8, 0, 0.8, 0);
    mainContainer.Position = UDim2.new(0.1, 0, 0.1, 0);
    mainContainer.BackgroundColor3 = Color3.fromRGB(20, 18, 30);
    mainContainer.BorderSizePixel = 0;
    mainContainer.Parent = safeContainer;

    -- // Add corner rounding
    local corner = Instance.new("UICorner");
    corner.CornerRadius = UDim.new(0, 8);
    corner.Parent = mainContainer;

    -- // Add shadow
    local shadow = Instance.new("ImageLabel");
    shadow.Name = "Shadow";
    shadow.AnchorPoint = Vector2.new(0.5, 0.5);
    shadow.BackgroundTransparency = 1;
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0);
    shadow.Size = UDim2.new(1, 40, 1, 40);
    shadow.ZIndex = -1;
    shadow.Image = "rbxassetid://6014257812";
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0);
    shadow.ImageTransparency = 0.5;
    shadow.Parent = mainContainer;

    -- // Create components with error handling
    local editor = CodeEditor and CodeEditor.new();
    if editor then
        editor.instance.Parent = mainContainer;
        editor.instance.Size = UDim2.new(0.65, 0, 0.9, -40);
        editor.instance.Position = UDim2.new(0.025, 0, 0.025, 0);
    end;

    local chatPanel = AIChatPanel and AIChatPanel.new();
    if chatPanel then
        chatPanel.instance.Parent = mainContainer;
        chatPanel.instance.Size = UDim2.new(0.275, 0, 0.9, -40);
        chatPanel.instance.Position = UDim2.new(0.7, 0, 0.025, 0);
    end;

    -- // Bottom bar
    local bottomBar = Instance.new("Frame");
    bottomBar.Name = "BottomBar";
    bottomBar.Size = UDim2.new(0.95, 0, 0, 30);
    bottomBar.Position = UDim2.new(0.025, 0, 0.95, -15);
    bottomBar.BackgroundColor3 = Color3.fromRGB(30, 28, 45);
    bottomBar.BorderSizePixel = 0;
    bottomBar.Parent = mainContainer;

    local corner2 = Instance.new("UICorner");
    corner2.CornerRadius = UDim.new(0, 6);
    corner2.Parent = bottomBar;

    -- // Run button
    if Button then
        local runButton = Button.new("Run Script", function()
            if editor then
                local scriptContent = editor:getText();
                local func, err = loadstring(scriptContent);
                if func then
                    if chatPanel then chatPanel:addMessage("Executing script...", "System") end;
                    local s, e = pcall(func);
                    if not s then
                        if chatPanel then chatPanel:addMessage("Error: " .. tostring(e), "System") end;
                    else
                        if chatPanel then chatPanel:addMessage("Script executed successfully!", "System") end;
                    end;
                else
                    if chatPanel then chatPanel:addMessage("Syntax Error: " .. tostring(err), "System") end;
                end;
            end;
        end);
        if runButton then
            runButton.instance.Size = UDim2.new(0, 100, 0, 25);
            runButton.instance.Position = UDim2.new(0, 5, 0, 2.5);
            runButton.instance.Parent = bottomBar;
        end;
    end;

    -- // Theme toggle
    if Toggle then
        local themeToggle = Toggle.new(true, function(isToggled)
            if chatPanel then
                chatPanel:addMessage("Theme: " .. (isToggled and "Dark" or "Still Dark"), "System");
            end;
        end);
        if themeToggle then
            themeToggle.instance.Position = UDim2.new(0, 120, 0, 2.5);
            themeToggle.instance.Parent = bottomBar;
        end;
    end;

    -- // Make draggable
    local dragging = false;
    local dragStart = nil;
    local startPos = nil;

    local function updateDrag(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart;
            local newPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            );
            mainContainer.Position = newPosition;
        end;
    end;

    mainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true;
            dragStart = input.Position;
            startPos = mainContainer.Position;
        end;
    end);

    game:GetService("UserInputService").InputChanged:Connect(updateDrag);

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false;
            dragStart = nil;
            startPos = nil;
        end;
    end);

    print("IDE layout mounted successfully");
    return {
        parent = gui,
        editor = editor,
        chat = chatPanel,
        destroy = function()
            gui:Destroy();
        end
    };
end;

return IDELayout;