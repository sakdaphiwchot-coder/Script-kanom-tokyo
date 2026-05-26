--------------------------------------------------------------------------

	--	░█████╗░██╗░░██╗██╗██╗░░██╗██╗░░░██╗██████╗░
	--	██╔══██╗██║░██╔╝██║██║░░██║██║░░░██║██╔══██╗
	--	███████║█████═╝░██║███████║██║░░░██║██████╦╝
	--	██╔══██║██╔═██╗░██║██╔══██║██║░░░██║██╔══██╗
	--	██║░░██║██║░╚██╗██║██║░░██║╚██████╔╝██████╦╝
	--	╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚═╝░╚═════╝░╚═════╝░
	-- kanom tokyo
-----------------------------------------------------------------------------------
local startTime = tick()

local NothingLibrary = loadstring(game:HttpGetAsync(
    'https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua'
))()

local Windows = NothingLibrary.new({
    Title = "AKIHUB",
    Description = "Kanom tokyo : กำลังโหลดเวลา...",
    Keybind = Enum.KeyCode.RightControl,
    Logo = 'http://www.roblox.com/asset/?id=123772963717609'
})

-- รอ UI โหลด
task.wait(1)

-- หา TextLabel ของ Description
local function findDescriptionLabel()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Kanom tokyo") then
            return v
        end
    end
end

local descLabel = findDescriptionLabel()

task.spawn(function()
    while true do
        if descLabel then
            local elapsed = math.floor(tick() - startTime)

            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60

            local timeText = string.format("%02d:%02d:%02d", hours, minutes, seconds)

            descLabel.Text = "Kanom tokyo : PlayTime " .. timeText
        end
        task.wait(1)
    end
end)

    local TabFrame = Windows:NewTab({
    	Title = "Main",
    	Description = "Fram tab",
    	Icon = "rbxassetid://80313090537874"
    })
    local Section = TabFrame:NewSection({
    	Title = "Farm Level",
    	Icon = "rbxassetid://116520925666989",
    	Position = "Left"
    })
    local InfoSection = TabFrame:NewSection({
    	Title = "Information",
    	Icon = "rbxassetid://120904195401721",
    	Position = "Right"
    })

-- Global Settings
_G.AutoFarm = false
_G.TweenSpeed = 180
_G.AttackDelay = 0.001
_G.HoldFTime = 2
_G.FlyPosition = "Below"
_G.DistanceFromEnemy = 6

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- Player
local Player = Players.LocalPlayer
local hasInitialized = false

-- Logging Function
local function Log(message, level)
    level = level or "INFO"
    local timestamp = os.date("%H:%M:%S")
    local logMessage = string.format("[%s] [%s] %s", timestamp, level, tostring(message))
    print(logMessage)
    warn(logMessage)
end

Log("Starting Auto Farm Script...")

-- Remove old farm platform
for _, v in pairs(workspace:GetChildren()) do
    if v.Name == "FarmPlatform" then
        v:Destroy()
        Log("Removed old FarmPlatform")
    end
end

-- Function: Normal Attack
local function NormalAttack()
    pcall(function()
        local args = { { "NormalAttack", "\014" } }
        ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    end)
end

-- Function: Press E Key
local function PressE()
    Log("Pressing E key to equip weapon...")
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    Log("E key pressed!")
end

-- Function: Check if Player is Dead
local function IsPlayerDead()
    local char = Player.Character
    if not char then return true end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return true end
    return humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead
end

-- Death Detection Loop
task.spawn(function()
    Log("Death detection system started!")
    while task.wait(0.5) do
        if _G.AutoFarm and IsPlayerDead() then
            Log("Player died! Waiting 7 seconds before respawn...", "WARN")
            task.wait(7)
            if _G.AutoFarm then
                PressE()
                Log("Weapon equipped after respawn!")
            end
        end
    end
end)

-- Function: Get Player Level
local function GetLevel()
    local success, level = pcall(function()
        return Player:WaitForChild("Data"):WaitForChild("Level").Value
    end)
    if success and type(level) == "number" then
        return level
    else
        return 1
    end
end

-- Quest Data (Updated)
local QuestTable = {
local QuestTable = {
    {1, 49, "QuestGiver (Lv.1-Lv.50)", "Human,Athlete"},
    {50, 149, "QuestGiver (Lv.50-Lv.150)", "Rank 2 Investigator"},
    {150, 249, "QuestGiver (Lv.150-Lv.250)", "Bulk Ghoul"},
    {250, 349, "QuestGiver (Lv.250-Lv.350)", "Rank 1 Investigator"},
    {350, 399, "QuestGiver (Lv.350-Lv.400)", "Serpent Ghoul"},
    {400, 449, "QuestGiver (Lv.400-Lv.450)", "Rin Ghoul"},
    {450, 499, "QuestGiver (Lv.450-Lv.500)", "First class Investigator"},
    {500, 549, "QuestGiver (Lv.500-Lv.550)", "Aogiri"},
    {550, 599, "QuestGiver (Lv.550-Lv.600)", "Akira"},
    {600, 699, "QuestGiver (Lv.600-Lv.700)", "Enforcer"},
    {700, 800, "QuestGiver (Lv.700-Lv.800)", "Phantom"},
    {1100, 1200, "QuestGiver (Lv.1100-Lv.1200)", "Faulty Tatara Ghoul"},
	}

local function GetQuestData()
    local lv = GetLevel()
    for _, q in ipairs(QuestTable) do
        if lv >= q[1] and lv <= q[2] then
            return q[3], q[4]
        end
    end
    return nil, nil
end

-- Function: Check if Player has Quest
local function HasQuest()
    local gui = Player.PlayerGui:FindFirstChild("Quest", true)
    return gui and gui.Visible
end

-- Function: Tween to CFrame
local function TweenTo(cf)
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    TweenService:Create(hrp, TweenInfo.new(dist / _G.TweenSpeed, Enum.EasingStyle.Linear), { CFrame = cf }):Play()
end

-- Function: Accept Quest
local function AcceptQuest(questName)
    Log("Accepting quest: " .. tostring(questName))
    local npc = workspace.TalkNpc.QuestGiver:FindFirstChild(questName)
    if not npc or not npc.PrimaryPart then
        Log("Quest NPC not found: " .. tostring(questName), "WARN")
        return
    end
    repeat
        if not _G.AutoFarm then return end
        TweenTo(npc.PrimaryPart.CFrame)
        task.wait(0.2)

        -- กด F กับ NPC
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(2)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)

        -- กดคลิกซ้าย 2 ครั้ง หลัง F
        for i = 1, 2 do
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)  -- กดลง
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) -- ปล่อย
            task.wait(0.01)
        end

        -- ตรวจสอบปุ่ม GUI "Understood"
        for _, v in ipairs(Player.PlayerGui:GetDescendants()) do
            if not _G.AutoFarm then return end
            if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
                local label = v:FindFirstChildWhichIsA("TextLabel")
                if (label and label.Text:find("Understood")) or (v:IsA("TextButton") and v.Text:find("Understood")) then
                    GuiService.SelectedObject = v
                    task.wait()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    break
                end
            end
        end

        task.wait(0.1)
    until HasQuest() or not _G.AutoFarm

    if HasQuest() then
        Log("Quest accepted successfully!")
    end
