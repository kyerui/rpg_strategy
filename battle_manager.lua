local Constants = require("config.constants")

local BattleManager = {}

function BattleManager.safeRequire(module)
    local success, result = pcall(require, module)
    if success then
        return result
    else
        error("Falha ao carregar modulo: " .. module)
    end
end

BattleManager.Warrior = BattleManager.safeRequire("character.warrior")
BattleManager.Archer = BattleManager.safeRequire("character.archer")
BattleManager.Mage = BattleManager.safeRequire("character.mage")
BattleManager.Paladin = BattleManager.safeRequire("character.paladin")
BattleManager.Battle = BattleManager.safeRequire("battle.battle")

BattleManager.weapons = {
    BattleManager.safeRequire("weapons.longsword"),
    BattleManager.safeRequire("weapons.elven_bow"), 
    BattleManager.safeRequire("weapons.arcane_staff"),
    BattleManager.safeRequire("weapons.war_axe"),
    BattleManager.safeRequire("weapons.shadow_dagger"),
    BattleManager.safeRequire("weapons.holy_hammer"),
    BattleManager.safeRequire("weapons.battle_staff")
}

function BattleManager.createCharacter(class, name, weaponIndex)
    local character
    if class == Constants.CLASSES.WARRIOR then
        character = BattleManager.Warrior:new(name)
    elseif class == Constants.CLASSES.ARCHER then
        character = BattleManager.Archer:new(name)
    elseif class == Constants.CLASSES.MAGE then
        character = BattleManager.Mage:new(name)
    elseif class == Constants.CLASSES.PALADIN then
        character = BattleManager.Paladin:new(name)
    end
    
    if character and weaponIndex then
        character:equipWeapon(BattleManager.weapons[weaponIndex]:new())
    end
    
    return character
end

function BattleManager.executeBasicBattles()
    print("\n" .. string.rep("=", 50))
    print("BATALHAS BASICAS")
    print(string.rep("=", 50))
    
    for i = 1, 3 do
        print("\n--- BATALHA " .. i .. " ---")
        
        local warrior = BattleManager.createCharacter(Constants.CLASSES.WARRIOR, "Guerreiro " .. i, 1)
        local archer = BattleManager.createCharacter(Constants.CLASSES.ARCHER, "Arqueiro " .. i, 2)
        
        print(warrior.name .. " vs " .. archer.name)
        print(warrior.name .. " com " .. warrior.equippedWeapon.name)
        print(archer.name .. " com " .. archer.equippedWeapon.name)
        
        local battle = BattleManager.Battle:new({warrior, archer})
        battle:startBattle()
    end
end

function BattleManager.executePaladinBattles()
    print("\n" .. string.rep("=", 50))
    print("BATALHAS DO PALADINO")
    print(string.rep("=", 50))
    
    print("\n--- BATALHA 1: PALADINO VS GUERREIRO ---")
    local paladin = BattleManager.createCharacter(Constants.CLASSES.PALADIN, "Uther o Paladino", 6)
    local warrior = BattleManager.createCharacter(Constants.CLASSES.WARRIOR, "Grom o Guerreiro", 4)
    
    BattleManager.executeDuel(paladin, warrior)
    
    print("\n--- BATALHA 2: PALADINO VS MAGO ---")
    local paladin2 = BattleManager.createCharacter(Constants.CLASSES.PALADIN, "Tirion o Justiceiro", 7)
    local mage = BattleManager.createCharacter(Constants.CLASSES.MAGE, "KelThuzad o Mago", 3)
    
    BattleManager.executeDuel(paladin2, mage)
end

function BattleManager.executeRoyaleBattle()
    print("\n" .. string.rep("=", 50))
    print("BATALHA REAL")
    print(string.rep("=", 50))
    
    local participants = {
        BattleManager.createCharacter(Constants.CLASSES.WARRIOR, "Conan o Guerreiro", 1),
        BattleManager.createCharacter(Constants.CLASSES.ARCHER, "Legolas o Arqueiro", 5),
        BattleManager.createCharacter(Constants.CLASSES.MAGE, "Gandalf o Mago", 3),
        BattleManager.createCharacter(Constants.CLASSES.PALADIN, "Arthas o Paladino", 6)
    }
    
    print("Batalha Real com todas as classes:")
    for i, participant in ipairs(participants) do
        print("- " .. participant.name .. " com " .. participant.equippedWeapon.name)
    end
    
    local battle = BattleManager.Battle:new(participants)
    battle:startBattle()
end

function BattleManager.executeDuel(player1, player2)
    print(player1.name .. " vs " .. player2.name)
    print(player1.name .. " com " .. player1.equippedWeapon.name)
    print(player2.name .. " com " .. player2.equippedWeapon.name)
    
    local battle = BattleManager.Battle:new({player1, player2})
    battle:startBattle()
end

return BattleManager