package laya.events {
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.utils.Browser;
	import laya.utils.Pool;
	
	/**
	 * @private
	 * Touch事件管理类，处理多点触控下的鼠标事件
	 */
	public class TouchManager {
		
		public static var I:TouchManager = new TouchManager();
		private static var _oldArr:Array = [];
		private static var _newArr:Array = [];
		private static var _tEleArr:Array = [];
		/**
		 * 当前over的touch表
		 */
		private var preOvers:Array = [];
		/**
		 * 当前down的touch表
		 */
		private var preDowns:Array = [];
		private var preRightDowns:Array = [];
		/**
		 * 是否启用
		 */
		public var enable:Boolean = true;
		
		/**
		 * 用于派发事件用的Event对象
		 */
		public var _event:Event = new Event();
		
		private var _lastClickTime:Number = 0;
		
		private function _clearTempArrs():void
		{
			_oldArr.length = 0;
			_newArr.length = 0;
			_tEleArr.length = 0;
		}
		
		/**
		 * 从touch表里查找对应touchID的数据
		 * @param touchID touch ID
		 * @param arr touch表
		 * @return
		 *
		 */
		private function getTouchFromArr(touchID:int, arr:Array):Object {
			var i:int, len:int;
			len = arr.length;
			var tTouchO:Object;
			for (i = 0; i < len; i++) {
				tTouchO = arr[i];
				if (tTouchO.id == touchID) {
					return tTouchO;
				}
			}
			return null;
		}
		
		/**
		 * 从touch表里移除一个元素
		 * @param touchID touch ID
		 * @param arr touch表
		 *
		 */
		private function removeTouchFromArr(touchID:int, arr:Array):void {
			//DebugTxt.dTrace("removeTouch:"+touchID);
			var i:int;
			for (i = arr.length - 1; i >= 0; i--) {
				if (arr[i].id == touchID) {
					//DebugTxt.dTrace("removeedTouch:"+touchID);
					arr.splice(i, 1);
				}
			}
		}
		
		/**
		 * 创建一个touch数据
		 * @param ele 当前的根节点
		 * @param touchID touchID
		 * @return
		 *
		 */
		private function createTouchO(ele:*, touchID:int):Object {
			var rst:Object;
			rst = Pool.getItem("TouchData") || {};
			rst.id = touchID;
			rst.tar = ele;
			
			return rst;
		}
		
		/**
		 * 处理touchStart
		 * @param ele		根节点
		 * @param touchID	touchID
		 * @param isLeft	（可选）是否为左键
		 */
		public function onMouseDown(ele:*, touchID:int, isLeft:Boolean = false):void {
			if (!enable)
				return;
			var preO:Object;
			var tO:Object;
			var arrs:Array;
			preO = getTouchFromArr(touchID, preOvers);
			
			arrs = getEles(ele, null, _tEleArr);
			if (!preO) {
				tO = createTouchO(ele, touchID);
				preOvers.push(tO);
			} else {
				//理论上不会发生，相同触摸事件必然不会在end之前再次出发
				preO.tar = ele;
			}
			if (Browser.onMobile)
				sendEvents(arrs, Event.MOUSE_OVER, touchID);
			
			var preDowns:Array;
			preDowns = isLeft ? this.preDowns : this.preRightDowns;
			preO = getTouchFromArr(touchID, preDowns);
			if (!preO) {
				tO = createTouchO(ele, touchID);
				preDowns.push(tO);
			} else {
				//理论上不会发生，相同触摸事件必然不会在end之前再次出发
				preO.tar = ele;
				
			}
			sendEvents(arrs, isLeft ? Event.MOUSE_DOWN : Event.RIGHT_MOUSE_DOWN, touchID);
			_clearTempArrs();
		
		}
		
		/**
		 * 派发事件。
		 * @param eles		对象列表。
		 * @param type		事件类型。
		 * @param touchID	（可选）touchID，默认为0。
		 */
		private function sendEvents(eles:Array, type:String, touchID:int = 0):void {
			var i:int, len:int;
			len = eles.length;
			_event._stoped = false;
			var _target:*;
			_target = eles[0];
			var tE:Sprite;
			for (i = 0; i < len; i++) {
				tE = eles[i];
				if (tE.destroyed) return;
				tE.event(type, _event.setTo(type, tE, _target));
				if (_event._stoped)
					break;
			}
		}
		
		/**
		 * 获取对象列表。
		 * @param start	起始节点。
		 * @param end	结束节点。
		 * @param rst	返回值。如果此值不为空，则将其赋值为计算结果，从而避免创建新数组；如果此值为空，则创建新数组返回。
		 * @return Array 返回节点列表。
		 */
		private function getEles(start:Node, end:Node = null, rst:Array = null):Array {
			if (!rst) {
				rst = [];
			} else {
				rst.length = 0;
			}
			while (start && start != end) {
				rst.push(start);
				start = start.parent;
			}
			return rst;
		}
		
		/**
		 * touchMove时处理out事件和over时间。
		 * @param eleNew	新的根节点。
		 * @param elePre	旧的根节点。
		 * @param touchID	（可选）touchID，默认为0。
		 */
		private function checkMouseOutAndOverOfMove(eleNew:Node, elePre:Node, touchID:int = 0):void {
			if (elePre == eleNew)
				return;
			var tar:Node;
			var arrs:Array;
			var i:int, len:int;
			if (elePre.contains(eleNew)) {
				arrs = getEles(eleNew, elePre, _tEleArr);
				sendEvents(arrs, Event.MOUSE_OVER, touchID);
			} else if (eleNew.contains(elePre)) {
				arrs = getEles(elePre, eleNew, _tEleArr);
				sendEvents(arrs, Event.MOUSE_OUT, touchID);
			} else {
				//arrs = getEles(elePre);
				arrs = _tEleArr;
				arrs.length = 0;
				var oldArr:Array;
				oldArr = getEles(elePre, null, _oldArr);
				var newArr:Array;
				newArr = getEles(eleNew, null, _newArr);
				len = oldArr.length;
				var tIndex:int;
				for (i = 0; i < len; i++) {
					tar = oldArr[i];
					tIndex = newArr.indexOf(tar);
					if (tIndex >= 0) {
						newArr.splice(tIndex, newArr.length - tIndex);
						break;
						
					} else {
						arrs.push(tar);
					}
				}
				if (arrs.length > 0) {
					sendEvents(arrs, Event.MOUSE_OUT, touchID);
				}
				
				if (newArr.length > 0) {
					sendEvents(newArr, Event.MOUSE_OVER, touchID);
				}
			}
		}
		
		/**
		 * 处理TouchMove事件
		 * @param ele 根节点
		 * @param touchID touchID
		 *
		 */
		public function onMouseMove(ele:*, touchID:int):void {
			if (!enable)
				return;
			//DebugTxt.dTrace("onMouseMove:"+touchID);
			var preO:Object;
			preO = getTouchFromArr(touchID, preOvers);
			var arrs:Array;
			
			var tO:Object;
			if (!preO) {
				//理论上不会发生，因为必然先有touchstart再有touchMove
				arrs = getEles(ele, null, _tEleArr);
				sendEvents(arrs, Event.MOUSE_OVER, touchID);
				preOvers.push(createTouchO(ele, touchID));
			} else {
				checkMouseOutAndOverOfMove(ele, preO.tar);
				preO.tar = ele;
				arrs = getEles(ele, null, _tEleArr);
			}
			
			sendEvents(arrs, Event.MOUSE_MOVE, touchID);
			_clearTempArrs();
		}
		
		public function getLastOvers():Array {
			_tEleArr.length = 0;
			if (preOvers.length > 0 && preOvers[0].tar) {
				return getEles(preOvers[0].tar, null, _tEleArr);
			}
			_tEleArr.push(Laya.stage);
			return _tEleArr;
		}
		
		public function stageMouseOut():void
		{
			var lastOvers:Array;
			lastOvers = getLastOvers();
			preOvers.length = 0;
			sendEvents(lastOvers, Event.MOUSE_OUT, 0);
		}
		
		/**
		 * 处理TouchEnd事件
		 * @param ele		根节点
		 * @param touchID	touchID
		 * @param isLeft	是否为左键
		 */
		public function onMouseUp(ele:*, touchID:int, isLeft:Boolean = false):void {
			if (!enable)
				return;
			var preO:Object;
			var tO:Object;
			var arrs:Array;
			var oldArr:Array;
			var i:int, len:int;
			var tar:Node;
			var sendArr:Array;
			
			var onMobile:Boolean = Browser.onMobile;
			
			//处理up
			arrs = getEles(ele, null, _tEleArr);
			sendEvents(arrs, isLeft ? Event.MOUSE_UP : Event.RIGHT_MOUSE_UP, touchID);
			
			//处理click
			var preDowns:Array;
			preDowns = isLeft ? this.preDowns : this.preRightDowns;
			preO = getTouchFromArr(touchID, preDowns);
			if (!preO) {
				
			} else {
				var isDouble:Boolean;
				var now:Number = Browser.now();
				isDouble = now - _lastClickTime < 300;
				_lastClickTime = now;
				if (ele == preO.tar) {
					sendArr = arrs;
				} else {
					oldArr = getEles(preO.tar, null, _oldArr);
					sendArr = _newArr;
					sendArr.length = 0;
					len = oldArr.length;
					for (i = 0; i < len; i++) {
						tar = oldArr[i];
						if (arrs.indexOf(tar) >= 0) {
							sendArr.push(tar);
						}
					}
				}
				
				if (sendArr.length > 0) {
					sendEvents(sendArr, isLeft ? Event.CLICK : Event.RIGHT_CLICK, touchID);
				}
				if (isLeft && isDouble) {
					sendEvents(sendArr, Event.DOUBLE_CLICK, touchID);
				}
				removeTouchFromArr(touchID, preDowns);
				preO.tar = null;
				Pool.recover("TouchData", preO);
			}
			
			//处理out
			preO = getTouchFromArr(touchID, preOvers);
			if (!preO) {
				//理论上不会发生，因为必然先有touchstart再有touchEnd
			} else {
				if (onMobile) {
					sendArr = getEles(preO.tar, null, sendArr);
					if (sendArr && sendArr.length > 0) {
						sendEvents(sendArr, Event.MOUSE_OUT, touchID);
					}
					removeTouchFromArr(touchID, preOvers);
					preO.tar = null;
					Pool.recover("TouchData", preO);
				}
			}
			_clearTempArrs();
		}
	}
}