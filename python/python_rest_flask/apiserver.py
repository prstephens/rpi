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

class TorOn(Resource):
    def get(self):
	call('/home/pi/scripts/deep')
        return {'message': 'tor turned on'}        

api.add_resource(TimemachineOn, '/api/timemachine/on') # Route_1
api.add_resource(TorOn, '/api/tor/on') # Route_2

if __name__ == '__main__':
     app.run(host='25.56.128.186',port='5002')
