package laya.debug.tools {

	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	
	public class DragBox extends Sprite {
		private static var BLOCK_WIDTH:int = 6;
		private var _box:Sprite;
		private var _left:Sprite = drawBlock();
		private var _right:Sprite = drawBlock();
		private var _top:Sprite = drawBlock();
		private var _bottom:Sprite = drawBlock();
		private var _topLeft:Sprite = drawBlock();
		private var _topRight:Sprite = drawBlock();
		private var _bottomLeft:Sprite = drawBlock();
		private var _bottomRight:Sprite = drawBlock();
		private var _target:Sprite;
		private var _lastPoint:Point = new Point();
		private var _currDir:Sprite;
		/**0-无，1-水平，2-垂直，3-全部*/
		private var _type:int;
		
		public function DragBox(type:int) {
			_type =type=3;
			addChild(_box = drawBorder(0, 0, 0xff0000));
			//_box.mouseEnabled=true;
			if (type == 1 || type == 3) {
				addChild(_left);
				addChild(_right);
			}
			if (type == 2 || type == 3) {
				addChild(_top);
				addChild(_bottom);
			}
			if (type == 3) {
				addChild(_topLeft);
				addChild(_topRight);
				addChild(_bottomLeft);
				addChild(_bottomRight);
			}
			this.on(Event.MOUSE_DOWN, this,onMouseDown);
			this.mouseThrough=true;
			
		}
		private var fixScale:Number;
		private function onMouseDown(e:Event):void {
			_currDir = e.target as Sprite;
			if(e.nativeEvent.shiftKey)
			{
				initFixScale();
			}
			if (_currDir != this) {
				_lastPoint.x = Laya.stage.mouseX;
				_lastPoint.y = Laya.stage.mouseY;
				Laya.stage.on(Event.MOUSE_MOVE, this,onMouseMove);
				Laya.stage.on(Event.MOUSE_UP, this,onMouseUp);
				e.stopPropagation();
			}
		}
		
		protected function onMouseUp(e:Event):void {
			Laya.stage.off(Event.MOUSE_MOVE, this,onMouseMove);
			Laya.stage.off(Event.MOUSE_UP, this,onMouseUp);
		}
		private function initFixScale():void
		{
			fixScale=_target.height / _target.width;
		}
		protected function onMouseMove(e:Event):void {
			
			var scale:Number =1;
			var tx:int = (Laya.stage.mouseX - _lastPoint.x) / scale;
			var ty:int = (Laya.stage.mouseY - _lastPoint.y) / scale;
			var sameScale:Boolean = false;
			var adptX:Number;
			var adptY:Number;
			if(e.nativeEvent.shiftKey)
			{			
				if(fixScale<0) initFixScale();
//				ty=Math.ceil(tx/_target.width*_target.height);
				adptY = tx * fixScale;
				adptX=ty/fixScale;
				sameScale = true;
				switch(_currDir)
				{
					case _topLeft:
					case _bottomLeft:
						_currDir = _left;
						break;
					case _topRight:
					case _bottomRight:
						_currDir = _right;
						break;
				}
			}
			if (tx != 0 || ty != 0) {
				_lastPoint.x += tx * scale;
				_lastPoint.y += ty * scale;
				var tw:Number = tx / _target.scaleX;
				var th:Number = ty / _target.scaleY;			
				if (_currDir == _left) {
					_target.x += tx;
					_target.width -= tw;
					if (sameScale)
					{
//						_target.height -= adptY / _target.scaleY;
						_target.height=_target.width*fixScale;
					}
				} else if (_currDir == _right) {
					_target.width += tw;
					if (sameScale)
					{
//						_target.height+=adptY / _target.scaleY;
						_target.height=_target.width*fixScale;
					}
				} else if (_currDir == _top) {
					_target.y += ty;
					_target.height -= th;
					if (sameScale)
					{
//						_target.width -= adptX / _target.scaleX;
						_target.width=_target.height/fixScale;
					}
				} else if (_currDir == _bottom) {
					_target.height += th;
					if (sameScale)
					{
//						_target.width+=adptX / _target.scaleX;
						_target.width=_target.height/fixScale;
					}
				} else if (_currDir == _topLeft) {
					_target.x += tx;
					_target.y += ty;
					_target.width -= tw;
					_target.height -= th;
					
				} else if (_currDir == _topRight) {
					_target.y += ty;
					_target.width += tw;
					_target.height -= th;
				} else if (_currDir == _bottomLeft) {
					_target.x += tx;
					_target.width -= tw;
					_target.height += th;
				} else if (_currDir == _bottomRight) {
					_target.width += tw;
					_target.height += th;
				}
				
				if (_target.width < 1) {
					_target.width = 1;
				}
				if (_target.height < 1) {
					_target.height = 1;
				}
				//
				//if (_target is Sprite) {
					//var bg:Sprite = Sprite(_target).getChildByName("bg") as Sprite;
					//if (bg) {
						//bg.width = _target.width;
						//bg.height = _target.height;
					//}
				//}
				_target.width = Math.round(_target.width);
				_target.x = Math.round(_target.x);
				_target.y = Math.round(_target.y);
				_target.height = Math.round(_target.height);
				refresh();
			}
		}
		
		/**画矩形*/
		private function drawBorder(width:int, height:int, color:uint, alpha:Number = 1):Sprite {
			var box:Sprite = new Sprite();
			var g:Graphics = box.graphics;
			g.clear();
			//g.lineStyle(1, color, 1, false, LineScaleMode.NONE);
			g.drawRect(0, 0, width, height,null,"#"+color);
			return box;
		}
		
		/**画矩形*/
		private function drawBlock():Sprite {
			var box:Sprite = new Sprite();
			var g:Graphics = box.graphics;
			g.clear();
			//g.beginFill(0xffffff, 1);
			//g.lineStyle(1, 0xff0000);
			box.width = BLOCK_WIDTH;
			box.height = BLOCK_WIDTH;
			g.drawRect(-BLOCK_WIDTH * 0.5, -BLOCK_WIDTH * 0.5, BLOCK_WIDTH, BLOCK_WIDTH,"#ffffff","#ff0000",1);
			//g.endFill();
			box.mouseEnabled=true;
			box.mouseThrough=true;
			return box;
		}
		
		/**设置对象*/
		public function setTarget(target:Sprite):void {
			_target = target;
			refresh();
		}
		
		public function refresh():void {
			changePoint();
			changeSize();
		}
		
		private function changePoint():void {
			var p:Point = _target.localToGlobal(new Point());
			var np:Point = (parent as Sprite).globalToLocal(p);
			x = np.x;
			y = np.y;
		}
		
		/**设置大小*/
		private function changeSize():void {
			var width:Number = _target.width * _target.scaleX;
			var height:Number = _target.height * _target.scaleY;
			//var rect:Rectangle = _target.getRect(_target.parent);
			//var rect:Rectangle = _target.getBounds();
			trace("change size");
			this.rotation=_target.rotation;
			//this.pivot(_target.pivotX,_target.pivotY);
			if (_box.width != width || _box.height != height) {
//				_box.width = Math.abs(width);
//				_box.height = Math.abs(height);
				_box.graphics.clear();
				_box.graphics.drawRect(0, 0, Math.abs(width), Math.abs(height),null,"#ff0000");
				this._box.size(width,height);
				this.size(width,height);
				_box.scaleX = Math.abs(_box.scaleX) * (_target.scaleX > 0 ? 1 : -1);
				_box.scaleY = Math.abs(_box.scaleY) * (_target.scaleY > 0 ? 1 : -1);
				_left.x = 0;
				_left.y = height * 0.5;
				_right.x = width;
				_right.y = height * 0.5;
				_top.x = width * 0.5;
				_top.y = 0;
				_bottom.x = width * 0.5;
				_bottom.y = height;
				_topLeft.x = _topLeft.y = 0;
				_topRight.x = width;
				_topRight.y = 0;
				_bottomLeft.x = 0;
				_bottomLeft.y = height;
				_bottomRight.x = width;
				_bottomRight.y = height;
			}
		}
	}
}