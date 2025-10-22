-- Sistema de Combate RPG - Versão Modular
local BattleManager = require("battle_manager")
local DemoManager = require("demo_manager")

-- Configurar aleatoriedade
math.randomseed(os.time())

local function main()
    print("===== SISTEMA DE COMBATE RPG =====")
    print("Versao Modular com Paladino")
    print("")
    
    -- Executar sequência de batalhas
    BattleManager.executeBasicBattles()
    BattleManager.executePaladinBattles() 
    BattleManager.executeRoyaleBattle()
    
    -- Demonstração das habilidades
    DemoManager.showPaladinAbilities()
    DemoManager.showClassSummary()
    
    print("\n" .. string.rep("=", 50))
    print("FIM DO SISTEMA DE COMBATE")
    print(string.rep("=", 50))
end

main()