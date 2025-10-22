-- Classe Context base para o Padrao Strategy
local Context = {}
Context.__index = Context

function Context:new()
    local instance = setmetatable({}, Context)
    instance.strategies = {}
    return instance
end

function Context:setStrategy(key, strategy)
    self.strategies[key] = strategy
end

function Context:getStrategy(key)
    return self.strategies[key]
end

function Context:executeStrategy(key, ...)
    local strategy = self.strategies[key]
    if strategy then
        return strategy:execute(...)
    else
        error("Estrategia '" .. key .. "' nao definida!")
    end
end

-- Contexto para Personagens
local CharacterContext = {}
CharacterContext.__index = CharacterContext
setmetatable(CharacterContext, Context)

function CharacterContext:new(character)
    local instance = Context:new()
    setmetatable(instance, CharacterContext)
    instance.character = character
    return instance
end

function CharacterContext:executeAttack(target)
    local weaponStrategy = self:getStrategy("weapon")
    if weaponStrategy then
        weaponStrategy:execute(self.character, target)
    else
        print("Nenhuma arma equipada!")
    end
end

function CharacterContext:executeDamageCalculation(damage)
    local defenseStrategy = self:getStrategy("defense")
    if defenseStrategy then
        return defenseStrategy:execute(self.character, damage)
    end
    return damage
end

function CharacterContext:executeTurnProcessing()
    local turnStrategy = self:getStrategy("turn")
    if turnStrategy then
        turnStrategy:execute(self.character)
    end
end

-- Contexto para Batalha
local BattleContext = {}
BattleContext.__index = BattleContext
setmetatable(BattleContext, Context)

function BattleContext:new(participants)
    local instance = Context:new()
    setmetatable(instance, BattleContext)
    instance.participants = participants
    instance.turn = 1
    return instance
end

function BattleContext:executeTurn()
    local turnStrategy = self:getStrategy("turn")
    if turnStrategy then
        turnStrategy:execute(self)
    end
end

function BattleContext:executeTargetSelection(attacker)
    local targetStrategy = self:getStrategy("target")
    if targetStrategy then
        return targetStrategy:execute(self, attacker)
    end
    return nil
end

return {
    Context = Context,
    CharacterContext = CharacterContext,
    BattleContext = BattleContext
}