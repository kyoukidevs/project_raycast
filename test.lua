local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Конфиг
local ESP_CONFIG = {
    Box = true,
    Name = true,
    HealthBar = true,
    HealthText = true,
    Distance = true,
    Skeleton = true,
    Tracer = false,
    
    MaxDistance = 2000,
    
    BoxColor = Color3.fromRGB(0, 255, 0),
    BoxColorHidden = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(255, 255, 255)
}

local ESPObjects = {}
local PlayerModelsFolder = workspace:FindFirstChild("Players")

if not PlayerModelsFolder then
    warn("Папка 'Players' не найдена в Workspace!")
    return
end

-- Создание Drawing объектов для игрока
function CreateESP(player)
    if player == LocalPlayer then return end
    
    local drawings = {
        -- Бокс
        BoxTop = Drawing.new("Line"),
        BoxBottom = Drawing.new("Line"),
        BoxLeft = Drawing.new("Line"),
        BoxRight = Drawing.new("Line"),
        
        -- Текст
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        
        -- Хилбар
        HealthBarBG = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        
        -- Трейсер
        Tracer = Drawing.new("Line"),
        
        -- Скелетон (линии между частями тела)
        SkeletonLines = {}
    }
    
    -- Настройка бокса
    for _, line in pairs({drawings.BoxTop, drawings.BoxBottom, drawings.BoxLeft, drawings.BoxRight}) do
        line.Thickness = 2
        line.Color = ESP_CONFIG.BoxColor
        line.Visible = false
    end
    
    -- Настройка текста
    local textSettings = {
        Size = 16,
        Center = true,
        Outline = true,
        OutlineColor = Color3.new(0, 0, 0),
        Color = ESP_CONFIG.TextColor,
        Font = Drawing.Fonts.UI
    }
    
    for _, text in pairs({drawings.Name, drawings.Health, drawings.Distance}) do
        for setting, value in pairs(textSettings) do
            text[setting] = value
        end
        text.Visible = false
    end
    
    drawings.Name.Size = 18
    
    -- Хилбар
    drawings.HealthBarBG.Filled = true
    drawings.HealthBarBG.Color = Color3.new(0, 0, 0)
    drawings.HealthBarBG.Thickness = 1
    drawings.HealthBarBG.Visible = false
    
    drawings.HealthBar.Filled = true
    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Visible = false
    
    -- Трейсер
    drawings.Tracer.Thickness = 1
    drawings.Tracer.Color = ESP_CONFIG.SkeletonColor
    drawings.Tracer.Visible = false
    
    ESPObjects[player] = {
        Drawings = drawings,
        Model = nil,
        LastUpdate = 0
    }
    
    -- Поиск модели игрока в папке Players
    FindPlayerModel(player)
end

-- Поиск модели игрока в папке Players
function FindPlayerModel(player)
    local model = PlayerModelsFolder:FindFirstChild(player.Name)
    if model and model:IsA("Model") then
        ESPObjects[player].Model = model
        
        -- Создание линий скелетона при найденной модели
        CreateSkeletonLines(player, model)
    end
end

-- Создание линий скелетона
function CreateSkeletonLines(player, model)
    local skeletonConfig = {
        -- Туловище
        {"HumanoidRootPart", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        
        -- Левая рука
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        
        -- Правая рука
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        
        -- Левая нога
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        
        -- Правая нога
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        
        -- Голова
        {"UpperTorso", "Head"}
    }
    
    ESPObjects[player].SkeletonLines = {}
    
    for _, bonePair in ipairs(skeletonConfig) do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = ESP_CONFIG.SkeletonColor
        line.Visible = false
        
        table.insert(ESPObjects[player].SkeletonLines, {
            Line = line,
            Part1Name = bonePair[1],
            Part2Name = bonePair[2]
        })
    end
end

-- Получение Bounding Box модели
function GetModelBoundingBox(model)
    local primaryPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
    if not primaryPart then return nil end
    
    local cf = primaryPart.CFrame
    local size = model:GetExtentsSize()
    
    if size.Magnitude < 1 then
        size = Vector3.new(4, 6, 2) -- Стандартный размер если модель маленькая
    end
    
    local points = {
        cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
        cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
        cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
        cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
        
        cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
        cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
        cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
        cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)
    }
    
    return {
        Points = points,
        Center = cf.Position,
        Size = size
    }
end

-- Проверка видимости
function IsVisible(point)
    local origin = Camera.CFrame.Position
    local direction = (point - origin).Unit * 2000
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera, PlayerModelsFolder}
    
    local result = workspace:Raycast(origin, direction, rayParams)
    return not result or (result.Position - point).Magnitude < 2
end

