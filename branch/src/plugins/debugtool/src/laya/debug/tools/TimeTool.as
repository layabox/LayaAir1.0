package laya.debug.tools 
{
	import laya.utils.Browser;
	/**
	 * ...
	 * @author ww
	 */
	public class TimeTool 
	{
		
		public function TimeTool() 
		{
			
		}
		
		private static var timeDic:Object = { };
		
		public static function getTime(sign:String,update:Boolean=true):Number
		{
			if (!timeDic[sign])
			{
				timeDic[sign] = 0;
			}
			var tTime:Number;
			tTime = Browser.now();
			var rst:Number;
			rst = tTime-timeDic[sign];
			timeDic[sign] = tTime;
			return rst;
		}
		
	}

}