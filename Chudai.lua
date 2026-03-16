-- ==========================================
-- [MASTER BOOTSTRAPPER] SCRIPT JADUL GACOR + UI SULTAN (FULL AUTO 24/7) 🔥
-- ==========================================
task.spawn(function()
    -- Looping aman biar eksekutor gak nge-hang
    while not game:IsLoaded() do task.wait(1) end
    
    local Players = game:GetService("Players")
    while not Players.LocalPlayer do task.wait(1) end
    local player = Players.LocalPlayer
    
    while not player:FindFirstChild("PlayerGui") do task.wait(1) end
    local PlayerGui = player:WaitForChild("PlayerGui")
    
    print("[AutoFarm] 🟢 Engine Roblox & Karakter siap. Memuat script...")
    task.wait(3) -- Jeda nafas buat HP lu
    
    -- ==========================================
    -- VARIABEL & SERVICES UTAMA
    -- ==========================================
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local PathfindingService = game:GetService("PathfindingService")
    local CoreGui = game:GetService("CoreGui")
    local TeleportService = game:GetService("TeleportService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    local jobEvents = ReplicatedStorage:WaitForChild("JobEvents", 999)
    local computersFolder = Workspace:WaitForChild("Computers", 999)

    local generateQuestion = jobEvents:WaitForChild("GenerateQuestion", 999)
    local correctAnswer = jobEvents:WaitForChild("CorrectAnswer", 999)
    local assignPrintJob = jobEvents:WaitForChild("AssignPrintJob", 999)
    local clearPrintJob = jobEvents:WaitForChild("ClearPrintJob", 999)

    local autoFarmEnabled = false
    local antiAfkEnabled = false

    local isPrinting = false
    local targetPrinterName = nil
    local currentState = "IDLE"
    local isAnswering = false 
    local isAsking = false

    -- ==========================================
    -- KONFIGURASI MEJA FAVORIT (SISTEM GPS)
    -- ==========================================
    local targetDeskCoordinate = Vector3.new(-5946.3037109375, 2.7061471939086914, -260.9524230957031) 
    local useLockedDesk = true 

    -- ==========================================
    -- MENDATA SEMUA MEJA (SETUP)
    -- ==========================================
    local allSetups = {}
    for _, v in ipairs(computersFolder:GetChildren()) do
        if v.Name == "Setup" and v:FindFirstChild("Seat") then
            table.insert(allSetups, v)
        end
    end

    -- ==========================================
    -- MEMBUAT CUSTOM UI 🔥
    -- ==========================================
    local guiName = "DragDriveSecureUI"
    local safeGuiParent = (gethui and gethui()) or CoreGui

    if safeGuiParent:FindFirstChild(guiName) then
        safeGuiParent:FindFirstChild(guiName):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = guiName
    ScreenGui.Parent = safeGuiParent

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 240, 0, 185) 
    MainFrame.Position = UDim2.new(0.5, -120, 0.5, -92)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true 

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = HeaderFrame
    
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = HeaderFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -45, 1, 0) 
    Title.Position = UDim2.new(0, 15, 0, 2) 
    Title.BackgroundTransparency = 1
    Title.Text = "OFFICE FARM | Garskirtz"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = HeaderFrame

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 0, 40)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Divider.BorderSizePixel = 0
    Divider.Parent = MainFrame

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
    MinimizeBtn.Position = UDim2.new(1, -34, 0.5, -12)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Text = "-"
    MinimizeBtn.Parent = HeaderFrame
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn

    local function createButton(yPos, text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 35)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.Text = text
        btn.Parent = MainFrame
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        return btn
    end

    local BtnAutoFarm = createButton(55, "START AUTO FARM : OFF")
    local BtnAntiAFK = createButton(95, "AUTO RECONNECT : OFF")
    local BtnPotatoMode = createButton(135, "ULTIMATE AFK (POTATO)") 

    local function MakeDraggable(guiObject)
        local dragging, dragInput, dragStart, startPos
        guiObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = guiObject.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        guiObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    MakeDraggable(MainFrame) 

    local FloatingIcon = Instance.new("ImageButton")
    FloatingIcon.Size = UDim2.new(0, 65, 0, 65) 
    FloatingIcon.Position = UDim2.new(0, 20, 0, 20)
    FloatingIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    FloatingIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatingIcon.Visible = false
    FloatingIcon.Active = true
    FloatingIcon.Image = "rbxassetid://127995701456737" 
    FloatingIcon.Parent = ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 12) 
    FloatCorner.Parent = FloatingIcon
    
    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(60, 60, 65)
    FloatStroke.Thickness = 2
    FloatStroke.Parent = FloatingIcon

    MakeDraggable(FloatingIcon) 

    MinimizeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Wait() 
        MainFrame.Visible = false
        
        FloatingIcon.Size = UDim2.new(0, 0, 0, 0)
        FloatingIcon.Visible = true
        TweenService:Create(FloatingIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 65, 0, 65)}):Play()
    end)

    FloatingIcon.MouseButton1Click:Connect(function()
        local hideFloatTween = TweenService:Create(FloatingIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        hideFloatTween:Play()
        hideFloatTween.Completed:Wait()
        FloatingIcon.Visible = false
        
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 240, 0, 185)}):Play()
    end)

    local function toggleAutoFarm(forceState)
        if forceState ~= nil then autoFarmEnabled = forceState else autoFarmEnabled = not autoFarmEnabled end
        if autoFarmEnabled then
            BtnAutoFarm.Text = "START AUTO FARM : ON"
            BtnAutoFarm.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
        else
            BtnAutoFarm.Text = "START AUTO FARM : OFF"
            BtnAutoFarm.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            currentState = "IDLE"
            isPrinting = false
            targetPrinterName = nil
        end
    end

    local function toggleAntiAFK(forceState)
        if forceState ~= nil then antiAfkEnabled = forceState else antiAfkEnabled = not antiAfkEnabled end
        if antiAfkEnabled then
            BtnAntiAFK.Text = "AUTO RECONNECT : ON"
            BtnAntiAFK.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
            local gc = getconnections or get_signal_cons
            if gc then
                for _, connection in pairs(gc(player.Idled)) do
                    if connection.Disable then connection:Disable() elseif connection.Disconnect then connection:Disconnect() end
                end
            end
            task.spawn(function()
                while antiAfkEnabled do
                    task.wait(math.random(300, 600))
                    local character = player.Character
                    if character then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then humanoid.Jump = true end
                    end
                end
            end)
            task.spawn(function()
                while antiAfkEnabled do
                    task.wait(1) 
                    pcall(function()
                        local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
                        if promptGui then
                            local overlay = promptGui:FindFirstChild("promptOverlay")
                            if overlay and overlay:FindFirstChild("ErrorPrompt") then
                                print("[AutoFarm] 🚨 Layar Error Terdeteksi! RECONNECTING...")
                                TeleportService:Teleport(game.PlaceId, player)
                                task.wait(10)
                            end
                        end
                    end)
                end
            end)
        else
            BtnAntiAFK.Text = "AUTO RECONNECT : OFF"
            BtnAntiAFK.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
    end

    BtnAutoFarm.MouseButton1Click:Connect(function() toggleAutoFarm() end)
    BtnAntiAFK.MouseButton1Click:Connect(function() toggleAntiAFK() end)

    -- ==========================================
    -- ⬛ FUNGSI ULTIMATE AFK (POTATO MODE) ⬛
    -- ==========================================
    local isPotatoModeActive = false
    local function AktifinPotatoMode()
        if isPotatoModeActive then return end 
        isPotatoModeActive = true
        
        BtnPotatoMode.Text = "POTATO MODE : AKTIF ⬛"
        BtnPotatoMode.BackgroundColor3 = Color3.fromRGB(150, 150, 40)

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.Brightness = 0
        Lighting.FogEnd = 9e9
        for _, obj in pairs(Lighting:GetChildren()) do obj:Destroy() end

        local safeFolders = {}
        if Workspace:FindFirstChild("Computers") then table.insert(safeFolders, Workspace.Computers) end
        if Workspace:FindFirstChild("BUILDING_FAROKA") then table.insert(safeFolders, Workspace.BUILDING_FAROKA) end

        local function bersihkanObjek(obj)
            local isSafe = false
            local isPlayer = false

            if obj:FindFirstAncestorOfClass("Model") and Players:GetPlayerFromCharacter(obj:FindFirstAncestorOfClass("Model")) then
                isSafe = true; isPlayer = true
            elseif obj:IsA("Model") and Players:GetPlayerFromCharacter(obj) then
                isSafe = true; isPlayer = true
            end

            if obj:IsA("Terrain") or obj:IsA("Camera") then isSafe = true end

            if not isSafe then
                for _, folder in pairs(safeFolders) do
                    if obj == folder or obj:IsDescendantOf(folder) then
                        isSafe = true; break
                    end
                end
            end

            if not isSafe then
                pcall(function() obj:Destroy() end)
            else
                pcall(function()
                    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.CastShadow = false
                        obj.Reflectance = 0
                        if not isPlayer then obj.Color = Color3.fromRGB(150, 150, 150) end 
                    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
                        obj:Destroy() 
                    elseif isPlayer and (obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh")) then
                        obj:Destroy() 
                    end
                end)
            end
        end

        for _, obj in pairs(Workspace:GetDescendants()) do bersihkanObjek(obj) end
        for _, p in pairs(Players:GetPlayers()) do 
            if p.Character then for _, acc in pairs(p.Character:GetDescendants()) do bersihkanObjek(acc) end end
        end

        Workspace.DescendantAdded:Connect(function(obj)
            task.wait(0.1)
            bersihkanObjek(obj)
        end)

        local BlackScreen = Instance.new("Frame")
        BlackScreen.Size = UDim2.new(10, 0, 10, 0)
        BlackScreen.Position = UDim2.new(-5, 0, -5, 0)
        BlackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        BlackScreen.ZIndex = 9999
        BlackScreen.Parent = ScreenGui
        
        local AfkText = Instance.new("TextLabel")
        AfkText.Size = UDim2.new(0, 400, 0, 50)
        AfkText.Position = UDim2.new(0.5, -200, 0.5, -50)
        AfkText.BackgroundTransparency = 1
        AfkText.Text = "💤 DDS HUB AFK MODE 💤\n(Biarkan Layar Hitam Biar Batre Irit)"
        AfkText.TextColor3 = Color3.fromRGB(0, 255, 0)
        AfkText.Font = Enum.Font.GothamBold
        AfkText.TextSize = 18
        AfkText.ZIndex = 10000
        AfkText.Parent = ScreenGui

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(0, 150, 0, 40)
        ToggleBtn.Position = UDim2.new(0.5, -75, 0.5, 20)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.Text = "Buka Layar 👀"
        ToggleBtn.Font = Enum.Font.GothamBold
        ToggleBtn.TextSize = 14
        ToggleBtn.ZIndex = 10000
        ToggleBtn.Parent = ScreenGui

        local isBlack = true
        ToggleBtn.MouseButton1Click:Connect(function()
            isBlack = not isBlack
            if isBlack then
                BlackScreen.BackgroundTransparency = 0
                AfkText.TextTransparency = 0
                ToggleBtn.Text = "Buka Layar 👀"
            else
                BlackScreen.BackgroundTransparency = 1 
                AfkText.TextTransparency = 1
                ToggleBtn.Text = "Tutup Layar ⬛"
            end
        end)
    end
    
    BtnPotatoMode.MouseButton1Click:Connect(AktifinPotatoMode)

    -- ==========================================
    -- [LAPIS 4] AUTO-LOBBY BYPASS (OTOMATIS AFK + POTATO AMAN) 🔥
    -- ==========================================
    task.spawn(function()
        local mainMenu = PlayerGui:WaitForChild("mainMenuSystem", 999)
        
        while task.wait(1) do
            if mainMenu and mainMenu.Enabled then
                print("[AutoFarm] 🏠 Menu Terdeteksi. Menembak Remote Bypass...")
                task.wait(4) 
                
                pcall(function()
                    local teamRemote = jobEvents:WaitForChild("TeamChangeRequest", 10)
                    if teamRemote then
                        teamRemote:FireServer("Office Worker", 0, 0, 0, "MainMenu")
                    end
                end)
                task.wait(1.5) 
                
                pcall(function()
                    local toggleRemote = ReplicatedStorage:WaitForChild("menuToggleRequest", 10)
                    if toggleRemote then toggleRemote:FireServer() end
                end)
                task.wait(1)
                
                mainMenu.Enabled = false 
                print("[AutoFarm] ✅ Berhasil Spawn!")
                
                task.wait(3)
                
                -- NYALAIN FARM & ANTI-AFK DULU BIAR JALAN KE MEJA
                toggleAutoFarm(true)
                toggleAntiAFK(true)
                
                -- ==========================================
                -- 📡 RADAR ANTI-VOID: TUNGGU SAMPE DUDUK DI KURSI
                -- ==========================================
                print("[AutoFarm] 📡 Menunggu karakter jalan dan duduk di kursi...")
                
                repeat
                    task.wait(1)
                    local char = player.Character
                    local humanoid = char and char:FindFirstChild("Humanoid")
                until humanoid and humanoid.Sit == true
                
                print("[AutoFarm] 📍 Pantat udah nempel di kursi! Eksekusi Potato Mode...")
                task.wait(1) -- Kasih nafas 1 detik pas baru duduk
                AktifinPotatoMode() -- BAM! MAP LANGSUNG RATA & LAYAR ITEM!
                
                break 
            end
        end
    end)

    -- ==========================================
    -- FUNGSI JALAN AMAN (PATHFINDING) (MURNI PUNYA LU!)
    -- ==========================================
    local function smartWalkTo(targetPosition)
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        local path = PathfindingService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = false 
        })

        pcall(function() path:ComputeAsync(rootPart.Position, targetPosition) end)

        if path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            for _, waypoint in ipairs(waypoints) do
                if not autoFarmEnabled then return end
                humanoid:MoveTo(waypoint.Position)
                humanoid.MoveToFinished:Wait()
            end
        else
            humanoid:MoveTo(targetPosition)
            humanoid.MoveToFinished:Wait()
        end
    end

    -- ==========================================
    -- SISTEM PENJAWAB SOAL (MURNI PUNYA LU!)
    -- ==========================================
    generateQuestion.OnClientEvent:Connect(function(questionText, optionsTable, sessionUUID)
        if not autoFarmEnabled or isPrinting or isAnswering then return end
        isAnswering = true
        currentState = "WORKING"
        local num1, operator, num2 = string.match(questionText, "(%-?%d+)%s*([%+%-xX%*/])%s*(%-?%d+)")
        if num1 and operator and num2 then
            num1, num2 = tonumber(num1), tonumber(num2)
            local calculatedAnswer
            if operator == "+" then calculatedAnswer = num1 + num2
            elseif operator == "-" then calculatedAnswer = num1 - num2
            elseif operator == "*" or operator:lower() == "x" then calculatedAnswer = num1 * num2
            elseif operator == "/" then calculatedAnswer = num1 / num2
            end

            local correctOptionID = nil
            for _, option in ipairs(optionsTable) do
                local optNum = tonumber(string.match(tostring(option.Text), "(%-?%d+)"))
                if optNum == calculatedAnswer then correctOptionID = option.ID break end
            end

            if correctOptionID and sessionUUID then
                task.wait(1.2 + (math.random(8, 18) / 10)) 
                if autoFarmEnabled then correctAnswer:FireServer(correctOptionID, sessionUUID) end
            end
        end
        isAnswering = false
    end)

    correctAnswer.OnClientEvent:Connect(function(status)
        if not autoFarmEnabled then return end
        if status == "success" then
            task.wait(0.2)
            if not isPrinting and not isAsking and autoFarmEnabled then
                isAsking = true
                generateQuestion:FireServer()
                isAsking = false
            end
        end
    end)

    -- ==========================================
    -- SISTEM INTERAKSI PRINTER (MURNI PUNYA LU!)
    -- ==========================================
    assignPrintJob.OnClientEvent:Connect(function(printerName)
        if not autoFarmEnabled then return end
        targetPrinterName = printerName
        isPrinting = true
        currentState = "PRINTING"
    end)

    clearPrintJob.OnClientEvent:Connect(function()
        targetPrinterName = nil
        isPrinting = false
        currentState = "COOLDOWN" 
    end)

    -- ==========================================
    -- LOOP UTAMA PERGERAKAN (MURNI PUNYA LU!)
    -- ==========================================
    task.spawn(function()
        while task.wait(0.5) do
            local character = player.Character
            if not character then continue end
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then continue end
            
            if not autoFarmEnabled then
                if humanoid.Sit then humanoid.Sit = false end
                continue
            end
            
            if currentState == "COOLDOWN" then
                if humanoid.Sit then humanoid.Sit = false end
                local cooldownTimer = 0
                while cooldownTimer < 2 and autoFarmEnabled do
                    task.wait(1)
                    cooldownTimer = cooldownTimer + 1
                end
                if autoFarmEnabled then currentState = "IDLE" end
                continue
            end
            
            if currentState == "IDLE" then
                if humanoid.Sit then
                    humanoid.Sit = false
                    task.wait(0.5)
                end
                
                local targetSetup = nil
                
                if useLockedDesk and targetDeskCoordinate then
                    local closestDist = math.huge
                    for _, setup in ipairs(allSetups) do
                        if setup:FindFirstChild("Seat") then
                            local dist = (setup.Seat.Position - targetDeskCoordinate).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                if not setup.Seat.Occupant then targetSetup = setup end
                            end
                        end
                    end
                else
                    for _, setup in ipairs(allSetups) do
                        if not setup.Seat.Occupant then
                            targetSetup = setup
                            break
                        end
                    end
                end
                
                if targetSetup then
                    smartWalkTo(targetSetup.Seat.Position)
                    if autoFarmEnabled then
                        targetSetup.Seat:Sit(humanoid)
                        currentState = "WORKING"
                    end
                end
                
            elseif currentState == "PRINTING" and targetPrinterName then
                if humanoid.Sit then
                    humanoid.Sit = false
                    task.wait(0.5)
                end
                
                local printerFolder = computersFolder:FindFirstChild(targetPrinterName)
                if printerFolder and printerFolder:FindFirstChild("Part") then
                    local printerPart = printerFolder.Part
                    
                    smartWalkTo(printerPart.Position)
                    
                    if autoFarmEnabled then
                        local prompt = printerPart:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt then
                            local waitLimit = 0
                            while not prompt.Enabled and waitLimit < 10 do
                                task.wait(0.5)
                                waitLimit = waitLimit + 1
                            end
                            if prompt.Enabled then
                                fireproximityprompt(prompt)
                                task.wait(2)
                            end
                        end
                    end
                end
            end
        end
    end)
end)
