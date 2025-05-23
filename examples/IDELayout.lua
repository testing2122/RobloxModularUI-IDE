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
    -- // Fallback or error display could go here
    local screenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"));
    local errLabel = Instance.new("TextLabel", screenGui);
    errLabel.Size = UDim2.new(1,0,1,0);
    errLabel.Text = "Error: UI Modules Failed to Load. Check Output.";
    errLabel.TextColor3 = Color3.new(1,0,0);
    errLabel.TextScaled = true;
    return { mount = function() print("Cannot mount IDE due to load errors.") end };
end

local IDELayout = {};

function IDELayout.mount(parentGui)
  parentGui = parentGui or Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"));
  parentGui.Name = "IDE_ScreenGui";
  parentGui.ResetOnSpawn = false; -- // Keep UI persistent

  -- // Load the theme
  StyleManager.loadTheme(ThemesPath .. "MidnightPurple.lua");
  local theme = StyleManager.getStyle("UNUSED_VARIABLE_FIX"); -- // Ensure theme table is loaded by StyleManager
  local baseFrameStyle = StyleManager.getStyle("BaseFrame");
  StyleManager.applyStyle(parentGui, baseFrameStyle);

  -- // Main container for the IDE layout
  local mainContainer = Instance.new("Frame");
  mainContainer.Name = "MainIDEContainer";
  mainContainer.Size = UDim2.new(1, 0, 1, 0);
  StyleManager.applyStyle(mainContainer, baseFrameStyle);
  mainContainer.Parent = parentGui;
  
  -- // Create Code Editor
  local editor = CodeEditor.new();
  editor.instance.Parent = mainContainer;
  editor.instance.Size = UDim2.new(0.65, 0, 0.9, -40); -- // Adjusted for bottom bar
  editor.instance.Position = UDim2.new(0.025, 0, 0.025, 0);

  -- // Create AI Chat Panel
  local chatPanel = AIChatPanel.new();
  chatPanel.instance.Parent = mainContainer;
  chatPanel.instance.Size = UDim2.new(0.275, 0, 0.9, -40); -- // Adjusted for bottom bar
  chatPanel.instance.Position = UDim2.new(1 - 0.275 - 0.025, 0, 0.025, 0); -- // Dock to the right

  -- // Example bottom bar with buttons/toggles
  local bottomBar = Instance.new("Frame");
  bottomBar.Name = "BottomBar";
  bottomBar.Size = UDim2.new(1, -0.05*mainContainer.AbsoluteSize.X, 0, 30); -- // Relative width, fixed height
  bottomBar.Position = UDim2.new(0.025, 0, 1, -30 - 0.025*mainContainer.AbsoluteSize.Y); -- // Anchor to bottom
  bottomBar.BackgroundColor3 = StyleManager.getStyle("Colors").SecondaryBackground;
  bottomBar.BorderSizePixel = 0;
  bottomBar.Parent = mainContainer;

  local runButton = Button.new("Run Script", function()
    print("Run Script button clicked!");
    local scriptContent = editor:getText();
    local func, err = loadstring(scriptContent);
    if func then
      chatPanel:addMessage("Executing script...", "System");
      local s, e = pcall(func);
      if not s then
        chatPanel:addMessage("Error: " .. tostring(e), "System");
      else
        chatPanel:addMessage("Script executed.", "System");
      end
    else
      chatPanel:addMessage("Syntax Error: " .. tostring(err), "System");
    end
  end);
  runButton.instance.Size = UDim2.new(0, 100, 1, -10); -- // Adjust size within bar
  runButton.instance.Position = UDim2.new(0, 5, 0, 5);
  runButton.instance.Parent = bottomBar;

  local themeToggle = Toggle.new(true, function(isToggled)
    chatPanel:addMessage("Theme toggle: " .. (isToggled and "Dark Mode On" or "Dark Mode Off (jk it\'s always dark <3)"), "System");
    -- // Actual theme switching logic would go here if we had multiple themes
  end);
  themeToggle.instance.Position = UDim2.new(0, 120, 0, 2); -- // Position next to button
  themeToggle.instance.Parent = bottomBar;

  print("ide layout mounted");
  
  -- // Animate panels in
  if AnimationUtil then
      editor.instance.Visible = false; -- // Hide before animating
      chatPanel.instance.Visible = false;
      
      wait(0.1); -- // Short delay for setup
      
      editor.instance.Visible = true;
      chatPanel.instance.Visible = true;

      AnimationUtil.slideIn(editor.instance, 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, UDim2.new(0.025, 0, 0.025, 0));
      AnimationUtil.slideIn(chatPanel.instance, 0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, UDim2.new(1 - 0.275 - 0.025, 0, 0.025, 0));
      AnimationUtil.fadeIn(bottomBar, 0.5, 0);
  end
  
  return { parent = parentGui, editor = editor, chat = chatPanel };
end;

-- // To run this example:
-- // local ide = loadstring(readfile("examples/IDELayout.lua"))();
-- // ide.mount();

return IDELayout;