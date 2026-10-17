-- ═══════════════════════════════════════════════════════════════
--   👑 Pro Script v16.0 ULTRA (Anti-Desync + Save FOV)
--   ✦ إصلاح مشكلة التوقف المفاجئ (تسمع الناس بس ما تتحرك)
--   ✦ حفظ الـ FOV وترتيب الأوامر (;re ثم ;char)
--   ✦ حماية صارمة للسرعة و Noclip
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("ProRefreshUI") then
    CoreGui.ProRefreshUI:Destroy()
end

-- ═══ 📦 جدول حفظ الإعدادات ═══
local SavedSettings = {
    Speed = 16,
    Hotkey = "R",
    Username = "",
    NoclipState = false,
    InfiniteJump = false,
    FOV = 70,
    UnlockZoom = false,
}

-- ═══ الواجهة ═══
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProRefreshUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- زر عائم
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 25, 0, 200)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 26
ToggleBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.AutoButtonColor = false
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3
UIStroke.Parent = ToggleBtn

-- القائمة
local Menu = Instance.new("Frame")
Menu.Parent = ScreenGui
Menu.Size = UDim2.new(0, 320, 0, 720)
Menu.Position = UDim2.new(0, 25, 0, 150)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true
Menu.ClipsDescendants = true

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = Menu

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(0, 200, 255)
MenuStroke.Thickness = 1.5
MenuStroke.Transparency = 0.5
MenuStroke.Parent = Menu

-- عنوان
local TitleBar = Instance.new("Frame")
TitleBar.Parent = Menu
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ Pro Script v16.0 ULTRA"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseMenuBtn = Instance.new("TextButton")
CloseMenuBtn.Parent = TitleBar
CloseMenuBtn.Size = UDim2.new(0, 24, 0, 24)
CloseMenuBtn.Position = UDim2.new(1, -28, 0, 4)
CloseMenuBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseMenuBtn.BorderSizePixel = 0
CloseMenuBtn.Text = "✕"
CloseMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseMenuBtn.Font = Enum.Font.GothamBold
CloseMenuBtn.TextSize = 13

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseMenuBtn

-- ═══ قسم الأوامر ═══
local UserLbl = Instance.new("TextLabel")
UserLbl.Parent = Menu
UserLbl.Size = UDim2.new(1, -30, 0, 16)
UserLbl.Position = UDim2.new(0, 15, 0, 40)
UserLbl.BackgroundTransparency = 1
UserLbl.Text = "👤 اسم اليوزر (اختياري):"
UserLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
UserLbl.Font = Enum.Font.Gotham
UserLbl.TextSize = 11
UserLbl.TextXAlignment = Enum.TextXAlignment.Left

local UserTextBox = Instance.new("TextBox")
UserTextBox.Parent = Menu
UserTextBox.Size = UDim2.new(1, -30, 0, 28)
UserTextBox.Position = UDim2.new(0, 15, 0, 58)
UserTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
UserTextBox.BorderSizePixel = 0
UserTextBox.Text = SavedSettings.Username
UserTextBox.PlaceholderText = "اتركه فاضي لـ ;re فقط..."
UserTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
UserTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UserTextBox.Font = Enum.Font.Gotham
UserTextBox.TextSize = 12
UserTextBox.ClearTextOnFocus = false
local UTC = Instance.new("UICorner"); UTC.CornerRadius = UDim.new(0,8); UTC.Parent = UserTextBox

UserTextBox:GetPropertyChangedSignal("Text"):Connect(function()
    SavedSettings.Username = UserTextBox.Text
end)

local HotkeyLbl = Instance.new("TextLabel")
HotkeyLbl.Parent = Menu
HotkeyLbl.Size = UDim2.new(1, -30, 0, 16)
HotkeyLbl.Position = UDim2.new(0, 15, 0, 92)
HotkeyLbl.BackgroundTransparency = 1
HotkeyLbl.Text = "⌨️ حرف الكيبورد:"
HotkeyLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
HotkeyLbl.Font = Enum.Font.Gotham
HotkeyLbl.TextSize = 11
HotkeyLbl.TextXAlignment = Enum.TextXAlignment.Left

