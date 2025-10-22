-- Arquivo para execuções rápidas de batalhas específicas
local BattleManager = require("battle_manager")

math.randomseed(os.time())

print("===== EXECUCAO RAPIDA DE BATALHAS =====")

-- Executar apenas batalhas básicas
BattleManager.executeBasicBattles()

print("\n=== FIM ===")