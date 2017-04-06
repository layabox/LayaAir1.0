/*[IF-FLASH]*/package laya.flash {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	/**
	 * ...
	 * @author laya
	 */
	public class FlashElement 
	{
		public var style:FlashStyle;
		public var scrollTop:int = 0;
		public var id: * ;
		public var parent:*;
		protected var _displayObject:DisplayObject;
		
		public function FlashElement() 
		{
			style = new FlashStyle(this);
			_displayObject = createDisplayObject();
		}
		
		public function appendChild(e:*):void
		{
			e.parent = this;
			(_displayObject as DisplayObjectContainer).addChild(e._displayObject);
		}
		
		public function createDisplayObject():DisplayObject
		{
			return null;
		}
		
		public function getDisplayObject():DisplayObject
		{
			return _displayObject;
		}
		
		public function contains(value:FlashElement):Boolean
		{
			return value.parent == this;
		}
		
		public function removeChild(e:*):void
		{
			(_displayObject as DisplayObjectContainer).removeChild(e._displayObject);
			e.parent = null;
		}
		
		public function get parentNode():*
		{
			return parent;
		}
		
		public function get parentElement():*
		{
			return parent;
		}
		
		public function addEventListener(type:String,  listener:Function, useCapture:Boolean=false):void
		{
			if (this is FlashCanvas) FlashEvent.addEventListener(Window.stage,type,listener,useCapture);
			else if(_displayObject) FlashEvent.addEventListener(_displayObject,type,listener,useCapture);
		}
		
		public function get clientWidth():int
		{
			return style.width;
		}
		
		public function get clientHeight():int
		{
			return style.height;
		}
		
		public function set width(value:Number):void
		{
			style.width = value;
			if(_displayObject) _displayObject.width = value;
		}
		
		public function get width():Number
		{
			return style.width;
		}

		public function set height(value:Number):void
		{
			style.height = value;
			if(_displayObject) _displayObject.height = value;
		}
		
		public function get height():Number
		{
			return style.height;
		}
		
		
	}

}