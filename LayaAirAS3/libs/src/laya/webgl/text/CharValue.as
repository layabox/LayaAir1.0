package laya.webgl.text 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CharValue {
	/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
	private static var _keymap:* = {};
	private static var _keymapCount:int = 1;
	
	public var txtID:Number;
	public var font:*;
	public var fillColor:String;
	public var borderColor:String;
	public var lineWidth:int;
	public var size:Number;
	public var scaleX:Number;
	public var scaleY:Number;
	
	public function value(font:*, fillColor:String, borderColor:String, lineWidth:int, size:Number, scaleX:Number, scaleY:Number):void {
		this.font = font;
		this.fillColor = fillColor;
		this.borderColor = borderColor;
		this.lineWidth = lineWidth;
		this.size = size;
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		var key:String = [font, scaleX, scaleY, lineWidth, fillColor, borderColor].join('`');
		this.txtID = _keymap[key]
		if (!this.txtID) {
			this.txtID = (++_keymapCount)*0.0000001;
			_keymap[key] = this.txtID;
		}
	}
}

}