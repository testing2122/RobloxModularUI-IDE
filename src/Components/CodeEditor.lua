-- // CodeEditor.lua - Component for the code editor panel

-- // Xenon, this is where all the magic coding happens! Like, totally epic!

-- // Assuming Component.lua, StyleManager.lua, AnimationUtil.lua are in src/Core/
-- // For exploit environment, direct loadstring/readfile might be used if they are not pre-loaded.

local Component;
local StyleManager;
local AnimationUtil;

local componentLoaded, componentModule = pcall(function()
    return loadstring(readfile("src/Core/Component.lua"))();
end)
if componentLoaded then Component = componentModule else warn("Failed to load Component module for CodeEditor") end

local styleManagerLoaded, styleManagerModule = pcall(function()
    return loadstring(readfile("src/Core/StyleManager.lua"))();
end)
if styleManagerLoaded then StyleManager = styleManagerModule else warn("Failed to load StyleManager module for CodeEditor") end

local animUtilLoaded, animUtilModule = pcall(function()
    return loadstring(readfile("src/Core/AnimationUtil.lua"))();
end)
if animUtilLoaded then AnimationUtil = animUtilModule else warn("Failed to load AnimationUtil module for CodeEditor") end


local CodeEditor = {};
CodeEditor.__index = CodeEditor;
setmetatable(CodeEditor, Component);

function CodeEditor.new()
  local self = Component.new("CodeEditor"); -- // Call base class constructor
  setmetatable(self, CodeEditor);

  self.instance.Name = "CodeEditorPanel";
  self.instance.Size = UDim2.new(0.7, 0, 1, 0); -- // Example size
  self.instance.Position = UDim2.new(0, 0, 0, 0);
  
  local styles = StyleManager.getStyle("CodeEditor");
  StyleManager.applyStyle(self.instance, styles);
  
  -- // Add a TextBox for code input
  self.textBox = Instance.new("TextBox");
  self.textBox.Name = "CodeInput";
  self.textBox.Size = UDim2.new(1, -2 * (styles.Padding or 10), 1, -2 * (styles.Padding or 10));
  self.textBox.Position = UDim2.new(0, (styles.Padding or 10), 0, (styles.Padding or 10));
  self.textBox.MultiLine = true;
  self.textBox.TextWrapped = true;
  self.textBox.TextXAlignment = Enum.TextXAlignment.Left;
  self.textBox.TextYAlignment = Enum.TextYAlignment.Top;
  self.textBox.ClearTextOnFocus = false;
  self.textBox.Text = "-- // start coding here babe! <3";
  StyleManager.applyStyle(self.textBox, styles); -- // Apply editor styles to textbox too
  self.textBox.BackgroundColor3 = styles.BackgroundColor3 or Color3.fromRGB(30,28,45);
  self.textBox.TextColor3 = styles.TextColor3 or Color3.fromRGB(220,210,255);
  self.textBox.Font = styles.Font or Enum.Font.Code;
  self.textBox.TextSize = styles.TextSize or 14;
  self.textBox.Parent = self.instance;

  -- // Placeholder for syntax highlighting, line numbers etc.
  print("code editor component created");
  return self;
end;

function CodeEditor:setText(text)
  self.textBox.Text = text;
end;

function CodeEditor:getText()
  return self.textBox.Text;
end;

return CodeEditor;