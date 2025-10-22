local Character = require("character.character")
local TurnStrategy = require("strategies.character_strategy").TurnStrategy

-- Estrategia de Turno do Mago
local MageTurnStrategy = {}
MageTurnStrategy.__index = MageTurnStrategy
setmetatable(MageTurnStrategy, TurnStrategy)

function MageTurnStrategy:new()
    local instance = TurnStrategy:new()
    setmetatable(instance, MageTurnStrategy)
    return instance
end

function MageTurnStrategy:execute(character)
    -- Passiva: "Regeneracao de Mana" - +10 mana por turno
    character.mana = math.min(character.maxMana, character.mana + 10)
end

local Mage = {}
Mage.__index = Mage
setmetatable(Mage, Character)

function Mage:new(name)
    local baseStats = {
        health = 10,
        mana = 150,
        strength = 5,
        dexterity = 7,
        intelligence = 18
    }
    
    local instance = Character:new(name, "Mago", baseStats)
    setmetatable(instance, Mage)
    
    -- Configurar estrategias especificas do Mago
    instance.context:setStrategy("turn", MageTurnStrategy:new())
    
    return instance
end

return Mage