local WeaponStrategy = require("strategies.weapon_strategy")

local ElvenBow = {}
ElvenBow.__index = ElvenBow
setmetatable(ElvenBow, WeaponStrategy)

function ElvenBow:new()
    local requirements = {dexterity = 8}
    local instance = WeaponStrategy:new("Arco Elfico", 12, 15, requirements)
    setmetatable(instance, ElvenBow)
    return instance
end

function ElvenBow:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    target:takeDamage(damage)
    
    print(string.format("%s atira em %s com Arco Elfico causando %d de dano!", 
        attacker.name, target.name, damage))
    
    -- Efeito Especial: "Chuva de Flechas" - Ataque em area (simulado)
    print("Chuva de Flechas! As flechas atingem com precisao!")
end

return ElvenBow