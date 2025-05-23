-- // Button.lua - A reusable button component

-- // Xenon, buttons are like, so essential! Clicky click!

local Component;
local StyleManager;
local AnimationUtil;

pcall(function() Component = loadstring(readfile("src/Core/Component.lua"))() end);
pcall(function() StyleManager = loadstring(readfile("src/Core/StyleManager.lua"))() end);
pcall(function() AnimationUtil = loadstring(readfile("src/Core/AnimationUtil.lua"))() end);

if not Component then warn("Button: Component module not loaded!") end
if not StyleManager then warn("Button: StyleManager module not loaded!") end

local Button = {};
Button.__index = Button;
setmetatable(Button, Component);

function Button.new(text, onClick)
  local self = Component.new("Button");
  setmetatable(self, Button);

  self.instance = Instance.new("TextButton"); -- // Override base instance type
  self.instance.Name = "StyledButton";
  self.instance.Text = text or "button";
  
  local baseStyle = StyleManager.getStyle("Button");
  local hoverStyle = StyleManager.getStyle("ButtonHover");
  local pressedStyle = StyleManager.getStyle("ButtonPressed");
  
  StyleManager.applyStyle(self.instance, baseStyle);

  self.instance.MouseEnter:Connect(function()
    if AnimationUtil and hoverStyle then
      AnimationUtil.tween(self.instance, TweenInfo.new(0.15), hoverStyle);
    elseif hoverStyle then
      StyleManager.applyStyle(self.instance, hoverStyle);
    end;
  end);

  self.instance.MouseLeave:Connect(function()
    if AnimationUtil and baseStyle then
       AnimationUtil.tween(self.instance, TweenInfo.new(0.15), baseStyle);
    elseif baseStyle then
      StyleManager.applyStyle(self.instance, baseStyle);
    end;
  end);
  
  self.instance.MouseButton1Down:Connect(function()
    if AnimationUtil and pressedStyle then
        AnimationUtil.tween(self.instance, TweenInfo.new(0.1), pressedStyle);
    elseif pressedStyle then
        StyleManager.applyStyle(self.instance, pressedStyle);
    end;
  end);
  
  self.instance.MouseButton1Up:Connect(function()
    -- // Return to hover style if mouse is still over, else base style
    local mousePos = game:GetService("UserInputService"):GetMouseLocation();
    local guiObject = self.instance;
    local absPos, absSize = guiObject.AbsolutePosition, guiObject.AbsoluteSize;
    if mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
       mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y then
      if AnimationUtil and hoverStyle then
        AnimationUtil.tween(self.instance, TweenInfo.new(0.1), hoverStyle);
      elseif hoverStyle then StyleManager.applyStyle(self.instance, hoverStyle) end;
    else
      if AnimationUtil and baseStyle then
        AnimationUtil.tween(self.instance, TweenInfo.new(0.1), baseStyle);
      elseif baseStyle then StyleManager.applyStyle(self.instance, baseStyle) end;
    end
    if onClick then
      pcall(onClick);
    end;
  end);

  print("button '" .. text .. "' created");
  return self;
end;

function Button:setText(text)
  self.instance.Text = text;
end;

return Button;