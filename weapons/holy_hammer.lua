local WeaponStrategy = require("strategies.weapon_strategy")

local HolyHammer = {}
HolyHammer.__index = HolyHammer
setmetatable(HolyHammer, WeaponStrategy)

function HolyHammer:new()
    local requirements = {strength = 10, intelligence = 9}
    local instance = WeaponStrategy:new("Martelo Sagrado", 16, 15, requirements)
    setmetatable(instance, HolyHammer)
    return instance
end

function HolyHammer:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    target:takeDamage(damage)
    
    print(string.format("%s golpeia %s com Martelo Sagrado causando %d de dano!", 
        attacker.name, target.name, damage))
    
    -- Efeito Especial: "Impacto Divino" - Chance de curar o portador
    if math.random() <= 0.35 then
        local healAmount = 8 + math.floor(attacker.intelligence * 0.5)
        local oldHealth = attacker.health
        attacker.health = math.min(attacker.maxHealth, attacker.health + healAmount)
        local actualHeal = attacker.health - oldHealth
        
        print(string.format("Impacto Divino cura %s em %d de vida!", attacker.name, actualHeal))
    end
    
    -- Chance de causar atordoamento adicional
    if math.random() <= 0.20 then
        print("O martelo sagrado emana energia divina, atordoando o alvo!")
        local StunEffect = require("status.stun")
        local stun = StunEffect:new(1)
        target:addStatusEffect(stun)
    end
end

return HolyHammer