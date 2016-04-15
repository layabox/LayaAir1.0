package laya.events {
	
	import laya.display.Sprite;
	import laya.maths.Point;
	
	/**
	 * 事件类型
	 * @author yung
	 */
	public dynamic class Event {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public static const EMPTY:Event =/*[STATIC SAFE]*/ new Event();
		public static const MOUSE_DOWN:String = "mousedown";
		public static const MOUSE_UP:String = "mouseup";
		public static const CLICK:String = "click";
		public static const RIGHT_MOUSE_DOWN:String = "rightmousedown";
		public static const RIGHT_MOUSE_UP:String = "rightmouseup";
		public static const RIGHT_CLICK:String = "rightclick";
		public static const MOUSE_MOVE:String = "mousemove";
		public static const MOUSE_OVER:String = "mouseover";
		public static const MOUSE_OUT:String = "mouseout";
		public static const MOUSE_WHEEL:String = "mousewheel";
		public static const ROLL_OVER:String = "mouseover";
		public static const ROLL_OUT:String = "mouseout";
		public static const DOUBLE_CLICK:String = "doubleclick";
		public static const CHANGE:String = "change";
		public static const CHANGED:String = "changed";
		public static const RESIZE:String = "resize";
		public static const ADDED:String = "added";
		public static const REMOVED:String = "removed";
		public static const DISPLAY:String = "display";
		public static const UNDISPLAY:String = "undisplay";
		public static const ERROR:String = "error";
		public static const COMPLETE:String = "complete";
		public static const LOADED:String = "loaded";
		public static const PROGRESS:String = "progress";
		public static const INPUT:String = "input";
		public static const RENDER:String = "render";
		public static const OPEN:String = "open";
		public static const MESSAGE:String = "message";
		public static const CLOSE:String = "close";
		public static const KEY_DOWN:String = "keydown";
		public static const KEY_PRESS:String = "keypress";
		public static const KEY_UP:String = "keyup";
		public static const ENTER_FRAME:String = "enterframe";
		public static const DRAG_START:String = "dragstart";
		public static const DRAG_MOVE:String = "dragmove";
		public static const DRAG_END:String = "dragend";
		public static const ENTER:String = "enter";
		public static const SELECT:String = "select";
		public static const BLUR:String = "blur";
		public static const FOCUS:String = "focus";
		public static const PLAYED:String = "played";
		public static const PAUSED:String = "paused";
		public static const STOPPED:String = "stopped";
		public static const START:String = "start";
		public static const END:String = "end";
		public static const ENABLED_CHANGED:String = "enabledchanged";
		public static const COMPONENT_ADDED:String = "componentadded";
		public static const COMPONENT_REMOVED:String = "componentremoved";
		public static const ACTIVE_CHANGED:String = "activechanged";
		public static const LAYER_CHANGED:String = "layerchanged";
		public static const HIERARCHY_LOADED:String = "hierarchyloaded";
		public static const MEMORY_CHANGED:String = "memorychanged";
		public static const RECOVERED:String = "recovered";
		public static const RELEASED:String = "released";
		public static const LINK:String = "link";
		
		/**事件类型*/
		public var type:String;
		/**原生浏览器事件*/
		public var nativeEvent:*;
		/**事件目标触发对象*/
		public var target:Sprite;
		/**事件当前冒泡对象*/
		public var currentTarget:Sprite;
		/** @private */
		public var _stoped:Boolean;
		/**touch事件唯一ID，用来区分多点触摸事件*/
		public var touchId:int;
		
		/**
		 * 设置事件数据
		 * @param	type 事件类型
		 * @param	currentTarget 事件目标触发对象
		 * @param	target 事件当前冒泡对象
		 * @return
		 */
		public function setTo(type:String, currentTarget:Sprite, target:Sprite):Event {
			this.type = type;
			this.currentTarget = currentTarget;
			this.target = target;
			return this;
		}
		
		/**停止事件冒泡*/
		public function stopPropagation():void {
			this._stoped = true;
		}
		
		/**多点触摸时，返回触摸点的集合*/
		public function get touches():Array {
			var arr:Array = this.nativeEvent.touches;
			if (arr) {
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					var e:* = arr[i];
					var point:Point = Point.TEMP;
					point.setTo(e.clientX, e.clientY);
					Laya.stage._canvasTransform.invertTransformPoint(point);
					
					e.stageX = point.x;
					e.stageY = point.y;
				}
			}
			return arr;
		}
		
		/**鼠标事件的同时是否按下alt键*/
		public function get altKey():Boolean {
			return this.nativeEvent.altKey;
		}
		
		/**鼠标事件的同时是否按下ctrl键*/
		public function get ctrlKey():Boolean {
			return this.nativeEvent.ctrlKey;
		}
		
		/**鼠标事件的同时是否按下shift键*/
		public function get shiftKey():Boolean {
			return this.nativeEvent.shiftKey;
		}
	}
}