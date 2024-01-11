from flask import Flask, request, redirect, jsonify
import mysql.connector
import random
import string
import configparser


config = configparser.ConfigParser()
config.read('config.ini')
db_config = config['database']

app = Flask(__name__)

db = mysql.connector.connect(
    host=db_config['host'],
    user=db_config['user'],
    passwd=db_config['passwd'],
    database=db_config['database']
)

cursor = db.cursor()
cursor.execute('''CREATE TABLE IF NOT EXISTS url_mapping (
    id INT AUTO_INCREMENT PRIMARY KEY,
    short_id VARCHAR(255),
    original_url VARCHAR(255)
)''')


def generate_short_id(num_of_chars):
    choices = string.ascii_letters + string.digits
    short_id = ''.join(random.choice(choices) for _ in range(num_of_chars))
    return short_id

def is_alias_taken(alias):
    cursor.execute(f'SELECT COUNT(*) FROM url_mapping WHERE short_id = \"{alias}\"')
    return cursor.fetchone()[0] > 0

@app.route('/shorten', methods=['POST'])
def shorten():
    original_url = request.form['url']
    custom_alias = request.form.get('alias')
    print("url: ", original_url, "custom_alias: ", custom_alias)

    if custom_alias and len(custom_alias) > 0:
        if is_alias_taken(custom_alias):
            return jsonify({"error": 'Alias already in use'}), 400
        short_id = custom_alias
    else:
        while True:
            short_id = generate_short_id(6)
            if not is_alias_taken(short_id):
                break
    
    cursor.execute(f'INSERT INTO url_mapping (short_id, original_url) VALUES (\"{short_id}\", \"{original_url}\")')
    db.commit()
    return jsonify({'shortened_url': f"http://127.0.0.1:5000/{short_id}"}), 200

@app.route('/<short_id>', methods=['GET'])
def redirect_to_original(short_id):
    cursor.execute(f"SELECT original_url FROM url_mapping WHERE short_id = \"{short_id}\"")
    result = cursor.fetchone()
    if result:
        return redirect(result[0])
    else:
        return "URL not found", 404

if __name__ == '__main__':
    app.run(debug=True)