local HotkeyBox = Instance.new("TextBox")
HotkeyBox.Parent = Menu
HotkeyBox.Size = UDim2.new(1, -30, 0, 28)
HotkeyBox.Position = UDim2.new(0, 15, 0, 110)
HotkeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
HotkeyBox.BorderSizePixel = 0
HotkeyBox.Text = SavedSettings.Hotkey
HotkeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
HotkeyBox.TextColor3 = Color3.fromRGB(0, 255, 150)
HotkeyBox.Font = Enum.Font.GothamBold
HotkeyBox.TextSize = 16
HotkeyBox.ClearTextOnFocus = false
HotkeyBox.TextXAlignment = Enum.TextXAlignment.Center
local HBC = Instance.new("UICorner"); HBC.CornerRadius = UDim.new(0,8); HBC.Parent = HotkeyBox

local EnableHotkeyBtn = Instance.new("TextButton")
EnableHotkeyBtn.Parent = Menu
EnableHotkeyBtn.Size = UDim2.new(1, -30, 0, 28)
EnableHotkeyBtn.Position = UDim2.new(0, 15, 0, 143)
EnableHotkeyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
EnableHotkeyBtn.BorderSizePixel = 0
EnableHotkeyBtn.Text = "✅ الهوت كي: مفعل (" .. SavedSettings.Hotkey .. ")"
EnableHotkeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableHotkeyBtn.Font = Enum.Font.GothamBold
EnableHotkeyBtn.TextSize = 11
EnableHotkeyBtn.AutoButtonColor = false
local EHC = Instance.new("UICorner"); EHC.CornerRadius = UDim.new(0,8); EHC.Parent = EnableHotkeyBtn

-- ═══════════════════════════════════════════════════════════════
-- 📷 قسم الكاميرا (FOV + Unlock Zoom)
-- ═══════════════════════════════════════════════════════════════
local D0 = Instance.new("Frame")
D0.Parent = Menu
D0.Size = UDim2.new(1, -30, 0, 1)
D0.Position = UDim2.new(0, 15, 0, 180)
D0.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
D0.BorderSizePixel = 0

local CamLbl = Instance.new("TextLabel")
CamLbl.Parent = Menu
CamLbl.Size = UDim2.new(1, -30, 0, 16)
CamLbl.Position = UDim2.new(0, 15, 0, 186)
CamLbl.BackgroundTransparency = 1
CamLbl.Text = "📷 التحكم بالكاميرا:"
CamLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
CamLbl.Font = Enum.Font.GothamBold
CamLbl.TextSize = 12
CamLbl.TextXAlignment = Enum.TextXAlignment.Left

-- FOV
local FOVLbl = Instance.new("TextLabel")
FOVLbl.Parent = Menu
FOVLbl.Size = UDim2.new(0.5, -20, 0, 16)
FOVLbl.Position = UDim2.new(0, 15, 0, 208)
FOVLbl.BackgroundTransparency = 1
FOVLbl.Text = "🔭 مجال الرؤية (FOV):"
FOVLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
FOVLbl.Font = Enum.Font.Gotham
FOVLbl.TextSize = 10
FOVLbl.TextXAlignment = Enum.TextXAlignment.Left

local FOVBox = Instance.new("TextBox")
FOVBox.Parent = Menu
FOVBox.Size = UDim2.new(0.3, -20, 0, 26)
FOVBox.Position = UDim2.new(0.5, -10, 0, 205)
FOVBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FOVBox.BorderSizePixel = 0
FOVBox.Text = tostring(SavedSettings.FOV)
FOVBox.PlaceholderText = "70"
FOVBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
FOVBox.TextColor3 = Color3.fromRGB(0, 255, 150)
FOVBox.Font = Enum.Font.GothamBold
FOVBox.TextSize = 12
FOVBox.ClearTextOnFocus = false
FOVBox.TextXAlignment = Enum.TextXAlignment.Center
local FOVBC = Instance.new("UICorner"); FOVBC.CornerRadius = UDim.new(0,6); FOVBC.Parent = FOVBox

