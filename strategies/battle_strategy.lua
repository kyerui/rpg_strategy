local BattleStrategy = {}
BattleStrategy.__index = BattleStrategy

function BattleStrategy:new()
    local instance = setmetatable({}, BattleStrategy)
    return instance
end

-- Estrategia de Turno de Batalha
local BattleTurnStrategy = {}
BattleTurnStrategy.__index = BattleTurnStrategy
setmetatable(BattleTurnStrategy, BattleStrategy)

function BattleTurnStrategy:new()
    local instance = BattleStrategy:new()
    setmetatable(instance, BattleTurnStrategy)
    return instance
end

function BattleTurnStrategy:execute(battleContext)
end

-- Estrategia de Selecao de Alvo
local TargetSelectionStrategy = {}
TargetSelectionStrategy.__index = TargetSelectionStrategy
setmetatable(TargetSelectionStrategy, BattleStrategy)

function TargetSelectionStrategy:new()
    local instance = BattleStrategy:new()
    setmetatable(instance, TargetSelectionStrategy)
    return instance
end

function TargetSelectionStrategy:execute(battleContext, attacker)
end

return {
    BattleStrategy = BattleStrategy,
    BattleTurnStrategy = BattleTurnStrategy,
    TargetSelectionStrategy = TargetSelectionStrategy
}