from flask import Flask
from flask import render_template

app = Flask(__name__)


@app.route('/')
@app.route('/index.html')
def main():
    return render_template('index.html')

@app.route('/header')
def header():
    return render_template('header.html')

if __name__ == '__main__':
    app.run()
