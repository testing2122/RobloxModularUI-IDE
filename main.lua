-- // main.lua - Entry point for the UI system

-- // Xenon, this is like, the main gateway to our awesome UI! totes! <3

local function init()
  print("ui system initializing...");
  
  -- // Wait for game to be loaded, just in case
  if not game:IsLoaded() then
    print("waiting for game to load...");
    game.Loaded:Wait();
  end
  print("game loaded, proceeding with ui.");

  local success, ideLayoutModule = pcall(function()
    -- // In an exploit environment, you'd use readfile and loadstring
    -- // Ensure the path is correct relative to your executor's workspace/scripts folder
    return loadstring(readfile("RobloxModularUI-IDE/examples/IDELayout.lua"))(); 
    -- // Changed path to be more explicit from root, assuming "RobloxModularUI-IDE" is a folder in the executor's root/workspace
    -- // If main.lua is *inside* RobloxModularUI-IDE, then "examples/IDELayout.lua" is correct.
    -- // The user will need to adjust this path based on where they place the folder.
  end);

  if success and ideLayoutModule and ideLayoutModule.mount then
    print("IDELayout.lua loaded, attempting to mount...");
    local s, mountedUI = pcall(ideLayoutModule.mount);
    if not s then
        warn("Failed to mount IDE Layout: " .. tostring(mountedUI));
    else
        print("IDE Layout mounted successfully!");
    end
  else
    warn("Failed to load or find mount function in IDELayout.lua: " .. tostring(ideLayoutModule));
  end
end;

-- // Wrap init in a pcall for safety in exploit environment
local s, e = pcall(init);
if not s then
    warn("Critical error during UI initialization: " .. tostring(e));
    -- // Optionally, display an error message on screen
    local errGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"));
    local errLabel = Instance.new("TextLabel", errGui);
    errLabel.Size = UDim2.new(1,0,0,50);
    errLabel.Position = UDim2.new(0,0,0.5,-25);
    errLabel.Text = "UI Init Error: " .. tostring(e);
    errLabel.TextColor3 = Color3.new(1,0.5,0.5);
    errLabel.BackgroundColor3 = Color3.new(0.1,0.1,0.1);
    errLabel.BackgroundTransparency = 0.3;
    errLabel.TextScaled = true;
    wait(10); -- // Show error for a bit
    errGui:Destroy();
end;

-- // Note for Xenon: The path in readfile inside init() might need adjustment based on where you save the RobloxModularUI-IDE folder!
-- // Make sure it points to examples/IDELayout.lua correctly from where main.lua is executed!