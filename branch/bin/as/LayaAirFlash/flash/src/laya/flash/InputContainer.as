/*[IF-FLASH]*/
package laya.flash 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * @author Survivor
	 */
	public class InputContainer extends FlashElement 
	{
		public function InputContainer() 
		{
			super();
		}
		
		override public function createDisplayObject():DisplayObject
		{
			return new Sprite();
		}
		
		public function setPos(x:int, y:int):void
		{
			_displayObject.x = x;
			_displayObject.y = y;
		}	
	}
}