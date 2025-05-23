-- // direct_loader.lua - Minimal single-file loader for debugging

local repo = "testing2122/RobloxModularUI-IDE";
local branch = "main";

local function ghraw(path)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s", repo, branch, path);
end;

local function fetch(path)
    local success, content = pcall(function()
        return game:HttpGet(ghraw(path));
    end);
    if not success then
        warn("Failed to fetch " .. path);
        return nil;
    end;
    return content;
end;

-- // Setup UI directly
local function createUI()
    -- // Create ScreenGui
    local gui = Instance.new("ScreenGui");
    gui.Name = "IDE_" .. tostring(math.random(1000, 9999));
    gui.ResetOnSpawn = false;
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    gui.DisplayOrder = 999;
    
    -- // Apply protection if possible
    if syn and syn.protect_gui then
        syn.protect_gui(gui);
        gui.Parent = game:GetService("CoreGui");
    elseif gethui then
        gui.Parent = gethui();
    elseif get_hidden_gui then
        gui.Parent = get_hidden_gui();
    else
        gui.Parent = game:GetService("CoreGui");
    end;

    -- // Create main container
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

    -- // Add title bar
    local titleBar = Instance.new("Frame");
    titleBar.Name = "TitleBar";
    titleBar.Size = UDim2.new(1, 0, 0, 30);
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 35, 60);
    titleBar.BorderSizePixel = 0;
    titleBar.Parent = mainContainer;

    local titleCorner = Instance.new("UICorner");
    titleCorner.CornerRadius = UDim.new(0, 8);
    titleCorner.Parent = titleBar;

    local titleText = Instance.new("TextLabel");
    titleText.Name = "Title";
    titleText.Size = UDim2.new(1, -10, 1, 0);
    titleText.Position = UDim2.new(0, 10, 0, 0);
    titleText.BackgroundTransparency = 1;
    titleText.Text = "Roblox Modular IDE";
    titleText.TextColor3 = Color3.fromRGB(240, 230, 255);
    titleText.Font = Enum.Font.GothamBold;
    titleText.TextSize = 16;
    titleText.TextXAlignment = Enum.TextXAlignment.Left;
    titleText.Parent = titleBar;

    -- // Add code editor
    local editorFrame = Instance.new("Frame");
    editorFrame.Name = "EditorFrame";
    editorFrame.Size = UDim2.new(0.65, 0, 0.9, -40);
    editorFrame.Position = UDim2.new(0.025, 0, 0.06, 10);
    editorFrame.BackgroundColor3 = Color3.fromRGB(30, 28, 45);
    editorFrame.BorderSizePixel = 0;
    editorFrame.Parent = mainContainer;

    local editorCorner = Instance.new("UICorner");
    editorCorner.CornerRadius = UDim.new(0, 6);
    editorCorner.Parent = editorFrame;

    local codeTextBox = Instance.new("TextBox");
    codeTextBox.Name = "CodeInput";
    codeTextBox.Size = UDim2.new(1, -20, 1, -20);
    codeTextBox.Position = UDim2.new(0, 10, 0, 10);
    codeTextBox.BackgroundColor3 = Color3.fromRGB(25, 23, 40);
    codeTextBox.BorderSizePixel = 0;
    codeTextBox.TextColor3 = Color3.fromRGB(220, 210, 255);
    codeTextBox.PlaceholderText = "-- // start coding here <3";
    codeTextBox.PlaceholderColor3 = Color3.fromRGB(120, 110, 150);
    codeTextBox.ClearTextOnFocus = false;
    codeTextBox.MultiLine = true;
    codeTextBox.TextWrapped = true;
    codeTextBox.TextXAlignment = Enum.TextXAlignment.Left;
    codeTextBox.TextYAlignment = Enum.TextYAlignment.Top;
    codeTextBox.Font = Enum.Font.Code;
    codeTextBox.TextSize = 14;
    codeTextBox.Parent = editorFrame;

    local chatFrame = Instance.new("Frame");
    chatFrame.Name = "ChatFrame";
    chatFrame.Size = UDim2.new(0.275, 0, 0.9, -40);
    chatFrame.Position = UDim2.new(0.7, 0, 0.06, 10);
    chatFrame.BackgroundColor3 = Color3.fromRGB(30, 28, 45);
    chatFrame.BorderSizePixel = 0;
    chatFrame.Parent = mainContainer;

    local chatCorner = Instance.new("UICorner");
    chatCorner.CornerRadius = UDim.new(0, 6);
    chatCorner.Parent = chatFrame;

    local chatTitle = Instance.new("TextLabel");
    chatTitle.Name = "ChatTitle";
    chatTitle.Size = UDim2.new(1, 0, 0, 30);
    chatTitle.BackgroundColor3 = Color3.fromRGB(40, 35, 60);
    chatTitle.BorderSizePixel = 0;
    chatTitle.Text = "AI Chat";
    chatTitle.TextColor3 = Color3.fromRGB(220, 210, 255);
    chatTitle.Font = Enum.Font.GothamBold;
    chatTitle.TextSize = 14;
    chatTitle.Parent = chatFrame;

    local chatTitleCorner = Instance.new("UICorner");
    chatTitleCorner.CornerRadius = UDim.new(0, 6);
    chatTitleCorner.Parent = chatTitle;

    local chatDisplayFrame = Instance.new("ScrollingFrame");
    chatDisplayFrame.Name = "ChatDisplay";
    chatDisplayFrame.Size = UDim2.new(1, -20, 1, -80);
    chatDisplayFrame.Position = UDim2.new(0, 10, 0, 40);
    chatDisplayFrame.BackgroundColor3 = Color3.fromRGB(25, 23, 40);
    chatDisplayFrame.BorderSizePixel = 0;
    chatDisplayFrame.ScrollBarThickness = 6;
    chatDisplayFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    chatDisplayFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    chatDisplayFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    chatDisplayFrame.Parent = chatFrame;

    local chatDisplayCorner = Instance.new("UICorner");
    chatDisplayCorner.CornerRadius = UDim.new(0, 4);
    chatDisplayCorner.Parent = chatDisplayFrame;

    local chatLayout = Instance.new("UIListLayout");
    chatLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    chatLayout.Padding = UDim.new(0, 5);
    chatLayout.Parent = chatDisplayFrame;

    local chatPadding = Instance.new("UIPadding");
    chatPadding.PaddingTop = UDim.new(0, 5);
    chatPadding.PaddingBottom = UDim.new(0, 5);
    chatPadding.PaddingLeft = UDim.new(0, 5);
    chatPadding.PaddingRight = UDim.new(0, 5);
    chatPadding.Parent = chatDisplayFrame;

    -- // Add a welcome message
    local welcomeMsg = Instance.new("Frame");
    welcomeMsg.Name = "WelcomeMessage";
    welcomeMsg.Size = UDim2.new(1, -10, 0, 40);
    welcomeMsg.BackgroundColor3 = Color3.fromRGB(60, 50, 80);
    welcomeMsg.BorderSizePixel = 0;
    welcomeMsg.Parent = chatDisplayFrame;

    local welcomeCorner = Instance.new("UICorner");
    welcomeCorner.CornerRadius = UDim.new(0, 4);
    welcomeCorner.Parent = welcomeMsg;

    local welcomeText = Instance.new("TextLabel");
    welcomeText.Name = "Text";
    welcomeText.Size = UDim2.new(1, -10, 1, -10);
    welcomeText.Position = UDim2.new(0, 5, 0, 5);
    welcomeText.BackgroundTransparency = 1;
    welcomeText.Text = "Welcome to the IDE! Type your code on the left.";
    welcomeText.TextColor3 = Color3.fromRGB(220, 210, 255);
    welcomeText.Font = Enum.Font.Gotham;
    welcomeText.TextSize = 12;
    welcomeText.TextWrapped = true;
    welcomeText.TextXAlignment = Enum.TextXAlignment.Left;
    welcomeText.Parent = welcomeMsg;

    -- // Add bottom bar with buttons
    local bottomBar = Instance.new("Frame");
    bottomBar.Name = "BottomBar";
    bottomBar.Size = UDim2.new(0.95, 0, 0, 30);
    bottomBar.Position = UDim2.new(0.025, 0, 0.95, -15);
    bottomBar.BackgroundColor3 = Color3.fromRGB(30, 28, 45);
    bottomBar.BorderSizePixel = 0;
    bottomBar.Parent = mainContainer;

    local bottomCorner = Instance.new("UICorner");
    bottomCorner.CornerRadius = UDim.new(0, 6);
    bottomCorner.Parent = bottomBar;

    -- // Run button
    local runButton = Instance.new("TextButton");
    runButton.Name = "RunButton";
    runButton.Size = UDim2.new(0, 100, 0, 25);
    runButton.Position = UDim2.new(0, 5, 0, 2.5);
    runButton.BackgroundColor3 = Color3.fromRGB(100, 80, 220);
    runButton.Text = "Run Script";
    runButton.TextColor3 = Color3.fromRGB(240, 240, 250);
    runButton.Font = Enum.Font.GothamBold;
    runButton.TextSize = 14;
    runButton.BorderSizePixel = 0;
    runButton.AutoButtonColor = true;
    runButton.Parent = bottomBar;

    local runCorner = Instance.new("UICorner");
    runCorner.CornerRadius = UDim.new(0, 4);
    runCorner.Parent = runButton;

    -- // Add execute functionality
    runButton.MouseButton1Click:Connect(function()
        local code = codeTextBox.Text;
        if code and code ~= "" then
            -- // Add message to chat display
            local msg = welcomeMsg:Clone();
            msg.Name = "SystemMessage";
            msg.BackgroundColor3 = Color3.fromRGB(80, 70, 120);
            msg.LayoutOrder = 1;
            msg.Parent = chatDisplayFrame;
            
            msg.Text.Text = "Executing script...";
            
            -- // Actually run the script
            local success, result = pcall(function()
                return loadstring(code)();
            end);
            
            if not success then
                local errorMsg = welcomeMsg:Clone();
                errorMsg.Name = "ErrorMessage";
                errorMsg.BackgroundColor3 = Color3.fromRGB(180, 70, 70);
                errorMsg.LayoutOrder = 2;
                errorMsg.Parent = chatDisplayFrame;
                
                errorMsg.Text.Text = "Error: " .. tostring(result);
            else
                local successMsg = welcomeMsg:Clone();
                successMsg.Name = "SuccessMessage";
                successMsg.BackgroundColor3 = Color3.fromRGB(70, 180, 90);
                successMsg.LayoutOrder = 2;
                successMsg.Parent = chatDisplayFrame;
                
                successMsg.Text.Text = "Script executed successfully!";
            end;
            
            -- // Scroll to bottom
            chatDisplayFrame.CanvasPosition = Vector2.new(0, chatDisplayFrame.CanvasSize.Y.Offset);
        end;
    end);

    -- // Make the UI draggable
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

    titleBar.InputBegan:Connect(function(input)
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

    -- // Add glow effect
    local glow = Instance.new("ImageLabel");
    glow.Name = "Glow";
    glow.BackgroundTransparency = 1;
    glow.Image = "rbxassetid://5028857084"; -- // Radial gradient image
    glow.ImageColor3 = Color3.fromRGB(111, 80, 255);
    glow.ImageTransparency = 0.8;
    glow.Size = UDim2.new(1.5, 0, 1.5, 0);
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0);
    glow.ZIndex = -2;
    glow.Parent = mainContainer;

    return {
        gui = gui,
        codeEditor = codeTextBox,
        chatDisplay = chatDisplayFrame,
        container = mainContainer
    };
end;

-- // Create minimal UI
local ui = createUI();
print("Direct UI loaded - minimal UI created");
