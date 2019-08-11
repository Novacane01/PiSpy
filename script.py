from subprocess import Popen, PIPE
import re
import requests
import json
from os import path
from templates.stream import create_template

def submit_info():
	url = 'https://pi-spy.herokuapp.com/assign-camera'
	p = Popen(['ifconfig','wlan0'],stdin=PIPE, stdout=PIPE, stderr=PIPE)
	output = p.communicate()
	pattern = re.compile("(?<=ether )\S+|(?<=inet )\S+")
	data = re.findall(pattern,str(output))
	r = requests.get(url = url, params = {'ip':data[0],'mac':data[1]})
	with open('./settings.json', 'w') as file:
		file.write(json.dumps(r.json(), file, ensure_ascii=False, indent=4))

def tunnel_ports():
	if not path.exists('./settings.json'):
		submit_info()

	with open('./settings.json','r') as file:
		settings = json.load(file)
		create_template(settings['stream_port'])
		p = Popen(['sshpass','-p','password','ssh','-fNR', '*:{}:{}:7070'.format(settings['config_port'],settings['ip_address']),'server@192.168.0.33'])
		p = Popen(['sshpass','-p','password','ssh','-fNR', '*:{}:{}:8081'.format(settings['stream_port'],settings['ip_address']),'server@192.168.0.33'])
		p = Popen(['python', 'server.py'])

tunnel_ports()
