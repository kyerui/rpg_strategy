local BattleManager = require("battle_manager")
local Constants = require("config.constants")

local DemoManager = {}

function DemoManager.showPaladinAbilities()
    print("\n" .. string.rep("=", 50))
    print("DEMONSTRACAO DAS HABILIDADES DO PALADINO")
    print(string.rep("=", 50))
    
    local paladin = BattleManager.createCharacter(Constants.CLASSES.PALADIN, "Paladino Demonstracao", 6)
    local dummy = BattleManager.createCharacter(Constants.CLASSES.WARRIOR, "Alvo de Teste", 1)
    
    -- Restaurar para estado limpo
    paladin:restore()
    dummy:restore()
    
    DemoManager.testDefenseAbility(paladin)
    DemoManager.testRegenerationAbility(paladin)
    DemoManager.testSpecialAttack(paladin, dummy)
end

function DemoManager.testDefenseAbility(paladin)
    print("\n--- TESTE DE DEFESA - ARMADURA ABENCOADA ---")
    print("Habilidade: 15% reducao de dano + 25% chance de reduzir mais 30%")
    
    local testDamage = 50
    print("\nDano de teste: " .. testDamage)
    
    local initialHealth = paladin.health
    paladin:takeDamage(testDamage)
    local damageTaken = initialHealth - paladin.health
    
    print("Dano recebido: " .. damageTaken)
    print("Reducao: " .. (testDamage - damageTaken) .. " (" .. math.floor((testDamage - damageTaken) / testDamage * 100) .. "%)")
    print("Vida restante: " .. paladin.health .. "/" .. paladin.maxHealth)
end

function DemoManager.testRegenerationAbility(paladin)
    print("\n--- TESTE DE REGENERACAO - FE INABALAVEL ---")
    print("Habilidade: Regenera 5 de vida e 8 de mana por turno")
    
    paladin:restore()
    local initialHealth = paladin.health
    local initialMana = paladin.mana
    
    -- Simular um turno
    paladin:processStatusEffects()
    
    local healthRegained = paladin.health - initialHealth
    local manaRegained = paladin.mana - initialMana
    
    print("\nRegeneracao por turno:")
    print("Vida: " .. initialHealth .. " - " .. paladin.health .. " (+" .. healthRegained .. ")")
    print("Mana: " .. initialMana .. " - " .. paladin.mana .. " (+" .. manaRegained .. ")")
end

function DemoManager.testSpecialAttack(paladin, target)
    print("\n--- TESTE DE ATAQUE ESPECIAL - GOLPE SAGRADO ---")
    print("Habilidade: Dano base 20 + INTx1.2, 30% chance de atordoar, custo: 30 mana")
    
    paladin:restore()
    target:restore()
    
    local initialMana = paladin.mana
    local initialHealth = target.health
    
    print("\nMana antes: " .. initialMana)
    print("Vida do alvo antes: " .. initialHealth)
    
    -- Usar ataque especial (se disponível na classe Paladino)
    if paladin.specialAttack then
        paladin:specialAttack(target)
    else
        print("Ataque especial não disponivel nesta versao")
    end
    
    print("Mana depois: " .. paladin.mana)
    print("Vida do alvo depois: " .. target.health)
    print("Dano causado: " .. (initialHealth - target.health))
end

function DemoManager.showClassSummary()
    print("\n" .. string.rep("=", 50))
    print("RESUMO DAS CLASSES")
    print(string.rep("=", 50))
    
    local classes = {
        {
            name = "Guerreiro",
            health = 120,
            mana = 50,
            abilities = {"Pele Dura (20% reducao de dano)"},
            weapons = {"Espadas", "Machados"}
        },
        {
            name = "Arqueiro", 
            health = 90,
            mana = 80,
            abilities = {"Esquiva (25% chance de evitar dano)"},
            weapons = {"Arcos", "Adagas"}
        },
        {
            name = "Mago",
            health = 70, 
            mana = 150,
            abilities = {"Regeneracao de Mana (+10 mana/turno)"},
            weapons = {"Cajados", "Adagas"}
        },
        {
            name = "Paladino",
            health = 110,
            mana = 100,
            abilities = {"Armadura Abencoada", "Fe Inabalavel", "Golpe Sagrado"},
            weapons = {"Martelos Sagrados", "Cajados de Batalha"}
        }
    }
    
    for _, class in ipairs(classes) do
        print("\n" .. class.name .. ":")
        print("  Vida: " .. class.health .. " | Mana: " .. class.mana)
        print("  Habilidades: " .. table.concat(class.abilities, ", "))
        print("  Armas: " .. table.concat(class.weapons, ", "))
    end
end

return DemoManager