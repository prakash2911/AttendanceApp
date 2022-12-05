import mysql.connector
import json
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="14072003jp",
    database="test"
)
cursor = mydb.cursor()
class_name="ct_2020_batch1"
query = f"select * from {class_name}"
cursor.execute(query)       
detail = cursor.fetchall()
cursor.reset()
for i in detail:
    print(i[0])