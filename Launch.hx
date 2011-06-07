import neko.Sys;

class Launch
{
	static function main():Void
	{
		var server:Server = new Server();
		while(true)
		{
			trace("Lancement de Nebot en cours...");
			var c = new ChapaClient();
			server.majClient(c);
			c.start();
			Sys.sleep(5);
			trace('Tentative reconnexion de Nebot...');
		}
	}
}
