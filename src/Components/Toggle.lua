-- // Toggle.lua - A simple toggle switch component

-- // Xenon, toggles are like, so fun for switching things on and off! Boop!

local Component;
local StyleManager;
local AnimationUtil;

pcall(function() Component = loadstring(readfile("src/Core/Component.lua"))() end);
pcall(function() StyleManager = loadstring(readfile("src/Core/StyleManager.lua"))() end);
pcall(function() AnimationUtil = loadstring(readfile("src/Core/AnimationUtil.lua"))() end);

if not Component then warn("Toggle: Component module not loaded!") end
if not StyleManager then warn("Toggle: StyleManager module not loaded!") end

local Toggle = {};
Toggle.__index = Toggle;
setmetatable(Toggle, Component);

local DEFAULT_WIDTH = 50;
local DEFAULT_HEIGHT = 26;

function Toggle.new(initialState, onToggled)
  local self = Component.new("Toggle");
  setmetatable(self, Toggle);

  self.toggled = initialState or false;
  self.onToggled = onToggled;
  
  local themeColors = StyleManager.getStyle("Colors");
  local accentColor = themeColors and themeColors.Accent or Color3.fromRGB(120, 80, 220);
  local secondaryBgColor = themeColors and themeColors.SecondaryBackground or Color3.fromRGB(30, 28, 45);
  local outlineColor = themeColors and themeColors.Outline or Color3.fromRGB(60, 55, 80);

  self.instance = Instance.new("TextButton"); -- // Using TextButton for click + easy styling
  self.instance.Name = "StyledToggle";
  self.instance.Text = ""; -- // No text, visual only
  self.instance.Size = UDim2.new(0, DEFAULT_WIDTH, 0, DEFAULT_HEIGHT);
  self.instance.AutoButtonColor = false;
  self.instance.BackgroundColor3 = self.toggled and accentColor or secondaryBgColor;
  self.instance.BorderSizePixel = 1;
  self.instance.BorderColor3 = outlineColor;

  local uiCorner = Instance.new("UICorner");
  uiCorner.CornerRadius = UDim.new(0, DEFAULT_HEIGHT / 2);
  uiCorner.Parent = self.instance;

  -- // The knob
  self.knob = Instance.new("Frame");
  self.knob.Name = "Knob";
  self.knob.Size = UDim2.new(0, DEFAULT_HEIGHT - 6, 0, DEFAULT_HEIGHT - 6); -- // Circle
  self.knob.Position = self.toggled and UDim2.new(1, - (DEFAULT_HEIGHT - 6) - 3, 0, 3) or UDim2.new(0, 3, 0, 3);
  self.knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240);
  self.knob.BorderSizePixel = 0;
  self.knob.Parent = self.instance;
  
  local knobCorner = Instance.new("UICorner");
  knobCorner.CornerRadius = UDim.new(0, (DEFAULT_HEIGHT - 6) / 2);
  knobCorner.Parent = self.knob;

  self.instance.MouseButton1Click:Connect(function()
    self:setState(not self.toggled);
    if self.onToggled then
      pcall(self.onToggled, self.toggled);
    end;
  end);
  
  print("toggle created, initial state: " .. tostring(self.toggled));
  return self;
end;

function Toggle:setState(newState, silent)
  if self.toggled == newState then return end; -- // No change
  self.toggled = newState;

  local themeColors = StyleManager.getStyle("Colors");
  local accentColor = themeColors and themeColors.Accent or Color3.fromRGB(120, 80, 220);
  local secondaryBgColor = themeColors and themeColors.SecondaryBackground or Color3.fromRGB(30, 28, 45);

  local targetBgColor = self.toggled and accentColor or secondaryBgColor;
  local targetKnobPos = self.toggled and UDim2.new(1, -self.knob.AbsoluteSize.X - 3, 0, 3) or UDim2.new(0, 3, 0, 3);

  if AnimationUtil then
    AnimationUtil.tween(self.instance, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor});
    AnimationUtil.tween(self.knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetKnobPos});
  else
    self.instance.BackgroundColor3 = targetBgColor;
    self.knob.Position = targetKnobPos;
  end;
  
  if not silent and self.onToggled then
    pcall(self.onToggled, self.toggled);
  end;
end;

function Toggle:getState()
  return self.toggled;
end;

return Toggle;