local ApplyFOVBtn = Instance.new("TextButton")
ApplyFOVBtn.Parent = Menu
ApplyFOVBtn.Size = UDim2.new(0.2, -5, 0, 26)
ApplyFOVBtn.Position = UDim2.new(0.8, -15, 0, 205)
ApplyFOVBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
ApplyFOVBtn.BorderSizePixel = 0
ApplyFOVBtn.Text = "✅"
ApplyFOVBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyFOVBtn.Font = Enum.Font.GothamBold
ApplyFOVBtn.TextSize = 12
ApplyFOVBtn.AutoButtonColor = false
local AFBC = Instance.new("UICorner"); AFBC.CornerRadius = UDim.new(0,6); AFBC.Parent = ApplyFOVBtn

-- زر كسر قفل الزوم
local UnlockZoomBtn = Instance.new("TextButton")
UnlockZoomBtn.Parent = Menu
UnlockZoomBtn.Size = UDim2.new(1, -30, 0, 32)
UnlockZoomBtn.Position = UDim2.new(0, 15, 0, 240)
UnlockZoomBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
UnlockZoomBtn.BorderSizePixel = 0
UnlockZoomBtn.Text = "🔓 كسر حدود الزوم (اسحب بالماوس)"
UnlockZoomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockZoomBtn.Font = Enum.Font.GothamBold
UnlockZoomBtn.TextSize = 11
UnlockZoomBtn.AutoButtonColor = false
local UZC = Instance.new("UICorner"); UZC.CornerRadius = UDim.new(0,8); UZC.Parent = UnlockZoomBtn

-- ═══ أدوات إضافية ═══
local D1 = Instance.new("Frame")
D1.Parent = Menu
D1.Size = UDim2.new(1, -30, 0, 1)
D1.Position = UDim2.new(0, 15, 0, 285)
D1.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
D1.BorderSizePixel = 0

local ToolsLbl = Instance.new("TextLabel")
ToolsLbl.Parent = Menu
ToolsLbl.Size = UDim2.new(1, -30, 0, 16)
ToolsLbl.Position = UDim2.new(0, 15, 0, 291)
ToolsLbl.BackgroundTransparency = 1
ToolsLbl.Text = "🛠️ أدوات إضافية:"
ToolsLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
ToolsLbl.Font = Enum.Font.GothamBold
ToolsLbl.TextSize = 12
ToolsLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Noclip
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Parent = Menu
NoclipBtn.Size = UDim2.new(0.5, -20, 0, 32)
NoclipBtn.Position = UDim2.new(0, 15, 0, 313)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
NoclipBtn.BorderSizePixel = 0
NoclipBtn.Text = "🚀 Noclip"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.TextSize = 11
NoclipBtn.AutoButtonColor = false
local NC = Instance.new("UICorner"); NC.CornerRadius = UDim.new(0,8); NC.Parent = NoclipBtn

-- Infinite Jump
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Parent = Menu
InfJumpBtn.Size = UDim2.new(0.5, -20, 0, 32)
InfJumpBtn.Position = UDim2.new(0.5, 5, 0, 313)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
InfJumpBtn.BorderSizePixel = 0
InfJumpBtn.Text = "🦘 قفز لا نهائي"
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpBtn.Font = Enum.Font.GothamBold
InfJumpBtn.TextSize = 11
InfJumpBtn.AutoButtonColor = false
local IJC = Instance.new("UICorner"); IJC.CornerRadius = UDim.new(0,8); IJC.Parent = InfJumpBtn

-- ═══ Speed ═══
local SpeedLbl = Instance.new("TextLabel")
SpeedLbl.Parent = Menu
SpeedLbl.Size = UDim2.new(0.5, -20, 0, 16)
SpeedLbl.Position = UDim2.new(0, 15, 0, 353)
SpeedLbl.BackgroundTransparency = 1
SpeedLbl.Text = "🏃 السرعة:"
SpeedLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLbl.Font = Enum.Font.Gotham
SpeedLbl.TextSize = 11
SpeedLbl.TextXAlignment = Enum.TextXAlignment.Left

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = Menu
SpeedBox.Size = UDim2.new(0.5, -20, 0, 28)
SpeedBox.Position = UDim2.new(0, 15, 0, 370)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(SavedSettings.Speed)
SpeedBox.PlaceholderText = "16"
SpeedBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SpeedBox.TextColor3 = Color3.fromRGB(0, 255, 150)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 14
SpeedBox.ClearTextOnFocus = false
SpeedBox.TextXAlignment = Enum.TextXAlignment.Center
local SBC = Instance.new("UICorner"); SBC.CornerRadius = UDim.new(0,8); SBC.Parent = SpeedBox

