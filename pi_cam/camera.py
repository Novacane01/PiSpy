from picamera import PiCamera
from time import sleep, time
from datetime import datetime
import os

"""runtime = time() + 10
camera = PiCamera()
camera.resolution = (1080,720)
camera.start_preview()
#camera.start_recording('/home/pi/Pictures/PiPictures/myVIdeo.h264')
while(time()<runtime):
    camera.annotate_text = "{}".format(datetime.now())
#camera.stop_recording()
camera.stop_preview()"""
images = []
for root,dirs,files in os.walk('/var/lib/motion'):
	for file in files:
		if 'img' in file:
			images.append(file)
print(images)
