///////////////////////////////////////////////////////////
//  CallLaterTool.as
//  Macromedia ActionScript Implementation of the Class CallLaterTool
//  Created on:      2017-3-2 下午12:11:59
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.utils.Timer;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2017-3-2 下午12:11:59
	 */
	public class CallLaterTool
	{
		public function CallLaterTool()
		{
		}
		public static function initCallLaterRecorder():void
		{
			if(oldCallLater) return;
			oldCallLater=Laya.timer["callLater"];
			Laya.timer["callLater"]=CallLaterTool["prototype"]["callLater"];
		}
		
		private static var _recordedCallLaters:Array=[];
		private static var _isRecording:Boolean=false;
		public static function beginRecordCallLater():void
		{
			initCallLaterRecorder();
			_isRecording=true;
		}
		public static function runRecordedCallLaters():void
		{
			_isRecording=false;
			var timer:Timer;
			timer=Laya.timer;
			//处理callLater
			var laters:Array = timer["_laters"];
			laters=_recordedCallLaters;
			for (var i:int = 0, n:int = laters.length - 1; i <= n; i++) {
				var handler:* = laters[i];
				if(_recordedCallLaters.indexOf(handler)<0) continue;
				handler.method !== null && handler.run(false);
				timer["_recoverHandler"](handler);
				laters.splice(i,1);
			}
			_recordedCallLaters.length=0;
			
		}
		
		public var _getHandler:Function;
		public var _indexHandler:Function;
		public var _pool:Array;
		public var _laters:Array;
		
		public static var oldCallLater:Function;
		
		/**
		 * 延迟执行。
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
		 * @param	args 回调参数。
		 */
		public function callLater(caller:*, method:Function, args:Array = null):void {
			if (_getHandler(caller, method) == null) {
				oldCallLater.call(this,caller,method,args);
				if(_isRecording)
				{
					_recordedCallLaters.push(this._laters[this._laters.length-1]);
				}
				
			}
		}
	}
}