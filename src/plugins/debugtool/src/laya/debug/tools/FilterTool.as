///////////////////////////////////////////////////////////
//  FilterTool.as
//  Macromedia ActionScript Implementation of the Class FilterTool
//  Created on:      2015-10-30 下午1:06:56
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-30 下午1:06:56
	 */
	public class FilterTool
	{
		public function FilterTool()
		{
		}
		public static function getArrByFilter(arr:Array,filterFun:Function):Array
		{
			var i:int,len:int=arr.length;
			var rst:Array=[];
			for(i=0;i<len;i++)
			{
				if(filterFun(arr[i])) rst.push(arr[i]);
			}
			return rst;
		}
		
		public static function getArr(arr:Array,sign:String,value:*):Array
		{
			var i:int,len:int=arr.length;
			var rst:Array=[];
			for(i=0;i<len;i++)
			{
				if(arr[i][sign]==value) rst.push(arr[i]);
			}
			return rst;
		}
		
	}
}