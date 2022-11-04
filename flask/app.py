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

@app.route('/kinematics')
def kinematics():
    return render_template('kinematics.html')

@app.route('/kinematics/basicsOfSi')
def basicsOfSi():
    return render_template('kinematics/basicsOfSi.html')

@app.route('/kinematics/pathAndMovement')
def pathAndMovement():
    return render_template('kinematics/pathAndMovement.html')

@app.route('/kinematics/averageSpeed')
def averageSpeed():
    return render_template('kinematics/averageSpeed.html')

@app.route('/kinematics/equidistantStraightMovement')
def equidistantStraightMovement():
    return render_template('kinematics/equidistantStraightMovement.html')

if __name__ == '__main__':
    app.run()
