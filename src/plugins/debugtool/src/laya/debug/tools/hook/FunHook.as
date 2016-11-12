///////////////////////////////////////////////////////////
//  FunHook.as
//  Macromedia ActionScript Implementation of the Class FunHook
//  Created on:      2015-10-23 下午1:13:13
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.hook
{
	
	
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.TraceTool;
	
	/**
	 * 本类用于在对象的函数上挂钩子
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-23 下午1:13:13
	 */
	public class FunHook
	{
		public function FunHook()
		{
		}
		public static function hook(obj:Object,funName:String,preFun:Function=null,aftFun:Function=null):void
		{
			hookFuns(obj,funName,[preFun,obj[funName],aftFun],1);
		}
		public static var special:Object = {
			"length":true,
			"name":true,
			"arguments":true,
			"caller":true,
			"prototype":true,
			//"keys":true,
			//"create":true,
			//"defineProperty":true,
			////"defineProperties":true,
			//"getPrototypeOf":true,
			//"setPrototypeOf":true,
			//"getOwnPropertyDescriptor":true,
			//"getOwnPropertyNames":true,
			"is":true,
			"isExtensible":true,
			"isFrozen":true,
			"isSealed":true,
			"preventExtensions":true,
			"seal":true,
			//"getOwnPropertySymbols":true,
			//"deliverChangeRecords":true,
			//"getNotifier":true,
			//"observe":true,
			"unobserve":true,
			"apply":true,
			"call":true,
			"bind":true,
			"freeze":true,
			//"assign":true,
			"unobserve":true
			};
		public static function hookAllFun(obj:Object):void
		{
			var key:String;
			var arr:Array;
			arr=ClassTool.getOwnPropertyNames(obj);
			for(key in arr)
			{
				key = arr[key];
				if (special[key]) continue;
				trace("try hook:",key);
				if(obj[key] is Function)
				{
					trace("hook:",key);
					hookFuns(obj, key, [getTraceMsg("call:" + key), obj[key]], 1);
				}
			}
			if(obj["__proto__"])
			{
				hookAllFun(obj["__proto__"]);
			}else
			{
				trace("end:",obj);
			}
		}
		private static function getTraceMsg(msg:String):Function
		{
		   var rst:Function;
		   rst=function():void
		   {
			   trace(msg);
		   }
		   return rst;
		}
		public static function hookFuns(obj:Object,funName:String,funList:Array,rstI:int=-1):void
		{
			var _preFun:Function=obj[funName];
			var newFun:Function;
			
			newFun=function(...args):*
			{
	
				var rst:*;
				var i:int;
				var len:int;
				len=funList.length;
				for(i=0;i<len;i++)
				{
					if(!funList[i]) continue;
					if(i==rstI)
					{
						rst=funList[i].apply(this,args);
					}else
					{
						funList[i].apply(this,args);
					}
				}

				return rst;
			};
			newFun["pre"]=_preFun;
			obj[funName]=newFun;
		}
		public static function removeHook(obj:Object,funName:String):void
		{
			if(obj[funName].pre!=null)
			{
				obj[funName]=obj[funName].pre;
			}
			
		}
		public static function debugHere():void
		{
			__JS__("debugger;");

		}
		
		public static function traceLoc(level:int=0,msg:String=""):void
		{
			trace(msg,"fun loc:",TraceTool.getCallLoc(3+level));
		}
		
		public static function getLocFun(level:int=0,msg:String=""):Function
        {
			level += 1;

			var rst:Function;
			rst=function ():void
			{
				traceLoc(level,msg);
			}
			return rst;
		}		
	}
}