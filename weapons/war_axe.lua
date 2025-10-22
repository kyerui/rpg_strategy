local WeaponStrategy = require("strategies.weapon_strategy")
local StunEffect = require("status.stun")

local WarAxe = {}
WarAxe.__index = WarAxe
setmetatable(WarAxe, WeaponStrategy)

function WarAxe:new()
    local requirements = {strength = 15}
    local instance = WeaponStrategy:new("Machado de Guerra", 18, 5, requirements)
    setmetatable(instance, WarAxe)
    return instance
end

function WarAxe:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    target:takeDamage(damage)
    
    print(string.format("%s golpeia %s com Machado de Guerra causando %d de dano!", 
        attacker.name, target.name, damage))
    
    -- Efeito Especial: "Golpe Esmagador" - 25% de chance de atordoar
    if math.random() <= 0.25 then
        print("Golpe Esmagador! O alvo esta atordoado!")
        local stun = StunEffect:new(1)
        target:addStatusEffect(stun)
    end
end

return WarAxe