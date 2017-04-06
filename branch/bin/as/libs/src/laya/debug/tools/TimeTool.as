package laya.debug.tools 
{
	import laya.utils.Browser;
	import laya.utils.Timer;

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
		
		
		
		public static function runAllCallLater():void
		{
			var timer:Timer;
			timer=Laya.timer;
			//处理callLater
			var laters:Array = timer["_laters"];
			for (var i:int = 0, n:int = laters.length - 1; i <= n; i++) {
				var handler:* = laters[i];
				handler.method !== null && handler.run(false);
				timer["_recoverHandler"](handler);
				i === n && (n = laters.length - 1);
			}
			laters.length = 0;
		}
		
	}

}