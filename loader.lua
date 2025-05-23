-- // loader.lua - Direct GitHub loader for the UI system

-- // Xenon, this is our magical loader that pulls everything from GitHub! uwu

local repo = "testing2122/RobloxModularUI-IDE";
local branch = "main";

local function ghraw(path)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s", repo, branch, path);
end;

local function fetchmodule(path)
    local success, content = pcall(game.HttpGet, game, ghraw(path));
    if not success then
        warn("failed to fetch " .. path .. ": " .. tostring(content));
        return nil;
    end;
    return content;
end;

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

-- // Create a virtual filesystem for our modules
local vfs = {};

-- // Fetch all modules
print("fetching modules...");

-- // Fetch core modules
for k, path in pairs(modules.core) do
    local content = fetchmodule(path);
    if content then
        vfs[path] = content;
        print("fetched " .. k);
    end;
end;

-- // Fetch components
for k, path in pairs(modules.components) do
    local content = fetchmodule(path);
    if content then
        vfs[path] = content;
        print("fetched " .. k);
    end;
end;

-- // Fetch theme
local theme = fetchmodule(modules.theme);
if theme then
    vfs[modules.theme] = theme;
    print("fetched theme");
end;

-- // Fetch layout
local layout = fetchmodule(modules.layout);
if layout then
    vfs[modules.layout] = layout;
    print("fetched layout");
end;

-- // Override readfile to use our virtual filesystem
local oldreadfile = readfile;
getgenv().readfile = function(path)
    if vfs[path] then
        return vfs[path];
    end;
    return oldreadfile(path);
end;

-- // Initialize the UI
print("initializing ui...");
local success, ideLayout = pcall(function()
    return loadstring(vfs[modules.layout])();
end);

if success and ideLayout then
    print("mounting ui...");
    local s, e = pcall(function()
        ideLayout.mount();
    end);
    if not s then
        warn("failed to mount ui: " .. tostring(e));
    else
        print("ui mounted successfully!");
    end;
else
    warn("failed to load ui: " .. tostring(ideLayout));
end;
