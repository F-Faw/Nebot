import neko.net.Socket;
import neko.net.Host;
import haxe.io.Eof;
import haxe.Md5;

class Chapatiz
{
	var ip:String;
	var port:Int;
	public function new():Void
	{
		trace('Chapatiz.hx chargé');
		ip = 'www.chapatiz.com';
		port = 80;
	}

	public function httpConnexion():Array<String>
	{
		var email:String = getEmail();
		var password:String = getPassword();
		var cookie:String = getConnexion(email,password);
		var kc:String = getKc(cookie);
		return [cookie, Md5.encode(cookie+"naz"+kc)];
	}

	private function getEmail():String
	{
		var fileContent:String = neko.io.File.getContent('./config.txt');
		var informations:Array<String> = fileContent.split("\n");
		return informations[0];
	}

	private function getPassword():String
	{
		var fileContent:String = neko.io.File.getContent('./config.txt');
		var informations:Array<String> = fileContent.split("\n");
		return informations[1];
	}

	private function getConnexion(email:String,password:String):String
	{
		var socket:Socket = new Socket();
		socket.connect(new Host(ip),port);
		var vars:String = 'username=' + Std.string(email) + '&password=' + Std.string(password) +'&redirect=&validate=Connexion';
		var reqhttp:String = "POST /login/ HTTP/1.1\r\n";
		reqhttp+= "Host: www.chapatiz.com\r\n";
		reqhttp+= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fr; rv:1.9.1.2) Gecko/20090729 Firefox/3.0.11 jA (.NET CLR 3.5.30729)\r\n";
		reqhttp+= "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n";
		reqhttp+= "Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3\r\n";
		reqhttp+= "Accept-Encoding: gzip,deflate\r\n";
		reqhttp+= "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n";
		reqhttp+= "Keep-Alive: 300\r\n";
		reqhttp+= "Connection: keep-alive\r\n";
		reqhttp+= "Referer: http://www.chapatiz.com/login/\r\n";
		reqhttp+= "Cookie: nocookie=true;\r\n";
		reqhttp+= "Content-Type: application/x-www-form-urlencoded\r\n";
		reqhttp+= "Content-Length: " + Std.string(vars.length) + "\r\n";
		reqhttp+= "\r\n" + Std.string(vars) + "\r\n";
		socket.write(reqhttp);
		var answer:String = '';
		while(true)
		{
			try
			{
				answer += socket.input.readLine();
			}
			catch(ex:Eof)
			{
				break;
			}
		}
		return (answer.split("chapatiz_portal=")[1]).split(";")[0];
	}

	private function getKc(cookie:String):String
	{
		var socket:Socket = new Socket();
		socket.connect(new Host(ip),port);
		var reqhttp:String = "POST /tchat/ HTTP/1.1\r\n";
		reqhttp+= "Host: www.chapatiz.com\r\n";
		reqhttp+= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; fr; rv:1.9.1.2) Gecko/20090729 Firefox/3.0.11 jA (.NET CLR 3.5.30729)\r\n";
		reqhttp+= "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n";
		reqhttp+= "Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3\r\n";
		reqhttp+= "Accept-Encoding: gzip,deflate\r\n";
		reqhttp+= "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n";
		reqhttp+= "Keep-Alive: 300\r\n";
		reqhttp+= "Referer: http://www.chapatiz.com/login/\r\n";
		reqhttp+= "Cookie: chapatiz_portal=" +Std.string(cookie)+ ";\r\n";
		reqhttp+= "Content-Type: application/x-www-form-urlencoded\r\n";
		reqhttp+= "Content-Length: 0\r\n\r\n";
		socket.write(reqhttp);
		var answer:String = '';
		while(true)
		{
			try
			{
				answer += socket.input.readLine();
			}
			catch(ex:Eof)
			{
				break;
			}
		}
		return (answer.split("flashvars.kc = '")[1]).split("';")[0];
	}
}
