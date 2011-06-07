import neko.Sys;

import Client;
import Chapatiz;
import Tiz;

class ChapaClient extends Client
{
	static inline var IP = 'chat.chapatiz.com';
	static inline var PORT = 9299;
	var chapatiz:Chapatiz;
	var nbRequest:Int;
	var tizs:Hash<Tiz>;
	var tpInformations:Array<Int>;
	var currentRoom:String;

	public function new():Void
	{
		trace('ChapaClient.hx chargé');
		super(IP,PORT);
		chapatiz = new Chapatiz();
		tizs = new Hash();
		tpInformations = new Array();
		nbRequest = 0;
		newauth();
	}

	public function newauth():Void
	{
		try
		{
			var informations:Array<String> = chapatiz.httpConnexion();
			request('<newauth sid="'+informations[0]+'" k="'+informations[1]+'"/>');
		}
		catch(e:Dynamic)
		{
			trace('Erreur connexion Chapatiz');
		}
	}

	override function request(query:String):Void
	{
		super.request(query+Std.string(nbRequest));
		nbRequest++;
	}

	override function onRecept(query:Xml):Void
	{
		trace('<< '+ Std.string(query));
		treatRequest(query);
	}

	private function treatRequest(query:Xml):Void
	{
		switch(query.nodeName)
		{
			case 'user':
				var currentTiz:Tiz = new Tiz(query.get('p'),query.get('avatar_design'),Std.parseInt(query.get('mid')),Std.parseInt(query.get('attributes')));
				tizs.set(query.get('i'),currentTiz);
				playerJoin(currentTiz);
				request('<nopowers s="t" />');
				warp('central.hallofficials',600,850);
			case 'addusr':
				var currentTiz:Tiz = new Tiz(query.get('n'),query.get('ad'),Std.parseInt(query.get('mid')),Std.parseInt(query.get('at')));
				tizs.set(query.get('i'),currentTiz);
				playerJoin(currentTiz);
			case 'roomps':
				notify("Connecté à "+query.get('id'));
				for(child in query.elements())
				{
					if(child.nodeName == 'c')
					{
						var currentTiz:Tiz = new Tiz(child.get('n'),child.get('ad'),Std.parseInt(child.get('mid')),Std.parseInt(child.get('at')));
						tizs.set(child.get('i'),currentTiz);
						playerJoin(currentTiz);
					}
				}
			case 'remusr':
				try
				{
					playerLeft(query.get('i'));
				}
				catch(msg : String)
				{
					trace(msg);
				}
			case 'login':
				onLogin();

			case 'c':
				onTizSpeak(query.get('i'),StringTools.urlDecode(query.get('t')));
			case 'sendPing':
				request('<ping/>');
		}
	}

	private function playerJoin(player:Tiz):Void
	{
		notify(player.getPseudo()+" connecté dans la salle.");
	}

	private function playerLeft(id:String):Void
	{
		notify(tizs.get(id).getPseudo()+" déconnecté de la salle.");
		tizs.remove(id);
	}

	private function onLogin():Void
	{
		Sys.sleep(1);
		request('<ready x="'+Std.string(tpInformations[0])+'" y="'+Std.string(tpInformations[1])+'"/>');
	}

	private function onTizSpeak(id:String,message:String):Void
	{
	}

	public function warp(room:String,x:Int,y:Int):Void
	{
		tpInformations = [x,y];
		currentRoom = room;
		request('<login rid="'+room+'"/>');
	}

	public function speak(text:String):Void
	{
		request('<c t="'+StringTools.urlEncode(text)+'"/>');
	}

	public function getCoords():Array<Int>
	{
		return tpInformations;
	}

	public function getRoom():String
	{
		return currentRoom;
	}
}
