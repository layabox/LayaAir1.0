///////////////////////////////////////////////////////////
//  Watch.as
//  Macromedia ActionScript Implementation of the Class Watch
//  Created on:      2015-10-26 上午9:48:18
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.exp
{
	
	/**
	 * 本类调用原生watch接口，仅火狐有效
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-26 上午9:48:18
	 */
	public class Watch
	{
		public function Watch()
		{
		}
		public static function watch(obj:Object,name:String,callBack:Function):void
		{
			__JS__("obj.watch(name,callBack)");
		}
		public static function unwatch(obj:Object,name:String,callBack:Function):void
		{
			__JS__("obj.unwatch(name,callBack)");
		}
	}
}