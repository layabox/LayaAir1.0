package laya.webgl.text 
{
	/**
	 * ...
	 * @author rivetr
	 */
	public interface ICharSegment 
	{
		function textToSpit( str : String ) : void;
		function getChar( i : int ) : String;
		function getCharCode( i:int ) : int;
		function length() : int;
	}

}