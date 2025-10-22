local StatusStrategy = require("strategies.status_strategy")

local StunEffect = {}
StunEffect.__index = StunEffect
setmetatable(StunEffect, StatusStrategy)

function StunEffect:new(duration)
    local instance = StatusStrategy:new("Atordoado", duration)
    setmetatable(instance, StunEffect)
    instance.hasActedThisTurn = false
    return instance
end

function StunEffect:apply(target)
    print(string.format("%s esta atordoado!", target.name))
end

function StunEffect:processTurn(target)
    if not self.hasActedThisTurn then
        print(string.format("%s esta atordoado e nao pode agir!", target.name))
        self.hasActedThisTurn = true
    else
        StatusStrategy.processTurn(self, target)
        self.hasActedThisTurn = false
    end
end

function StunEffect:remove(target)
    print(string.format("%s nao esta mais atordoado.", target.name))
end

return StunEffect