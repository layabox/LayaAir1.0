///////////////////////////////////////////////////////////
//  DifferTool.as
//  Macromedia ActionScript Implementation of the Class DifferTool
//  Created on:      2015-10-23 上午10:41:50
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 本类用于显示对象值变化过程
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-23 上午10:41:50
	 */
	public class DifferTool
	{
		public function DifferTool(sign:String="",autoTrace:Boolean=true)
		{
		     this.sign=sign;
			 this.autoTrace=autoTrace;
		}
		public var autoTrace:Boolean=true;
		public var sign:String="";
		public var obj:Object;
		public function update(data:Object,msg:String=null):Object
		{
			if(msg)
			{
				trace(msg);
			}
			var tObj:Object=ObjectTools.copyObj(data);
			if(!obj) obj={};
			var rst:Object;
			rst=ObjectTools.differ(obj,tObj);
			obj=tObj;
			if(autoTrace)
			{
				trace(sign+" differ:");
				ObjectTools.traceDifferObj(rst);
			}
			return rst;
		}
		
		
		private static var _differO:Object={};
		public static function differ(sign:String,data:Object,msg:String=null):Object
		{
			if(!_differO[sign]) _differO[sign]=new DifferTool(sign,true);
			var tDiffer:DifferTool;
			tDiffer=_differO[sign];
			return tDiffer.update(data,msg);
			
		}
	}
}