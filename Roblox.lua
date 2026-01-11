local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- CONFIGURATION AIMBOT ---
local aimbotEnabled = false
local aimFov = 150
local smoothing = 0.15
local teamCheck = false

-- --- BASE DU GUI ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PeakTigerUltraV4"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- --- WATERMARK NEON METAL (HAUT CENTRE) ---
local devWatermark = Instance.new("TextLabel")
devWatermark.Name = "DevWatermarkCenter"
devWatermark.Size = UDim2.new(0, 400, 0, 50)
devWatermark.Position = UDim2.new(0.5, -200, 0, 15)
devWatermark.BackgroundTransparency = 1
devWatermark.Text = "PeakTigerV1_By_PeakDev"
devWatermark.TextColor3 = Color3.fromRGB(255, 0, 0)
devWatermark.Font = Enum.Font.GothamBold
devWatermark.TextSize = 22
devWatermark.ZIndex = 10
devWatermark.Parent = screenGui

-- Effet Neon (Glow)
local neonStroke = Instance.new("UIStroke")
neonStroke.Color = Color3.fromRGB(255, 0, 0)
neonStroke.Thickness = 3
neonStroke.Transparency = 0.5
neonStroke.Parent = devWatermark

local metalStroke = Instance.new("UIStroke")
metalStroke.Color = Color3.fromRGB(0, 0, 0)
metalStroke.Thickness = 1.5
metalStroke.Parent = devWatermark

-- --- CERCLE FOV (ROUGE) ---
local fovCircle = Instance.new("Frame")
fovCircle.Name = "AimbotFOV"
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fovCircle.BackgroundTransparency = 0.8
fovCircle.BorderSizePixel = 0
fovCircle.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Visible = false
fovCircle.Parent = screenGui

local fovCorner = Instance.new("UICorner", fovCircle)
fovCorner.CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = Color3.fromRGB(255, 0, 0)
fovStroke.Thickness = 1

-- --- WATERMARK PeakTigerV1 (HAUT DROITE) ---
local watermark = Instance.new("TextLabel")
watermark.Name = "PeakWatermark"
watermark.Size = UDim2.new(0, 200, 0, 50)
watermark.Position = UDim2.new(1, -210, 0, 10)
watermark.BackgroundTransparency = 1
watermark.Text = "PeakTigerV1"
watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
watermark.Font = Enum.Font.GothamBold
watermark.TextSize = 25
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = screenGui

local waterStroke = Instance.new("UIStroke")
waterStroke.Color = Color3.fromRGB(255, 0, 0)
waterStroke.Thickness = 2
waterStroke.Parent = watermark

-- --- MENU PRINCIPAL ---
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 0, 0)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- --- BARRE LATÉRALE ---
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 110, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
sideBar.BorderSizePixel = 0
sideBar.Parent = mainFrame

local function createNavButton(name, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = sideBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local btnP1 = createNavButton("PRINCIPAL", UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(180, 0, 0))
local btnP2 = createNavButton("ESP", UDim2.new(0.05, 0, 0.22, 0), Color3.fromRGB(40, 40, 40))
local btnP3 = createNavButton("AIMBOT", UDim2.new(0.05, 0, 0.39, 0), Color3.fromRGB(40, 40, 40))
local btnP4 = createNavButton("MOUVEMENT", UDim2.new(0.05, 0, 0.56, 0), Color3.fromRGB(40, 40, 40))
local btnP5 = createNavButton("MISC", UDim2.new(0.05, 0, 0.73, 0), Color3.fromRGB(40, 40, 40))

-- --- CONTENEURS ---
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -120, 1, -10)
content.Position = UDim2.new(0, 115, 0, 5)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local function createPage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = content
    return p
end

local pageMain = createPage() pageMain.Visible = true
local pageESP = createPage()
local pageAim = createPage()
local pageMove = createPage()
local pageMisc = createPage()

