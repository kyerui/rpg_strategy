local WeaponStrategy = require("strategies.weapon_strategy")
local BleedingEffect = require("status.bleeding")

local LongSword = {}
LongSword.__index = LongSword
setmetatable(LongSword, WeaponStrategy)

function LongSword:new()
    local requirements = {strength = 10}
    local instance = WeaponStrategy:new("Espada Longa", 15, 0, requirements)
    setmetatable(instance, LongSword)
    return instance
end

function LongSword:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    target:takeDamage(damage)
    
    print(string.format("%s ataca %s com Espada Longa causando %d de dano!", 
        attacker.name, target.name, damage))
    
    -- Efeito Especial: "Corte Profundo" - 30% de chance de causar sangramento
    if math.random() <= 0.30 then
        print("Corte Profundo! O alvo esta sangrando!")
        local bleeding = BleedingEffect:new(5, 3)
        target:addStatusEffect(bleeding)
    end
end

return LongSword