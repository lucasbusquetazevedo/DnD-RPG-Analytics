import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Configurações de estilo
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (12, 6)
plt.rcParams['font.size'] = 10

# Cria pasta para salvar gráficos
if not os.path.exists('graficos'):
    os.makedirs('graficos')

# Conecta no banco e carrega dados
conn = sqlite3.connect('dnd_analytics.db')

# Juntando todas as tabelas
df = pd.read_sql_query("""
    SELECT 
        e.encounter_id,
        e.character_id,
        e.damage_dealt,
        e.damage_taken,
        e.won,
        c.level,
        c.strength,
        c.intelligence,
        c.hp,
        c.defense,
        cl.name as class_name,
        cl.strength_base,
        cl.int_base,
        cl.hp_base
    FROM encounters e
    JOIN characters c ON e.character_id = c.character_id
    JOIN classes cl ON c.class_id = cl.class_id
""", conn)

conn.close()

print("=" * 70)
print("D&D RPG ANALYTICS - ANÁLISE EXPLORATÓRIA DE DADOS")
print("=" * 70)
print(f"\nTotal de combates analisados: {len(df)}")
print(f"Classes analisadas: {df['class_name'].nunique()}")
print(f"Personagens únicos: {df['character_id'].nunique()}")

# ============================================
# ANÁLISE 1: Estatísticas Descritivas
# ============================================

print("\n" + "=" * 70)
print("ESTATÍSTICAS DESCRITIVAS POR CLASSE")
print("=" * 70)

stats_by_class = df.groupby('class_name').agg({
    'damage_dealt': ['mean', 'std', 'min', 'max'],
    'damage_taken': ['mean', 'std'],
    'won': ['sum', 'mean']
}).round(2)

stats_by_class.columns = ['_'.join(col) for col in stats_by_class.columns]
stats_by_class['win_rate_pct'] = (stats_by_class['won_mean'] * 100).round(1)

print(stats_by_class)

# ============================================
# GRÁFICO 1: Win Rate por Classe
# ============================================

print("\nGerando gráfico: Win Rate por Classe...")

win_rate_data = df.groupby('class_name')['won'].agg(['sum', 'count'])
win_rate_data['win_rate'] = (win_rate_data['sum'] / win_rate_data['count'] * 100).round(1)
win_rate_data = win_rate_data.sort_values('win_rate', ascending=False)

plt.figure(figsize=(12, 6))
bars = plt.bar(win_rate_data.index, win_rate_data['win_rate'], 
               color=sns.color_palette("viridis", len(win_rate_data)))
plt.axhline(y=win_rate_data['win_rate'].mean(), color='red', linestyle='--', 
            label=f'Média: {win_rate_data["win_rate"].mean():.1f}%')
plt.xlabel('Classe')
plt.ylabel('Win Rate (%)')
plt.title('Taxa de Vitória por Classe (D&D 5e Níveis 1-10)', fontsize=14, fontweight='bold')
plt.xticks(rotation=45, ha='right')
plt.ylim(0, 100)
plt.legend()
plt.grid(axis='y', alpha=0.3)

# Adiciona valores nas barras
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.1f}%', ha='center', va='bottom', fontsize=9)

