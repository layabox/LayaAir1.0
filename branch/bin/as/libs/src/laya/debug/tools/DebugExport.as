///////////////////////////////////////////////////////////
//  DebugExport.as
//  Macromedia ActionScript Implementation of the Class DebugExport
//  Created on:      2015-10-31 下午3:35:16
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.utils.Browser;
	import laya.debug.DebugTool;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-31 下午3:35:16
	 */
	public class DebugExport
	{
		public function DebugExport()
		{
		}
		private static var _exportsDic:Object=
			{
				"DebugTool":DebugTool,
				"Watcher":Watcher
			};
		public static function export():void
		{
			var _window:*;
			__JS__("_window=window;");
			var key:String;
			for(key in _exportsDic)
			{
				_window[key]=_exportsDic[key];
			}
		}
	}
}