local ApplySpeedBtn = Instance.new("TextButton")
ApplySpeedBtn.Parent = Menu
ApplySpeedBtn.Size = UDim2.new(0.5, -20, 0, 28)
ApplySpeedBtn.Position = UDim2.new(0.5, 5, 0, 370)
ApplySpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
ApplySpeedBtn.BorderSizePixel = 0
ApplySpeedBtn.Text = "✅ تطبيق"
ApplySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplySpeedBtn.Font = Enum.Font.GothamBold
ApplySpeedBtn.TextSize = 11
ApplySpeedBtn.AutoButtonColor = false
local ASC = Instance.new("UICorner"); ASC.CornerRadius = UDim.new(0,8); ASC.Parent = ApplySpeedBtn

-- Click TP
local ClickTPBtn = Instance.new("TextButton")
ClickTPBtn.Parent = Menu
ClickTPBtn.Size = UDim2.new(1, -30, 0, 35)
ClickTPBtn.Position = UDim2.new(0, 15, 0, 410)
ClickTPBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
ClickTPBtn.BorderSizePixel = 0
ClickTPBtn.Text = "🖱️ Click TP: معطل (يشتغل بالماوس)"
ClickTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickTPBtn.Font = Enum.Font.GothamBold
ClickTPBtn.TextSize = 11
ClickTPBtn.AutoButtonColor = false
local CTC = Instance.new("UICorner"); CTC.CornerRadius = UDim.new(0,8); CTC.Parent = ClickTPBtn

-- ═══ Checkpoint ═══
local D2 = Instance.new("Frame")
D2.Parent = Menu
D2.Size = UDim2.new(1, -30, 0, 1)
D2.Position = UDim2.new(0, 15, 0, 453)
D2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
D2.BorderSizePixel = 0

local CPLbl = Instance.new("TextLabel")
CPLbl.Parent = Menu
CPLbl.Size = UDim2.new(1, -30, 0, 16)
CPLbl.Position = UDim2.new(0, 15, 0, 459)
CPLbl.BackgroundTransparency = 1
CPLbl.Text = "📍 Checkpoint:"
CPLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
CPLbl.Font = Enum.Font.GothamBold
CPLbl.TextSize = 12
CPLbl.TextXAlignment = Enum.TextXAlignment.Left

local SaveCPBtn = Instance.new("TextButton")
SaveCPBtn.Parent = Menu
SaveCPBtn.Size = UDim2.new(0.5, -20, 0, 30)
SaveCPBtn.Position = UDim2.new(0, 15, 0, 481)
SaveCPBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
SaveCPBtn.BorderSizePixel = 0
SaveCPBtn.Text = "💾 حفظ"
SaveCPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveCPBtn.Font = Enum.Font.GothamBold
SaveCPBtn.TextSize = 11
SaveCPBtn.AutoButtonColor = false
local SCPC = Instance.new("UICorner"); SCPC.CornerRadius = UDim.new(0,8); SCPC.Parent = SaveCPBtn

local TeleBtn = Instance.new("TextButton")
TeleBtn.Parent = Menu
TeleBtn.Size = UDim2.new(0.5, -20, 0, 30)
TeleBtn.Position = UDim2.new(0.5, 5, 0, 481)
TeleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
TeleBtn.BorderSizePixel = 0
TeleBtn.Text = "📍 عودة"
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.GothamBold
TeleBtn.TextSize = 11
TeleBtn.AutoButtonColor = false
local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0,8); TC.Parent = TeleBtn