end


-- Platform Functions
local currentTween = nil
local platformPart = nil
local platformConnection = nil

local function CreatePlatform()
    if not platformPart or not platformPart.Parent then
        platformPart = Instance.new("Part")
        platformPart.Name = "FarmPlatform"
        platformPart.Size = Vector3.new(10, 1, 10)
        platformPart.Anchored = true
        platformPart.Transparency = 1
        platformPart.CanCollide = true
        platformPart.Parent = workspace
        Log("Platform created (invisible)!")
    end
    return platformPart
end

local function StartPlatformFollow()
    if platformConnection then
        platformConnection:Disconnect()
        platformConnection = nil
    end
    platformConnection = RunService.Heartbeat:Connect(function()
        if not _G.AutoFarm then return end
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local platform = CreatePlatform()
        if platform then
            platform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3, hrp.Position.Z)
        end
    end)
    Log("Platform follow started!")
end

local function StopPlatformFollow()
    if platformConnection then
        platformConnection:Disconnect()
        platformConnection = nil
        Log("Platform follow stopped!")
    end
end

local function RemovePlatform()
    StopPlatformFollow()
    if platformPart and platformPart.Parent then
        platformPart:Destroy()
        platformPart = nil
        Log("Platform removed!")
    end
end

-- Function: Tween To Enemy
local function TweenToEnemy(enemyHRP)
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local y = _G.DistanceFromEnemy
    if _G.FlyPosition == "Below" then
        y = -math.abs(_G.DistanceFromEnemy)
    else
        y = math.abs(_G.DistanceFromEnemy)
    end

    local targetPos = enemyHRP.Position + Vector3.new(0, y, 0)
    local dist = (hrp.Position - targetPos).Magnitude

    if dist < 3 then
        local targetCFrame = CFrame.lookAt(targetPos, enemyHRP.Position)
        hrp.CFrame = targetCFrame
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        local platform = CreatePlatform()
        platform.CFrame = CFrame.new(targetPos.X, targetPos.Y - 3, targetPos.Z)
        return
    end

    local platform = CreatePlatform()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    if currentTween then currentTween:Cancel() end

    platform.CFrame = CFrame.new(targetPos.X, targetPos.Y - 3, targetPos.Z)
    local targetCFrame = CFrame.lookAt(targetPos, enemyHRP.Position)
    local tweenTime = dist / _G.TweenSpeed

    currentTween = TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
    currentTween:Play()
    TweenService:Create(platform, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), { CFrame = CFrame.new(targetPos.X, targetPos.Y - 3, targetPos.Z) }):Play()
end

-- Function: Find Enemy
local function FindEnemy(name)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    return nil
end

-- Function: Stay On Platform
local function StayOnPlatform()
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local platform = CreatePlatform()
    local currentPos = hrp.Position
    platform.CFrame = CFrame.new(currentPos.X, currentPos.Y - 3, currentPos.Z)
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end

-- Main Farming Loop
task.spawn(function()
    Log("Main loop started!")
    while task.wait(0.25) do
        if not _G.AutoFarm then
            RemovePlatform()
            continue
        end

        local questName, enemyNames = GetQuestData()
        if not questName or not enemyNames then
            Log("No quest data for current level: " .. tostring(GetLevel()), "WARN")
            StayOnPlatform()
            continue
        end

        if not HasQuest() then
            AcceptQuest(questName)
            continue
        end

        local enemiesToFarm = {}
        if type(enemyNames) == "string" and enemyNames ~= "" then
            for name in string.gmatch(enemyNames, "[^,]+") do
                local cleanName = name:match("^%s*(.-)%s*$")
                if cleanName ~= "" then table.insert(enemiesToFarm, cleanName) end
            end
        end

        local foundAnyEnemy = false
        for _, enemyName in ipairs(enemiesToFarm) do
            local enemy = FindEnemy(enemyName)
            if enemy then
                foundAnyEnemy = true
                Log("Farming: " .. enemyName)
                repeat
                    if not _G.AutoFarm then break end
                    TweenToEnemy(enemy.HumanoidRootPart)
                    NormalAttack()
                    task.wait(_G.AttackDelay)
                until enemy.Humanoid.Health <= 0 or not enemy.Parent
                Log("Enemy defeated: " .. enemyName)
                break
            end
        end

        if not foundAnyEnemy then
            Log("No enemy found, staying on platform...", "WARN")
            StayOnPlatform()
        end
    end
end)

-- ======================
-- UI Section Integration
-- ======================

-- Auto Farm Toggle
Section:NewToggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(tr)
        _G.AutoFarm = tr
        print("AutoFarm:", tr)
        if tr and not hasInitialized then
            hasInitialized = true
            task.wait(0.5)
            PressE()
        end
    end
})

-- Distance From Enemy Slider
Section:NewSlider({
    Title = "Distance From Enemy",
    Min = 1,
    Max = 100,
    Default = _G.DistanceFromEnemy,
    Callback = function(val)
        _G.DistanceFromEnemy = val
        print("Distance:", val)
    end
})

-- Fly Position Dropdown
Section:NewDropdown({
    Title = "Fly Position",
    Data = {"Above", "Below"},
    Default = _G.FlyPosition,
    Callback = function(val)
        _G.FlyPosition = val
        print("Fly Position:", val)
    end
})

-- Tween Speed Slider
Section:NewSlider({
    Title = "Tween Speed",
    Min = 50,
    Max = 500,
    Default = _G.TweenSpeed,
    Callback = function(val)
        _G.TweenSpeed = val
        print("Tween Speed:", val)
    end
})

