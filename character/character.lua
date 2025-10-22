local CharacterContext = require("context").CharacterContext
local DefenseStrategy = require("strategies.character_strategy").DefenseStrategy
local TurnStrategy = require("strategies.character_strategy").TurnStrategy

local Character = {}
Character.__index = Character

function Character:new(name, className, baseStats)
    local instance = setmetatable({}, Character)
    instance.name = name
    instance.className = className
    instance.level = 1
    instance.health = baseStats.health
    instance.maxHealth = baseStats.health
    instance.mana = baseStats.mana
    instance.maxMana = baseStats.mana
    instance.strength = baseStats.strength
    instance.dexterity = baseStats.dexterity
    instance.intelligence = baseStats.intelligence
    instance.equippedWeapon = nil
    instance.activeEffects = {}
    instance.isAlive = true
    
    -- Contexto Strategy para o personagem
    instance.context = CharacterContext:new(instance)
    
    -- Estrategias padrao
    instance.context:setStrategy("defense", DefenseStrategy:new())
    instance.context:setStrategy("turn", TurnStrategy:new())
    
    return instance
end

function Character:equipWeapon(weapon)
    if weapon:canEquip(self) then
        self.context:setStrategy("weapon", weapon)
        self.equippedWeapon = weapon
        print(string.format("%s equipou %s", self.name, weapon.name))
    else
        print(string.format("%s nao pode equipar %s! Requisitos nao atendidos.", self.name, weapon.name))
    end
end

function Character:attack(target)
    if not self.isAlive then
        print(string.format("%s esta morto e nao pode atacar!", self.name))
        return
    end
    
    if not target.isAlive then
        print(string.format("%s ja esta morto!", target.name))
        return
    end
    
    self.context:executeAttack(target)
    self:processStatusEffects()
end

function Character:takeDamage(damage)
    local actualDamage = self.context:executeDamageCalculation(damage)
    self.health = self.health - actualDamage
    
    print(string.format("%s recebe %d de dano! (%d/%d HP)", 
        self.name, actualDamage, math.max(0, self.health), self.maxHealth))
    
    if self.health <= 0 then
        self.health = 0
        self.isAlive = false
        print(string.format("%s foi derrotado!", self.name))
    end
    
    return actualDamage
end

function Character:addStatusEffect(effect)
    table.insert(self.activeEffects, effect)
    effect:execute(self)
end

function Character:processStatusEffects()
    self.context:executeTurnProcessing()
    
    local i = 1
    while i <= #self.activeEffects do
        local effect = self.activeEffects[i]
        effect:processTurn(self)
        
        if effect:isExpired() then
            effect:remove(self)
            table.remove(self.activeEffects, i)
        else
            i = i + 1
        end
    end
end

function Character:displayInfo()
    print(string.format("\n%s (%s) - Nivel %d", self.name, self.className, self.level))
    print(string.format("HP: %d/%d | Mana: %d/%d", self.health, self.maxHealth, self.mana, self.maxMana))
    print(string.format("FOR: %d | DES: %d | INT: %d", self.strength, self.dexterity, self.intelligence))
    
    if self.equippedWeapon then
        print(string.format("Arma: %s", self.equippedWeapon.name))
    else
        print("Arma: Nenhuma")
    end
    
    if #self.activeEffects > 0 then
        local effectNames = {}
        for _, effect in ipairs(self.activeEffects) do
            table.insert(effectNames, effect.name)
        end
        print(string.format("Efeitos Ativos: %s", table.concat(effectNames, ", ")))
    end
end

function Character:restore()
    self.health = self.maxHealth
    self.mana = self.maxMana
    self.activeEffects = {}
    self.isAlive = true
end

function Character:punch(target)
    if not self.isAlive then
        print(string.format("%s esta morto e nao pode dar socos!", self.name))
        return
    end
    
    if not target.isAlive then
        print(string.format("%s ja esta morto!", target.name))
        return
    end
    
    local punchDamage = 4
    target:takeDamage(punchDamage)
    print(string.format("%s da um soco em %s causando %d de dano!", self.name, target.name, punchDamage))
end

return Character