-- Рисование бокса
function DrawBox(drawings, corners, color, isVisible)
    if #corners < 8 then return false end
    
    local boxColor = isVisible and color or ESP_CONFIG.BoxColorHidden
    
    -- Верхняя грань
    drawings.BoxTop.From = corners[1]
    drawings.BoxTop.To = corners[2]
    drawings.BoxTop.Color = boxColor
    drawings.BoxTop.Visible = true
    
    drawings.BoxBottom.From = corners[3]
    drawings.BoxBottom.To = corners[4]
    drawings.BoxBottom.Color = boxColor
    drawings.BoxBottom.Visible = true
    
    -- Боковые грани
    drawings.BoxLeft.From = corners[1]
    drawings.BoxLeft.To = corners[4]
    drawings.BoxLeft.Color = boxColor
    drawings.BoxLeft.Visible = true
    
    drawings.BoxRight.From = corners[2]
    drawings.BoxRight.To = corners[3]
    drawings.BoxRight.Color = boxColor
    drawings.BoxRight.Visible = true
    
    return true
end

-- Рисование скелетона
function DrawSkeleton(player, model)
    local skeletonLines = ESPObjects[player].SkeletonLines
    if not skeletonLines then return end
    
    for _, boneData in ipairs(skeletonLines) do
        local part1 = model:FindFirstChild(boneData.Part1Name)
        local part2 = model:FindFirstChild(boneData.Part2Name)
        
        if part1 and part2 then
            local screenPos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
            local screenPos2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
            
            if onScreen1 and onScreen2 then
                boneData.Line.From = Vector2.new(screenPos1.X, screenPos1.Y)
                boneData.Line.To = Vector2.new(screenPos2.X, screenPos2.Y)
                boneData.Line.Visible = ESP_CONFIG.Skeleton
            else
                boneData.Line.Visible = false
            end
        else
            boneData.Line.Visible = false
        end
    end
end

-- Обновление ESP
function UpdateESP()
    for player, espData in pairs(ESPObjects) do
        local drawings = espData.Drawings
        
        -- Проверяем модель
        if not espData.Model or not espData.Model.Parent then
            FindPlayerModel(player)
            if not espData.Model then
                for _, drawing in pairs(drawings) do
                    if typeof(drawing) == "table" then
                        for _, d in pairs(drawing) do
                            if d.Visible then d.Visible = false end
                        end
                    else
                        if drawing.Visible then drawing.Visible = false end
                    end
                end
                continue
            end
        end
        
        local model = espData.Model
        local primaryPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
        
        if not primaryPart then
            for _, drawing in pairs(drawings) do
                if typeof(drawing) == "table" then
                    for _, d in pairs(drawing) do
                        if d.Visible then d.Visible = false end
                    end
                else
                    if drawing.Visible then drawing.Visible = false end
                end
            end
            continue
        end

        -- Дистанция
        local distance = (primaryPart.Position - Camera.CFrame.Position).Magnitude
        if distance > ESP_CONFIG.MaxDistance then
            for _, drawing in pairs(drawings) do
                if typeof(drawing) == "table" then
                    for _, d in pairs(drawing) do
                        if d.Visible then d.Visible = false end
                    end
                else
                    if drawing.Visible then drawing.Visible = false end
                end
            end
            continue
        end

        -- Получаем bounding box
        local bbox = GetModelBoundingBox(model)
        if not bbox then continue end

        -- Конвертируем точки в 2D
        local corners = {}
        local allOnScreen = true
        
        for i, point in ipairs(bbox.Points) do
            local screenPos, onScreen = Camera:WorldToViewportPoint(point.Position)
            corners[i] = Vector2.new(screenPos.X, screenPos.Y)
            if not onScreen then allOnScreen = false end
        end

        if not allOnScreen then
            for _, drawing in pairs(drawings) do
                if typeof(drawing) == "table" then
                    for _, d in pairs(drawing) do
                        if d.Visible then d.Visible = false end
                    end
                else
                    if drawing.Visible then drawing.Visible = false end
                end
            end
            continue
        end

        -- Проверяем видимость
        local isVisible = IsVisible(bbox.Center)

        -- Рисуем бокс
        if ESP_CONFIG.Box then
            DrawBox(drawings, corners, ESP_CONFIG.BoxColor, isVisible)
        else
            drawings.BoxTop.Visible = false
            drawings.BoxBottom.Visible = false
            drawings.BoxLeft.Visible = false
            drawings.BoxRight.Visible = false
        end

        -- Позиция для текста
        local head = model:FindFirstChild("Head")
        local textPosition = head and head.Position or bbox.Center
        local screenPos, onScreen = Camera:WorldToViewportPoint(textPosition)
        
        if not onScreen then
            drawings.Name.Visible = false
            drawings.Health.Visible = false
            drawings.Distance.Visible = false
            drawings.HealthBarBG.Visible = false
            drawings.HealthBar.Visible = false
            drawings.Tracer.Visible = false
            continue
        end

        local textScreenPos = Vector2.new(screenPos.X, screenPos.Y)

        -- ИМЯ
        if ESP_CONFIG.Name then
            drawings.Name.Position = Vector2.new(textScreenPos.X, textScreenPos.Y - 80)
            drawings.Name.Text = player.Name
            drawings.Name.Visible = true
        else
            drawings.Name.Visible = false
        end

        -- ЗДОРОВЬЕ (имитация)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local health = 100
        local maxHealth = 100
        
        if humanoid then
            health = humanoid.Health
            maxHealth = humanoid.MaxHealth
        end
        
        local healthPercent = health / maxHealth

        if ESP_CONFIG.HealthText then
            drawings.Health.Position = Vector2.new(textScreenPos.X, textScreenPos.Y - 60)
            drawings.Health.Text = "HP: " .. math.floor(health) .. "/" .. math.floor(maxHealth)
            drawings.Health.Color = Color3.new(1 - healthPercent, healthPercent, 0)
            drawings.Health.Visible = true
        else
            drawings.Health.Visible = false
        end

        -- ХИЛБАР
        if ESP_CONFIG.HealthBar then
            local barWidth = 60
            local barHeight = 5
            local barX = textScreenPos.X - barWidth/2
            local barY = textScreenPos.Y - 40
            
            drawings.HealthBarBG.Size = Vector2.new(barWidth, barHeight)
            drawings.HealthBarBG.Position = Vector2.new(barX, barY)
            drawings.HealthBarBG.Visible = true
            
            drawings.HealthBar.Size = Vector2.new(barWidth * healthPercent, barHeight)
            drawings.HealthBar.Position = Vector2.new(barX, barY)
            drawings.HealthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
            drawings.HealthBar.Visible = true
        else
            drawings.HealthBarBG.Visible = false
            drawings.HealthBar.Visible = false
        end

        -- ДИСТАНЦИЯ
        if ESP_CONFIG.Distance then
            drawings.Distance.Position = Vector2.new(textScreenPos.X, textScreenPos.Y - 20)
            drawings.Distance.Text = math.floor(distance) .. "m"
            drawings.Distance.Visible = true
        else
            drawings.Distance.Visible = false
        end

        -- ТРЕЙСЕР
        if ESP_CONFIG.Tracer then
            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            drawings.Tracer.To = textScreenPos
            drawings.Tracer.Visible = true
        else
            drawings.Tracer.Visible = false
        end

        -- СКЕЛЕТОН
        if ESP_CONFIG.Skeleton then
            DrawSkeleton(player, model)
        else
            if espData.SkeletonLines then
                for _, boneData in ipairs(espData.SkeletonLines) do
                    boneData.Line.Visible = false
                end
            end
        end
    end
