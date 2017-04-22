package laya.debug.tools 
{
	import laya.display.Text;
	/**
	 * ...
	 * @author ww
	 */
	public class DebugTxt 
	{
		
		public function DebugTxt() 
		{
			
		}
		public static var _txt:Text;
		public static var I:DebugTxt;
		public static function init():void
		{
			if (_txt) return;
			_txt = new Text();
			_txt.pos(100, 100);
			_txt.color = "#ff00ff";
			_txt.zOrder = 999;
			_txt.fontSize = 24;
			_txt.text = "debugTxt inited";
			Laya.stage.addChild(_txt);
		}
		public static function getArgArr(arg:Array):Array
		{
			var rst:Array;
			rst=[];
			var i:int,len:int=arg.length;
			
			for(i=0;i<len;i++)
			{
				rst.push(arg[i]);
			}
			return rst;
		}
		public static function dTrace(...arg):void
		{
			arg=getArgArr(arg);
			//arg.push(TraceTool.getCallLoc(2));
			//__JS__("console.log.apply(console,arg)");
			var str:String;
			str=arg.join(" ");
			if (_txt)
			{
				_txt.text = str + "\n" + _txt.text;
			}
		}
		private static function getTimeStr():String
		{
			var dateO:*= __JS__("new Date()");
			return dateO.toTimeString();
		}
		public static function traceTime(msg:String):void
		{
			dTrace(getTimeStr());
			dTrace(msg);
		}
		public static function show(...arg):void
		{
			arg=getArgArr(arg);
			//arg.push(TraceTool.getCallLoc(2));
			//__JS__("console.log.apply(console,arg)");
			var str:String;
			str=arg.join(" ");
			if (_txt)
			{
				_txt.text = str;
			}
		}
	}

}