-- Status Updater (optional, print status to console)
task.spawn(function()
    while task.wait(2) do
        local level = GetLevel()
        local questName, enemyNames = GetQuestData()
        local hasQuest = HasQuest()
        local status = string.format(
            "Level: %d | Quest: %s | AutoFarm: %s",
            level,
            hasQuest and "Active" or "None",
            _G.AutoFarm and "ON" or "OFF"
        )
        print(status)
    end
end)

Log("Script loaded successfully! All features ready.")
Log("Current Level: " .. tostring(GetLevel()))

----ฆ่าบอส
local Section = TabFrame:NewSection({
    	Title = "Boss Target",
    	Icon = "rbxassetid://100017212359303",
    	Position = "Left"
    })
---------------------------------------------
--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

--==================================================
-- LOCAL STATE
--==================================================
local AutoFarmEnabled = false
local FollowConnection = nil
local AttackConnection = nil

local SelectedBoss = "Kaneki"
local DistanceBelowBoss = 10
local TweenSpeed = 180 -- speed ของ tween

--==================================================
-- REMOTE ATTACK
--==================================================
local attackRemote =
	ReplicatedStorage:WaitForChild("BridgeNet2")
	:WaitForChild("dataRemoteEvent")

local attackArgs = {
	{
		"NormalAttack",
		"\014"
	}
}

--==================================================
-- UTILS
--==================================================
local function getRoot(obj)
	if not obj then return nil end
	if obj:IsA("Model") then
		return obj:FindFirstChild("HumanoidRootPart")
			or obj:FindFirstChild("Torso")
			or obj:FindFirstChild("UpperTorso")
	elseif obj:IsA("BasePart") then
		return obj
	end
	return nil
end

local function getCharRoot()
	return getRoot(char)
end

--==================================================
-- BOSS FOLDER
--==================================================
local bossFolder = workspace:WaitForChild("AI/Player"):WaitForChild("Boss")

--==================================================
-- FIND BOSS
--==================================================
local function findBoss()
	for _, v in ipairs(bossFolder:GetChildren()) do
		if SelectedBoss == "Kaneki" and v.Name == "Kaneki" then
			return v
		end
		if SelectedBoss == "Jason" and string.sub(v.Name, 1, 5) == "Jason" then
			return v
		end
		if SelectedBoss == "Noro" and string.sub(v.Name, 1, 4) == "Noro" then
			return v
		end
		if SelectedBoss == "GiftBox" and v.Name == "GiftBox" then
			return v
		end
	end
	return nil
end

--==================================================
-- STOP ALL
--==================================================
local function stopAll()
	if FollowConnection then
		FollowConnection:Disconnect()
		FollowConnection = nil
	end
	if AttackConnection then
		AttackConnection:Disconnect()
		AttackConnection = nil
	end
end

--==================================================
-- START ATTACK LOOP
--==================================================
local function startAttack()
	if AttackConnection then
		AttackConnection:Disconnect()
	end

	AttackConnection = RunService.Heartbeat:Connect(function()
		if not AutoFarmEnabled then return end
		pcall(function()
			attackRemote:FireServer(unpack(attackArgs))
		end)
	end)
end

--==================================================
-- START FOLLOW (ใช้ Tween)
--==================================================
local function startFollow()
	stopAll()
	if not AutoFarmEnabled then return end

	local boss = nil
	local bossRoot = nil
	local platformPart = nil

	-- สร้าง platform ใต้ตัวละครเพื่อวาง Tween
	if not platformPart or not platformPart.Parent then
		platformPart = Instance.new("Part")
		platformPart.Name = "TweenPlatform"
		platformPart.Size = Vector3.new(10,1,10)
		platformPart.Anchored = true
		platformPart.Transparency = 1
		platformPart.CanCollide = true
		platformPart.Parent = workspace
	end

	FollowConnection = RunService.Heartbeat:Connect(function()
		if not AutoFarmEnabled then return end

		local hrp = getCharRoot()
		if not hrp then return end

		-- หา boss แบบ realtime
		if not boss or not boss.Parent then
			boss = findBoss()
			if not boss then return end
			bossRoot = getRoot(boss)
			if not bossRoot then return end
		end

		-- คำนวณตำแหน่งเป้าหมาย (ใต้บอส)
		local targetPos = bossRoot.Position - Vector3.new(0, DistanceBelowBoss, 0)

		-- tween ตัวละครไปยังตำแหน่งเป้าหมาย
		local dist = (hrp.Position - targetPos).Magnitude
		if dist > 1 then
			local tweenInfo = TweenInfo.new(dist / TweenSpeed, Enum.EasingStyle.Linear)
			local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos, bossRoot.Position)})
			tween:Play()
		end

		-- เคลื่อน platform ตามตัวละคร
		platformPart.CFrame = CFrame.new(targetPos.X, targetPos.Y - 3, targetPos.Z)
	end)

	startAttack()
end

--==================================================
-- RESPAWN FIX
--==================================================
player.CharacterAdded:Connect(function(newChar)
	char = newChar
	newChar:WaitForChild("HumanoidRootPart", 10)

	if AutoFarmEnabled then
		task.wait(0.4)
		startFollow()
	end
end)

--==================================================
-- UI
--==================================================
Section:NewDropdown({
	Title = "Boss",
	Data = {"Kaneki", "Jason", "Noro", "GiftBox"},
	Default = 1,
	Callback = function(v)
		SelectedBoss = v
		if AutoFarmEnabled then
			startFollow()
		end
	end,
})

Section:NewToggle({
	Title = "Auto Farm",
	Default = false,
	Callback = function(v)
		AutoFarmEnabled = v
		if v then
			startFollow()
		else
			stopAll()
		end
	end,
})

Section:NewSlider({
	Title = "Distance (Below Boss)",
	Min = 1,
	Max = 50,
	Default = 10,
	Callback = function(v)
		DistanceBelowBoss = v
	end,
})

Section:NewSlider({
	Title = "Tween Speed",
	Min = 50,
	Max = 500,
	Default = TweenSpeed,
	Callback = function(v)
		TweenSpeed = v
	end,
})
    
