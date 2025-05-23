-- // AIChatPanel.lua - Component for the AI chat panel

-- // Xenon, this is where we'll chat with our super smart AI! Omg, fun!

local Component;
local StyleManager;
local AnimationUtil;

-- // Dynamic loading for exploit environment
pcall(function() Component = loadstring(readfile("src/Core/Component.lua"))() end);
pcall(function() StyleManager = loadstring(readfile("src/Core/StyleManager.lua"))() end);
pcall(function() AnimationUtil = loadstring(readfile("src/Core/AnimationUtil.lua"))() end);

if not Component then warn("AI Chat: Component module not loaded!") end
if not StyleManager then warn("AI Chat: StyleManager module not loaded!") end
-- // AnimationUtil might be optional for basic version

local AIChatPanel = {};
AIChatPanel.__index = AIChatPanel;
setmetatable(AIChatPanel, Component);

function AIChatPanel.new()
  local self = Component.new("AIChatPanel");
  setmetatable(self, AIChatPanel);

  self.instance.Name = "AIChatPanel";
  self.instance.Size = UDim2.new(0.3, 0, 1, 0); -- // Example size, docked to the right
  self.instance.Position = UDim2.new(0.7, 0, 0, 0); -- // Positioned to the right of code editor

  local styles = StyleManager.getStyle("AIChatPanel");
  StyleManager.applyStyle(self.instance, styles);

  -- // Chat log (ScrollingFrame)
  self.chatLog = Instance.new("ScrollingFrame");
  self.chatLog.Name = "ChatLog";
  self.chatLog.Size = UDim2.new(1, -2 * (styles.Padding or 8), 0.8, -(styles.Padding or 8) - 40); -- // Space for input
  self.chatLog.Position = UDim2.new(0, (styles.Padding or 8), 0, (styles.Padding or 8));
  self.chatLog.BackgroundColor3 = StyleManager.getStyle("CodeEditor").BackgroundColor3; -- // Use a slightly different bg for contrast
  self.chatLog.BorderColor3 = styles.BorderColor3;
  self.chatLog.BorderSizePixel = 1;
  self.chatLog.ScrollBarThickness = 6;
  self.chatLog.CanvasSize = UDim2.new(0,0,0,0); -- // Auto-adjusts with UIListLayout
  self.chatLog.Parent = self.instance;

  local listLayout = Instance.new("UIListLayout");
  listLayout.Parent = self.chatLog;
  listLayout.SortOrder = Enum.SortOrder.LayoutOrder;
  listLayout.Padding = UDim.new(0, 5);

  -- // Input field
  self.inputField = Instance.new("TextBox");
  self.inputField.Name = "ChatInput";
  self.inputField.Size = UDim2.new(1, -2 * (styles.Padding or 8), 0, 30);
  self.inputField.Position = UDim2.new(0, (styles.Padding or 8), 1, -(styles.Padding or 8) - 30 - (styles.Padding or 8));
  self.inputField.PlaceholderText = "ask me anything, queen...";
  StyleManager.applyStyle(self.inputField, StyleManager.getStyle("InputField"));
  self.inputField.Parent = self.instance;

  self.inputField.FocusLost:Connect(function(enterPressed)
    if enterPressed and self.inputField.Text ~= "" then
      self:addMessage("User: " .. self.inputField.Text, "User");
      -- // Trigger AI response here
      self:addMessage("AI: Thinking...", "AI"); -- // Placeholder
      self.inputField.Text = "";
    end;
  end);

  print("ai chat panel component created");
  return self;
end;

function AIChatPanel:addMessage(text, senderType)
  local messageLabel = Instance.new("TextLabel");
  messageLabel.Name = senderType .. "Message";
  messageLabel.Text = text;
  messageLabel.TextWrapped = true;
  messageLabel.TextXAlignment = Enum.TextXAlignment.Left;
  messageLabel.Size = UDim2.new(1, -10, 0, 0); -- // Width, auto height
  messageLabel.AutomaticSize = Enum.AutomaticSize.Y;
  messageLabel.Font = StyleManager.getStyle("AIChatPanel").Font or Enum.Font.GothamSemibold;
  messageLabel.TextSize = (StyleManager.getStyle("AIChatPanel").TextSize or 14) - 1;
  
  if senderType == "User" then
    messageLabel.TextColor3 = StyleManager.getStyle("Colors").PrimaryText or Color3.new(1,1,1);
  else -- // AI
    messageLabel.TextColor3 = StyleManager.getStyle("Colors").AccentLight or Color3.fromRGB(150,110,250);
  end
  messageLabel.BackgroundTransparency = 1;
  messageLabel.LayoutOrder = #self.chatLog:GetChildren(); -- // For UIListLayout
  messageLabel.Parent = self.chatLog;
  
  -- // Scroll to bottom (may need slight delay)
  wait(); -- // allow UI to update
  self.chatLog.CanvasPosition = Vector2.new(0, self.chatLog.UIListLayout.AbsoluteContentSize.Y);
end;

return AIChatPanel;