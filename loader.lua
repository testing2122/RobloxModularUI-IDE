-- // loader.lua - Direct GitHub loader for the UI system

-- // Basic error handling and environment setup
local function safeCall(func, ...)
    local success, result = pcall(func, ...);
    if not success then
        warn("Error: " .. tostring(result));
        return nil;
    end;
    return result;
end;

-- // Setup secure environment
local env = getgenv();
local oldReadfile = env.readfile;
local oldHttpGet = game.HttpGet;

-- // Repository info
local repo = "testing2122/RobloxModularUI-IDE";
local branch = "main";

local function ghraw(path)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s", repo, branch, path);
end;

local function fetchmodule(path)
    local success, content = pcall(function()
        return oldHttpGet(game, ghraw(path));
    end);
    if not success then
        warn("Failed to fetch " .. path .. ": " .. tostring(content));
        return nil;
    end;
    return content;
end;

-- // Module paths
local modules = {
    core = {
        component = "src/Core/Component.lua",
        style = "src/Core/StyleManager.lua",
        anim = "src/Core/AnimationUtil.lua"
    },
    components = {
        editor = "src/Components/CodeEditor.lua",
        chat = "src/Components/AIChatPanel.lua",
        btn = "src/Components/Button.lua",
        tab = "src/Components/Tab.lua",
        toggle = "src/Components/Toggle.lua"
    },
    theme = "src/Themes/MidnightPurple.lua",
    layout = "examples/IDELayout.lua"
};

-- // Virtual filesystem
local vfs = {};

-- // Setup environment
local function setupEnv()
    -- // Override readfile to use our virtual filesystem
    env.readfile = function(path)
        if vfs[path] then return vfs[path] end;
        return oldReadfile(path);
    end;

    -- // Ensure we have required functions
    if not env.gethui and not env.get_hidden_gui and not env.hiddenUI then
        warn("No hidden UI function found - UI might be detected");
    end;

    -- // Basic protection
    if env.syn and env.syn.protect_gui then
        print("Synapse X protection available");
    end;
end;

-- // Main initialization
local function init()
    setupEnv();
    print("Fetching modules...");

    -- // Fetch core modules
    for k, path in pairs(modules.core) do
        local content = fetchmodule(path);
        if content then
            vfs[path] = content;
            print("Fetched " .. k);
        end;
    end;

    -- // Fetch components
    for k, path in pairs(modules.components) do
        local content = fetchmodule(path);
        if content then
            vfs[path] = content;
            print("Fetched " .. k);
        end;
    end;

    -- // Fetch theme and layout
    local theme = fetchmodule(modules.theme);
    if theme then
        vfs[modules.theme] = theme;
        print("Fetched theme");
    end;

    local layout = fetchmodule(modules.layout);
    if layout then
        vfs[modules.layout] = layout;
        print("Fetched layout");
    end;

    -- // Load and mount UI
    print("Initializing UI...");
    local ideLayout = safeCall(function()
        return loadstring(vfs[modules.layout])();
    end);

    if ideLayout then
        print("Mounting UI...");
        safeCall(function()
            -- // Create protected environment for UI execution
            local env = setmetatable({
                game = game,
                Instance = Instance,
                Vector2 = Vector2,
                Vector3 = Vector3,
                UDim2 = UDim2,
                UDim = UDim,
                Color3 = Color3,
                Enum = Enum,
                warn = warn,
                print = print,
                error = error,
                pcall = pcall,
                pairs = pairs,
                ipairs = ipairs,
                next = next,
                type = type,
                typeof = typeof,
                tostring = tostring,
                tonumber = tonumber,
                table = table,
                string = string,
                math = math,
                task = task,
                wait = wait,
                spawn = spawn,
                delay = delay,
                gethui = gethui or get_hidden_gui or function() return game:GetService("CoreGui") end,
                syn = syn,
            }, {__index = getfenv(0)});
            
            setfenv(ideLayout.mount, env);
            ideLayout.mount();
        end);
    else
        warn("Failed to initialize UI");
    end;
end;

-- // Run initialization
xpcall(init, function(err)
    warn("Critical error during initialization:");
    warn(debug.traceback(err));
    
    -- // Display error GUI
    local gui = Instance.new("ScreenGui");
    if syn and syn.protect_gui then syn.protect_gui(gui) end;
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui");
    
    local frame = Instance.new("Frame");
    frame.Size = UDim2.new(0, 300, 0, 100);
    frame.Position = UDim2.new(0.5, -150, 0.5, -50);
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
    frame.BorderSizePixel = 0;
    frame.Parent = gui;
    
    local text = Instance.new("TextLabel");
    text.Size = UDim2.new(1, -20, 1, -20);
    text.Position = UDim2.new(0, 10, 0, 10);
    text.Text = "Failed to load UI: " .. tostring(err);
    text.TextColor3 = Color3.new(1, 0, 0);
    text.TextWrapped = true;
    text.BackgroundTransparency = 1;
    text.Parent = frame;
    
    wait(10);
    gui:Destroy();
end);