local function createActionButton(text, pos, color, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

-- --- ÉLÉMENTS DES PAGES ---
local dupeBtn = createActionButton("DUPLIQUER OBJET", UDim2.new(0, 0, 0.1, 0), Color3.fromRGB(180, 0, 0), pageMain)
local destroyBtn = createActionButton("SELF DESTRUCT", UDim2.new(0, 0, 0.7, 0), Color3.fromRGB(60, 60, 60), pageMain)

local espToggle = createActionButton("ACTIVER ESP 2D", UDim2.new(0, 0, 0.05, 0), Color3.fromRGB(40, 40, 40), pageESP)
local tracerToggle = createActionButton("ACTIVER TRACERS", UDim2.new(0, 0, 0.22, 0), Color3.fromRGB(40, 40, 40), pageESP)
local skeletonToggle = createActionButton("ACTIVER SKELETON", UDim2.new(0, 0, 0.39, 0), Color3.fromRGB(40, 40, 40), pageESP)
local nameToggle = createActionButton("ACTIVER NAMETAG", UDim2.new(0, 0, 0.56, 0), Color3.fromRGB(40, 40, 40), pageESP)

local aimBtn = createActionButton("AIMBOT : OFF", UDim2.new(0, 0, 0.1, 0), Color3.fromRGB(40, 40, 40), pageAim)
local fovBtn = createActionButton("FOV CIRCLE : OFF", UDim2.new(0, 0, 0.3, 0), Color3.fromRGB(40, 40, 40), pageAim)

local flyToggle = createActionButton("ACTIVER FLY", UDim2.new(0, 0, 0.1, 0), Color3.fromRGB(40, 40, 40), pageMove)
local invisToggle = createActionButton("INVISIBILITÉ (LOCAL)", UDim2.new(0, 0, 0.1, 0), Color3.fromRGB(40, 40, 40), pageMisc)

-- --- LOGIQUE NAVIGATION ---
local pages = {pageMain, pageESP, pageAim, pageMove, pageMisc}
local navBtns = {btnP1, btnP2, btnP3, btnP4, btnP5}

local function showPage(index)
    for i, p in pairs(pages) do
        p.Visible = (i == index)
        navBtns[i].BackgroundColor3 = (i == index) and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(40, 40, 40)
    end
end

btnP1.MouseButton1Click:Connect(function() showPage(1) end)
btnP2.MouseButton1Click:Connect(function() showPage(2) end)
btnP3.MouseButton1Click:Connect(function() showPage(3) end)
btnP4.MouseButton1Click:Connect(function() showPage(4) end)
btnP5.MouseButton1Click:Connect(function() showPage(5) end)

-- --- AIMBOT LOGIC ---
local function getClosestPlayer()
    local target = nil
    local shortestDistance = aimFov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if teamCheck and player.Team == LocalPlayer.Team then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    target = player.Character.Head
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

aimBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimBtn.Text = aimbotEnabled and "AIMBOT : ON" or "AIMBOT : OFF"
    aimBtn.TextColor3 = aimbotEnabled and Color3.new(0,1,0) or Color3.new(1,1,1)
end)

fovBtn.MouseButton1Click:Connect(function()
    fovCircle.Visible = not fovCircle.Visible
    fovBtn.Text = fovCircle.Visible and "FOV CIRCLE : ON" or "FOV CIRCLE : OFF"
    fovBtn.TextColor3 = fovCircle.Visible and Color3.new(0,1,0) or Color3.new(1,1,1)
end)

-- --- ESP HELPERS ---
local espActive, tracerActive, skeletonActive, namesActive = false, false, false, false
local espObjects = {}

local function drawLine(parent)
    local l = Instance.new("Frame", parent)
    l.BorderSizePixel = 0
    l.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    l.AnchorPoint = Vector2.new(0.5, 0.5)
    return l
end

local function updateLine(line, p1, p2)
    local dist = (p1 - p2).Magnitude
    line.Size = UDim2.new(0, dist, 0, 1)
    line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
    line.Rotation = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
    line.Visible = true
