import sqlite3
import random

# Conecta no banco
conn = sqlite3.connect('dnd_analytics.db')
cursor = conn.cursor()

# Limpa combates simulados anteriores antes de rodar
cursor.execute("DELETE FROM encounters WHERE encounter_id > 36")
conn.commit()

# Busca todos os personagens do banco
cursor.execute("""
    SELECT 
        c.character_id,
        c.class_id,
        c.level,
        c.strength,
        c.intelligence,
        c.hp,
        cl.name as class_name,
        cl.strength_base,
        cl.int_base
    FROM characters c
    JOIN classes cl ON c.class_id = cl.class_id
""")

characters = cursor.fetchall()

print(f"Encontrados {len(characters)} personagens no banco")
print("Iniciando simulação de combates...\n")

# Função que simula um combate
def simulate_encounter(character):
    char_id, class_id, level, strength, intelligence, hp, class_name, strength_base, int_base = character
    
    # Calcula o dano base do personagem
    # Classes de força (Fighter, Barbarian, Paladin) usam força
    # Classes de inteligência (Wizard, Sorcerer, Warlock) usam inteligência
    # Classes híbridas usam ambos
    
    if strength_base >= 3:  # Classe física
        main_attribute = strength
    elif int_base >= 3:  # Classe mágica
        main_attribute = intelligence
    else:  # Híbrido
        main_attribute = (strength + intelligence) // 2
    
    # Dano causado = atributo principal + nível + aleatoriedade
    base_damage = main_attribute + (level * 3)
    damage_dealt = base_damage + random.randint(-5, 15)
    
    # Dano recebido depende do HP (mais HP = mais resistente)
    # e tem aleatoriedade do inimigo
    resistance = hp // 10
    damage_taken = random.randint(10, 40) - resistance
    damage_taken = max(5, damage_taken)  # Mínimo de 5 de dano
    
    # Decide se venceu
    # Vitória se causou mais dano do que recebeu + um pouco de sorte
    win_chance = (damage_dealt - damage_taken) + random.randint(-10, 10)
    won = 1 if win_chance > 0 else 0
    
    return damage_dealt, damage_taken, won

# Gera 20 combates para cada personagem (360 combates no total)
encounters_generated = 0

for character in characters:
    char_id = character[0]
    class_name = character[6]
    level = character[2]
    
    for i in range(20):
        damage_dealt, damage_taken, won = simulate_encounter(character)
        
        # Insere no banco
        cursor.execute("""
            INSERT INTO encounters (character_id, damage_dealt, damage_taken, won)
            VALUES (?, ?, ?, ?)
        """, (char_id, damage_dealt, damage_taken, won))
        
        encounters_generated += 1
    
    print(f"✓ {class_name} (nível {level}): 20 combates simulados")

# Salva tudo no banco
conn.commit()
conn.close()

print(f"\n Simulação concluída!")
print(f"Total de combates gerados: {encounters_generated}")
print(f"Banco atualizado: dnd_analytics.db")