package laya.debug.tools.enginehook 
{
	import laya.utils.Browser;
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.CountTool;
	import laya.debug.tools.hook.FunHook;
	/**
	 * ...
	 * @author ww
	 */
	public class FunctionTimeHook 
	{
		public static var HookID:int=1;
		public function FunctionTimeHook() 
		{
			
		}
		public static function hookFun(obj:Object, funName:String):void
		{
			if (!obj) return;
			if (obj.timeHooked) return;
			var myKey:String;
			HookID++;
			myKey = ClassTool.getNodeClassAndName(obj)+"."+funName+"():"+HookID;
			var timePreFun:Function = function(...args):void
			{
				funBegin(myKey);
			}
			var timeEndFun:Function = function(...args):void
			{
				funEnd(myKey);
			}
			obj.timeHooked = true;
			FunHook.hook(obj, funName, timePreFun, timeEndFun);
		}
		public static var counter:CountTool = new CountTool();
		public static var funPre:Object = { };
		public static function funBegin(funKey:String):void
		{
			funPre[funKey] = Browser.now();
		}
		public static function funEnd(funKey:String):void
		{
			if (!funPre[funKey]) funPre[funKey] = 0;
			counter.add(funKey, Browser.now() - funPre[funKey]);		
		}
		public static const TotalSign:String = "TotalSign";
		public static function fresh():void
		{
			funEnd(TotalSign);
			counter.record();
			funBegin(TotalSign);
		}
	}

}