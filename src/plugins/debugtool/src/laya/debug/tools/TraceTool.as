///////////////////////////////////////////////////////////
//  TraceTool.as
//  Macromedia ActionScript Implementation of the Class TraceTool
//  Created on:      2015-9-25 上午10:48:54
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.utils.Browser;
	import laya.debug.DebugTool;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-9-25 上午10:48:54
	 */
	public class TraceTool
	{
		public function TraceTool()
		{
		}
		public static function closeAllLog():void
		{
			var logFun:Function;
			logFun = emptyLog;
			Browser.window.console.log = logFun;
		}
		public static function emptyLog():void
		{
			
		}
		public static var tempArr:Array=[];
		/**
		 * 打印obj 
		 * @param obj
		 */
		public static function traceObj(obj:Object):String
		{
			tempArr.length = 0;
			var key:String;
			for(key in obj)
			{
				tempArr.push(key+":"+obj[key]);
				//trace(key+":"+obj[key]);
			}
			var rst:String;
			rst = tempArr.join("\n");
			trace(rst);
			return rst;
		}
		public static function traceObjR(obj:Object):String
		{
			tempArr.length = 0;
			var key:String;
			for(key in obj)
			{
				tempArr.push(obj[key]+":"+key);
				//trace(key+":"+obj[key]);
			}
			var rst:String;
			rst = tempArr.join("\n");
			trace(rst);
			return rst;
		}
		public static function traceSize(tar:Object):void
		{
			DebugTool.dTrace("Size: x:"+tar.x+" y:"+tar.y+" w:"+tar.width+" h:"+tar.height+" scaleX:"+tar.scaleX+" scaleY:"+tar.scaleY);
		}
		public static function traceSplit(msg:String):void
		{
			trace("---------------------"+msg+"---------------------------");
		}
		public static function group(gName:*):void
		{
			__JS__("console.group(gName);");
		}
		public static function groupEnd():void
		{
			__JS__("console.groupEnd();");
		}
		/**
		 *  在js中可打印调用堆栈 
		 * @param life 打印堆栈的深度
		 */
		public static function getCallStack(life:int=1,s:int=1):String
		{
			//return;
			/*[IF-FLASH]*/return "";
			var caller:*;
			caller=getCallStack;
			caller=caller.caller.caller;
			var msg:String;
			msg="";
			while(caller&&life>0)
			{
				if(s<=0)
				{
					msg += caller + "<-";
					life--;
				}else
				{
					
				}
				caller = caller.caller;
				s--;
			}
			return msg;
		}
		public static var Erroer:Object = null;
		public static function getCallLoc(index:int=2):String
		{
			var loc:String;
			try {
				Erroer.i++;
			} catch (e:*) {
				var arr:Array;
				arr = e.stack.replace(/Error\n/).split(/\n/);
				if (arr[index])
				{
					loc= arr[index].replace(/^\s+|\s+$/, "");
				}else
				{
					loc = "unknow";
				}
				// loc= e.stack.replace(/Error\n/).split(/\n/)[index].replace(/^\s+|\s+$/, "");
			}
			return loc;
		}
		public static function traceCallStack():String
		{
			var loc:String;
			try {
				Erroer.i++;
			} catch (e:*) {
				 loc= e.stack;
			}
			
			trace(loc);
			return loc;
		}
		private static var holderDic:Object={};
		public static function getPlaceHolder(len:int):String
		{
			if(!holderDic.hasOwnProperty(len))
			{
				var rst:String;
				rst="";
				var i:int;
				for(i=0;i<len;i++)
				{
					rst+="-";
				}		
				holderDic[len]=rst;
			}		
			return holderDic[len];
		}
		public static function traceTree(tar:Node,depth:int=0,isFirst:Boolean=true):void
		{
			if(isFirst)
			{
				trace("traceTree");
			}
			if(!tar) return;
			var i:int;
			var len:int;
			//trace(getPlaceHolder(depth*2)+"->",tar);
			if(tar.numChildren<1)
			{
				trace(tar);
				return;
			}
			group(tar);
			len=tar.numChildren;
			depth++;
			for(i=0;i<len;i++)
			{
				traceTree(tar.getChildAt(i),depth,false);
			}
			groupEnd();
		}
		public static function getClassName(tar:Object):String
		{
			return tar["constructor"].name;
		}
		public static function traceSpriteInfo(tar:Sprite,showBounds:Boolean=true,showSize:Boolean=true,showTree:Boolean=true):void
		{
			if(!(tar is Sprite)) 
			{
				trace("not Sprite");
				return;
			}
			if(!tar) 
			{
				trace("null Sprite");
				return;
			}
			traceSplit("traceSpriteInfo");
//			trace("Sprite:"+tar.name);
			DebugTool.dTrace(TraceTool.getClassName(tar)+":"+tar.name);
			if(showTree)
			{
				traceTree(tar);
			}else
			{
				trace(tar);
			}
//			trace(tar);
//			traceTree(tar);
			if(showSize)
			{
				traceSize(tar);
			}
			if(showBounds)
			{
				trace("bounds:"+tar.getBounds());
			}
		}
	}
}