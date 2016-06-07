package laya.events {
	
	import laya.display.Sprite;
	import laya.maths.Point;
	
	/**
	 * <code>Event</code> 是事件类型的集合。
	 */
	public dynamic class Event {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** 一个空的 Event 对象。用于事件派发中转使用。*/
		public static const EMPTY:Event =/*[STATIC SAFE]*/ new Event();
		/** 定义 mousedown 事件对象的 type 属性值。*/
		public static const MOUSE_DOWN:String = "mousedown";
		/** 定义 mouseup 事件对象的 type 属性值。*/
		public static const MOUSE_UP:String = "mouseup";
		/** 定义 click 事件对象的 type 属性值。*/
		public static const CLICK:String = "click";
		/** 定义 rightmousedown 事件对象的 type 属性值。*/
		public static const RIGHT_MOUSE_DOWN:String = "rightmousedown";
		/** 定义 rightmouseup 事件对象的 type 属性值。*/
		public static const RIGHT_MOUSE_UP:String = "rightmouseup";
		/** 定义 rightclick 事件对象的 type 属性值。*/
		public static const RIGHT_CLICK:String = "rightclick";
		/** 定义 mousemove 事件对象的 type 属性值。*/
		public static const MOUSE_MOVE:String = "mousemove";
		/** 定义 mouseover 事件对象的 type 属性值。*/
		public static const MOUSE_OVER:String = "mouseover";
		/** 定义 mouseout 事件对象的 type 属性值。*/
		public static const MOUSE_OUT:String = "mouseout";
		/** 定义 mousewheel 事件对象的 type 属性值。*/
		public static const MOUSE_WHEEL:String = "mousewheel";
		/** 定义 mouseover 事件对象的 type 属性值。*/
		public static const ROLL_OVER:String = "mouseover";
		/** 定义 mouseout 事件对象的 type 属性值。*/
		public static const ROLL_OUT:String = "mouseout";
		/** 定义 doubleclick 事件对象的 type 属性值。*/
		public static const DOUBLE_CLICK:String = "doubleclick";
		/** 定义 change 事件对象的 type 属性值。*/
		public static const CHANGE:String = "change";
		/** 定义 changed 事件对象的 type 属性值。*/
		public static const CHANGED:String = "changed";
		/** 定义 resize 事件对象的 type 属性值。*/
		public static const RESIZE:String = "resize";
		/** 定义 added 事件对象的 type 属性值。*/
		public static const ADDED:String = "added";
		/** 定义 removed 事件对象的 type 属性值。*/
		public static const REMOVED:String = "removed";
		/** 定义 display 事件对象的 type 属性值。*/
		public static const DISPLAY:String = "display";
		/** 定义 undisplay 事件对象的 type 属性值。*/
		public static const UNDISPLAY:String = "undisplay";
		/** 定义 error 事件对象的 type 属性值。*/
		public static const ERROR:String = "error";
		/** 定义 complete 事件对象的 type 属性值。*/
		public static const COMPLETE:String = "complete";
		/** 定义 loaded 事件对象的 type 属性值。*/
		public static const LOADED:String = "loaded";
		/** 定义 progress 事件对象的 type 属性值。*/
		public static const PROGRESS:String = "progress";
		/** 定义 input 事件对象的 type 属性值。*/
		public static const INPUT:String = "input";
		/** 定义 render 事件对象的 type 属性值。*/
		public static const RENDER:String = "render";
		/** 定义 open 事件对象的 type 属性值。*/
		public static const OPEN:String = "open";
		/** 定义 message 事件对象的 type 属性值。*/
		public static const MESSAGE:String = "message";
		/** 定义 close 事件对象的 type 属性值。*/
		public static const CLOSE:String = "close";
		/** 定义 keydown 事件对象的 type 属性值。*/
		public static const KEY_DOWN:String = "keydown";
		/** 定义 keypress 事件对象的 type 属性值。*/
		public static const KEY_PRESS:String = "keypress";
		/** 定义 keyup 事件对象的 type 属性值。*/
		public static const KEY_UP:String = "keyup";
		/** 定义 frame 事件对象的 type 属性值。*/
		public static const FRAME:String = "enterframe";
		/** 定义 dragstart 事件对象的 type 属性值。*/
		public static const DRAG_START:String = "dragstart";
		/** 定义 dragmove 事件对象的 type 属性值。*/
		public static const DRAG_MOVE:String = "dragmove";
		/** 定义 dragend 事件对象的 type 属性值。*/
		public static const DRAG_END:String = "dragend";
		/** 定义 enter 事件对象的 type 属性值。*/
		public static const ENTER:String = "enter";
		/** 定义 select 事件对象的 type 属性值。*/
		public static const SELECT:String = "select";
		/** 定义 blur 事件对象的 type 属性值。*/
		public static const BLUR:String = "blur";
		/** 定义 focus 事件对象的 type 属性值。*/
		public static const FOCUS:String = "focus";
		/** 定义 played 事件对象的 type 属性值。*/
		public static const PLAYED:String = "played";
		/** 定义 paused 事件对象的 type 属性值。*/
		public static const PAUSED:String = "paused";
		/** 定义 stopped 事件对象的 type 属性值。*/
		public static const STOPPED:String = "stopped";
		/** 定义 start 事件对象的 type 属性值。*/
		public static const START:String = "start";
		/** 定义 end 事件对象的 type 属性值。*/
		public static const END:String = "end";
		/** 定义 enabledchanged 事件对象的 type 属性值。*/
		public static const ENABLED_CHANGED:String = "enabledchanged";
		/** 定义 componentadded 事件对象的 type 属性值。*/
		public static const COMPONENT_ADDED:String = "componentadded";
		/** 定义 componentremoved 事件对象的 type 属性值。*/
		public static const COMPONENT_REMOVED:String = "componentremoved";
		/** 定义 activechanged 事件对象的 type 属性值。*/
		public static const ACTIVE_CHANGED:String = "activechanged";
		/** 定义 layerchanged 事件对象的 type 属性值。*/
		public static const LAYER_CHANGED:String = "layerchanged";
		/** 定义 hierarchyloaded 事件对象的 type 属性值。*/
		public static const HIERARCHY_LOADED:String = "hierarchyloaded";
		/** 定义 memorychanged 事件对象的 type 属性值。*/
		public static const MEMORY_CHANGED:String = "memorychanged";
		/** 定义 recovering 事件对象的 type 属性值。*/
		public static const RECOVERING:String = "recovering";
		/** 定义 recovered 事件对象的 type 属性值。*/
		public static const RECOVERED:String = "recovered";
		/** 定义 released 事件对象的 type 属性值。*/
		public static const RELEASED:String = "released";
		/** 定义 link 事件对象的 type 属性值。*/
		public static const LINK:String = "link";
		/** 定义 label 事件对象的 type 属性值。*/
		public static const LABEL:String = "label";
		/**浏览器全屏更改时触发*/
		public static const FULL_SCREEN_CHANGE:String = "fullscreenchange";
		
		/** 事件类型。*/
		public var type:String;
		/** 原生浏览器事件。*/
		public var nativeEvent:*;
		/** 事件目标触发对象。*/
		public var target:Sprite;
		/** 事件当前冒泡对象。*/
		public var currentTarget:Sprite;
		/** @private */
		public var _stoped:Boolean;
		/** 分配给触摸点的唯一标识号（作为 int）。*/
		public var touchId:int;
		
		/**
		 * 设置事件数据。
		 * @param	type 事件类型。
		 * @param	currentTarget 事件目标触发对象。
		 * @param	target 事件当前冒泡对象。
		 * @return 返回当前 Event 对象。
		 */
		public function setTo(type:String, currentTarget:Sprite, target:Sprite):Event {
			this.type = type;
			this.currentTarget = currentTarget;
			this.target = target;
			return this;
		}
		
		/**
		 * 防止对事件流中当前节点的后续节点中的所有事件侦听器进行处理。
		 */
		public function stopPropagation():void {
			this._stoped = true;
		}
		
		/**
		 * 触摸点列表。
		 */
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
		
		/**
		 * 表示 Alt 键是处于活动状态 (true) 还是非活动状态 (false)。
		 */
		public function get altKey():Boolean {
			return this.nativeEvent.altKey;
		}
		
		/**
		 * 表示 Ctrl 键是处于活动状态 (true) 还是非活动状态 (false)。
		 */
		public function get ctrlKey():Boolean {
			return this.nativeEvent.ctrlKey;
		}
		
		/**
		 * 表示 Shift 键是处于活动状态 (true) 还是非活动状态 (false)。
		 */
		public function get shiftKey():Boolean {
			return this.nativeEvent.shiftKey;
		}
	}
}