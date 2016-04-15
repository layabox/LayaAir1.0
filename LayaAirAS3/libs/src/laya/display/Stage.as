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
	 * */
	[Event(name = "resize", type = "laya.events.Event")]
	/**
	 * 舞台获得焦点时调度。
	 * 比如浏览器或者当前标签被切换到后台后，重新切换回来时.
	 * @eventType Event.FOCUS
	 * */
	[Event(name = "focus", type = "laya.events.Event")]
	/**
	 * 舞台失去焦点时触发，比如浏览器或者当前标签被切换到后台后触发
	 * @eventType Event.BLUR
	 * */
	[Event(name = "blur", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Stage</code> 类是显示对象的根节点。</p>
	 * 可以通过Laya.stage访问。
	 */
	public class Stage extends Sprite {
		/**整个应用程序的大小固定，因此，即使播放器窗口的大小更改，它也会保持不变。如果播放器窗口比内容小，则可能进行一些裁切。*/
		public static const SCALE_NOSCALE:String = "noscale";
		/**整个应用程序在指定区域中可见，但不尝试保持原始高宽比。可能会发生扭曲，应用程序可能会拉伸或压缩显示。*/
		public static const SCALE_EXACTFIT:String = "exactfit";
		/**整个应用程序在指定区域中可见，且不发生扭曲，同时保持应用程序的原始高宽比。应用程序的两侧可能会显示边框。*/
		public static const SCALE_SHOWALL:String = "showall";
		/**整个应用程序根据屏幕的尺寸等比缩放内容，缩放后应用程序内容向较窄方向填满播放器窗口，另一个方向的两侧可能会超出播放器窗口而被裁切，只显示中间的部分。*/
		public static const SCALE_NOBORDER:String = "noborder";
		
		/**按照设计宽高显示，画布大小不变，stage同设计大小*/
		public static const SIZE_NONE:String = "none";
		/**按照屏幕宽高显示，画布充满全屏，stage大小等于屏幕大小。*/
		public static const SIZE_FULL:String = "full";
		/**宽度充满全屏，画布高度不变，宽度根据屏幕比充满全屏，stage高度为设计宽度，宽度为根据屏幕比率计算的宽度。*/
		public static const SIZE_FULL_WIDTH:String = "fullwidth";
		/**高度充满全屏，画布宽度不变，高度根据屏幕比充满全屏，stage宽度为设计宽度，高度为根据屏幕比率计算的宽度。*/
		public static const SIZE_FULL_HEIGHT:String = "fullheight";
		
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
		/**如果小于48帧，以30的帧率运行。*/
		public static const FRAME_AUTO:String = "auto";
		
		/**当前焦点对象，此对象会影响当前键盘事件的派发主体。*/
		public var focus:Node;
		/**相对浏览器左上角的偏移。*/
		public var offset:Point = new Point();
		/**帧率类型，支持三种模式：fast-60帧(默认)，slow-30帧，auto-30帧，但鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗。*/
		public var frameRate:String = "fast";
		
		/**本帧开始时间，只读，如果不是对精度要求过高，建议使用此时间，比Browser.now()快3倍。*/
		public var now:Number = Browser.now();
		
		/** @private */
		public var _canvasTransform:Matrix = new Matrix();
		/**画布是否发送翻转*/
		public var canvasRotation:Boolean = false;
		
		/** @private */
		private var _screenMode:String = "none";
		/** @private */
		private var _scaleMode:String = "noscale";
		/** @private */
		private var _sizeMode:String = "none";
		/** @private */
		private var _alignV:String = "top";
		/** @private */
		private var _alignH:String = "left";
		/** @private */
		private var _bgColor:String = "black";
		/** @private */
		private var _useHDRendering:Boolean = true;
		/** @private */
		private var _preLoopTime:Number = Browser.now();
		/** @private */
		private var _mouseMoveTime:Number = 0;
		/** @private */
		private var _oldSize:Point;
		/** @private */
		private var _renderCount:int = 0;
		
		public function Stage() {
			this.mouseEnabled = true;
			this._displayInStage = true;
			
			var _this:Stage = this;
			var window:* = Browser.window;
			window.addEventListener("resize", function():void {
				if (!Input.isInputting) {
					resetCanvas();
					Laya.timer.once(100, _this, _this._changeCanvasSize, null, true);
				}
			})
			window.addEventListener("focus", function():void {
				_this.event(Event.FOCUS);
			})
			window.addEventListener("blur", function():void {
				_this.event(Event.BLUR);
			})
			window.addEventListener("orientationchange", function(e:*):void {
				resetCanvas();
				Laya.timer.once(100, _this, _this._changeCanvasSize, null, true);
			})
			
			on(Event.MOUSE_MOVE, this, _onmouseMove);
		}
		
		/**@inheritDoc	 */
		override public function size(width:Number, height:Number):Sprite {
			this.width = width;
			this.height = height;
			Laya.timer.callLater(this, _changeCanvasSize);
			return this;
		}
		
		/** @private */
		private function _changeCanvasSize():void {
			setCanvasSize(Browser.clientWidth, Browser.clientHeight);
		}
		
		private function resetCanvas():void {
			var canvas:HTMLCanvas = Render.canvas;
			var canvasStyle:* = canvas.source.style;
			canvas.size(1, 1);
			canvasStyle.transform = canvasStyle.webkitTransform = canvasStyle.msTransform = canvasStyle.mozTransform = canvasStyle.oTransform = "";
			this.visible = false;
		}
		
		/**
		 * 设置画布大小。
		 * @param	canvasWidth	画布宽度。
		 * @param	canvasHeight 画布高度。
		 */
		public function setCanvasSize(canvasWidth:Number, canvasHeight:Number):void {
			//纪录设计宽度
			_oldSize || (_oldSize = new Point(_width, _height));
			//计算是否旋转
			var rotation:Boolean = false;
			if (_screenMode !== SCREEN_NONE) {
				var screenType:String = canvasWidth / canvasHeight < 1 ? SCREEN_VERTICAL : SCREEN_HORIZONTAL;
				rotation = screenType !== _screenMode;
				
				if (rotation) {
					//宽高互换
					var temp:Number = canvasHeight;
					canvasHeight = canvasWidth;
					canvasWidth = temp;
				}
			}
			this.canvasRotation = rotation;
			
			var pixelRatio:Number = _useHDRendering ? Browser.pixelRatio : 1;
			var canvas:HTMLCanvas = Render.canvas;
			var canvasStyle:* = canvas.source.style;
			var mat:Matrix = this._canvasTransform.identity();
			var pixelWidth:Number = canvasWidth * pixelRatio;
			var pixelHeight:Number = canvasHeight * pixelRatio;
			var screenRatio:Number = canvasWidth / canvasHeight;
			
			var width:Number = _oldSize.x;
			var height:Number = _oldSize.y;
			//计算画布大小
			if (_sizeMode === SIZE_FULL) {
				width = pixelWidth;
				height = pixelHeight;
			} else if (_sizeMode === SIZE_FULL_WIDTH) {
				height = _oldSize.y;
				width = _height * screenRatio;
			} else if (_sizeMode === SIZE_FULL_HEIGHT) {
				width = _oldSize.x;
				height = _width / screenRatio;
			}
			_width = width;
			_height = height;
			canvas.size(width, height);
			System.changeWebGLSize(width, height);
			
			//处理缩放模式
			var scaleX:Number = pixelWidth / _oldSize.x;
			var scaleY:Number = pixelHeight / _oldSize.y;
			if (_scaleMode === SCALE_SHOWALL) {
				//显示全部内容，按照最小缩放比缩放
				scaleX = scaleY = Math.min(scaleX, scaleY);
			} else if (_scaleMode === SCALE_NOBORDER) {
				//等比缩放填满屏幕
				scaleX = scaleY = Math.max(scaleX, scaleY);
			} else if (_scaleMode === SCALE_NOSCALE) {
				//不缩放
				scaleX = scaleY = 1;
			}
			//根据不同尺寸缩放stage画面
			if (scaleX === 1 && scaleY === 1) {
				transform && transform.identity();
			} else {
				transform || (transform = new Matrix());
				transform.a = scaleX;
				transform.d = scaleY;
			}
			
			//按照实际像素显示
			if (_sizeMode === SIZE_NONE) {
				//canvasStyle.width = Math.round(canvas.width / Browser.pixelRatio) + 'px';
				//canvasStyle.height = Math.round(canvas.height / Browser.pixelRatio) + 'px';
				
				canvas.size(_oldSize.x * scaleX, _oldSize.y * scaleY);
				System.changeWebGLSize(canvas.width, canvas.height);
				mat.scale(1 / pixelRatio, 1 / pixelRatio);
				
				//处理水平对齐
				if (_alignH === ALIGN_LEFT) offset.x = 0;
				else if (_alignH === ALIGN_RIGHT) offset.x = pixelWidth - canvas.width / pixelRatio;
				else offset.x = (pixelWidth - canvas.width) * 0.5 / pixelRatio;
				//canvasStyle.left = offset.x;
				
				//处理垂直对齐
				if (_alignV === ALIGN_TOP) offset.y = 0;
				else if (_alignV === ALIGN_BOTTOM) offset.y = pixelHeight - canvas.height / pixelRatio;
				else offset.y = (pixelHeight - canvas.height) * 0.5 / pixelRatio;
				//canvasStyle.top = offset.y;			   
				mat.translate(offset.x, offset.y);
				
			} else {
				_width = width / scaleX;
				_height = height / scaleY;
				//canvasStyle.width = canvasWidth + 'px';
				//canvasStyle.height = canvasHeight + 'px';
				mat.scale(canvasWidth / canvas.width, canvasHeight / canvas.height);
			}
			
			//处理横竖屏
			if (rotation) {
				if (_screenMode === SCREEN_HORIZONTAL) {
					mat.rotate(Math.PI / 2);
					mat.translate(canvasHeight, 0);
				} else {
					mat.rotate(-Math.PI / 2);
					mat.translate(0, canvasWidth);
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
		 *
		 * <p><ul>取值范围：
		 * <li>"noScale" ：不缩放；</li>
		 * <li>"exactFit" ：全屏不等比缩放；</li>
		 * <li>"showAll" ：最小比例缩放；</li>
		 * <li>"noBorder" ：最大比例缩放；</li>
		 * </ul></p>
		 * 默认值为"noScale"。
		 * */
		public function get scaleMode():String {
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void {
			_scaleMode = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		/**
		 * 应用程序大小模式。
		 * <p><ul>取值范围：
		 * <li>"full"；</li>
		 * <li>"none"；</li>
		 * </ul></p>
		 * 默认值为"none"。
		 * */
		public function get sizeMode():String {
			return _sizeMode;
		}
		
		public function set sizeMode(value:String):void {
			_sizeMode = value;
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
		 * */
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
		 * */
		public function get alignV():String {
			return _alignV;
		}
		
		public function set alignV(value:String):void {
			_alignV = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		/**使用高清渲染，默认为true*/
		public function get useHDRendering():Boolean {
			return _useHDRendering;
		}
		
		public function set useHDRendering(value:Boolean):void {
			_useHDRendering = value;
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
		
		/**鼠标在 Stage 上的X坐标。*/
		override public function get mouseX():Number {
			// River: 加入了round.
			return Math.round(MouseManager.instance.mouseX / (_transform ? _transform.a : 1));
		}
		
		/**鼠标在 Stage 上的Y坐标。*/
		override public function get mouseY():Number {
			// River:加入了round.
			return Math.round(MouseManager.instance.mouseY / (_transform ? _transform.d : 1));
		}
		
		/**当前视窗X轴缩放大小。*/
		public function get clientScaleX():Number {
			return _transform ? _transform.a : 1;
		}
		
		/**当前视窗Y轴缩放大小。*/
		public function get clientScaleY():Number {
			return _transform ? _transform.d : 1;
		}
		
		/**
		 * 场景布局类型
		 * <p><ul>取值范围：
		 * <li>"none" ：不更改屏幕</li>
		 * <li>"horizontal" ：自动横屏</li>
		 * <li>"vertical" ：自动竖屏</li>
		 * </ul></p>
		 * */
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