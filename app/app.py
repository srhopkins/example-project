from flask import Flask
from flask import json


app = Flask(__name__)


@app.route('/')
def version():
    with app.open_resource('version.json') as f:
        data = json.load(f)

    response = app.response_class(
        response=json.dumps(data),
        status=200,
        mimetype='application/json'
    )
    return response
