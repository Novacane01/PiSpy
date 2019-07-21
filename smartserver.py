#SQL TABLES
""" 
cur.execute("INSERT INTO ports("Port Number","IP Address") values(6890),(6891),(6892),(6893),(6894),(6895),(6896),(6897),(6898),(6899),(6900)")
cur.execute("CREATE TABLE Users(Username VARCHAR(255) PRIMARY KEY, Password VARCHAR(255) NOT NULL, Email VARCHAR(255) UNIQUE NOT NULL);")
cur.execute("CREATE TABLE Camera(\"IP Address\" VARCHAR(15) PRIMARY KEY, \"Mac Address\" VARCHAR(12) UNIQUE NOT NULL);")
cur.execute("CREATE TABLE Ports(\"Port Number\" INT PRIMARY KEY, \"IP Address\" VARCHAR(17) UNIQUE REFERENCES Camera(\"IP Address\") ON DELETE SET NULL);")
cur.execute("CREATE TABLE Camera_to_User(ID SERIAL PRIMARY KEY, Username VARCHAR(255) REFERENCES Users(Username), \"Mac Address\" VARCHAR(17) UNIQUE REFERENCES Camera(\"Mac Address\") ON DELETE CASCADE);")
"""

import os
import psycopg2
from flask import Flask, request, jsonify

DATABASE_URL = os.environ.get('DATABASE_URL')
conn = psycopg2.connect(DATABASE_URL, sslmode='require')

cur = conn.cursor()

app = Flask(__name__)


@app.route('/')
def init():
    return 'Server is running'


@app.route('/assign-camera')
def assign_camera():
    ip_address = request.args.get('ip')
    mac_address = request.args.get('mac')

    print(ip_address)
    print(mac_address)

    try:
        sql_string = 'INSERT INTO Camera(\"IP Address\", \"Mac Address\") VALUES (\'{}\',\'{}\')'.format(ip_address,
                                                                                                         mac_address)
        cur.execute(sql_string)

        sql_string = 'SELECT * FROM Ports WHERE \"IP Address\" IS NULL ORDER BY \"Port Number\" ASC LIMIT 2'

        cur.execute(sql_string)

        available_ports = list(map(lambda x: x[0], cur.fetchall()))
        config_port, stream_port = available_ports

        sql_string = 'UPDATE Ports SET \"IP Address\" = \'{}\' WHERE \"Port Number\" = {} OR \"Port Number\" = {}'.format(
            ip_address, config_port, stream_port)

        cur.execute(sql_string)
        conn.commit()
        return jsonify({'config_port': config_port, 'stream_port': stream_port}), 200

    except psycopg2.Error as e:
        print(e.pgerror)
        conn.rollback()
        return e.pgerror, 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=os.environ.get('PORT', 6969))
