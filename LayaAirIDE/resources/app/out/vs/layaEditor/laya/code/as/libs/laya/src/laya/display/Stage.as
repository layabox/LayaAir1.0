package laya.display {
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.resource.HTMLCanvas;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Log;
	import laya.utils.Stat;
	
	/**
	 * stage大小经过重新调整时进行调度。
	 * @eventType Event.RESIZE
	 */
	[Event(name = "resize", type = "laya.events.Event")]
	/**
	 * 舞台获得焦点时调度。
	 * 比如浏览器或者当前标签被切换到后台后，重新切换回来时。
	 * @eventType Event.FOCUS
	 */
	[Event(name = "focus", type = "laya.events.Event")]
	/**
	 * 舞台失去焦点时调度，比如浏览器或者当前标签被切换到后台后调度。
	 * @eventType Event.BLUR
	 */
	[Event(name = "blur", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Stage</code> 类是显示对象的根节点。</p>
	 * 可以通过 Laya.stage 访问。
	 */
	public class Stage extends Sprite {
		/**应用保持设计宽高不变，不缩放不变性，stage的宽高等于设计宽高。*/
		public static const SCALE_NOSCALE:String = "noscale";
		/**应用根据屏幕大小铺满全屏，非等比缩放会变形，stage的宽高等于设计宽高。*/
		public static const SCALE_EXACTFIT:String = "exactfit";
		/**应用显示全部内容，按照最小比率缩放，等比缩放不变性，一边可能会留空白，stage的宽高等于设计宽高。*/
		public static const SCALE_SHOWALL:String = "showall";
		/**应用按照最大比率缩放显示，宽或高方向会显示一部分，等比缩放不变性，stage的宽高等于设计宽高。*/
		public static const SCALE_NOBORDER:String = "noborder";
		/**应用保持设计宽高不变，不缩放不变性，stage的宽高等于屏幕宽高。*/
		public static const SCALE_FULL:String = "full";
		/**应用保持设计宽度不变，高度根据屏幕比缩放，stage的宽度等于设计宽度，高度根据屏幕比率大小而变化*/
		public static const SCALE_FIXED_WIDTH:String = "fixedwidth";
		/**应用保持设计宽度不变，高度根据屏幕比缩放，stage的宽度等于设计宽度，高度根据屏幕比率大小而变化*/
		public static const SCALE_FIXED_HEIGHT:String = "fixedheight";
		
		/**画布水平居左对齐。*/
		public static const ALIGN_LEFT:String = "left";
		/**画布水平居右对齐。*/
		public static const ALIGN_RIGHT:String = "right";
		/**画布水平居中对齐。*/
		public static const ALIGN_CENTER:String = "center";
		/**画布垂直居上对齐。*/
		public static const ALIGN_TOP:String = "top";
		/**画布垂直居中对齐。*/
		public static const ALIGN_MIDDLE:String = "middle";
		/**画布垂直居下对齐。*/
		public static const ALIGN_BOTTOM:String = "bottom";
		
		/**不更改屏幕。*/
		public static const SCREEN_NONE:String = "none";
		/**自动横屏。*/
		public static const SCREEN_HORIZONTAL:String = "horizontal";
		/**自动竖屏。*/
		public static const SCREEN_VERTICAL:String = "vertical";
		
		/**全速模式，以60的帧率运行。*/
		public static const FRAME_FAST:String = "fast";
		/**慢速模式，以30的帧率运行。*/
		public static const FRAME_SLOW:String = "slow";
		/**自动模式，以30的帧率运行，但鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗。*/
		public static const FRAME_MOUSE:String = "mouse";
		
		/**当前焦点对象，此对象会影响当前键盘事件的派发主体。*/
		public var focus:Node;
		/**相对浏览器左上角的偏移。*/
		public var offset:Point = new Point();
		/**帧率类型，支持三种模式：fast-60帧(默认)，slow-30帧，mouse-30帧，但鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗。*/
		public var frameRate:String = "fast";
		/**本帧开始时间，只读，如果不是对精度要求过高，建议使用此时间，比Browser.now()快3倍。*/
		public var now:Number = Browser.now();
		/**设计宽度（初始化时设置的宽度Laya.init(width,height)）*/
		public var desginWidth:Number = 0;
		/**设计高度（初始化时设置的高度Laya.init(width,height)）*/
		public var desginHeight:Number = 0;
		/**画布是否发生翻转。*/
		public var canvasRotation:Boolean = false;
		
		/** @private */
		public var _canvasTransform:Matrix = new Matrix();
		/** @private */
		private var _screenMode:String = "none";
		/** @private */
		private var _scaleMode:String = "noscale";
		/** @private */
		private var _alignV:String = "top";
		/** @private */
		private var _alignH:String = "left";
		/** @private */
		private var _bgColor:String = "black";
		/** @private */
		private var _preLoopTime:Number = Browser.now();
		/** @private */
		private var _mouseMoveTime:Number = 0;
		/** @private */
		private var _renderCount:int = 0;
		
		public function Stage() {
			this.mouseEnabled = true;
			this._displayInStage = true;
			
			var _this:Stage = this;
			var window:* = Browser.window;
			window.addEventListener("focus", function():void {
				_this.event(Event.FOCUS);
			})
			window.addEventListener("blur", function():void {
				_this.event(Event.BLUR);
			})
			window.addEventListener("resize", function():void {
				_this._resetCanvas();
				Laya.timer.once(100, _this, _this._changeCanvasSize);
			})
			window.addEventListener("orientationchange", function(e:*):void {
				_this._resetCanvas();
				Laya.timer.once(100, _this, _this._changeCanvasSize);
			})
			
			on(Event.MOUSE_MOVE, this, _onmouseMove);
		}
		
		/**@inheritDoc	 */
		override public function size(width:Number, height:Number):Sprite {
			this.desginWidth = this.width = width;
			this.desginHeight = this.height = height;
			Laya.timer.callLater(this, _changeCanvasSize);
			return this;
		}
		
		/** @private */
		private function _changeCanvasSize():void {
			setScreenSize(Browser.clientWidth * Browser.pixelRatio, Browser.clientHeight * Browser.pixelRatio);
		}
		
		/** @private */
		private function _resetCanvas():void {
			var canvas:HTMLCanvas = Render.canvas;
			var canvasStyle:* = canvas.source.style;
			canvas.size(1, 1);
			canvasStyle.transform = canvasStyle.webkitTransform = canvasStyle.msTransform = canvasStyle.mozTransform = canvasStyle.oTransform = "";
			this.visible = false;
		}
		
		/**
		 * 设置屏幕大小。
		 * @param	screenWidth		屏幕宽度。
		 * @param	screenHeight	屏幕高度。
		 */
		public function setScreenSize(screenWidth:Number, screenHeight:Number):void {
			//计算是否旋转
			var rotation:Boolean = false;
			if (_screenMode !== SCREEN_NONE) {
				var screenType:String = screenWidth / screenHeight < 1 ? SCREEN_VERTICAL : SCREEN_HORIZONTAL;
				rotation = screenType !== _screenMode;
				
				if (rotation) {
					//宽高互换
					var temp:Number = screenHeight;
					screenHeight = screenWidth;
					screenWidth = temp;
				}
			}
			this.canvasRotation = rotation;
			
			var canvas:HTMLCanvas = Render.canvas;
			var canvasStyle:* = canvas.source.style;
			var mat:Matrix = this._canvasTransform.identity();
			var scaleMode:String = this._scaleMode;
			var scaleX:Number = screenWidth / desginWidth
			var scaleY:Number = screenHeight / desginHeight;
			var canvasWidth:Number = desginWidth;
			var canvasHeight:Number = desginHeight;
			var realWidth:Number = screenWidth;
			var realHeight:Number = screenHeight;
			var pixelRatio:Number = Browser.pixelRatio;
			_width = desginWidth;
			_height = desginHeight;
			
			//处理缩放模式
			switch (scaleMode) {
			case SCALE_NOSCALE: 
				scaleX = scaleY = 1;
				realWidth = desginWidth;
				realHeight = desginHeight;
				break;
			case SCALE_SHOWALL: 
				scaleX = scaleY = Math.min(scaleX, scaleY);
				realWidth = Math.round(desginWidth * scaleX);
				realHeight = Math.round(desginHeight * scaleY);
				break;
			case SCALE_NOBORDER: 
				scaleX = scaleY = Math.max(scaleX, scaleY);
				realWidth = Math.round(desginWidth * scaleX);
				realHeight = Math.round(desginHeight * scaleY);
				break;
			case SCALE_FULL: 
				scaleX = scaleY = 1;
				_width = canvasWidth = screenWidth;
				_height = canvasHeight = screenHeight;
				break;
			case SCALE_FIXED_WIDTH: 
				scaleY = scaleX;
				_height = screenHeight / scaleX;
				canvasHeight = Math.round(screenHeight / scaleX);
				break;
			case SCALE_FIXED_HEIGHT: 
				scaleX = scaleY;
				_width = screenWidth / scaleY;
				canvasWidth = Math.round(screenWidth / scaleY);
				break;
			}
			
			//根据不同尺寸缩放stage画面
			if (scaleX === 1 && scaleY === 1) {
				transform && transform.identity();
			} else {
				transform || (transform = new Matrix());
				transform.a = scaleX / (realWidth / canvasWidth);
				transform.d = scaleY / (realHeight / canvasHeight);
			}
			
			//处理canvas大小			
			canvas.size(canvasWidth, canvasHeight);
			System.changeWebGLSize(canvasWidth, canvasHeight);
			mat.scale(realWidth / canvasWidth / pixelRatio, realHeight / canvasHeight / pixelRatio);
			
			//处理水平对齐
			if (_alignH === ALIGN_LEFT) offset.x = 0;
			else if (_alignH === ALIGN_RIGHT) offset.x = screenWidth - realWidth;
			else offset.x = (screenWidth - realWidth) * 0.5 / pixelRatio;
			
			//处理垂直对齐
			if (_alignV === ALIGN_TOP) offset.y = 0;
			else if (_alignV === ALIGN_BOTTOM) offset.y = screenHeight - realHeight;
			else offset.y = (screenHeight - realHeight) * 0.5 / pixelRatio;
			mat.translate(offset.x, offset.y);
			
			//处理横竖屏
			if (rotation) {
				if (_screenMode === SCREEN_HORIZONTAL) {
					mat.rotate(Math.PI / 2);
					mat.translate(screenHeight / pixelRatio, 0);
				} else {
					mat.rotate(-Math.PI / 2);
					mat.translate(0, screenWidth / pixelRatio);
				}
			}
			
			if (mat.a < 0.00000000000001) mat.a = mat.d = 0;
			canvasStyle.transformOrigin = canvasStyle.webkitTransformOrigin = canvasStyle.msTransformOrigin = canvasStyle.mozTransformOrigin = canvasStyle.oTransformOrigin = "0px 0px 0px";
			canvasStyle.transform = canvasStyle.webkitTransform = canvasStyle.msTransform = canvasStyle.mozTransform = canvasStyle.oTransform = "matrix(" + mat.toString() + ")";
			this.visible = true;
			_repaint = 1;
			event(Event.RESIZE);
		}
		
		/**
		 * <p>缩放模式。</p>
		 * <p><ul>取值范围：
		 * <li>"noScale" ：不缩放；</li>
		 * <li>"exactFit" ：全屏不等比缩放；</li>
		 * <li>"showAll" ：最小比例缩放；</li>
		 * <li>"noBorder" ：最大比例缩放；</li>
		 * </ul></p>
		 * 默认值为 "noScale"。
		 */
		public function get scaleMode():String {
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void {
			_scaleMode = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		/**
		 * 水平对齐方式。
		 * <p><ul>取值范围：
		 * <li>"left" ：居左对齐；</li>
		 * <li>"center" ：居中对齐；</li>
		 * <li>"right" ：居右对齐；</li>
		 * </ul></p>
		 * 默认值为"left"。
		 */
		public function get alignH():String {
			return _alignH;
		}
		
		public function set alignH(value:String):void {
			_alignH = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		/**
		 * 垂直对齐方式。
		 * <p><ul>取值范围：
		 * <li>"top" ：居顶部对齐；</li>
		 * <li>"middle" ：居中对齐；</li>
		 * <li>"bottom" ：居底部对齐；</li>
		 * </ul></p>
		 */
		public function get alignV():String {
			return _alignV;
		}
		
		public function set alignV(value:String):void {
			_alignV = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		/**舞台的背景颜色，默认为黑色，null为透明。*/
		public function get bgColor():String {
			return _bgColor;
		}
		
		public function set bgColor(value:String):void {
			_bgColor = value;
			if (value) {
				Render.canvas.source.style.background = value;
			} else {
				Render.canvas.source.style.background = "none";
			}
		}
		
		/** 鼠标在 Stage 上的 X 轴坐标。*/
		override public function get mouseX():Number {
			// River: 加入了round.
			return Math.round(MouseManager.instance.mouseX / (_transform ? _transform.a : 1));
		}
		
		/**鼠标在 Stage 上的 Y 轴坐标。*/
		override public function get mouseY():Number {
			// River:加入了round.
			return Math.round(MouseManager.instance.mouseY / (_transform ? _transform.d : 1));
		}
		
		/**当前视窗 X 轴缩放系数。*/
		public function get clientScaleX():Number {
			return _transform ? _transform.a : 1;
		}
		
		/**当前视窗 Y 轴缩放系数。*/
		public function get clientScaleY():Number {
			return _transform ? _transform.d : 1;
		}
		
		/**
		 * 场景布局类型。
		 * <p><ul>取值范围：
		 * <li>"none" ：不更改屏幕</li>
		 * <li>"horizontal" ：自动横屏</li>
		 * <li>"vertical" ：自动竖屏</li>
		 * </ul></p>
		 */
		public function get screenMode():String {
			return _screenMode;
		}
		
		public function set screenMode(value:String):void {
			_screenMode = value;
		}
		
		/**@inheritDoc */
		override public function repaint():void {
			_repaint = 1;
		}
		
		/**@inheritDoc */
		override public function parentRepaint(child:Sprite):void {
		}
		
		/** @private */
		public function _loop():Boolean {
			render(Render.context, 0, 0);
			return true;
		}
		
		/** @private */
		private function _onmouseMove(e:Event):void {
			_mouseMoveTime = Browser.now();
		}
		
		/**@inheritDoc */
		override public function render(context:RenderContext, x:Number, y:Number):void {
			var loopTime:Number = Browser.now();
			
			if (Log.enable() && (loopTime - now) > 500) {
				Log.print("-------------render delay:" + (Browser.now() - now) + "  cound:" + _renderCount);
			}
			
			now = loopTime;
			
			_renderCount++;
			
			var delay:int = loopTime - _preLoopTime;
			var isFastMode:Boolean = (frameRate !== FRAME_SLOW);
			var isDoubleLoop:Boolean = (_renderCount % 2 === 0);
			var ctx:* = Render.context;
			
			Stat.renderSlow = !isFastMode;
			
			if (isFastMode || isDoubleLoop) {
				Stat.loopCount++;
				MouseManager.instance.runEvent();
				Laya.timer._update();
				if (this._style.visible) {
					Render.isWebGl ? ctx.clear() : Render.clear(_bgColor);
					super.render(context, x, y);
				}
			}
			
			if (this._style.visible && (isFastMode || !isDoubleLoop)) {
				Render.isWebGl && Render.clear(_bgColor);
				context.flush();
				Render.finish();
			}
			
			_preLoopTime = loopTime;
		}
	}
}