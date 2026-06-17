-- script. --

task.wait(1)

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

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

local Window = Library:CreateWindow({
    Title = "script mais daora de merdy's world >:D v0.1",
    Center = true,
    AutoShow = true,
})

local abas = {
    -- Creates a new tab titled Main
    lobby = Window:AddTab('aba pro lobby'),
    partida = Window:AddTab('aba pra partida'),
}

local grupindolobby = abas.lobby:AddLeftGroupbox('player')
local grupindapartida = abas.partida:AddLeftGroupbox('player')

-- Definindo a velocidade inicial
local CFspeed = 30
local CFloop

grupindolobby:AddToggle('toggleFly', {
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

grupindolobby:AddSlider('speedSlider', {
    Text = 'velocidarade',
    Default = 16, -- Default value (number)
    Min = 4, -- Minimum value of the slider (number)
    Max = 200, -- Maximum value of the slider (number)
    Rounding = 0, -- Round the number to a certain amount of decimals (number)
    Compact = false, -- If true, the slider will use a more compact design (boolean)

    Callback = function(Value)
        print('speed ', Value)
        mudarVelocidade(Value)
    end
})

grupindapartida:AddToggle('toggleFly', {
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

grupindapartida:AddSlider('speedSlider', {
    Text = 'velocidarade',
    Default = 16, -- Default value (number)
    Min = 4, -- Minimum value of the slider (number)
    Max = 200, -- Maximum value of the slider (number)
    Rounding = 0, -- Round the number to a certain amount of decimals (number)
    Compact = false, -- If true, the slider will use a more compact design (boolean)

    Callback = function(Value)
        print('speed ', Value)
        mudarVelocidade(Value)
    end
})
