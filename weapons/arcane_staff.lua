local WeaponStrategy = require("strategies.weapon_strategy")
local BurnEffect = require("status.burn")

local ArcaneStaff = {}
ArcaneStaff.__index = ArcaneStaff
setmetatable(ArcaneStaff, WeaponStrategy)

function ArcaneStaff:new()
    local requirements = {intelligence = 12}
    local instance = WeaponStrategy:new("Cajado Arcano", 8, 25, requirements)
    setmetatable(instance, ArcaneStaff)
    return instance
end

function ArcaneStaff:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    target:takeDamage(damage)
    
    print(string.format("%s conjura Bola de Fogo em %s com Cajado Arcano causando %d de dano!", 
        attacker.name, target.name, damage))
    
    -- Efeito Especial: "Bola de Fogo" - Causa queimadura
    print("Bola de Fogo! O alvo esta queimando!")
    local burn = BurnEffect:new(10, 2)
    target:addStatusEffect(burn)
end

return ArcaneStaff