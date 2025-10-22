local StatusEffect = {}
StatusEffect.__index = StatusEffect

function StatusEffect:new(name, duration)
    local instance = setmetatable({}, StatusEffect)
    instance.name = name
    instance.duration = duration
    instance.remainingTurns = duration
    return instance
end

function StatusEffect:apply(target)
    -- Para ser sobrescrito pelos efeitos especificos
end

function StatusEffect:processTurn(target)
    -- Para ser sobrescrito pelos efeitos especificos
    self.remainingTurns = self.remainingTurns - 1
end

function StatusEffect:remove(target)
    -- Para ser sobrescrito pelos efeitos especificos
end

function StatusEffect:isExpired()
    return self.remainingTurns <= 0
end

return StatusEffect