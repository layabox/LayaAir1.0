/*[IF-FLASH]*/package laya.flash {
	/**
	 * ...
	 * @author laya
	 */
	public dynamic class FlashStyle 
	{
		public var _ower:FlashElement;
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function FlashStyle(ower:FlashElement) 
		{
			_ower = ower;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get width():Number
		{
			return _width;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get height():Number
		{
			return _height;			
		}

	}

}