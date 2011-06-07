import neko.net.Socket;
import neko.net.Host;
import neko.vm.Thread;
import haxe.io.Eof;

class Server
{
	var client:ChapaClient;

	public function new():Void
	{
		Thread.create(server);
	}

	public function majClient(c:ChapaClient):Void
	{
		client = c;
	}

	private function listen(socket:Socket):Void
	{
		while(true)
		{
			try
			{
				treatRequest(socket,socket.input.readUntil(0));
			}
			catch(ex:Eof)
			{
				break;
			}
		}
		socket.close();
	}

	private function treatRequest(socket:Socket,message:String):Void
	{
		trace(message);
		var donneesXML:Xml = Xml.parse(message).firstElement();
		switch(donneesXML.nodeName)
		{
			case 'speak':
				client.speak(donneesXML.firstChild().nodeValue);
				sendRequest(socket,'<speaked/>');
			case 'warp':
				client.warp(Std.string(donneesXML.get('room')),Std.parseInt(donneesXML.get('x')),Std.parseInt(donneesXML.get('y')));
				sendRequest(socket,'<warped/>');
		}
	}

	private function sendRequest(socket:Socket,message:String):Void
	{
		socket.write(message+String.fromCharCode(0));
		trace('Sended : '+message);
	}

	private function server():Void
	{
		var s = new Socket();
		s.bind(new Host("0.0.0.0"),27850);
		s.listen(1);
		trace("Démarrage du serveur");
		while(true)
		{
			var c:Socket = s.accept();
			trace("Client connecté...");
			Thread.create(callback(listen, c));
		}
	}
}
