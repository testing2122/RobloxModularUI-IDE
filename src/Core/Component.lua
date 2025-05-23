-- // Component.lua - Base class for all UI components

-- // Hey Xenon! This is like, the blueprint for all our cute UI thingies! UwU

local Component = {};
Component.__index = Component;

function Component.new(componentType)
  local self = setmetatable({}, Component);
  self.instance = Instance.new("Frame"); -- // Default to a Frame, can be overridden
  self.componentType = componentType or "Component";
  self.children = {};
  self.visible = true;
  print(self.componentType .. " created");
  return self;
end;

function Component:addChild(childComponent)
  table.insert(self.children, childComponent);
  childComponent.instance.Parent = self.instance;
  print(self.componentType .. ": added child " .. childComponent.componentType);
end;

function Component:destroy()
  self.instance:Destroy();
  for _, child in ipairs(self.children) do
    child:destroy();
  end;
  print(self.componentType .. " destroyed");
end;

function Component:show()
  self.instance.Visible = true;
  self.visible = true;
  print(self.componentType .. " shown");
end;

function Component:hide()
  self.instance.Visible = false;
  self.visible = false;
  print(self.componentType .. " hidden");
end;

function Component:on(event, callback)
  -- // Basic event handling, can be expanded
  if self.instance[event] then
    return self.instance[event]:Connect(callback);
  else
    warn("event " .. tostring(event) .. " not found on " .. self.componentType);
    return nil;
  end;
end;

return Component;