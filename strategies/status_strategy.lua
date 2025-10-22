local StatusStrategy = {}
StatusStrategy.__index = StatusStrategy

function StatusStrategy:new(name, duration)
    local instance = setmetatable({}, StatusStrategy)
    instance.name = name
    instance.duration = duration
    instance.remainingTurns = duration
    return instance
end

function StatusStrategy:execute(target)
    self:apply(target)
end

function StatusStrategy:processTurn(target)
    self.remainingTurns = self.remainingTurns - 1
end

function StatusStrategy:apply(target)
end

function StatusStrategy:remove(target)
end

function StatusStrategy:isExpired()
    return self.remainingTurns <= 0
end

return StatusStrategy