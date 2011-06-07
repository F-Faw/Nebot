class Tiz
{
	var pseudo:String;
	var ad:String;
	var mid:Int;
	var at:Int;

	public function new(pseudo:String,ad:String,mid:Int,at:Int):Void
	{
		this.pseudo = pseudo;
		this.ad = ad;
		this.mid = mid;
		this.at = at;
	}

	public function getPseudo():String
	{
		return pseudo;
	}
}
