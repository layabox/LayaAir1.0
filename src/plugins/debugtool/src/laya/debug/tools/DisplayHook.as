package laya.debug.tools 
{
	
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.views.SelectInfosView;
	
	import laya.debug.tools.debugUI.DButton;
	import laya.events.Event;
	import laya.debug.DebugTool;

	/**
	 * 调试拾取显示对象类
	 * @author ww
	 */
	public class DisplayHook 
	{
		
		public function DisplayHook() 
		{
			this._stage = Laya.stage;
			init(Render.context.canvas);
		}
		public static const ITEM_CLICKED:String = "ItemClicked";
		public static var instance:DisplayHook ;
		public var mouseX:Number;
		public var mouseY:Number;
		private var _stage:Stage;
		private var _matrix:Matrix = new Matrix();
		private var _point:Point = new Point();
		private var _rect:Rectangle = new Rectangle();
		private var _event:Event = Event.EMPTY;
		private var _target:*;
		
		public static function initMe():void
		{
			if(!instance)
			{
				instance=new DisplayHook();
			}
		}
		
		public function init(canvas:*):void {
			//禁用IE下屏幕缩放
			if (Browser.window.navigator.msPointerEnabled) {
				canvas.style['-ms-content-zooming'] = 'none';
				canvas.style['-ms-touch-action'] = 'none';
			}
			
			var _this:DisplayHook = this;
			Browser.document.addEventListener('mousedown', function(e:*):void {
//			canvas.addEventListener('mousedown', function(e:*):void {
				_event._stoped = false;
				isFirst=true;
//				trace("mousePos:",e.offsetX, e.offsetY);
				_this.check(_this._stage, e.offsetX, e.offsetY, _this.onMouseDown, true, false);
			}, true);
			Browser.document.addEventListener('touchstart', function(e:*):void {
//			canvas.addEventListener('mousedown', function(e:*):void {
				_event._stoped = false;
				isFirst=true;
//				trace("mousePos:",e.offsetX, e.offsetY);
               	var touches:Array = e.changedTouches;
				for (var i:int = 0, n:int = touches.length; i < n; i++) {
					var touch:* = touches[i];
					initEvent(touch, e);
					_this.check(_this._stage, _this.mouseX, _this.mouseY, _this.onMouseDown, true, false);
				}
				//_this.check(_this._stage, e.offsetX, e.offsetY, _this.onMouseDown, true, false);
			}, true);
			
			function initEvent(e:Event, event:* = null):void {
				_this._event._stoped = false;
				_this._event.nativeEvent = event || e;
				_this._target = null;
				
				if (e.offsetX) {
					_this.mouseX = e.offsetX;
					_this.mouseY = e.offsetY;
				} else {
					_this.mouseX = e.clientX - Laya.stage.offset.x;
					_this.mouseY = e.clientY - Laya.stage.offset.y;
				}
			}
		}
		
		private function onMouseMove(ele:*, hit:Boolean):void {
			sendEvent(ele, Event.MOUSE_MOVE);
			//TODO:BUG
			return;
			
			if (hit && ele != _stage && ele !== _target) {
				if (_target) {
					if (_target.$_MOUSEOVER) {
						_target.$_MOUSEOVER = false;
						_target.event(Event.MOUSE_OUT);
					}
				}
				_target = ele;
				if (!ele.$_MOUSEOVER) {
					ele.$_MOUSEOVER = true;
					sendEvent(ele, Event.MOUSE_OVER);
					//TODO:BUG
					//trace(ele, "mouseover");
				}
			} else if (!hit && _target && ele === _target) {
				_target = null;
				if (ele.$_MOUSEOVER) {
					ele.$_MOUSEOVER = false;
					sendEvent(ele, Event.MOUSE_OUT);
				}
			}
		}
		
		private function onMouseUp(ele:*, hit:Boolean):void {
			hit && sendEvent(ele, Event.MOUSE_UP);
		}
		
		private function onMouseDown(ele:*, hit:Boolean):void {
			if (hit) {
				ele.$_MOUSEDOWN = true;
				sendEvent(ele, Event.MOUSE_DOWN);
			}
		}
		
		private function sendEvent(ele:*, type:String):void {
			if (!_event._stoped) {
				ele.event(type, _event.setTo(type, ele,ele));
				if (type === Event.MOUSE_UP && ele.$_MOUSEDOWN) {
					ele.$_MOUSEDOWN = false;
					ele.event(Event.CLICK, _event.setTo(Event.CLICK, ele,ele));
				}
			}
		}
		public function selectDisUnderMouse():void
		{
			isFirst=true;
			check(Laya.stage, Laya.stage.mouseX, Laya.stage.mouseY, null, true, false);
			SelectInfosView.I.setSelectTarget(DebugTool.target);
		}
		
		private var isGetting:Boolean = false;
		public function getDisUnderMouse():Sprite
		{
			isGetting = true;
			isFirst = true;
			DebugTool.target = null;
			check(Laya.stage, Laya.stage.mouseX, Laya.stage.mouseY, null, true, false);
			isGetting = false;
			return DebugTool.target;
		}
		public static var isFirst:Boolean=false;
		private function check(sp:Sprite, mouseX:Number, mouseY:Number, callBack:Function, hitTest:Boolean, mouseEnable:Boolean):Boolean {
//			trace("check:"+sp.name);
			if (sp == DebugTool.debugLayer) return false;
			if (sp == DebugInfoLayer.I) return false;
//			if(sp==DebugTool._mainPain) return false;
			//if (sp is TraceOutUI) return false;
			//if(sp=DebugInfoLayer.I) return false;
			if (isGetting && sp == DebugInfoLayer.I) return false;
			
			if (!sp.visible || sp.getSelfBounds().width<=0) return false;
			
			var isHit:Boolean = false;
			mouseEnable = true
			if (mouseEnable) {
				var graphicHit:Boolean=false;
				if (hitTest) {					
					this._rect=sp.getBounds();					
					isHit = this._rect.contains(mouseX, mouseY);
					this._point.setTo(mouseX, mouseY);
					sp.fromParentPoint(this._point);
					mouseX = this._point.x;
					mouseY = this._point.y;		
				}
//				trace("check work:"+sp.name,isHit);
				//父对象没有接收到事件，子对象不再测试
				if (isHit) {
					var flag:Boolean = false;
					for (var i:int = sp._childs.length - 1; i > -1; i--) {
						var child:Sprite = sp._childs[i];
						//只有接受交互事件的，才进行处理
						 (flag = check(child, mouseX, mouseY, callBack, hitTest, true));
						if (flag) break;
					}
					//if(sp is DMainPain) return false;
					graphicHit=sp.getGraphicBounds().contains(mouseX, mouseY);
					isHit=flag||graphicHit;
					if(isHit&&!flag&&isFirst)
					{
						isFirst=false;
						if(! (sp is DButton))
						{
							DebugTool.target = sp;
							if (!isGetting)
							{
								//trace("click target:");
							    DebugTool.autoWork();
							    Notice.notify(ITEM_CLICKED, sp);
							}
							
						}
					}
				}

				
			}
			return isHit;
		}
		
	}

}