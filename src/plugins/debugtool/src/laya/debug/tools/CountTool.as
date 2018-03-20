///////////////////////////////////////////////////////////
//  CountTool.as
//  Macromedia ActionScript Implementation of the Class CountTool
//  Created on:      2015-9-24 下午6:37:56
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-9-24 下午6:37:56
	 */
	public class CountTool
	{
		public function CountTool()
		{
		}
		public var data:Object = { };
		public var preO:Object = { };
		public var changeO:Object = { };
		public var count:int;
		public function reset():void
		{
			data={};
			count=0;
		}
		public function add(name:String, num:int=1 ):void
		{
			count++;
			if(!data.hasOwnProperty(name))
			{
				data[name]=0;
			}
			data[name]=data[name]+num;
		}
		public function getKeyCount(key:String):int
		{
			if(!data.hasOwnProperty(key))
			{
				data[key]=0;
			}
			return data[key];
		}
		public function getKeyChange(key:String):int
		{
			if (!changeO[key]) return 0;
			return changeO[key];
		}
		public function record():void
		{
			var key:String;
			for (key in changeO)
			{
				changeO[key] = 0;
			}
			for (key in data)
			{
				if (!preO[key]) preO[key] = 0;
				changeO[key] = data[key] - preO[key];
				preO[key]=data[key]
			}
		}
		public function getCount(dataO:Object):int
		{
			var rst:int = 0;
			var key:String;
			for (key in dataO)
			{
				rst += dataO[key];
			}
			return rst;
		}
		public function traceSelf(dataO:Object=null):String
		{
			if (!dataO) dataO = data;
			var tCount:int;
			tCount = getCount(dataO);
			trace("total:"+tCount);
//			trace(data);
			return "total:"+tCount+"\n"+TraceTool.traceObj(dataO);
		}
		public function traceSelfR(dataO:Object=null):String
		{
			if (!dataO) dataO = data;
			var tCount:int;
			tCount = getCount(dataO);
			trace("total:"+tCount);
			//			trace(data);
			return "total:"+tCount+"\n"+TraceTool.traceObjR(dataO);
		}
	}
}