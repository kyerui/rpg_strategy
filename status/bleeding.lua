local StatusStrategy = require("strategies.status_strategy")

local BleedingEffect = {}
BleedingEffect.__index = BleedingEffect
setmetatable(BleedingEffect, StatusStrategy)

function BleedingEffect:new(damagePerTurn, duration)
    local instance = StatusStrategy:new("Sangramento", duration)
    setmetatable(instance, BleedingEffect)
    instance.damagePerTurn = damagePerTurn
    return instance
end

function BleedingEffect:apply(target)
    print(string.format("%s esta sangrando!", target.name))
end

function BleedingEffect:processTurn(target)
    StatusStrategy.processTurn(self, target)
    if not self:isExpired() then
        target:takeDamage(self.damagePerTurn)
        print(string.format("%s recebe %d de dano de sangramento! (%d turnos restantes)", 
            target.name, self.damagePerTurn, self.remainingTurns))
    end
end

function BleedingEffect:remove(target)
    print(string.format("O sangramento de %s parou.", target.name))
end

return BleedingEffect