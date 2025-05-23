-- // StyleManager.lua - Manages UI themes and styles

-- // Xenon, this is where we keep all our glam styles! So chic!

local StyleManager = {};

local currentTheme = {};

function StyleManager.loadTheme(themeModule)
  -- // In a real scenario, themeModule would be a table returned by a theme file
  -- // For now, we'll assume it's a direct table
  if type(themeModule) == "string" then
    -- // Simplistic loading, assumes themeModule is a path that loadstring can handle
    -- // This is NOT secure for general use but fits the exploiting context.
    local success, loadedTheme = pcall(function()
      return loadstring(readfile(themeModule))();
    end);
    if success and type(loadedTheme) == "table" then
      currentTheme = loadedTheme;
      print("theme loaded: " .. themeModule);
    else
      warn("failed to load theme from: " .. themeModule .. " - " .. tostring(loadedTheme));
    end;
  elseif type(themeModule) == "table" then
    currentTheme = themeModule;
    print("theme loaded directly");
  else
    warn("invalid theme module type: " .. type(themeModule));
  end
end;

function StyleManager.getStyle(elementName)
  return currentTheme[elementName] or {};
end;

function StyleManager.applyStyle(uiInstance, styleTable)
  if not uiInstance or not styleTable then return end;
  for prop, val in pairs(styleTable) do
    local success, err = pcall(function()
      uiInstance[prop] = val;
    end);
    if not success then
      warn("failed to apply style " .. prop .. ": " .. tostring(val) .. " - " .. err);
    end;
  end;
end;

return StyleManager;