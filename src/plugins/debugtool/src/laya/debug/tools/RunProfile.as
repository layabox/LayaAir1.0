///////////////////////////////////////////////////////////
//  CreateProfile.as
//  Macromedia ActionScript Implementation of the Class CreateProfile
//  Created on:      2015-9-25 下午3:31:46
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.utils.Browser;
	
	/**
	 * 类实例创建分析工具
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-9-25 下午3:31:46
	 */
	public class RunProfile
	{
		public function RunProfile()
		{
		}
		private static var infoDic:Object={};
		public static function run(funName:String,callLen:int=3):void
		{
			var tCount:CountTool;
			if(!infoDic.hasOwnProperty(funName))
			{
				infoDic[funName]=new CountTool();
			}
			tCount=infoDic[funName];
			var msg:String;
			msg=TraceTool.getCallLoc(callLen)+"\n"+TraceTool.getCallStack(1,callLen-3);
			tCount.add(msg);
			if(_runShowDic[funName])
			{
				trace("Create:"+funName);
				trace(msg);
			}
		}
		
		private static var _runShowDic:Object={};
		public static function showClassCreate(funName:String):void
		{
		        _runShowDic[funName]=true;	
		}
		public static function hideClassCreate(funName:String):void
		{
			_runShowDic[funName]=false;	
		}
		public static function getRunInfo(funName:String):CountTool
		{
			var rst:CountTool;
			rst=infoDic[funName];
			if(rst)
			{
				//rst.traceSelfR();
			}
			return infoDic[funName];
		}
		public static function runTest(fun:Function,count:int,sign:String="runTest"):void
		{
			DTrace.timeStart(sign);
			var i:int;
			for(i=0;i<count;i++)
			{
				fun();
			}
			DTrace.timeEnd(sign);
		}
		
		public static function runTest2(fun:Function,count:int,sign:String="runTest"):int
		{
			var preTime:Number;
			preTime = Browser.now();
			var i:int;
			for(i=0;i<count;i++)
			{
				fun();
			}
			return Browser.now() - preTime;
		}
	}
}