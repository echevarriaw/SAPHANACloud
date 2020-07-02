from hdbcli import dbapi
conn = dbapi.connect(
    address="<host>",
    port=<port>,
    encrypt="true",
    sslValidateCertificate="false",
    user="<user>",
    password="<password>"
)

with conn.cursor() as cursor:
	sql = "SELECT * FROM travel.budgetrooms"
	cursor.execute(sql)
	result = cursor.fetchall()
print(result)

conn.close()
