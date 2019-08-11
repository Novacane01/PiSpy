import firebase_admin
from firebase_admin import credentials
from firebase_admin import messaging

cred = credentials.Certificate('/home/pi/Programming/pi_cam/.service.json')
app = firebase_admin.initialize_app(cred)

registration_token = 'eybAvYpSuUA:APA91bHUiQn04wMtC9cs9nwYe3CvHP42U4Ln9KVCyvJsRnBPPMw0leQU439b8fhGsemDcGFLSEmlVa6KHPL3Qlj8yTxl95RI5OTLwYC_G7Et7dehHjsXzwEQwiqGe7ULrsQ7qOs6tLgm'

message = messaging.Message(
	notification=messaging.Notification(
		title='Pi Spy',
		body='Movement has been detected on your camera!',
	),
	token=registration_token
)

response = messaging.send(message)

print('Successfully sent message:', response)