----------------------------------------------
    InfoSection:NewTitle('Join Discord')
    InfoSection:NewButton({
    
    	Title = "Discord",
    	Callback = function()
    		-- สคริปต์นี้ใช้คัดลอกข้อความที่กำหนดไว้ไปยังคลิปบอร์ด
    -- วางใน LocalScript (เช่น StarterPlayerScripts หรือ StarterGui)
    
    local textToCopy = "https://discord.gg/NeGv59fYEd"  -- <== ใส่ข้อความที่ต้องการคัดลอกตรงนี้
    
    if setclipboard then
    	setclipboard(textToCopy)
    	game:GetService("StarterGui"):SetCore("SendNotification", {
    		Title = "คัดลอกลิ้งดิสคอสแล้ว!";
    		Text = textToCopy;
    		Duration = 5;
    	})
    else
    	warn("setclipboard ใช้งานไม่ได้ในสภาพแวดล้อมนี้")
    end
    	end,
    })
-- เริ่มต้น Section ตามที่คุณให้
local Section = TabFrame:NewSection({
    Title = "Stats", 
    Icon = "rbxassetid://106134345394902",
    Position = "Left"
})

-- เก็บค่า Toggle + Slider
local autoValues = {
    Damage = false,
    Durability = false,
    Stamina = false,
    Speed = false,
    Amount = 25
}

-- ฟังก์ชันยิงรีโมท
local function fireRemote(stat, amount)
    local args = {
        {
            { stat, amount },
            "\003"
        }
    }
    ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
end

-- สร้าง Toggle ตามลำดับ
Section:NewToggle({
    Title = "Damage",
    Default = false,
    Callback = function(tr)
        autoValues.Damage = tr
    end,
})

Section:NewToggle({
    Title = "Durability",
    Default = false,
    Callback = function(tr)
        autoValues.Durability = tr
    end,
})

Section:NewToggle({
    Title = "Stamina",
    Default = false,
    Callback = function(tr)
        autoValues.Stamina = tr
    end,
})

Section:NewToggle({
    Title = "Speed",
    Default = false,
    Callback = function(tr)
        autoValues.Speed = tr
    end,
})

-- Slider วางล่างสุด
Section:NewSlider({
    Title = "Amount",
    Min = 1,
    Max = 50,
    Default = 3,
    Callback = function(a)
        autoValues.Amount = a
    end,
})

-- Loop ยิงรัว
spawn(function()
    while true do
        task.wait(0.1) -- ปรับความเร็วรัวได้
        for stat, enabled in pairs(autoValues) do
            if enabled and stat ~= "Amount" then
                fireRemote(stat, autoValues.Amount)
            end
        end
    end
end)
-----------------------------------------------------
local Section = TabFrame:NewSection({
	Title = "FramMonster",
	Icon = "rbxassetid://88389776033023",
	Position = "Left"
})
-------------------------------------------------------
-- ================== CONFIG ==========================
local Distance = 10
local ATTACK_DELAY = 0.001
local TweenSpeed = 180
local SelectedMonster = nil
local AutoFarmRunning = false
local FarmAllRunning = false
local NoclipEnabled = false

local MONSTERS = {
    "Bulk Ghoul",
    "First class Investigator",
    "Rank 1 Investigator",
    "Rank 2 Investigator",
    "Rin Ghoul",
    "Serpent Ghoul",
    "Athlete",
    "Akira",
    "Aogiri",
    "Human"


-- ================== SERVICES ========================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- ================== ATTACK REMOTE ===================
local function NormalAttack()
    local args = {{"NormalAttack","\014"}}
    ReplicatedStorage:WaitForChild("BridgeNet2")
        :WaitForChild("dataRemoteEvent")
        :FireServer(unpack(args))
end

-- ================== FIND CLOSEST ENEMY =========================
local function FindEnemyByName(name)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local closest, shortest = nil, math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model")
        and v.Name == name
        and v:FindFirstChild("Humanoid")
        and v:FindFirstChild("HumanoidRootPart")
        and v.Humanoid.Health > 0 then

            local dist = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
    end

    return closest
end

-- ================== CREATE PLATFORM ====================
local platformPart = Instance.new("Part")
platformPart.Name = "TweenPlatform"
platformPart.Size = Vector3.new(10,1,10)
platformPart.Anchored = true
platformPart.Transparency = 1
platformPart.CanCollide = true
platformPart.Parent = workspace

-- ================== TP ใต้มอนแบบ Tween ====================
local function TweenUnder(enemyHRP)
    local char = Player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    hum:ChangeState(Enum.HumanoidStateType.Physics)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    local targetPos = enemyHRP.Position - Vector3.new(0, Distance, 0)
    local tweenTime = (hrp.Position - targetPos).Magnitude / TweenSpeed
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos, enemyHRP.Position)})
    tween:Play()

    -- เคลื่อน platform ตาม
    TweenService:Create(platformPart, tweenInfo, {CFrame = CFrame.new(targetPos.X, targetPos.Y - 3, targetPos.Z)}):Play()
end

-- ================== NOCALIP ===========================
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ================== AUTO FARM MONSTER ==================
task.spawn(function()
    while true do
        task.wait(0.2)
        if not AutoFarmRunning then continue end
        if not SelectedMonster then continue end
        if FarmAllRunning then continue end -- หยุด AutoFarm ถ้า FarmAll กำลังทำงาน

        local enemy = FindEnemyByName(SelectedMonster)
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            repeat
                if not AutoFarmRunning or FarmAllRunning then break end
                task.wait(ATTACK_DELAY)
                if not enemy.Parent or enemy.Humanoid.Health <= 0 then break end

                TweenUnder(enemy.HumanoidRootPart)
                NormalAttack()
            until false
        end
    end
end)

-- ================== FARM ALL MONSTERS ==================
task.spawn(function()
    while true do
        task.wait(0.2)
        if not FarmAllRunning then continue end

        for _, monsterName in ipairs(MONSTERS) do
            if not FarmAllRunning then break end
            local enemy = FindEnemyByName(monsterName)
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                repeat
                    if not FarmAllRunning then break end
                    task.wait(ATTACK_DELAY)
                    if not enemy.Parent or enemy.Humanoid.Health <= 0 then break end

                    TweenUnder(enemy.HumanoidRootPart)
                    NormalAttack()
                until false
            end
        end
    end
end)

-- ================== UI ==============================
Section:NewDropdown({
    Title = "Select Monster",
    Data = MONSTERS,
    Default = MONSTERS[1],
    Callback = function(v)
        SelectedMonster = v
        print("🎯 Selected:", v)
    end,
})