plt.tight_layout()
plt.savefig('graficos/01_win_rate_por_classe.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================
# GRÁFICO 2: Dano Médio Causado vs Recebido
# ============================================

print("Gerando gráfico: Dano Causado vs Recebido...")

damage_data = df.groupby('class_name').agg({
    'damage_dealt': 'mean',
    'damage_taken': 'mean'
}).round(1).reset_index()

x = range(len(damage_data))
width = 0.35

plt.figure(figsize=(12, 6))
plt.bar([i - width/2 for i in x], damage_data['damage_dealt'], width, 
        label='Dano Causado', color='#2E86AB')
plt.bar([i + width/2 for i in x], damage_data['damage_taken'], width, 
        label='Dano Recebido', color='#A23B72')

plt.xlabel('Classe')
plt.ylabel('Dano Médio')
plt.title('Dano Médio Causado vs Recebido por Classe', fontsize=14, fontweight='bold')
plt.xticks(x, damage_data['class_name'], rotation=45, ha='right')
plt.legend()
plt.grid(axis='y', alpha=0.3)
plt.tight_layout()
plt.savefig('graficos/02_dano_causado_vs_recebido.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================
# GRÁFICO 3: Eficiência (Saldo de Dano)
# ============================================

print("Gerando gráfico: Eficiência (Saldo de Dano)...")

damage_data['damage_balance'] = damage_data['damage_dealt'] - damage_data['damage_taken']
damage_data = damage_data.sort_values('damage_balance', ascending=False)

colors = ['green' if x > 0 else 'red' for x in damage_data['damage_balance']]

plt.figure(figsize=(12, 6))
bars = plt.barh(damage_data['class_name'], damage_data['damage_balance'], color=colors, alpha=0.7)
plt.axvline(x=0, color='black', linestyle='-', linewidth=0.8)
plt.xlabel('Saldo de Dano (Causado - Recebido)')
plt.ylabel('Classe')
plt.title('Eficiência de Combate por Classe', fontsize=14, fontweight='bold')
plt.grid(axis='x', alpha=0.3)

# Adiciona valores nas barras
for i, bar in enumerate(bars):
    width = bar.get_width()
    plt.text(width, bar.get_y() + bar.get_height()/2., 
             f'{width:.1f}', ha='left' if width > 0 else 'right', 
             va='center', fontsize=9)

plt.tight_layout()
plt.savefig('graficos/03_eficiencia_saldo_dano.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================
# GRÁFICO 4: Distribuição de Dano por Classe (Box Plot)
# ============================================

print("Gerando gráfico: Distribuição de Dano...")

plt.figure(figsize=(14, 7))
sns.boxplot(data=df, x='class_name', y='damage_dealt', 
            palette='Set2', linewidth=1.5)
plt.xlabel('Classe')
plt.ylabel('Dano Causado')
plt.title('Distribuição de Dano Causado por Classe', fontsize=14, fontweight='bold')
plt.xticks(rotation=45, ha='right')
plt.grid(axis='y', alpha=0.3)
plt.tight_layout()
plt.savefig('graficos/04_distribuicao_dano_boxplot.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================
# GRÁFICO 5: Win Rate por Nível
# ============================================

print("Gerando gráfico: Win Rate por Nível...")

win_by_level = df.groupby(['level', 'class_name'])['won'].mean() * 100
win_by_level = win_by_level.reset_index()

plt.figure(figsize=(14, 7))
for class_name in df['class_name'].unique():
    data = win_by_level[win_by_level['class_name'] == class_name]
    plt.plot(data['level'], data['won'], marker='o', label=class_name, linewidth=2)

plt.xlabel('Nível do Personagem')
plt.ylabel('Win Rate (%)')
plt.title('Evolução do Win Rate por Nível e Classe', fontsize=14, fontweight='bold')
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.grid(alpha=0.3)
plt.xticks(df['level'].unique())
plt.ylim(0, 105)
plt.tight_layout()
plt.savefig('graficos/05_win_rate_por_nivel.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================
# GRÁFICO 6: Correlação Dano vs Win Rate
# ============================================

print("Gerando gráfico: Correlação Dano vs Win Rate...")

correlation_data = df.groupby('class_name').agg({
    'damage_dealt': 'mean',
    'won': 'mean'
}).reset_index()

correlation_data['win_rate'] = correlation_data['won'] * 100

plt.figure(figsize=(10, 8))
plt.scatter(correlation_data['damage_dealt'], correlation_data['win_rate'], 
            s=200, alpha=0.6, c=range(len(correlation_data)), cmap='viridis')

for i, row in correlation_data.iterrows():
    plt.annotate(row['class_name'], 
                 (row['damage_dealt'], row['win_rate']),
                 xytext=(5, 5), textcoords='offset points', fontsize=10)

plt.xlabel('Dano Médio Causado')
plt.ylabel('Win Rate (%)')
plt.title('Relação entre Dano Causado e Taxa de Vitória', fontsize=14, fontweight='bold')
plt.grid(alpha=0.3)
plt.tight_layout()
plt.savefig('graficos/06_correlacao_dano_winrate.png', dpi=300, bbox_inches='tight')
plt.close()

# ============================================
# RESUMO FINAL
# ============================================

print("\n" + "=" * 70)
print("RESUMO DA ANÁLISE")
print("=" * 70)

print("\n TOP 3 CLASSES POR WIN RATE:")
top_winrate = win_rate_data.head(3)
for i, (class_name, row) in enumerate(top_winrate.iterrows(), 1):
    print(f"{i}. {class_name}: {row['win_rate']:.1f}%")

print("\n TOP 3 CLASSES POR DANO CAUSADO:")
top_damage = df.groupby('class_name')['damage_dealt'].mean().sort_values(ascending=False).head(3)
for i, (class_name, damage) in enumerate(top_damage.items(), 1):
    print(f"{i}. {class_name}: {damage:.1f}")

print("\n TOP 3 CLASSES MAIS RESISTENTES (menor dano recebido):")
top_defense = df.groupby('class_name')['damage_taken'].mean().sort_values().head(3)
for i, (class_name, damage) in enumerate(top_defense.items(), 1):
    print(f"{i}. {class_name}: {damage:.1f}")

print("\n" + "=" * 70)
print(" Análise completa!")
print(f" {6} gráficos salvos em: graficos/")
print("=" * 70)