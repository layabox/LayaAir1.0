///////////////////////////////////////////////////////////
//  Observer.as
//  Macromedia ActionScript Implementation of the Class Observer
//  Created on:      2015-10-26 上午9:35:45
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.exp
{
	import laya.debug.tools.DifferTool;
	
	/**
	 * 本类调用原生observe接口，仅支持部分浏览器，chrome有效
	 * 变化输出为异步方式,所以无法跟踪到是什么函数导致变化
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-26 上午9:35:45
	 */
	public class Observer
	{
		public function Observer()
		{
		}
		
		public static function observe(obj:Object,callBack:Function):void
		{
			__JS__("Object.observe(obj, callBack)");
		}
		public static function unobserve(obj:Object,callBack:Function):void
		{
			__JS__("Object.unobserve(obj, callBack)");
		}
		
		public static function observeDiffer(obj:Object,sign:String,msg:String="obDiffer"):void
		{
			var differFun:Function=function():void
			{
				DifferTool.differ(sign,obj,msg);
			}
			observe(obj,differFun);
		}
	}
}