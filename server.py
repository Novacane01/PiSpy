from flask import Flask, send_file, render_template, jsonify
import json
import subprocess
import os

motion_folder = '/var/lib/motion'
port = 7070
is_camera_enabled = False

app = Flask(__name__)


@app.route('/')
def hello():
	return 'App is running'

@app.route('/stream')
def render_stream():
	return render_template('stream.html')

@app.route('/status', methods=['GET'])
def get_camera_status():
	return json.dumps(is_camera_enabled)

@app.route('/files/<path:path>', methods =['GET'])
def get_file(path):
	exists = os.path.isfile(motion_folder+'/'+path)
	return (send_file(motion_folder+'/'+path),200) if exists else ('File not found',404)

@app.route('/camera/enable',methods=['POST'])
def enable_camera():
	global is_camera_enabled
	disable_camera()
	p = subprocess.run(['sudo','systemctl','start' ,'motion'])
	if p.returncode < 0:
		raise Exception('Unable to start motion')
	is_camera_enabled = True
	return '', 201

@app.route('/camera/disable',methods=['POST'])
def disable_camera():
	global is_camera_enabled
	p = subprocess.run(['sudo', 'systemctl', 'stop', 'motion'])
	if p.returncode < 0:
                raise Exception('Unable to stop motion')
	is_camera_enabled = False
	return '', 201

@app.route('/file-names',methods=['GET'])
def get_file_names():
	eventCodes = []
	temp = {}
	for root,dirs,files in os.walk(motion_folder):
		for file in files:
			if file.endswith('.jpg'):
				eventCode = file.split('_')[1].replace('.jpg','')
				temp[eventCode] = True
				print(eventCode)
			if file.endswith('.mp4'):
				eventCode = file.split('_')[1].replace('.mp4','')
				print(eventCode)
				if eventCode in temp:
					eventCodes.append(eventCode)
	return jsonify(eventCodes),200


@app.route('/camera/files',methods=['DELETE'])
def deleteFiles():
	p = subprocess.run(['sudo', 'rm', '-rf', '/var/lib/motion/*'])
	if p.returncode < 0:
                raise Exception('Unable to delete files')
	return '', 204

@app.route('/camera/files/<file_name>',methods=['DELETE'])
def deleteFile(file_name):
	p = subprocess.run(['sudo', 'rm', '-f', motion_folder+'/'+file_name])
	if p.returncode < 0:
                raise Exception('Unable to delete file')
	return '', 204

if __name__ == '__main__':
	print('Now listening on port {}'.format(port))
	app.run(port=port, host = '0.0.0.0', threaded=True)
