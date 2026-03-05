-- ============================================
-- D&D RPG ANALYTICS — SEMANA 1
-- Versão iniciante: 3 tabelas 
-- Sistema: D&D 5e 2024 | Foco: Níveis 1–10
-- ============================================


-- ============================================
-- TABELA 1: classes
-- Guarda as características base de cada classe
-- ============================================

CREATE TABLE classes (
    class_id      INTEGER PRIMARY KEY,  
    name          TEXT NOT NULL,        
    strength_base INTEGER,              -- bônus de força inicial
    int_base      INTEGER,              -- bônus de inteligência inicial
    defense_base  INTEGER,              -- armor class base (CA)
    hp_base       INTEGER               -- hit die máximo (d6=6, d8=8, d10=10, d12=12)
);

INSERT INTO classes VALUES (1, 'Fighter',   3, 0, 16, 10);
INSERT INTO classes VALUES (2, 'Rogue',     1, 2, 14,  8);
INSERT INTO classes VALUES (3, 'Barbarian', 4, 0, 14, 12);
INSERT INTO classes VALUES (4, 'Monk',      1, 2, 15,  8);
INSERT INTO classes VALUES (5, 'Ranger',    2, 1, 15, 10);
INSERT INTO classes VALUES (6, 'Paladin',   3, 1, 17, 10);
INSERT INTO classes VALUES (7, 'Wizard',    0, 4, 12,  6);
INSERT INTO classes VALUES (8, 'Sorcerer',  0, 3, 12,  6);
INSERT INTO classes VALUES (9, 'Warlock',   0, 3, 13,  8);


-- ============================================
-- TABELA 2: characters (personagens)
-- Cada personagem pertence a uma classe
-- ============================================