local DelCPBtn = Instance.new("TextButton")
DelCPBtn.Parent = Menu
DelCPBtn.Size = UDim2.new(1, -30, 0, 28)
DelCPBtn.Position = UDim2.new(0, 15, 0, 516)
DelCPBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
DelCPBtn.BorderSizePixel = 0
DelCPBtn.Text = "🗑️ حذف الـ Checkpoint"
DelCPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DelCPBtn.Font = Enum.Font.GothamBold
DelCPBtn.TextSize = 11
DelCPBtn.AutoButtonColor = false
local DCC = Instance.new("UICorner"); DCC.CornerRadius = UDim.new(0,8); DCC.Parent = DelCPBtn

local AutoRetBtn = Instance.new("TextButton")
AutoRetBtn.Parent = Menu
AutoRetBtn.Size = UDim2.new(1, -30, 0, 28)
AutoRetBtn.Position = UDim2.new(0, 15, 0, 549)
AutoRetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AutoRetBtn.BorderSizePixel = 0
AutoRetBtn.Text = "🔄 الرجوع التلقائي: معطل"
AutoRetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoRetBtn.Font = Enum.Font.Gotham
AutoRetBtn.TextSize = 11
AutoRetBtn.AutoButtonColor = false
local ARC = Instance.new("UICorner"); ARC.CornerRadius = UDim.new(0,8); ARC.Parent = AutoRetBtn

-- شريط الحالة
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = Menu
StatusLabel.Size = UDim2.new(1, -30, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 585)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "⚪ في انتظار..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ═══ البيانات ═══
local checkpointData = { position = nil, autoReturn = false }
local states = { noclip = false, infiniteJump = false, zoomUnlocked = false }
local zoomConnection = nil

-- ═══ إرسال شات ═══
local function sendCommand(cmd)
    local success = false
    pcall(function()
        local TCS = game:GetService("TextChatService")
        local ch = TCS:FindFirstChild("TextChannels")
        if ch then
            local g = ch:FindFirstChild("RBXGeneral")
            if g then g:SendAsync(cmd); success = true end
        end
    end)
    if not success then
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local e = RS:FindFirstChild("DefaultChatSystemChatEvents")
            if e and e:FindFirstChild("SayMessageRequest") then
                e.SayMessageRequest:FireServer(cmd, "All"); success = true
            end
        end)
    end
    return success
end

-- ═══════════════════════════════════════════════════════════════
-- ⚡ تنفيذ الأوامر (;re أولاً ثم ;char)
-- ═══════════════════════════════════════════════════════════════
local function executeCommands()
    local u = UserTextBox.Text
    local hasUser = (u ~= "" and u ~= nil)
    
    StatusLabel.Text = "⚡ جاري إرسال ;re..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    
    -- 1. إرسال ;re أولاً
    sendCommand(";re")
    
    -- 2. إصلاح التثبيت + السرعة
    local c = player.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyPosition") or v:IsA("BodyAngularVelocity") then
                    v:Destroy()
                end
            end
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector)
        end
        
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = SavedSettings.Speed
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
    
    -- 3. إرسال ;char me بعد تأخير
    if hasUser then
        StatusLabel.Text = "⚡ جاري إرسال ;char me..."
        task.wait(0.5)
        sendCommand(";char me " .. u)
    end
    
    local finalText = ";re"
    if hasUser then finalText = ";re + ;char me " .. u end
    
    StatusLabel.Text = "✅ " .. finalText .. " (سرعة: " .. SavedSettings.Speed .. ")"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
end

-- ═══ الكاميرا ═══
local function applyFOV()
    local fov = tonumber(FOVBox.Text)
    if not fov then return end
    if fov < 1 then fov = 1 end
    SavedSettings.FOV = fov
    camera.FieldOfView = fov
    StatusLabel.Text = "🔭 FOV: " .. fov .. " (محفوظ ✅)"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
end

ApplyFOVBtn.MouseButton1Click:Connect(applyFOV)

