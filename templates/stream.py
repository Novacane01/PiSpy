from os import path

def create_template(stream_port):
	if not path.exists('./templates/stream.html'):
		with open('./templates/stream.html', 'w') as file:
			html = """<html>
        <head>
        <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=yes, viewport-fit=cover">
        <link rel="stylesheet" href="resource://content-accessible/ImageDocument.css">
        <link rel="stylesheet" href="resource://content-accessible/TopLevelImageDocument.css">
        <title>PiSpy Camera Stream</title></head>
        <body>
                <img src="http://24.250.168.190:{}/" alt="Stream" width= 100% height=100%>
      	</body>
</html>""".format(stream_port)
			file.write(html)
