/*[IF-FLASH]*/package laya.flash {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	/**
	 * ...
	 * @author laya
	 */
	public class FlashBody extends FlashElement 
	{
		public function FlashBody() 
		{
			super();
			width = clientWidth;
			height = clientHeight;
			_displayObject = Window.stage;
			//Window.stage.addChild(_displayObject);
		}
		
		public override function get clientWidth():int
		{
			//获取stage的属性
			return Window.stage.stageWidth;
		}
		
		public override function get clientHeight():int
		{
			return Window.stage.stageHeight;
		}
		
		public override function addEventListener(type:String,  listener:Function, useCapture:Boolean=false):void
		{
			FlashEvent.addEventListener(Window.stage,type,listener,useCapture);
		}
		
		public override function appendChild(e:*):void
		{
			e.parent = this;
			(_displayObject as Stage).addChild( (e as FlashElement).getDisplayObject());
		}
		
	}

}