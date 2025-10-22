local Character = require("character.character")
local DefenseStrategy = require("strategies.character_strategy").DefenseStrategy

-- Estrategia de Defesa do Arqueiro
local ArcherDefenseStrategy = {}
ArcherDefenseStrategy.__index = ArcherDefenseStrategy
setmetatable(ArcherDefenseStrategy, DefenseStrategy)

function ArcherDefenseStrategy:new()
    local instance = DefenseStrategy:new()
    setmetatable(instance, ArcherDefenseStrategy)
    return instance
end

function ArcherDefenseStrategy:execute(character, damage)
    -- Passiva: "Esquiva" - 25% de chance de evitar ataque
    if math.random() <= 0.25 then
        print(string.format("%s esquivou do ataque!", character.name))
        return 0
    end
    return damage
end

local Archer = {}
Archer.__index = Archer
setmetatable(Archer, Character)

function Archer:new(name)
    local baseStats = {
        health = 12,
        mana = 80,
        strength = 8,
        dexterity = 15,
        intelligence = 7
    }
    
    local instance = Character:new(name, "Arqueiro", baseStats)
    setmetatable(instance, Archer)
    
    -- Configurar estrategias especificas do Arqueiro
    instance.context:setStrategy("defense", ArcherDefenseStrategy:new())
    
    return instance
end

return Archer