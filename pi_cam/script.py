from subprocess import Popen, PIPE
import re
import requests
import json


def submit_info():
	url = 'https://pi-spy.herokuapp.com/assign-camera'
	p = Popen(['ifconfig','wlan0'],stdin=PIPE, stdout=PIPE, stderr=PIPE)
	output = p.communicate()
	pattern = re.compile("(?<=ether )\S+|(?<=inet )\S+")
	data = re.findall(pattern,str(output))
	r = requests.get(url = url, params = {'ip':data[0],'mac':data[1]})
	print(r.json())
	with open('./settings.json', 'w') as file:
		file.write(json.dumps(r.json(), file, ensure_ascii=False, indent=4))

submit_info()
