-- script. --

-- [[ variáveis ]] --

task.wait(1)

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()

-- [[ funções ]] --

local function mudarVelocidade(velocidade)
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = velocidade
    end
end

local function ESP(model)
    if model:IsA("Model") and not model:FindFirstChild(model.Name.."_KiBen_ESP") then
        local a = Instance.new("Highlight")
        a.Name = model.Name.."_KiBen_ESP"
        a.Parent = model
        a.Adornee = model
        a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function removeESP(model)
    if model:IsA("Model") then
        local espItem = model:FindFirstChild(model.Name.."_KiBen_ESP")
        if espItem then
            espItem:Destroy()
        end
    end
end

-- [[ baguio da lib ]] --

local Window = Library:CreateWindow({
    Title = "script mais daora de merdy's world >:D meuehehe v0.2",
    Center = true,
    AutoShow = true,
})

local abas = {
    -- Creates a new tab titled Main
    lobby = Window:AddTab('aba pro lobby'),
    praye = Window:AddTab("prayler pera plarey COMO Q ESCREVE"),
    partida = Window:AddTab('aba pra partida'),
}

local grupindolobby = abas.lobby:AddLeftGroupbox('em dersinvorvimento')
local grupindapartida = abas.partida:AddLeftGroupbox('maquininha')
local grupindoprayler = abas.praye:AddLeftGroupbox('player')

-- Definindo a velocidade inicial
local CFspeed = 30
local CFloop

grupindoprayler:AddToggle('toggleFly', {
    Text = 'vuá',
    Default = false,
    Tooltip = 'te voa igual aviao',

    Callback = function(Value)
        if Value then
            -- Ação quando LIGAR
            local humanoid = character:FindFirstChildOfClass('Humanoid')
            local head = character:WaitForChild("Head")
            
            if humanoid then humanoid.PlatformStand = true end
            if head then head.Anchored = true end
            
            if CFloop then CFloop:Disconnect() end
            
            CFloop = RunService.Heartbeat:Connect(function(deltaTime)
                local moveDirection = humanoid.MoveDirection * (CFspeed * deltaTime)
                local headCFrame = head.CFrame
                local camera = workspace.CurrentCamera
                local cameraCFrame = camera.CFrame
                local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
                
                cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
                local cameraPosition = cameraCFrame.Position
                local headPosition = headCFrame.Position

                local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
                head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
            end)
        else
            -- Ação quando DESLIGAR
            if CFloop then
                CFloop:Disconnect()
                CFloop = nil
            end
            
            if character then
                local humanoid = character:FindFirstChildOfClass('Humanoid')
                local head = character:WaitForChild("Head")

                if humanoid then humanoid.PlatformStand = false end
                if head then head.Anchored = false end
            end
        end
    end
})

grupindoprayler:AddSlider('speedSlider', {
    Text = 'velocidarade (player)',
    Default = character.Humanoid.WalkSpeed, -- Default value (number)
    Min = 4, -- Minimum value of the slider (number)
    Max = 200, -- Maximum value of the slider (number)
    Rounding = 0, -- Round the number to a certain amount of decimals (number)
    Compact = false, -- If true, the slider will use a more compact design (boolean)

    Callback = function(Value)
        print('speed ', Value)
        mudarVelocidade(Value)
    end
})

local ESPloop

grupindapartida:AddToggle('toggleESP', {
    Text = 'esp nas maquininha',
    Default = false,
    Tooltip = 've maquininha de longe wow :0000',

    Callback = function(Value)
        if Value then
            ESPloop = task.spawn(function()
                while true do
                    -- Usamos uma lista local para garantir que processamos tudo
                    for _, item in pairs(workspace:GetDescendants()) do
                        -- Usa string.find para ignorar variações de nome e espaços
                        if item:IsA("Model") and string.find(string.lower(item.Name), "generator") then
                            -- Verifica se o objeto ainda existe e não tem o ESP
                            if item and not item:FindFirstChild(item.Name .. "_KiBen_ESP") then 
                                ESP(item)
                            end
                        end
                    end
                    task.wait(1) -- Ciclo mais rápido para detectar novos geradores no mapa
                end
            end)
        else
            if ESPloop then
                task.cancel(ESPloop)
                ESPloop = nil
            end
            
            -- Limpeza profunda
            for _, item in pairs(workspace:GetDescendants()) do
                if item:IsA("Model") and string.find(string.lower(item.Name), "generator") then
                    removeESP(item)
                end
            end
        end
    end
})