Section:NewSlider({
    Title = "Distance Under Monster",
    Min = 1,
    Max = 50,
    Default = Distance,
    Callback = function(v)
        Distance = v
    end,
})

Section:NewSlider({
    Title = "Tween Speed",
    Min = 50,
    Max = 500,
    Default = TweenSpeed,
    Callback = function(v)
        TweenSpeed = v
    end,
})

Section:NewToggle({
    Title = "Auto Farm Monster",
    Default = false,
    Callback = function(state)
        AutoFarmRunning = state
        print(state and "✅ Auto Farm : ON" or "⛔ Auto Farm : OFF")
    end,
})

Section:NewToggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        NoclipEnabled = state
        print(state and "👻 Noclip : ON" or "🚫 Noclip : OFF")
    end,
})

Section:NewToggle({
    Title = "Farm All",
    Default = false,
    Callback = function(state)
        FarmAllRunning = state
        print(state and "⚡ Farming All Monsters : ON" or "⛔ Farming All Monsters : OFF")
    end,
})

    local Section = TabFrame:NewSection({
	Title = "PlayerInfo",
	Icon = "rbxassetid://100713420961350",
	Position = "Right"
    })
    local player = game:GetService("Players").LocalPlayer
local levelValue = player.Data.Level.Value
local rcValue = player.leaderstats.RC.Value

local player = game:GetService("Players").LocalPlayer

-- สมมติว่าตัวแปร dropdown คือสิ่งที่ถูกสร้างขึ้นมา
local dropdown = Section:NewDropdown({
    Title = "User: " .. player.Name,
    Data = {"Level: Loading...", "RC: Loading..."},
    Default = 1,
    Callback = function(a)
        print("Selected: " .. a)
    end,
})

-- ลูปสำหรับอัปเดตข้อมูลทุกๆ 1 วินาที
task.spawn(function()
    while true do
        pcall(function()
            local levelValue = player.Data.Level.Value
            local rcValue = player.leaderstats.RC.Value
            
            -- อัปเดตข้อมูลใน Dropdown (ชื่อฟังก์ชัน Refresh/Update ขึ้นอยู่กับแต่ละ Library)
            -- ตัวอย่างทั่วไปมักใช้ :Refresh หรือสร้าง Data Table ใหม่
            dropdown:Refresh({
                "Level: " .. tostring(levelValue),
                "RC: " .. tostring(rcValue)
            }, true) -- true เพื่อให้ค่าที่เลือกปัจจุบันยังคงอยู่
        end)
        task.wait(1)
    end
end)
-----------------------------------------------------------------------------------------tap2จุดวาป
    local TabFrame = Windows:NewTab({
    	Title = "Teleport",
    	Description = "Teleport To Savezone and Boss",
    	Icon = "rbxassetid://136578691850987"
    })
    
    local Section = TabFrame:NewSection({
    	Title = "Teleport",
    	Icon = "rbxassetid://7743869054",
    	Position = "Left"
    })
-- ================== SERVICES ==========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ================== UTILS =============================
local function TweenToPosition(targetPosition, speed)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local dist = (hrp.Position - targetPosition).Magnitude
    local tweenTime = dist / speed
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
end

-- ================== BUTTONS ===========================
local TWEEN_SPEED = 180 -- ความเร็วการวาป

Section:NewButton({
    Title = "Ccg Spawn",
    Callback = function()
        local targetPosition = Vector3.new(182, 6, -479)
        TweenToPosition(targetPosition, TWEEN_SPEED)
    end,
})

Section:NewButton({
    Title = "Ghoul Spawn",
    Callback = function()
        local targetPosition = Vector3.new(-102, 5, 206)
        TweenToPosition(targetPosition, TWEEN_SPEED)
    end,
})

Section:NewButton({
    Title = "Cafe",
    Callback = function()
        local targetPosition = Vector3.new(446, 20, 161)
        TweenToPosition(targetPosition, TWEEN_SPEED)
    end,
})
local Section = TabFrame:NewSection({
	Title = "Boss",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})
Section:NewButton({
    Title = "Json",
    Callback = function()
        local targetPosition = Vector3.new(-86, 5, -161)
        TweenToPosition(targetPosition, TWEEN_SPEED)
    end,
})

Section:NewButton({
    Title = "Noro",
    Callback = function()
        local targetPosition = Vector3.new(225, 8, -157)
        TweenToPosition(targetPosition, TWEEN_SPEED)
    end,
})

Section:NewButton({
    Title = "Kaneki",
    Callback = function()
        local targetPosition = Vector3.new(143, 5, 620)
        TweenToPosition(targetPosition, TWEEN_SPEED)
    end,
})
local TabFrame = Windows:NewTab({
	Title = "Quest Tap",
	Description = "Quest tab",
	Icon = "rbxassetid://7733960981"
})

