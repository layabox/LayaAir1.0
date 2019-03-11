package laya.layagl 
{
	import laya.display.Graphics;
	import laya.layagl.LayaGL;
	/**
	 * ...
	 * @author ww
	 */
	public class ConchGraphicsAdpt 
	{
		public var _commandEncoder:*;
		
		//TODO:coverage
		public function ConchGraphicsAdpt() 
		{
			
		}
		
		//TODO:coverage
		public function _createData():void
		{
			_commandEncoder = LayaGL.instance.createCommandEncoder(128, 64, true);
		}
		
		//TODO:coverage
		public function _clearData():void
		{
			if (_commandEncoder)_commandEncoder.clearEncoding();
		}
		
		//TODO:coverage
		public function _destroyData():void
		{
			if (_commandEncoder)
			{
				_commandEncoder.clearEncoding();
				_commandEncoder = null;
			}
		}
		
		//TODO:coverage
		public static function __init__():void
		{
			var spP:* = Graphics["prototype"];
			var mP:*= ConchGraphicsAdpt["prototype"];
			var funs:Array = [
			"_createData",
			"_clearData",
			"_destroyData"
			];
			var i:int, len:int;
			len = funs.length;
			var tFunName:String;
			for (i = 0; i < len; i++)
			{
				tFunName = funs[i];
				spP[tFunName] = mP[tFunName];
			}
		}
	}

}