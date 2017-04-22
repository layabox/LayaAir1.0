package laya.debug.tools 
{
	/**
	 * ...
	 * @author ww
	 */
	public class TouchDebugTools 
	{
		
		public function TouchDebugTools() 
		{
			
		}
		public static function getTouchIDs(events:Array):Array
		{
			var rst:Array;
			rst = [];
			var i:int, len:int;
			len = events.length;
			for (i = 0; i < len; i++)
			{
				rst.push(events[i].identifier||0);
			}
			return rst;
		}
		public static function traceTouchIDs(msg:String,events:Array):void
		{
			DebugTxt.dTrace(msg+":"+getTouchIDs(events).join(","));
		}
	}

}