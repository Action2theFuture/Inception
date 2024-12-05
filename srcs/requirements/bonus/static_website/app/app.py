import redis
from flask import Flask, render_template, session
from flask_session import Session

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Redis 설정
app.config['SESSION_TYPE'] = 'redis'
app.config['SESSION_REDIS'] = redis.Redis(host='redis', port=6379)

# Flask-Session 초기화
Session(app)

@app.route('/')
def home():
    session['visitor'] = session.get('visitor', 0) + 1
    return render_template('index.html', visitor=session['visitor'])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
