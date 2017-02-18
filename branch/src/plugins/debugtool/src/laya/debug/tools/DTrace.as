///////////////////////////////////////////////////////////
//  DTrace.as
//  Macromedia ActionScript Implementation of the Class DTrace
//  Created on:      2015-9-28 上午10:39:47
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-9-28 上午10:39:47
	 */
	public class DTrace
	{
		public function DTrace()
		{
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
			arg.push(TraceTool.getCallLoc(2));
			__JS__("console.log.apply(console,arg)");
			var str:String;
			str=arg.join(" ");
			
		}
		/**
		 * 开始计时 
		 * @param sign
		 */
		public static function timeStart(sign:String):void
		{
			__JS__("console.time(sign);");
		}
		/**
		 * 结束计时 
		 * @param sign
		 */
		public static function timeEnd(sign:String):void
		{
			__JS__("console.timeEnd(sign);");
		}
		public static function traceTable(data:Array):void
		{
			__JS__("console.table(data);");
		}
	}
}