end

-- Инициализация
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        local espData = ESPObjects[player]
        
        -- Удаляем все Drawing объекты
        for _, drawing in pairs(espData.Drawings) do
            if typeof(drawing) == "table" then
                for _, d in pairs(drawing) do
                    d:Remove()
                end
            else
                drawing:Remove()
            end
        end
        
        -- Удаляем линии скелетона
        if espData.SkeletonLines then
            for _, boneData in ipairs(espData.SkeletonLines) do
                boneData.Line:Remove()
            end
        end
        
        ESPObjects[player] = nil
    end
end)

-- Мониторинг моделей в папке Players
PlayerModelsFolder.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        local player = Players:FindFirstChild(child.Name)
        if player and player ~= LocalPlayer and ESPObjects[player] then
            ESPObjects[player].Model = child
            CreateSkeletonLines(player, child)
        end
    end
end)

PlayerModelsFolder.ChildRemoved:Connect(function(child)
    if child:IsA("Model") then
        local player = Players:FindFirstChild(child.Name)
        if player and ESPObjects[player] then
            ESPObjects[player].Model = nil
        end
    end
end)

-- Главный цикл с оптимизацией
local lastUpdate = 0
RunService.Heartbeat:Connect(function(delta)
    lastUpdate = lastUpdate + delta
    if lastUpdate >= 0.033 then -- ~30 FPS
        pcall(UpdateESP)
        lastUpdate = 0
    end
end)

-- Управление
local ESP = {}

function ESP:Toggle(type, state)
    if ESP_CONFIG[type] ~= nil then
        ESP_CONFIG[type] = state
    end
end

function ESP:SetMaxDistance(distance)
    ESP_CONFIG.MaxDistance = distance
end

function ESP:SetColors(boxVisible, boxHidden, text, skeleton)
    ESP_CONFIG.BoxColor = boxVisible or ESP_CONFIG.BoxColor
    ESP_CONFIG.BoxColorHidden = boxHidden or ESP_CONFIG.BoxColorHidden
    ESP_CONFIG.TextColor = text or ESP_CONFIG.TextColor
    ESP_CONFIG.SkeletonColor = skeleton or ESP_CONFIG.SkeletonColor
end

print("✅ ESP для кастомных моделей загружен!")
print("📁 Папка Players: " .. tostring(PlayerModelsFolder))
print("🎯 Игроков: " .. #Players:GetPlayers())

return ESP
