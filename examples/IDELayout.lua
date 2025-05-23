-- // IDELayout.lua - Example usage of the IDE components

-- // Xenon, this is where we put all our cool UI pieces together! It's gonna be a masterpiece!

-- // For exploit environment, direct loadstring/readfile for dependencies
local CorePath = "src/Core/";
local ComponentsPath = "src/Components/";
local ThemesPath = "src/Themes/";

local Component;
local StyleManager;
local AnimationUtil;
local CodeEditor;
local AIChatPanel;
local Button;
local Tab;
local Toggle;

-- // Load core modules
pcall(function() Component = loadstring(readfile(CorePath .. "Component.lua"))() end);
pcall(function() StyleManager = loadstring(readfile(CorePath .. "StyleManager.lua"))() end);
pcall(function() AnimationUtil = loadstring(readfile(CorePath .. "AnimationUtil.lua"))() end);

-- // Load components
pcall(function() CodeEditor = loadstring(readfile(ComponentsPath .. "CodeEditor.lua"))() end);
pcall(function() AIChatPanel = loadstring(readfile(ComponentsPath .. "AIChatPanel.lua"))() end);
pcall(function() Button = loadstring(readfile(ComponentsPath .. "Button.lua"))() end);
pcall(function() Tab = loadstring(readfile(ComponentsPath .. "Tab.lua"))() end);
pcall(function() Toggle = loadstring(readfile(ComponentsPath .. "Toggle.lua"))() end);

if not (Component and StyleManager and AnimationUtil and CodeEditor and AIChatPanel and Button and Tab and Toggle) then
    warn("IDELayout: One or more modules failed to load! UI might not work as expected.");
    return { mount = function() print("Cannot mount IDE due to load errors.") end };
end

local IDELayout = {};

function IDELayout.mount()
    -- // Get the proper parent for our UI
    local parent = (syn and syn.protect_gui) or (gethui) or (get_hidden_gui) or (hiddenUI) or game:GetService("CoreGui");
    
    -- // Create our ScreenGui with protection if available
    local gui = Instance.new("ScreenGui");
    gui.Name = "IDE_" .. tostring(math.random(1000, 9999)); -- // Random name to avoid conflicts
    gui.ResetOnSpawn = false;
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    
    -- // Apply protection if available
    if syn and syn.protect_gui then
        syn.protect_gui(gui);
        gui.Parent = game:GetService("CoreGui");
    elseif gethui then
        gui.Parent = gethui();
    else
        gui.Parent = parent;
    end

    -- // Load the theme
    pcall(function() StyleManager.loadTheme(ThemesPath .. "MidnightPurple.lua") end);
    
    -- // Main container
    local mainContainer = Instance.new("Frame");
    mainContainer.Name = "MainContainer";
    mainContainer.Size = UDim2.new(0.8, 0, 0.8, 0);
    mainContainer.Position = UDim2.new(0.1, 0, 0.1, 0);
    mainContainer.BackgroundColor3 = Color3.fromRGB(20, 18, 30);
    mainContainer.BorderSizePixel = 0;
    mainContainer.Parent = gui;

    -- // Add corner rounding
    local corner = Instance.new("UICorner");
    corner.CornerRadius = UDim.new(0, 8);
    corner.Parent = mainContainer;

    -- // Create Code Editor
    local editor = CodeEditor.new();
    editor.instance.Parent = mainContainer;
    editor.instance.Size = UDim2.new(0.65, 0, 0.9, -40);
    editor.instance.Position = UDim2.new(0.025, 0, 0.025, 0);

    -- // Create AI Chat Panel
    local chatPanel = AIChatPanel.new();
    chatPanel.instance.Parent = mainContainer;
    chatPanel.instance.Size = UDim2.new(0.275, 0, 0.9, -40);
    chatPanel.instance.Position = UDim2.new(0.7, 0, 0.025, 0);

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
    local runButton = Button.new("Run Script", function()
        local scriptContent = editor:getText();
        local func, err = loadstring(scriptContent);
        if func then
            chatPanel:addMessage("Executing script...", "System");
            local s, e = pcall(func);
            if not s then
                chatPanel:addMessage("Error: " .. tostring(e), "System");
            else
                chatPanel:addMessage("Script executed successfully!", "System");
            end
        else
            chatPanel:addMessage("Syntax Error: " .. tostring(err), "System");
        end
    end);
    runButton.instance.Size = UDim2.new(0, 100, 0, 25);
    runButton.instance.Position = UDim2.new(0, 5, 0, 2.5);
    runButton.instance.Parent = bottomBar;

    -- // Theme toggle
    local themeToggle = Toggle.new(true, function(isToggled)
        chatPanel:addMessage("Theme: " .. (isToggled and "Dark" or "Still Dark"), "System");
    end);
    themeToggle.instance.Position = UDim2.new(0, 120, 0, 2.5);
    themeToggle.instance.Parent = bottomBar;

    -- // Make draggable
    local dragging;
    local dragStart;
    local startPos;

    mainContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true;
            dragStart = input.Position;
            startPos = mainContainer.Position;
        end
    end);

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart;
            mainContainer.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            );
        end
    end);

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false;
        end
    end);

    print("ide layout mounted successfully");
    return { parent = gui, editor = editor, chat = chatPanel };
end;

return IDELayout;