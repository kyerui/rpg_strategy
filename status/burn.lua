local StatusStrategy = require("strategies.status_strategy")

local BurnEffect = {}
BurnEffect.__index = BurnEffect
setmetatable(BurnEffect, StatusStrategy)

function BurnEffect:new(damagePerTurn, duration)
    local instance = StatusStrategy:new("Queimadura", duration)
    setmetatable(instance, BurnEffect)
    instance.damagePerTurn = damagePerTurn
    return instance
end

function BurnEffect:apply(target)
    print(string.format("%s esta queimando!", target.name))
end

function BurnEffect:processTurn(target)
    StatusStrategy.processTurn(self, target)
    if not self:isExpired() then
        target:takeDamage(self.damagePerTurn)
        print(string.format("%s recebe %d de dano de queimadura! (%d turnos restantes)", 
            target.name, self.damagePerTurn, self.remainingTurns))
    end
end

function BurnEffect:remove(target)
    print(string.format("%s nao esta mais queimando.", target.name))
end

return BurnEffect