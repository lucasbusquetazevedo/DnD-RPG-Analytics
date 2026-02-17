-- ============================================
-- D&D RPG ANALYTICS — SEMANA 1
-- Versão iniciante: 3 tabelas 
-- Sistema: D&D 5e 2024 | Foco: Níveis 1–10
-- ============================================


-- ============================================
-- TABELA 1: classes
-- ============================================

CREATE TABLE classes (
    id_classe   INTEGER PRIMARY KEY,  
    nome        TEXT NOT NULL,        
    forca_base  INTEGER,              -- bônus de força inicial
    int_base    INTEGER,              -- bônus de inteligência inicial
    defesa_base INTEGER,              -- armor class base (CA)
    vida_base   INTEGER               
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
-- TABELA 2: personagens dos jogadores
-- Cada personagem tem sua classe
-- ============================================

CREATE TABLE personagens (                  
    id_personagem INTEGER PRIMARY KEY,  
    id_classe     INTEGER NOT NULL,     
    nivel         INTEGER,             
    forca         INTEGER,              
    inteligencia  INTEGER,              
    defesa        INTEGER,              
    vida          INTEGER,              

    FOREIGN KEY (id_classe) REFERENCES classes(id_classe)
);

-- 2 personagens por classe, níveis concentrados em 5–9
-- (faixa mais jogada segundo dados do D&D Beyond)

INSERT INTO personagens VALUES (1,  1, 5, 16, 8,  18, 44);  -- Fighter nível 5
INSERT INTO personagens VALUES (2,  1, 8, 17, 8,  18, 60);  -- Fighter nível 8
INSERT INTO personagens VALUES (3,  2, 5,  8, 14, 15, 32);  -- Rogue nível 5
INSERT INTO personagens VALUES (4,  2, 7,  9, 14, 15, 42);  -- Rogue nível 7
INSERT INTO personagens VALUES (5,  3, 5, 18, 8,  14, 52);  -- Barbarian nível 5
INSERT INTO personagens VALUES (6,  3, 8, 20, 8,  14, 76);  -- Barbarian nível 8
INSERT INTO personagens VALUES (7,  4, 5, 10, 16, 17, 35);  -- Monk nível 5
INSERT INTO personagens VALUES (8,  4, 7, 11, 16, 17, 46);  -- Monk nível 7
INSERT INTO personagens VALUES (9,  5, 5, 14, 12, 15, 40);  -- Ranger nível 5
INSERT INTO personagens VALUES (10, 5, 8, 15, 12, 15, 56);  -- Ranger nível 8
INSERT INTO personagens VALUES (11, 6, 5, 16, 14, 18, 44);  -- Paladin nível 5
INSERT INTO personagens VALUES (12, 6, 7, 17, 14, 18, 56);  -- Paladin nível 7
INSERT INTO personagens VALUES (13, 7, 5,  8, 18, 12, 28);  -- Wizard nível 5
INSERT INTO personagens VALUES (14, 7, 9,  8, 20, 12, 40);  -- Wizard nível 9
INSERT INTO personagens VALUES (15, 8, 5,  8, 17, 12, 28);  -- Sorcerer nível 5
INSERT INTO personagens VALUES (16, 8, 7,  8, 18, 12, 36);  -- Sorcerer nível 7
INSERT INTO personagens VALUES (17, 9, 5,  8, 17, 13, 32);  -- Warlock nível 5
INSERT INTO personagens VALUES (18, 9, 8,  8, 18, 13, 44);  -- Warlock nível 8


-- ============================================
-- TABELA 3: combates
-- Cada linha = um encontro de combate
-- ============================================

CREATE TABLE combates (
    id_combate    INTEGER PRIMARY KEY,  -- identificador único
    id_personagem INTEGER NOT NULL,     -- qual personagem lutou
    dano_causado  INTEGER,              -- dano total causado no encontro
    dano_recebido INTEGER,              -- dano total recebido
    venceu        INTEGER,              -- 1 = vitória | 0 = derrota

    FOREIGN KEY (id_personagem) REFERENCES personagens(id_personagem)
);

-- 2 combates por personagem = 36 combates de teste

INSERT INTO combates VALUES (1,  1,  45, 12, 1);
INSERT INTO combates VALUES (2,  1,  38, 30, 1);
INSERT INTO combates VALUES (3,  2,  60, 18, 1);
INSERT INTO combates VALUES (4,  2,  55, 40, 0);
INSERT INTO combates VALUES (5,  3,  28, 22, 1);
INSERT INTO combates VALUES (6,  3,  32, 35, 0);
INSERT INTO combates VALUES (7,  4,  70, 10, 1);
INSERT INTO combates VALUES (8,  4,  65, 50, 1);
INSERT INTO combates VALUES (9,  5,  40, 20, 1);
INSERT INTO combates VALUES (10, 5,  35, 45, 0);
INSERT INTO combates VALUES (11, 6,  50, 15, 1);
INSERT INTO combates VALUES (12, 6,  42, 28, 1);
INSERT INTO combates VALUES (13, 7,  30, 35, 0);
INSERT INTO combates VALUES (14, 7,  55, 20, 1);
INSERT INTO combates VALUES (15, 8,  25, 40, 0);
INSERT INTO combates VALUES (16, 8,  48, 18, 1);
INSERT INTO combates VALUES (17, 9,  80, 22, 1);
INSERT INTO combates VALUES (18, 9,  72, 30, 1);
INSERT INTO combates VALUES (19, 10, 45, 25, 1);
INSERT INTO combates VALUES (20, 10, 38, 40, 0);
INSERT INTO combates VALUES (21, 11, 55, 10, 1);
INSERT INTO combates VALUES (22, 11, 60, 20, 1);
INSERT INTO combates VALUES (23, 12, 20, 45, 0);
INSERT INTO combates VALUES (24, 12, 35, 30, 1);
INSERT INTO combates VALUES (25, 13, 90, 25, 1);
INSERT INTO combates VALUES (26, 13, 85, 40, 1);
INSERT INTO combates VALUES (27, 14, 18, 50, 0);
INSERT INTO combates VALUES (28, 14, 42, 22, 1);
INSERT INTO combates VALUES (29, 15, 75, 30, 1);
INSERT INTO combates VALUES (30, 15, 68, 35, 1);
INSERT INTO combates VALUES (31, 16, 22, 48, 0);
INSERT INTO combates VALUES (32, 16, 40, 20, 1);
INSERT INTO combates VALUES (33, 17, 50, 28, 1);
INSERT INTO combates VALUES (34, 17, 55, 15, 1);
INSERT INTO combates VALUES (35, 18, 30, 42, 0);
INSERT INTO combates VALUES (36, 18, 48, 25, 1);

-- ============================================
-- QUERIES DE VALIDAÇÃO
-- ============================================

SELECT * FROM classes;


SELECT
    p.id_personagem,
    c.nome       AS classe,
    p.nivel,
    p.vida,
    p.defesa
FROM personagens p
JOIN classes c ON p.id_classe = c.id_classe
ORDER BY c.nome, p.nivel;

-- Dano médio por classe (GROUP BY + JOIN)
SELECT
    c.nome AS classe,
    ROUND(AVG(cb.dano_causado), 1)  AS dano_medio,
    ROUND(AVG(cb.dano_recebido), 1) AS dano_recebido_medio
FROM combates cb
JOIN personagens p ON cb.id_personagem = p.id_personagem
JOIN classes c     ON p.id_classe = c.id_classe
GROUP BY c.nome
ORDER BY dano_medio DESC;

-- Taxa de vitória por classe
SELECT
    c.nome   AS classe,
    COUNT(*) AS total_combates,
    SUM(cb.venceu) AS vitorias,
    ROUND(100.0 * SUM(cb.venceu) / COUNT(*), 1) AS win_rate_pct
FROM combates cb
JOIN personagens p ON cb.id_personagem = p.id_personagem
JOIN classes c     ON p.id_classe = c.id_classe
GROUP BY c.nome
ORDER BY win_rate_pct DESC;

-- Eficiência: saldo de dano por classe
SELECT
    c.nome AS classe,
    ROUND(AVG(cb.dano_causado), 1)  AS dano_medio,
    ROUND(AVG(cb.dano_recebido), 1) AS dano_sofrido_medio,
    ROUND(AVG(cb.dano_causado) - AVG(cb.dano_recebido), 1) AS saldo
FROM combates cb
JOIN personagens p ON cb.id_personagem = p.id_personagem
JOIN classes c     ON p.id_classe = c.id_classe
GROUP BY c.nome
ORDER BY saldo DESC;