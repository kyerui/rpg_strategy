local BattleContext = require("context").BattleContext
local BattleTurnStrategy = require("strategies.battle_strategy").BattleTurnStrategy
local TargetSelectionStrategy = require("strategies.battle_strategy").TargetSelectionStrategy

-- Estrategia de Turno de Batalha Padrao
local StandardBattleTurnStrategy = {}
StandardBattleTurnStrategy.__index = StandardBattleTurnStrategy
setmetatable(StandardBattleTurnStrategy, BattleTurnStrategy)

function StandardBattleTurnStrategy:new()
    local instance = BattleTurnStrategy:new()
    setmetatable(instance, StandardBattleTurnStrategy)
    return instance
end

function StandardBattleTurnStrategy:execute(battleContext)
    print(string.format("\n--- Turno %d ---", battleContext.turn))
    
    for _, participant in ipairs(battleContext.participants) do
        if participant.isAlive then
            local target = battleContext:executeTargetSelection(participant)
            if target then
                participant:attack(target)
            end
        end
    end
    
    battleContext.turn = battleContext.turn + 1
    
    if battleContext.turn > 20 then
        print("\nA batalha demorou muito! Terminando batalha...")
        return false
    end
    
    return true
end

-- Estrategia de Selecao de Alvo Aleatorio
local RandomTargetSelectionStrategy = {}
RandomTargetSelectionStrategy.__index = RandomTargetSelectionStrategy
setmetatable(RandomTargetSelectionStrategy, TargetSelectionStrategy)

function RandomTargetSelectionStrategy:new()
    local instance = TargetSelectionStrategy:new()
    setmetatable(instance, RandomTargetSelectionStrategy)
    return instance
end

function RandomTargetSelectionStrategy:execute(battleContext, attacker)
    local possibleTargets = {}
    for _, participant in ipairs(battleContext.participants) do
        if participant ~= attacker and participant.isAlive then
            table.insert(possibleTargets, participant)
        end
    end
    
    if #possibleTargets > 0 then
        return possibleTargets[math.random(#possibleTargets)]
    end
    return nil
end

-- Implementacao da Batalha
local Battle = {}
Battle.__index = Battle

function Battle:new(participants)
    local instance = setmetatable({}, Battle)
    
    -- Contexto Strategy para a batalha
    instance.context = BattleContext:new(participants)
    instance.context:setStrategy("turn", StandardBattleTurnStrategy:new())
    instance.context:setStrategy("target", RandomTargetSelectionStrategy:new())
    
    return instance
end

function Battle:startBattle()
    print("\n===== INICIO DA BATALHA =====")
    
    while self:isBattleOngoing() do
        local shouldContinue = self.context:executeTurn()
        if not shouldContinue then
            break
        end
    end
    
    self:declareWinner()
end

function Battle:isBattleOngoing()
    local aliveCount = 0
    for _, participant in ipairs(self.context.participants) do
        if participant.isAlive then
            aliveCount = aliveCount + 1
        end
    end
    return aliveCount > 1
end

function Battle:declareWinner()
    local winners = {}
    for _, participant in ipairs(self.context.participants) do
        if participant.isAlive then
            table.insert(winners, participant)
        end
    end
    
    if #winners == 1 then
        print(string.format("\n%s venceu a batalha!", winners[1].name))
    else
        print("\nA batalha terminou em empate!")
    end
    
    -- Restaurar todos os participantes
    for _, participant in ipairs(self.context.participants) do
        participant:restore()
    end
end

return Battle