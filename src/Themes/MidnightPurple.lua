-- // MidnightPurple.lua - Theme definition

-- // Xenon, this is our super fab Midnight Purple theme! It's gonna look sooooo good!

local theme = {
  Name = "MidnightPurple";

  Colors = {
    PrimaryBackground = Color3.fromRGB(20, 18, 30); -- // Deep midnight blue/purple
    SecondaryBackground = Color3.fromRGB(30, 28, 45); -- // Slightly lighter for panels
    TertiaryBackground = Color3.fromRGB(45, 42, 68); -- // For interactive elements

    PrimaryText = Color3.fromRGB(220, 210, 255); -- // Light lavender
    SecondaryText = Color3.fromRGB(180, 170, 220); -- // Muted lavender

    Accent = Color3.fromRGB(120, 80, 220); -- // Vibrant Purple (glowy bits)
    AccentDark = Color3.fromRGB(90, 60, 180);
    AccentLight = Color3.fromRGB(150, 110, 250);

    Success = Color3.fromRGB(80, 200, 120);
    Warning = Color3.fromRGB(220, 180, 80);
    Error = Color3.fromRGB(200, 80, 80);

    Outline = Color3.fromRGB(60, 55, 80);
    Shadow = Color3.fromRGB(10, 9, 15);
  };

  Fonts = {
    Default = Enum.Font.GothamSemibold;
    Code = Enum.Font.Code;
    Monospace = Enum.Font.Monospace;
  };

  Sizes = {
    Padding = 10;
    SmallPadding = 5;
    BorderRadius = 6;
    TextSize = 16;
    TitleSize = 24;
    IconSize = 20;
  };

  -- // Component-specific styles
  BaseFrame = {
    BackgroundColor3 = Color3.fromRGB(20, 18, 30); -- // PrimaryBackground
    BorderSizePixel = 0;
  };

  Button = {
    BackgroundColor3 = Color3.fromRGB(45, 42, 68); -- // TertiaryBackground
    TextColor3 = Color3.fromRGB(220, 210, 255); -- // PrimaryText
    Font = Enum.Font.GothamSemibold;
    TextSize = 16; -- // Sizes.TextSize
    Size = UDim2.new(0, 120, 0, 40);
    AutoButtonColor = false; -- // For custom hover effects
    BorderSizePixel = 1;
    BorderColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
  };

  ButtonHover = {
    BackgroundColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
    TextColor3 = Color3.fromRGB(255, 255, 255);
  };
  
  ButtonPressed = {
    BackgroundColor3 = Color3.fromRGB(90, 60, 180); -- // AccentDark
  };

  CodeEditor = {
    BackgroundColor3 = Color3.fromRGB(30, 28, 45); -- // SecondaryBackground
    TextColor3 = Color3.fromRGB(220, 210, 255);    -- // PrimaryText
    Font = Enum.Font.Code; -- // Fonts.Code
    TextSize = 14;
    Padding = 10; -- // Sizes.Padding
    BorderColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
    BorderSizePixel = 1;
  };

  AIChatPanel = {
    BackgroundColor3 = Color3.fromRGB(30, 28, 45); -- // SecondaryBackground
    TextColor3 = Color3.fromRGB(180, 170, 220); -- // SecondaryText
    Font = Enum.Font.GothamSemibold; -- // Fonts.Default
    TextSize = 14;
    Padding = 8;
    BorderColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
    BorderSizePixel = 1;
  };

  InputField = {
    BackgroundColor3 = Color3.fromRGB(20, 18, 30); -- // PrimaryBackground
    TextColor3 = Color3.fromRGB(220, 210, 255); -- // PrimaryText
    PlaceholderColor3 = Color3.fromRGB(100, 90, 130);
    Font = Enum.Font.GothamSemibold;
    TextSize = 14;
    BorderColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
    BorderSizePixel = 1;
  };

  Tab = {
    BackgroundColor3 = Color3.fromRGB(30, 28, 45); -- // SecondaryBackground
    TextColor3 = Color3.fromRGB(180, 170, 220); -- // SecondaryText
    Font = Enum.Font.GothamSemibold;
    TextSize = 14;
    BorderColor3 = Color3.fromRGB(60, 55, 80); -- // Outline
    BorderSizePixel = 1;
  };

  TabActive = {
    BackgroundColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
    TextColor3 = Color3.fromRGB(255, 255, 255);
    BorderColor3 = Color3.fromRGB(120, 80, 220); -- // Accent
  };

  GlowEffect = {
    Color = Color3.fromRGB(120, 80, 220); --// Accent
    Offset = Vector2.new(0,0);
    Size = Vector2.new(1,1); -- // Relative to parent
    Transparency = 0.5;
  };

  -- // Add more component styles as needed
};

return theme;