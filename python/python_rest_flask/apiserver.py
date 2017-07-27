#!/usr/bin/env python
from flask import Flask, request
from flask_restful import Resource, Api
from json import dumps
from flask_jsonpify import jsonify
from subprocess import call

app = Flask(__name__)
api = Api(app)

class TimemachineOn(Resource):
    def get(self):
	call('/home/pi/scripts/wol')
        return {'message': 'wol requested'}        

api.add_resource(TimemachineOn, '/api/timemachine/on') # Route_1

if __name__ == '__main__':
     app.run(host='25.56.128.186',port='5002')