local function toggleUnlockZoom()
    states.zoomUnlocked = not states.zoomUnlocked
    SavedSettings.UnlockZoom = states.zoomUnlocked
    
    if states.zoomUnlocked then
        UnlockZoomBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        UnlockZoomBtn.Text = "🔓 كسر الزوم: مفعل ✅ (اسحب بالماوس)"
        player.CameraMaxZoomDistance = 1000000
        player.CameraMinZoomDistance = 0.5
        
        if zoomConnection then zoomConnection:Disconnect() end
        zoomConnection = RunService.Heartbeat:Connect(function()
            if states.zoomUnlocked then
                if player.CameraMaxZoomDistance ~= 1000000 then
                    player.CameraMaxZoomDistance = 1000000
                end
                if player.CameraMinZoomDistance ~= 0.5 then
                    player.CameraMinZoomDistance = 0.5
                end
            end
        end)
    else
        UnlockZoomBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        UnlockZoomBtn.Text = "🔓 كسر حدود الزوم (اسحب بالماوس)"
        player.CameraMaxZoomDistance = 128
        player.CameraMinZoomDistance = 0.5
        if zoomConnection then
            zoomConnection:Disconnect()
            zoomConnection = nil
        end
    end
end

UnlockZoomBtn.MouseButton1Click:Connect(toggleUnlockZoom)

-- ═══ Noclip ═══
local function toggleNoclip()
    states.noclip = not states.noclip
    SavedSettings.NoclipState = states.noclip
    if states.noclip then
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        NoclipBtn.Text = "🚀 ON"
    else
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        NoclipBtn.Text = "🚀 Noclip"
    end
end

-- ═══ Infinite Jump ═══
local function toggleInfiniteJump()
    states.infiniteJump = not states.infiniteJump
    SavedSettings.InfiniteJump = states.infiniteJump
    if states.infiniteJump then
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        InfJumpBtn.Text = "🦘 ON"
    else
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        InfJumpBtn.Text = "🦘 قفز لا نهائي"
    end
end

-- ═══ Speed ═══
ApplySpeedBtn.MouseButton1Click:Connect(function()
    local spd = tonumber(SpeedBox.Text)
    if spd then
        SavedSettings.Speed = spd
        local c = player.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = spd end
        end
        StatusLabel.Text = "🏃 السرعة: " .. spd .. " (محفوظة)"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    end
end)

-- ═══ Click TP ═══
local clickTPEnabled = false
local clickConn

local function calculateBestSpot(hitPos)
    local testPos = hitPos + Vector3.new(0, 3.5, 0)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {player.Character}
    local checkRay = workspace:Raycast(testPos + Vector3.new(0, 2, 0), Vector3.new(0, -5, 0), rayParams)
    if checkRay then
        return checkRay.Position + Vector3.new(0, 3.5, 0)
    end
    return testPos
end

local function toggleClickTP()
    clickTPEnabled = not clickTPEnabled
    if clickTPEnabled then
        ClickTPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        ClickTPBtn.Text = "🖱️ Click TP: ON ✅"
        clickConn = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if UserInputService:GetFocusedTextBox() then return end
            if not clickTPEnabled then return end
            local mouse = player:GetMouse()
            if not mouse.Target then return end
            local bestPos = calculateBestSpot(mouse.Hit.Position)
            local c = player.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.CFrame = CFrame.new(bestPos)
            StatusLabel.Text = "🖱️ طار للهدف!"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        end)
    else
        ClickTPBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        ClickTPBtn.Text = "🖱️ Click TP: معطل (يشتغل بالماوس)"
        if clickConn then clickConn:Disconnect(); clickConn = nil end
    end
end

-- ═══ Checkpoint ═══
local function saveCheckpoint()
    local c = player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    checkpointData.position = hrp.CFrame
    StatusLabel.Text = "💾 تم حفظ الموقع!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
end

local function teleportToCheckpoint()
    if not checkpointData.position then
        StatusLabel.Text = "⚠️ لا يوجد Checkpoint!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        return
    end
    local c = player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = checkpointData.position
    StatusLabel.Text = "📍 تم الانتقال!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
end

local function deleteCheckpoint()
    checkpointData.position = nil
    StatusLabel.Text = "🗑️ تم الحذف!"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
end

