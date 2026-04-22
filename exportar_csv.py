import sqlite3
import pandas as pd

conn = sqlite3.connect('dnd_analytics.db')

df = pd.read_sql_query("""
    SELECT 
        e.damage_dealt,
        e.damage_taken,
        e.won,
        c.level,
        cl.name as class_name
    FROM encounters e
    JOIN characters c ON e.character_id = c.character_id
    JOIN classes cl ON c.class_id = cl.class_id
""", conn)

df.to_csv('dnd_dashboard.csv', index=False)
conn.close()
print("CSV exportado!")