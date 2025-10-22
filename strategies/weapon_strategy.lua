local WeaponStrategy = {}
WeaponStrategy.__index = WeaponStrategy

function WeaponStrategy:new(name, baseDamage, manaCost, requirements)
    local instance = setmetatable({}, WeaponStrategy)
    instance.name = name
    instance.baseDamage = baseDamage
    instance.manaCost = manaCost
    instance.requirements = requirements or {}
    return instance
end

function WeaponStrategy:canEquip(character)
    if self.requirements.strength and character.strength < self.requirements.strength then
        return false
    end
    if self.requirements.dexterity and character.dexterity < self.requirements.dexterity then
        return false
    end
    if self.requirements.intelligence and character.intelligence < self.requirements.intelligence then
        return false
    end
    return true
end

function WeaponStrategy:execute(attacker, target)
    if attacker.mana < self.manaCost then
        print(string.format("%s nao tem mana para %s! Usando soco.", attacker.name, self.name))
        if attacker.punch then
            attacker:punch(target)
        else
            local punchDamage = 4
            target:takeDamage(punchDamage)
            print(string.format("%s da um soco em %s causando %d de dano!", attacker.name, target.name, punchDamage))
        end
        return
    end
    
    attacker.mana = attacker.mana - self.manaCost
    self:performAttack(attacker, target)
end

function WeaponStrategy:performAttack(attacker, target)
    local damage = self:calculateDamage(attacker)
    target:takeDamage(damage)
    print(string.format("%s ataca %s com %s causando %d de dano!", 
        attacker.name, target.name, self.name, damage))
end

function WeaponStrategy:calculateDamage(attacker)
    local damage = self.baseDamage
    if math.random() <= 0.15 then
        damage = math.floor(damage * 1.5)
        print("Dano critico!")
    end
    return damage
end

return WeaponStrategy