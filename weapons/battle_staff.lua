local WeaponStrategy = require("strategies.weapon_strategy")
local BurnEffect = require("status.burn")

local BattleStaff = {}
BattleStaff.__index = BattleStaff
setmetatable(BattleStaff, WeaponStrategy)

function BattleStaff:new()
    local requirements = {strength = 8, intelligence = 10}
    local instance = WeaponStrategy:new("Cajado de Batalha", 12, 12, requirements)
    setmetatable(instance, BattleStaff)
    return instance
end

function BattleStaff:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    
    -- Dano adicional baseado na inteligência (híbrido)
    local magicDamage = math.floor(attacker.intelligence * 0.8)
    local totalDamage = damage + magicDamage
    
    target:takeDamage(totalDamage)
    
    print(string.format("%s ataca %s com Cajado de Batalha causando %d de dano (%d físico + %d mágico)!", 
        attacker.name, target.name, totalDamage, damage, magicDamage))
    
    -- Efeito Especial: "Chama de Convicção" - Chance de queimar
    if math.random() <= 0.25 then
        print("Chamas sagradas queimam o alvo!")
        local burn = BurnEffect:new(6, 2) 
        target:addStatusEffect(burn)
    end
end

return BattleStaff