-- // AnimationUtil.lua - Utility for UI animations

-- // Xenon, let's make our UI dance with this! Sparkle sparkle!

local AnimationUtil = {};
local tweenService = game:GetService("TweenService");

function AnimationUtil.tween(instance, tweenInfo, properties)
  if not instance or not tweenInfo or not properties then
    warn("tween: invalid arguments");
    return nil;
  end;
  local tween = tweenService:Create(instance, tweenInfo, properties);
  tween:Play();
  return tween;
end;

-- // Example: Slide in from left
function AnimationUtil.slideIn(guiObject, duration, easingStyle, easingDirection, targetPos)
  local startPos = UDim2.new(targetPos.X.Scale - 1, targetPos.X.Offset, targetPos.Y.Scale, targetPos.Y.Offset);
  if guiObject.Position.X.Scale < targetPos.X.Scale then -- // if it's already to the left or at the target
    startPos = guiObject.Position;
  end

  guiObject.Position = startPos;
  local ti = TweenInfo.new(duration, easingStyle, easingDirection);
  return AnimationUtil.tween(guiObject, ti, {Position = targetPos});
end;

-- // Example: Fade in
function AnimationUtil.fadeIn(guiObject, duration, targetTransparency)
  targetTransparency = targetTransparency or 0;
  guiObject.BackgroundTransparency = 1;
  if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
    guiObject.TextTransparency = 1;
  end

  local ti = TweenInfo.new(duration);
  local props = {BackgroundTransparency = targetTransparency};
  if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
    props.TextTransparency = targetTransparency;
  end
  return AnimationUtil.tween(guiObject, ti, props);
end;

return AnimationUtil;