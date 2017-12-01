/*[IF-FLASH]*/package laya.flash {
	/**
	 * ...
	 * @author laya
	 */
	public dynamic class Document 
	{
		public var body:FlashBody= new FlashBody();
		
		public function Document() 
		{
			
		}
		
		public function __createElement(type:String):*
		{
			if (type == "canvas") return new FlashCanvas();
			if (type == "image" || type == "img") return new FlashImage();
			if (type == "input" || type == "textarea") return new FlashInput(type == "textarea");
			if (type == "div") return new InputContainer();
			return new FlashElement();
		}
		
		public function getElementById(id:String):Object
		{
			return {};
		}
		
		public function addEventListener(type:String,  listener:Function, useCapture:Boolean=false):void
		{
			FlashEvent.addEventListener(Window.stage,type,listener,useCapture);
		}
		
		public function removeEventListener(type:String,  listener:Function, useCapture:Boolean = false):void
		{
			FlashEvent.removeEventListener(Window.stage,type,listener,useCapture);
		}
	}

}