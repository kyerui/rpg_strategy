local Character = require("character.character")
local DefenseStrategy = require("strategies.character_strategy").DefenseStrategy
local TurnStrategy = require("strategies.character_strategy").TurnStrategy

-- Estrategia de Defesa do Guerreiro
local WarriorDefenseStrategy = {}
WarriorDefenseStrategy.__index = WarriorDefenseStrategy
setmetatable(WarriorDefenseStrategy, DefenseStrategy)

function WarriorDefenseStrategy:new()
    local instance = DefenseStrategy:new()
    setmetatable(instance, WarriorDefenseStrategy)
    return instance
end

function WarriorDefenseStrategy:execute(character, damage)
    -- Passiva: "Pele Dura" - 20% de reducao de dano
    local reducedDamage = damage * 0.8
    return math.floor(reducedDamage)
end

-- Implementacao do Guerreiro
local Warrior = {}
Warrior.__index = Warrior
setmetatable(Warrior, Character)

function Warrior:new(name)
    local baseStats = {
        health = 20,
        mana = 50,
        strength = 15,
        dexterity = 8,
        intelligence = 5
    }
    
    local instance = Character:new(name, "Guerreiro", baseStats)
    setmetatable(instance, Warrior)
    
    -- Configurar estrategias especificas do Guerreiro
    instance.context:setStrategy("defense", WarriorDefenseStrategy:new())
    
    return instance
end

return Warrior