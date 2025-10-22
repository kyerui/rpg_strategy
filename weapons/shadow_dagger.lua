local WeaponStrategy = require("strategies.weapon_strategy")

local ShadowDagger = {}
ShadowDagger.__index = ShadowDagger
setmetatable(ShadowDagger, WeaponStrategy)

function ShadowDagger:new()
    local requirements = {dexterity = 12}
    local instance = WeaponStrategy:new("Adaga Sombria", 10, 10, requirements)
    setmetatable(instance, ShadowDagger)
    return instance
end

function ShadowDagger:performAttack(attacker, target)
    -- Efeito Especial: "Ataque Furtivo" - Dano triplo se o inimigo estiver desprevenido
    local isUnaware = math.random() <= 0.4 -- 40% de chance do alvo estar desprevenido
    
    local damage = self.baseDamage
    if isUnaware then
        damage = damage * 3
        print("Ataque Furtivo! O alvo estava desprevenido!")
    else
        damage = self:calculateDamage(attacker)
    end
    
    target:takeDamage(damage)
    print(string.format("%s ataca %s com Adaga Sombria causando %d de dano!", 
        attacker.name, target.name, damage))
end

return ShadowDagger