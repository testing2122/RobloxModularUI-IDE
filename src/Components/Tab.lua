-- // Tab.lua - A component for individual tabs

-- // Xenon, tabs are like, perfect for keeping things organized and cute!

local Component;
local StyleManager;
local AnimationUtil;

pcall(function() Component = loadstring(readfile("src/Core/Component.lua"))() end);
pcall(function() StyleManager = loadstring(readfile("src/Core/StyleManager.lua"))() end);
pcall(function() AnimationUtil = loadstring(readfile("src/Core/AnimationUtil.lua"))() end);

if not Component then warn("Tab: Component module not loaded!") end
if not StyleManager then warn("Tab: StyleManager module not loaded!") end

local Tab = {};
Tab.__index = Tab;
setmetatable(Tab, Component);

function Tab.new(text, onActivated)
  local self = Component.new("Tab");
  setmetatable(self, Tab);

  self.instance = Instance.new("TextButton"); -- // Tabs are clickable
  self.instance.Name = "StyledTab";
  self.instance.Text = text or "Tab";
  self.active = false;
  self.onActivated = onActivated;
  
  local baseStyle = StyleManager.getStyle("Tab");
  local activeStyle = StyleManager.getStyle("TabActive");
  
  StyleManager.applyStyle(self.instance, baseStyle);

  self.instance.MouseEnter:Connect(function()
    if not self.active and AnimationUtil then
      -- // Subtle hover for non-active tabs
      local hoverColor = baseStyle.BackgroundColor3:Lerp(activeStyle.BackgroundColor3, 0.2);
      AnimationUtil.tween(self.instance, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor});
    elseif not self.active then
       local hoverColor = baseStyle.BackgroundColor3:Lerp(activeStyle.BackgroundColor3, 0.2);
       self.instance.BackgroundColor3 = hoverColor;
    end
  end);

  self.instance.MouseLeave:Connect(function()
    if not self.active and AnimationUtil then
       AnimationUtil.tween(self.instance, TweenInfo.new(0.15), {BackgroundColor3 = baseStyle.BackgroundColor3});
    elseif not self.active then
      self.instance.BackgroundColor3 = baseStyle.BackgroundColor3;
    end
  end);
  
  self.instance.MouseButton1Click:Connect(function()
    if not self.active and self.onActivated then
      pcall(self.onActivated, self);
      -- // The TabContainer or managing component should call :setActive(true)
    end;
  end);

  print("tab '" .. text .. "' created");
  return self;
end;

function Tab:setText(text)
  self.instance.Text = text;
end;

function Tab:setActive(isActive)
  self.active = isActive;
  local baseStyle = StyleManager.getStyle("Tab");
  local activeStyle = StyleManager.getStyle("TabActive");

  if isActive then
    if AnimationUtil then
      AnimationUtil.tween(self.instance, TweenInfo.new(0.2), activeStyle);
    else
      StyleManager.applyStyle(self.instance, activeStyle);
    end;
  else
    if AnimationUtil then
      AnimationUtil.tween(self.instance, TweenInfo.new(0.2), baseStyle);
    else
      StyleManager.applyStyle(self.instance, baseStyle);
    end;
  end;
end;

return Tab;