-- ═══ فتح/إغلاق ═══
local menuOpen = false
local function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        Menu.Visible = true
        Menu.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 320, 0, 720)
        }):Play()
    else
        TweenService:Create(Menu, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.delay(0.2, function() if not menuOpen then Menu.Visible = false end end)
    end
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)
CloseMenuBtn.MouseButton1Click:Connect(toggleMenu)

-- ربط الأزرار
NoclipBtn.MouseButton1Click:Connect(toggleNoclip)
InfJumpBtn.MouseButton1Click:Connect(toggleInfiniteJump)
ClickTPBtn.MouseButton1Click:Connect(toggleClickTP)
SaveCPBtn.MouseButton1Click:Connect(saveCheckpoint)
TeleBtn.MouseButton1Click:Connect(teleportToCheckpoint)
DelCPBtn.MouseButton1Click:Connect(deleteCheckpoint)

AutoRetBtn.MouseButton1Click:Connect(function()
    checkpointData.autoReturn = not checkpointData.autoReturn
    if checkpointData.autoReturn then
        AutoRetBtn.Text = "✅ الرجوع التلقائي: مفعل"
        AutoRetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
        AutoRetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        AutoRetBtn.Text = "🔄 الرجوع التلقائي: معطل"
        AutoRetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        AutoRetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- ═══ الهوت كي ═══
local hotkeyEnabled = true
local currentHotkey = SavedSettings.Hotkey

HotkeyBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = HotkeyBox.Text
    if #t > 1 then HotkeyBox.Text = string.sub(t, -1) end
    if #HotkeyBox.Text == 1 then
        currentHotkey = string.upper(HotkeyBox.Text)
        SavedSettings.Hotkey = currentHotkey
        EnableHotkeyBtn.Text = (hotkeyEnabled and "✅ الهوت كي: مفعل (" or "❌ معطل (") .. currentHotkey .. ")"
    end
end)

EnableHotkeyBtn.MouseButton1Click:Connect(function()
    hotkeyEnabled = not hotkeyEnabled
    if hotkeyEnabled then
        EnableHotkeyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        EnableHotkeyBtn.Text = "✅ الهوت كي: مفعل (" .. currentHotkey .. ")"
    else
        EnableHotkeyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        EnableHotkeyBtn.Text = "❌ معطل (" .. currentHotkey .. ")"
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not hotkeyEnabled then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode[currentHotkey] then
        executeCommands()
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- 👑 المراقب الصارم (Strict Loop)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait() 
        
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hum and math.abs(hum.WalkSpeed - SavedSettings.Speed) > 0.1 then
                hum.WalkSpeed = SavedSettings.Speed
            end
            
            if states.noclip and hrp then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
            
            if hrp and hum and hum.Health > 0 then
                if hum.MoveDirection.Magnitude > 0 and hrp.AssemblyLinearVelocity.Magnitude < 1 then
                    for _, v in pairs(hrp:GetChildren()) do
                        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("BodyPosition") or v:IsA("AlignPosition") then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- 🛡️ Anti-Desync (منع التوقف المفاجئ)
-- ═══════════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(3) -- كل 3 ثواني نرسل تحديث للسيرفر
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- تحديث بسيط لموقعك عشان السيرفر ما ينساك
                hrp.CFrame = hrp.CFrame 
            end
        end
    end
end)

-- ═══ القفز اللانهائي ═══
UserInputService.JumpRequest:Connect(function()
    if states.infiniteJump then
        local c = player.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- ═══ إرجاع الإعدادات عند الموت ═══
local function restoreOnSpawn(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    
    hum.WalkSpeed = SavedSettings.Speed
    camera.FieldOfView = SavedSettings.FOV
    FOVBox.Text = tostring(SavedSettings.FOV)
    
    if states.zoomUnlocked then
        player.CameraMaxZoomDistance = 1000000
        player.CameraMinZoomDistance = 0.5
    end
    
    if checkpointData.autoReturn and checkpointData.position then
        task.wait(0.3)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = checkpointData.position
        end
    end
end

player.CharacterAdded:Connect(restoreOnSpawn)

if player.Character then
    camera.FieldOfView = SavedSettings.FOV
end

print("✅ Pro Script v16.0 ULTRA جاهز! (Anti-Desync + FOV + ترتيب ;re ثم ;char)")
