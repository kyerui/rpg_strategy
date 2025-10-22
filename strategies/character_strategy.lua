local CharacterStrategy = {}
CharacterStrategy.__index = CharacterStrategy

function CharacterStrategy:new()
    local instance = setmetatable({}, CharacterStrategy)
    return instance
end

-- Estrategia de Defesa
local DefenseStrategy = {}
DefenseStrategy.__index = DefenseStrategy
setmetatable(DefenseStrategy, CharacterStrategy)

function DefenseStrategy:new()
    local instance = CharacterStrategy:new()
    setmetatable(instance, DefenseStrategy)
    return instance
end

function DefenseStrategy:execute(character, damage)
    return damage
end

-- Estrategia de Turno
local TurnStrategy = {}
TurnStrategy.__index = TurnStrategy
setmetatable(TurnStrategy, CharacterStrategy)

function TurnStrategy:new()
    local instance = CharacterStrategy:new()
    setmetatable(instance, TurnStrategy)
    return instance
end

function TurnStrategy:execute(character)
end

return {
    CharacterStrategy = CharacterStrategy,
    DefenseStrategy = DefenseStrategy,
    TurnStrategy = TurnStrategy
}