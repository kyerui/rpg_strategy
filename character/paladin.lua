local Character = require("character.character")
local DefenseStrategy = require("strategies.character_strategy").DefenseStrategy
local TurnStrategy = require("strategies.character_strategy").TurnStrategy

local PaladinDefenseStrategy = {}
PaladinDefenseStrategy.__index = PaladinDefenseStrategy
setmetatable(PaladinDefenseStrategy, DefenseStrategy)

function PaladinDefenseStrategy:new()
    local instance = DefenseStrategy:new()
    setmetatable(instance, PaladinDefenseStrategy)
    return instance
end

function PaladinDefenseStrategy:execute(character, damage)
    -- Passiva: "Armadura Abençoada" - 15% de redução de dano + chance de reduzir mais
    local reducedDamage = damage * 0.85
    
    -- 25% de chance de reduzir dano adicionalmente
    if math.random() <= 0.25 then
        reducedDamage = reducedDamage * 0.7  -- Redução extra de 30%
        print(string.format("%s ativou Armadura Abencoada! Dano reduzido adicionalmente!", character.name))
    end
    
    return math.floor(reducedDamage)
end

-- Estrategia de Turno do Paladino
local PaladinTurnStrategy = {}
PaladinTurnStrategy.__index = PaladinTurnStrategy
setmetatable(PaladinTurnStrategy, TurnStrategy)

function PaladinTurnStrategy:new()
    local instance = TurnStrategy:new()
    setmetatable(instance, PaladinTurnStrategy)
    return instance
end

function PaladinTurnStrategy:execute(character)
    local healthRegen = 5
    local manaRegen = 8
    
    character.health = math.min(character.maxHealth, character.health + healthRegen)
    character.mana = math.min(character.maxMana, character.mana + manaRegen)
    
    if healthRegen > 0 or manaRegen > 0 then
        print(string.format("%s regenera %d de vida e %d de mana pela Fe Inabalavel", 
              character.name, healthRegen, manaRegen))
    end
end

local Paladin = {}
Paladin.__index = Paladin
setmetatable(Paladin, Character)

function Paladin:new(name)
    local baseStats = {
        health = 15,
        mana = 100,
        strength = 12,
        dexterity = 9,
        intelligence = 11 
    }
    
    local instance = Character:new(name, "Paladino", baseStats)
    setmetatable(instance, Paladin)
    
    instance.context:setStrategy("defense", PaladinDefenseStrategy:new())
    instance.context:setStrategy("turn", PaladinTurnStrategy:new())
    
    return instance
end

function Paladin:specialAttack(target)
    if not self.isAlive then
        print(string.format("%s está morto e não pode usar o Golpe Sagrado!", self.name))
        return
    end
    
    if not target.isAlive then
        print(string.format("%s já está morto!", target.name))
        return
    end
    
    local manaCost = 30
    if self.mana < manaCost then
        print(string.format("%s não tem mana suficiente para Golpe Sagrado!", self.name))
        return
    end
    
    self.mana = self.mana - manaCost
    
    local baseDamage = 20
    local bonusDamage = math.floor(self.intelligence * 1.2)
    local totalDamage = baseDamage + bonusDamage
    
    local stunChance = 0.3
    
    target:takeDamage(totalDamage)
    print(string.format("%s usa Golpe Sagrado em %s causando %d de dano!", 
          self.name, target.name, totalDamage))
    
    if math.random() <= stunChance then
        print("O golpe sagrado atordoa o alvo!")
        local StunEffect = require("status.stun")
        local stun = StunEffect:new(1)
        target:addStatusEffect(stun)
    end
    
    self:processStatusEffects()
end

return Paladin