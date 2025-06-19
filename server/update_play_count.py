# server/migrate_add_play_count.py
# Run this script to add the play_count column to existing songs table

import psycopg2
from database import DATABASE_URL
import os

def add_play_count_column():
    try:
        # Parse the database URL
        # Assuming your DATABASE_URL is in format: postgresql://username:password@host:port/database
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        
        # Add the play_count column with default value 0
        cursor.execute("""
            ALTER TABLE songs 
            ADD COLUMN IF NOT EXISTS play_count INTEGER DEFAULT 0;
        """)
        
        # Update existing songs to have play_count = 0 if they don't have it
        cursor.execute("""
            UPDATE songs 
            SET play_count = 0 
            WHERE play_count IS NULL;
        """)
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print("Successfully added play_count column to songs table!")
        
    except Exception as e:
        print(f"Error adding play_count column: {e}")

if __name__ == "__main__":
    add_play_count_column()