CREATE TABLE characters (                  
    character_id INTEGER PRIMARY KEY,  
    class_id     INTEGER NOT NULL,     
    level        INTEGER,             
    strength     INTEGER,              
    intelligence INTEGER,              
    defense      INTEGER,              
    hp           INTEGER,              

    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- 2 personagens por classe, níveis concentrados em 5–9
-- (faixa mais jogada segundo dados do D&D Beyond)

INSERT INTO characters VALUES (1,  1, 5, 16, 8,  18, 44);  -- Fighter nível 5
INSERT INTO characters VALUES (2,  1, 8, 17, 8,  18, 60);  -- Fighter nível 8
INSERT INTO characters VALUES (3,  2, 5,  8, 14, 15, 32);  -- Rogue nível 5
INSERT INTO characters VALUES (4,  2, 7,  9, 14, 15, 42);  -- Rogue nível 7
INSERT INTO characters VALUES (5,  3, 5, 18, 8,  14, 52);  -- Barbarian nível 5
INSERT INTO characters VALUES (6,  3, 8, 20, 8,  14, 76);  -- Barbarian nível 8
INSERT INTO characters VALUES (7,  4, 5, 10, 16, 17, 35);  -- Monk nível 5
INSERT INTO characters VALUES (8,  4, 7, 11, 16, 17, 46);  -- Monk nível 7
INSERT INTO characters VALUES (9,  5, 5, 14, 12, 15, 40);  -- Ranger nível 5
INSERT INTO characters VALUES (10, 5, 8, 15, 12, 15, 56);  -- Ranger nível 8
INSERT INTO characters VALUES (11, 6, 5, 16, 14, 18, 44);  -- Paladin nível 5
INSERT INTO characters VALUES (12, 6, 7, 17, 14, 18, 56);  -- Paladin nível 7
INSERT INTO characters VALUES (13, 7, 5,  8, 18, 12, 28);  -- Wizard nível 5
INSERT INTO characters VALUES (14, 7, 9,  8, 20, 12, 40);  -- Wizard nível 9
INSERT INTO characters VALUES (15, 8, 5,  8, 17, 12, 28);  -- Sorcerer nível 5
INSERT INTO characters VALUES (16, 8, 7,  8, 18, 12, 36);  -- Sorcerer nível 7
INSERT INTO characters VALUES (17, 9, 5,  8, 17, 13, 32);  -- Warlock nível 5
INSERT INTO characters VALUES (18, 9, 8,  8, 18, 13, 44);  -- Warlock nível 8


-- ============================================
-- TABELA 3: encounters (combates)
-- Cada linha = um encontro de combate
-- ============================================

CREATE TABLE encounters (
    encounter_id  INTEGER PRIMARY KEY,  
    character_id  INTEGER NOT NULL,     
    damage_dealt  INTEGER,              -- dano total causado
    damage_taken  INTEGER,              -- dano total recebido
    won           INTEGER,              -- 1 = vitória | 0 = derrota

    FOREIGN KEY (character_id) REFERENCES characters(character_id)
);

-- 2 combates por personagem = 36 combates de teste

INSERT INTO encounters VALUES (1,  1,  45, 12, 1);
INSERT INTO encounters VALUES (2,  1,  38, 30, 1);
INSERT INTO encounters VALUES (3,  2,  60, 18, 1);
INSERT INTO encounters VALUES (4,  2,  55, 40, 0);
INSERT INTO encounters VALUES (5,  3,  28, 22, 1);
INSERT INTO encounters VALUES (6,  3,  32, 35, 0);
INSERT INTO encounters VALUES (7,  4,  70, 10, 1);
INSERT INTO encounters VALUES (8,  4,  65, 50, 1);
INSERT INTO encounters VALUES (9,  5,  40, 20, 1);
INSERT INTO encounters VALUES (10, 5,  35, 45, 0);
INSERT INTO encounters VALUES (11, 6,  50, 15, 1);
INSERT INTO encounters VALUES (12, 6,  42, 28, 1);
INSERT INTO encounters VALUES (13, 7,  30, 35, 0);
INSERT INTO encounters VALUES (14, 7,  55, 20, 1);
INSERT INTO encounters VALUES (15, 8,  25, 40, 0);
INSERT INTO encounters VALUES (16, 8,  48, 18, 1);
INSERT INTO encounters VALUES (17, 9,  80, 22, 1);
INSERT INTO encounters VALUES (18, 9,  72, 30, 1);
INSERT INTO encounters VALUES (19, 10, 45, 25, 1);
INSERT INTO encounters VALUES (20, 10, 38, 40, 0);
INSERT INTO encounters VALUES (21, 11, 55, 10, 1);
INSERT INTO encounters VALUES (22, 11, 60, 20, 1);
INSERT INTO encounters VALUES (23, 12, 20, 45, 0);
INSERT INTO encounters VALUES (24, 12, 35, 30, 1);
INSERT INTO encounters VALUES (25, 13, 90, 25, 1);
INSERT INTO encounters VALUES (26, 13, 85, 40, 1);
INSERT INTO encounters VALUES (27, 14, 18, 50, 0);
INSERT INTO encounters VALUES (28, 14, 42, 22, 1);
INSERT INTO encounters VALUES (29, 15, 75, 30, 1);
INSERT INTO encounters VALUES (30, 15, 68, 35, 1);
INSERT INTO encounters VALUES (31, 16, 22, 48, 0);
INSERT INTO encounters VALUES (32, 16, 40, 20, 1);
INSERT INTO encounters VALUES (33, 17, 50, 28, 1);
INSERT INTO encounters VALUES (34, 17, 55, 15, 1);
INSERT INTO encounters VALUES (35, 18, 30, 42, 0);
INSERT INTO encounters VALUES (36, 18, 48, 25, 1);


-- ============================================
-- QUERIES DE VALIDAÇÃO
-- ============================================

-- 1. Ver todas as classes
SELECT * FROM classes;

-- 2. Personagens com nome da classe (JOIN)
SELECT 
    c.character_id,
    cl.name      AS class,
    c.level,
    c.hp,
    c.defense
FROM characters c
JOIN classes cl ON c.class_id = cl.class_id 
ORDER BY cl.name, c.level;

-- 3. Dano médio por classe (GROUP BY + JOIN)
SELECT
    cl.name AS class,
    ROUND(AVG(e.damage_dealt), 1) AS avg_damage_dealt,
    ROUND(AVG(e.damage_taken), 1) AS avg_damage_taken
FROM encounters e
JOIN characters c ON e.character_id = c.character_id
JOIN classes cl   ON c.class_id = cl.class_id
GROUP BY cl.name
ORDER BY avg_damage_dealt DESC;

-- 4. Taxa de vitória por classe
SELECT
    cl.name  AS class,
    COUNT(*) AS total_encounters,
    SUM(e.won) AS victories,
    ROUND(100.0 * SUM(e.won) / COUNT(*), 1) AS win_rate_pct
FROM encounters e
JOIN characters c ON e.character_id = c.character_id
JOIN classes cl   ON c.class_id = cl.class_id
GROUP BY cl.name
ORDER BY win_rate_pct DESC;

-- 5. Eficiência: saldo de dano por classe
SELECT
    cl.name AS class,
    ROUND(AVG(e.damage_dealt), 1) AS avg_damage_dealt,
    ROUND(AVG(e.damage_taken), 1) AS avg_damage_taken,
    ROUND(AVG(e.damage_dealt) - AVG(e.damage_taken), 1) AS damage_balance
FROM encounters e
JOIN characters c ON e.character_id = c.character_id
JOIN classes cl   ON c.class_id = cl.class_id
GROUP BY cl.name
ORDER BY damage_balance DESC;