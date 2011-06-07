import neko.net.Socket;
import neko.net.Host;
import haxe.io.Eof;
import haxe.io.Error;

class Client
{
	private var socket:Socket;
	private var stopped:Bool;
	public function new(ip:String,port:Int):Void
	{
		trace('Client.hx chargé');
		socket = new Socket();
		stopped = false;
		try
		{
			socket.connect(new Host(ip),port);
			trace('Connecté à '+ip+':'+Std.string(port));
		}
		catch(e:Dynamic)
		{
			trace('Erreur de connexion à '+ip+':'+Std.string(port));
			stopped = true;
		}
	}

	public function start()
	{
		while (!stopped)
		{
			var node:String = null;
			try
			{
				node = socket.input.readUntil(0);
				onRecept(Xml.parse(node).firstElement());
			}
			catch(ex:Eof)
			{
				trace("Erreur de connexion");
				socket.close();
				break;
			}
			catch(ex:Dynamic)
			{
				trace("Malformated node : "+node);
			}
		}
	}

	private function onRecept(query:Xml):Void
	{
	}

	public function request(query:String):Void
	{
		try
		{
			socket.write(query+String.fromCharCode(0));
		}
		catch(e:Dynamic)
		{
			stopped = true;
		}
		//trace('>> '+query);
	}

	public function notify(message:String):Void
	{
		neko.Lib.println(message);
	}
}