end

espToggle.MouseButton1Click:Connect(function()
    espActive = not espActive
    espToggle.TextColor3 = espActive and Color3.new(0,1,0) or Color3.new(1,1,1)
end)
tracerToggle.MouseButton1Click:Connect(function()
    tracerActive = not tracerActive
    tracerToggle.TextColor3 = tracerActive and Color3.new(0,1,0) or Color3.new(1,1,1)
end)
skeletonToggle.MouseButton1Click:Connect(function()
    skeletonActive = not skeletonActive
    skeletonToggle.TextColor3 = skeletonActive and Color3.new(0,1,0) or Color3.new(1,1,1)
end)
nameToggle.MouseButton1Click:Connect(function()
    namesActive = not namesActive
    nameToggle.TextColor3 = namesActive and Color3.new(0,1,0) or Color3.new(1,1,1)
end)

-- --- FLY SYSTEM ---
local flying = false
local flySpeed = 50

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            mousemoverel((targetPos.X - mousePos.X) * smoothing, (targetPos.Y - mousePos.Y) * smoothing)
        end
    end

    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end
        hrp.CFrame = hrp.CFrame + (moveDir * (flySpeed / 60))
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if not espObjects[p] then
                local folder = Instance.new("Folder", screenGui)
                local box = Instance.new("Frame", folder)
                box.BackgroundTransparency = 1
                Instance.new("UIStroke", box).Color = Color3.fromRGB(255, 0, 0)
                local tag = Instance.new("TextLabel", folder)
                tag.BackgroundTransparency = 1
                tag.TextColor3 = Color3.fromRGB(255, 0, 0)
                tag.Font = Enum.Font.GothamBold
                tag.TextSize = 14
                Instance.new("UIStroke", tag).Color = Color3.new(0,0,0)
                local tracer = drawLine(folder)
                local skel = {T1 = drawLine(folder), LA = drawLine(folder), RA = drawLine(folder), LL = drawLine(folder), RL = drawLine(folder)}
                espObjects[p] = {Folder = folder, Box = box, Tracer = tracer, Skeleton = skel, Tag = tag}
            end
            local obj = espObjects[p]
            if onScreen then
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                local size = (1 / dist) * 2000
                obj.Box.Visible = espActive
                obj.Box.Size = UDim2.new(0, size, 0, size * 1.5)
                obj.Box.Position = UDim2.new(0, pos.X - (size/2), 0, pos.Y - (size*1.5)/2)
                obj.Tag.Visible = namesActive
                if namesActive then
                    obj.Tag.Text = p.Name .. " [" .. math.floor(dist) .. "m]"
                    obj.Tag.Position = UDim2.new(0, pos.X, 0, pos.Y - (size * 0.9))
                end
                obj.Tracer.Visible = tracerActive
                if tracerActive then
                    updateLine(obj.Tracer, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), Vector2.new(pos.X, pos.Y + (size*0.75)))
                end
                for _, line in pairs(obj.Skeleton) do line.Visible = skeletonActive end
                if skeletonActive then
                    local head = Camera:WorldToViewportPoint(char:FindFirstChild("Head") and char.Head.Position or hrp.Position + Vector3.new(0,1.5,0))
                    updateLine(obj.Skeleton.T1, Vector2.new(head.X, head.Y), Vector2.new(pos.X, pos.Y))
                end
            else
                obj.Box.Visible = false
                obj.Tracer.Visible = false
                obj.Tag.Visible = false
                for _, l in pairs(obj.Skeleton) do l.Visible = false end
            end
        elseif espObjects[p] then
            espObjects[p].Folder:Destroy()
            espObjects[p] = nil
        end
    end
end)

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    flyToggle.Text = flying and "FLY : ON" or "FLY : OFF"
    flyToggle.TextColor3 = flying and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = flying
    end
end)

destroyBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
