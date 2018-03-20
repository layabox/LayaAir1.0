///////////////////////////////////////////////////////////
//  Watcher.as
//  Macromedia ActionScript Implementation of the Class Watcher
//  Created on:      2015-10-23 下午4:18:27
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.debug.tools.hook.FunHook;
	import laya.debug.tools.hook.VarHook;
	
	/**
	 * 本类用于监控对象值变化
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-23 下午4:18:27
	 */
	public class Watcher
	{
		public function Watcher()
		{
		}
		public static function watch(obj:Object,name:String,funs:Array):void
		{
			VarHook.hookVar(obj,name,funs);
		}
		public static function traceChange(obj:Object,name:String,sign:String="var changed:"):void
		{
			VarHook.hookVar(obj,name,[getTraceValueFun(name),VarHook.getLocFun(sign)]);
		}
		public static function debugChange(obj:Object,name:String):void
		{
			VarHook.hookVar(obj,name,[VarHook.getLocFun("debug loc"),FunHook.debugHere]);
		}
		public static function differChange(obj:Object,name:String,sign:String,msg:String=""):void
		{
			VarHook.hookVar(obj,name,[getDifferFun(obj,name,sign,msg)]);
		}
		public static function getDifferFun(obj:Object,name:String,sign:String,msg:String=""):Function
		{
			var rst:Function;
			
			rst=function():void
			{
				DifferTool.differ(sign,obj[name],msg);
			}
			return rst;
		}
		public static function traceValue(value:*):void
		{
			trace("value:",value);
		}
		public static function getTraceValueFun(name:String):Function
		{
			var rst:Function;
			
			rst=function(value:*):void
			{
				trace("set "+name+" :",value);
			}
			return rst;
		}
	}
}