local Section = TabFrame:NewSection({
	Title = "Quest",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

-- ตัวแปรควบคุมการทำงาน
local isRunning = false

-- ฟังก์ชันหยุดตัวละคร
local function StopMovement()
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.RotVelocity = Vector3.new(0, 0, 0)
end

-- ฟังก์ชันหาปุ่ม UI
local function FindHinamiButton()
    for _, gui in pairs(playerGui:GetDescendants()) do
        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
            local textLabel = gui:FindFirstChildOfClass("TextLabel")
            local btnText = textLabel and textLabel.Text or (gui:IsA("TextButton") and gui.Text or "")
            if string.find(string.lower(btnText), "of course") or string.find(string.lower(btnText), "hinami") then
                return gui
            end
        end
    end
    return nil
end

-- ฟังก์ชันกด F รัวๆ
local function SpamF(seconds)
    local endTime = tick() + seconds
    while tick() < endTime and isRunning do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        task.wait(0.05)
    end
end

-- ฟังก์ชันหาดอกไม้ที่ใกล้ที่สุด
local usedFlowers = {}
local function GetNearestFlower()
    local nearest = nil
    local minDistance = math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Flower" and not usedFlowers[obj] then
            local p = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
            if p then
                local dist = (hrp.Position - p.Position).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

-- ==========================================
-- UI Toggle Section
-- ==========================================
Section:NewToggle({
    Title = "Auto Hinami & Flower",
    Default = false,
    Callback = function(tr)
        isRunning = tr
        
        if isRunning then
            print("เริ่มทำงาน...")
            
            -- 1. ไปหา Hinami
            local npc = workspace:WaitForChild("TalkNpc"):WaitForChild("Special"):WaitForChild("Hinami")
            local targetCFrame = (npc.PrimaryPart and npc.PrimaryPart.CFrame or npc:GetModelCFrame()) * CFrame.new(0, 0, -2)

            local tweenNPC = TweenService:Create(hrp, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
            tweenNPC:Play()
            tweenNPC.Completed:Wait()
            StopMovement()

            if not isRunning then return end -- เช็คอีกรอบเผื่อปิดกลางคัน

            -- เปิดบทสนทนา
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(1.2)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)

            -- หาและกดปุ่ม
            local button = nil
            local retry = 0
            repeat 
                button = FindHinamiButton()
                task.wait(0.5)
                retry = retry + 1
            until button or retry > 10 or not isRunning

            if button and isRunning then
                GuiService.SelectedObject = button
                task.wait(0.2)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                pcall(function() button:Activate() end)
                
                task.wait(1.5)
                
                -- 2. ไปหา Flower 3 อัน
                usedFlowers = {} -- ล้างค่าเก่า
                for i = 1, 3 do
                    if not isRunning then break end
                    
                    local targetFlower = GetNearestFlower()
                    if targetFlower then
                        usedFlowers[targetFlower] = true
                        local part = targetFlower:IsA("BasePart") and targetFlower or targetFlower:FindFirstChildWhichIsA("BasePart", true)
                        
                        if part then
                            local targetPos = part.Position + Vector3.new(0, 2, 0)
                            local finalCFrame = CFrame.new(targetPos, Vector3.new(part.Position.X, targetPos.Y, part.Position.Z))
                            
                            local distance = (hrp.Position - targetPos).Magnitude
                            local travelTime = distance / 50
                            
                            local tween = TweenService:Create(hrp, TweenInfo.new(travelTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = finalCFrame})
                            tween:Play()
                            tween.Completed:Wait()
                            
                            StopMovement()
                            task.wait(0.2)
                            SpamF(1.2)
                            task.wait(0.5)
                        end
                    end
                end
                print("จบภารกิจ")
            end
        else
            print("หยุดการทำงาน")
            StopMovement()
        end
    end,
})
-----WEBHOOK
    local TabFrame = Windows:NewTab({
	    Title = "Webhook",
	    Description = "Webhook Tab",
	    Icon = "rbxassetid://94553780802594"
    })
    local Section = TabFrame:NewSection({
	    Title = "Start",
	    Icon = "rbxassetid://7743869054",
	    Position = "Left"
    })
    -- ================== GLOBAL ==================
_G.Webhook = _G.Webhook or ""
_G.WebhookEnabled = _G.WebhookEnabled or false
_G.SendCooldown = _G.SendCooldown or 60

-- ================== SEND LOOP ==================
task.spawn(function()
    while task.wait(1) do
        if _G.WebhookEnabled then
            task.wait(_G.SendCooldown)

            local Players = game:GetService("Players")
            local HttpService = game:GetService("HttpService")
            local plr = Players.LocalPlayer

            local Level = plr.Data.Level
            local RC = plr.leaderstats.RC
            local YenObj = plr.PlayerGui.HUD.Container.Profile.Yen.Amount
            local YenValue = YenObj:IsA("TextLabel") and YenObj.Text or tostring(YenObj.Value)

            local text =
                "👤 **Player :** "..plr.Name.."\n" ..
                "⭐ **Level :** "..Level.Value.."\n" ..
                "💎 **RC :** "..RC.Value.."\n" ..
                "💴 **Yen :** "..YenValue

            local payload = {
                embeds = {{
                    title = "📊 Player Info",
                    color = 7506394,
                    description = text
                }}
            }

            local request = syn and syn.request or http_request or request
            request({
                Url = _G.Webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end
    end
end)

-- ================== TOGGLE ==================
Section:NewToggle({
    Title = "Webhook",
    Default = false,
    Callback = function(tr)
        _G.WebhookEnabled = tr
    end,
})

-- ================== SLIDER ==================
Section:NewSlider({
    Title = "Webhook Cooldown (วินาที)",
    Min = 1,
    Max = 1000,
    Default = _G.SendCooldown,
    Callback = function(a)
        _G.SendCooldown = a
        print("Webhook Cooldown:", a)
    end,
})
-----Setting
    local TabFrame = Windows:NewTab({
    	Title = "Setting",
    	Description = "Setting tab",
    	Icon = "rbxassetid://127037527815611"
    })
    local Section = TabFrame:NewSection({
    	Title = "SelectTeam",
    	Icon = "rbxassetid://7743869054",
    	Position = "Left"
    })
    
    local InfoSection = TabFrame:NewSection({
    	Title = "Information",
    	Icon = "rbxassetid://7733964719",
    	Position = "Right"
    })
    Section:NewButton({
    	Title = "CCG",
    	Callback = function()
    		local args = {
    	"CCG"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("TeamSelect"):FireServer(unpack(args))
    	end,
    })
    
    Section:NewButton({
    	Title = "Ghoul",
    	Callback = function()
    		local args = {
    	"GHOUL"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("TeamSelect"):FireServer(unpack(args))
    	end,
    })
    Section:NewSlider({
        Title = "SuperJump",
        Min = 10,
        Max = 200,
        Default = 25,
        Callback = function(a)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
    
            humanoid.JumpPower = a
        end,
    })
    
    Section:NewSlider({
        Title = "WalkSpeed",
        Min = 15,
        Max = 200,
        Default = 16,
        Callback = function(a)
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
    
            humanoid.WalkSpeed = a
        end,
    })
    Section:NewSlider({
    	Title = "Fly",
    	Min = 10,
    	Max = 100,
    	Default = 20,
    	Callback = function(speed)
    		local player = game.Players.LocalPlayer
    		local character = player.Character or player.CharacterAdded:Wait()
    		local hrp = character:WaitForChild("HumanoidRootPart")
    		local uis = game:GetService("UserInputService")
    		local rs = game:GetService("RunService")
    
    		local flying = false
    		local control = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}
    		local bodyGyro, bodyVel
    
    		local function startFly()
    			if flying then return end
    			flying = true
    
    			bodyGyro = Instance.new("BodyGyro")
    			bodyGyro.P = 9e4
    			bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    			bodyGyro.CFrame = hrp.CFrame
    			bodyGyro.Parent = hrp
    
    			bodyVel = Instance.new("BodyVelocity")
    			bodyVel.Velocity = Vector3.zero
    			bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    			bodyVel.Parent = hrp
    
    			rs:BindToRenderStep("FlyControl", Enum.RenderPriority.Input.Value, function()
    				local cam = workspace.CurrentCamera
    				bodyGyro.CFrame = cam.CFrame
    
    				local moveDir = Vector3.new(control.R - control.L, control.U - control.D, control.B - control.F)
    				if moveDir.Magnitude > 0 then
    					moveDir = cam.CFrame:VectorToWorldSpace(moveDir).Unit * speed
    				end
    				bodyVel.Velocity = moveDir
    			end)
    		end
    
    		local function stopFly()
    			flying = false
    			rs:UnbindFromRenderStep("FlyControl")
    			if bodyGyro then bodyGyro:Destroy() end
    			if bodyVel then bodyVel:Destroy() end
    		end
    
    		-- เปลี่ยนปุ่มเปิด/ปิดบินเป็น Comma (,)
    		uis.InputBegan:Connect(function(input, gp)
    			if gp then return end
    			if input.KeyCode == Enum.KeyCode.Comma then
    				if flying then
    					stopFly()
    				else
    					startFly()
    				end
    			elseif input.KeyCode == Enum.KeyCode.W then
    				control.F = 1
    			elseif input.KeyCode == Enum.KeyCode.S then
    				control.B = 1
    			elseif input.KeyCode == Enum.KeyCode.A then
    				control.L = 1
    			elseif input.KeyCode == Enum.KeyCode.D then
    				control.R = 1
    			elseif input.KeyCode == Enum.KeyCode.Space then
    				control.U = 1
    			elseif input.KeyCode == Enum.KeyCode.LeftShift then
    				control.D = 1
    			end
    		end)
    
    		uis.InputEnded:Connect(function(input)
    			if input.KeyCode == Enum.KeyCode.W then
    				control.F = 0
    			elseif input.KeyCode == Enum.KeyCode.S then
    				control.B = 0
    			elseif input.KeyCode == Enum.KeyCode.A then
    				control.L = 0
    			elseif input.KeyCode == Enum.KeyCode.D then
    				control.R = 0
    			elseif input.KeyCode == Enum.KeyCode.Space then
    				control.U = 0
    			elseif input.KeyCode == Enum.KeyCode.LeftShift then
    				control.D = 0
    			end
    		end)
    	end
    })
    Section:NewButton({
    	Title = "Rejone",
    	Callback = function()
    		-- ดึง Service ที่จำเป็น
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    
    -- ดึงผู้เล่นปัจจุบัน
    local player = Players.LocalPlayer
    
    -- ดึง GameId ปัจจุบัน
    local placeId = game.PlaceId
    
    -- ฟังก์ชันรีเกม
    local function rejoinGame()
        -- Teleport ผู้เล่นไปที่เกมเดิม
        TeleportService:Teleport(placeId, player)
    end
    
    -- เรียกฟังก์ชัน
    rejoinGame()
    	end,
    })
    
    Section:NewButton({
    	Title = "HopServer",
    	Callback = function()
    		--  สคริปต์ Hop Server
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    
    local placeId = 71793674075007 -- ไอดีแมพที่ต้องการ
    local player = Players.LocalPlayer
    local servers = {}
    local cursor = ""
    local triedServers = {}
    
    local function hopServer()
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if success and response and response.data then
            for _, server in ipairs(response.data) do
                if server.playing < server.maxPlayers and not triedServers[server.id] then
                    triedServers[server.id] = true
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                    print("กำลังวาร์ปไปเซิร์ฟเวอร์ใหม่:", server.id)
                    return
                end
            end
            if response.nextPageCursor then
                cursor = response.nextPageCursor
                hopServer()
            else
                print("ไม่พบเซิร์ฟเวอร์ใหม่ ลองใหม่อีกครั้ง...")
            end
        else
            warn("โหลดข้อมูลเซิร์ฟเวอร์ไม่สำเร็จ")
        end
    end
    
    hopServer()
    	end,
    
    
    })
    Section:NewButton({
    	Title = "Ctrl + LeftClick = TP",
    	Callback = function()
    		-- Teleport on Ctrl + Left Click
    -- วางไฟล์นี้ใน StarterPlayer > StarterPlayerScripts
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    local player = Players.LocalPlayer
    local mouse = player:GetMouse()
    
    local ctrlHeld = false
    local debounce = false
    local ABLE_RANGE = 400 -- ระยะสูงสุดที่อนุญาตให้วาป (เปลี่ยนหรือตั้งเป็น math.huge เพื่อไม่จำกัด)
    
    local function getCharacter()
        return player.Character or player.CharacterAdded:Wait()
    end
    
    local function getHRP(char)
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end
    
    -- ตรวจจับ Ctrl กด/ปล่อย
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            ctrlHeld = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            ctrlHeld = false
        end
    end)
    
    -- ฟังก์ชันวาปจริง (ใช้ Tween ให้เนียน)
    local function teleportTo(position)
        if debounce then return end
        debounce = true
    
        local char = getCharacter()
        local hrp = getHRP(char)
        if not hrp then debounce = false return end
    
        local dist = (hrp.Position - position).Magnitude
        if ABLE_RANGE and dist > ABLE_RANGE then
            -- ถ้าอยากให้มีเสียงหรือข้อความแจ้ง ให้เพิ่มตรงนี้
            debounce = false
            return
        end
    
        -- ยกตำแหน่งขึ้นเล็กน้อยเพื่อไม่ให้ติดพื้น/วัตถุ
        local targetCFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    
        -- ถ้าต้องการให้วาปทันที: hrp.CFrame = targetCFrame
        -- เราใช้ Tween เพื่อให้การเคลื่อนที่ดูเนียน
        local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local ok, err = pcall(function()
            local tw = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            tw:Play()
            tw.Completed:Wait()
        end)
        if not ok then
            -- fallback ถ้า Tween ล้มเหลว
            hrp.CFrame = targetCFrame
        end
    
        wait(0.1) -- ระยะเวลาหน่วงเล็กน้อยก่อนเปิดใช้อีกครั้ง
        debounce = false
    end
    
    -- เมื่อคลิกซ้าย ถ้ามีการกด Ctrl อยู่ ให้วาปไปตำแหน่งเมาส์
    mouse.Button1Down:Connect(function()
        if not ctrlHeld then return end
    
        -- mouse.Hit อาจเป็น CFrame; ใช้ .p หรือ .Position
        local hit = mouse.Hit
        if not hit then return end
        local pos = hit.p or hit.Position
        if not pos then return end
    
        teleportTo(pos)
    end)
    
    -- ให้สคริปต์ยังทำงานหลังเกิดใหม่
    player.CharacterAdded:Connect(function(char)
        -- ถ้าอยากรีเซ็ตตัวแปรใด ให้ทำตรงนี้ (ปกติไม่จำเป็น)
    end)
    	end,
    })
----------------------------------------------------------------------
	Section:NewButton({
	Title = "BoosFps",
	Callback = function()
		--  Full BoosFPS Script (ลบ Texture + เปลี่ยนวัสดุทั้งหมด)
local workspace = game:GetService("Workspace")

local function superClean(obj)
	pcall(function()
		-- ลบพวก Decal, Texture, SurfaceAppearance
		if obj:IsA("Decal") or obj:IsA("Texture") then
			obj:Destroy()
		elseif obj:IsA("SurfaceAppearance") then
			obj.ColorMap = ""
			obj.NormalMap = ""
			obj.MetalnessMap = ""
		elseif obj:IsA("SpecialMesh") then
			obj.TextureId = ""
		elseif obj:IsA("MeshPart") then
			obj.TextureID = ""
			obj.MaterialVariant = ""
			obj.Material = Enum.Material.SmoothPlastic
			obj.Color = Color3.fromRGB(255, 255, 255)
		elseif obj:IsA("UnionOperation") then
			obj.UsePartColor = true
			obj.Material = Enum.Material.SmoothPlastic
			obj.Color = Color3.fromRGB(255, 255, 255)
		elseif obj:IsA("BasePart") then
			-- เปลี่ยนวัสดุทั้งหมดเป็น SmoothPlastic
			obj.Material = Enum.Material.SmoothPlastic
			obj.Color = Color3.fromRGB(255, 255, 255)
			
			-- ลบลูกที่เป็น Texture/Decal ออก
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
					child:Destroy()
				elseif child:IsA("SpecialMesh") then
					child.TextureId = ""
				end
			end
		elseif obj:IsA("Model") then
			-- ตรวจลูกใน Model
			for _, part in ipairs(obj:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Material = Enum.Material.SmoothPlastic
					part.Color = Color3.fromRGB(255, 255, 255)
				end
				if part:IsA("Decal") or part:IsA("Texture") then
					part:Destroy()
				elseif part:IsA("SurfaceAppearance") then
					part.ColorMap = ""
					part.NormalMap = ""
					part.MetalnessMap = ""
				elseif part:IsA("SpecialMesh") then
					part.TextureId = ""
				elseif part:IsA("MeshPart") then
					part.TextureID = ""
					part.Material = Enum.Material.SmoothPlastic
					part.Color = Color3.fromRGB(255, 255, 255)
				end
			end
		end
	end)
end

--  ล้างทั้งหมดที่มีอยู่
for _, obj in ipairs(workspace:GetDescendants()) do
	superClean(obj)
end

--  ตรวจจับสิ่งใหม่ที่ถูกสร้างขึ้นในภายหลัง
workspace.DescendantAdded:Connect(function(obj)
	task.delay(0.05, function()
		superClean(obj)
	end)
end)

print("[BoosFPS]")
	end,
})

Section:NewButton({
	Title = "Free HeadLess",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()

		local head = char:FindFirstChild("Head")
		if head then
			-- ทำให้หัวล่องหน
			head.Transparency = 1
			head.CanCollide = false

			-- ลบหน้า (Decal) ออกด้วย
			for _, v in pairs(head:GetChildren()) do
				if v:IsA("Decal") then
					v:Destroy()
				end
			end
		end
	end,
})

--==================================================
-- SECTION
--==================================================

local Section = TabFrame:NewSection({
	Title = "Anti Dev/Admin",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})

--==================================================
-- SETTINGS
--==================================================

local BlacklistUserIds = {
    4237831067,
    4773106771,
    451367976,
    669857001,
    3232600111,
    1892202467,
    9678111378,
    1529242348,
    2525819438,
}

_G.AntiAdmin = false
_G.AntiAdminMode = 1 -- 1=Rejoin | 2=Kick | 3=Hop

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

--==================================================
-- FUNCTIONS
--==================================================

local function IsBlacklisted(player)
	for _, id in ipairs(BlacklistUserIds) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

local function Rejoin()
	TeleportService:Teleport(PlaceId, LocalPlayer)
end

local function KickSelf()
	LocalPlayer:Kick("Detected Dev/Admin in server")
end

local function HopServer()
	local servers = {}
	local req = game:HttpGet(
		"https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
	)
	local data = HttpService:JSONDecode(req)

	for _, v in pairs(data.data) do
		if v.playing < v.maxPlayers then
			table.insert(servers, v.id)
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(
			PlaceId,
			servers[math.random(1, #servers)],
			LocalPlayer
		)
	else
		Rejoin()
	end
end

local function DoAction()
	if _G.AntiAdminMode == 1 then
		Rejoin()
	elseif _G.AntiAdminMode == 2 then
		KickSelf()
	elseif _G.AntiAdminMode == 3 then
		HopServer()
	end
end

--==================================================
-- CHECK LOOP
--==================================================

task.spawn(function()
	while task.wait(1) do
		if _G.AntiAdmin then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and IsBlacklisted(plr) then
					DoAction()
					return
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if _G.AntiAdmin and IsBlacklisted(plr) then
		DoAction()
	end
end)

--==================================================
-- UI
--==================================================

Section:NewToggle({
	Title = "Enable Anti Dev/Admin",
	Default = false,
	Callback = function(tr)
		_G.AntiAdmin = tr
	end,
})

Section:NewDropdown({
	Title = "Action Mode",
	Data = {
		"Rejoin Server",
		"Kick Self",
		"Hop Server"
	},
	Default = nill,
	Callback = function(a)
		_G.AntiAdminMode = a
	end,
})
----------------------------------------------------------------------

----------------------------------------------------------------------
    InfoSection:NewTitle('If you find any bugs or problems with the script, you can report the issue in Discord.')

    -- ********** จบสคริปต์ของผู้ใช้ **********
