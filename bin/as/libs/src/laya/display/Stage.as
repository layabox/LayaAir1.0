package laya.display {
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	import laya.utils.VectorGraphManager;
	
	/**
	 * stage大小经过重新调整时进行调度。
	 * @eventType Event.RESIZE
	 */
	[Event(name = "resize", type = "laya.events.Event")]
	/**
	 * 舞台获得焦点时调度。比如浏览器或者当前标签被切换到后台后，重新切换回来时。
	 * @eventType Event.FOCUS
	 */
	[Event(name = "focus", type = "laya.events.Event")]
	/**
	 * 舞台失去焦点时调度。比如浏览器或者当前标签被切换到后台后调度。
	 * @eventType Event.BLUR
	 */
	[Event(name = "blur", type = "laya.events.Event")]
	/**
	 * 浏览器全屏更改时调度，比如进入全屏或者退出全屏。
	 * @eventType Event.FULL_SCREEN_CHANGE
	 */
	[Event(name = "fullscreenchange", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Stage</code> 类是显示对象的根节点。</p>
	 * 可以通过 Laya.stage 访问。
	 */
	public class Stage extends Sprite {
		/**应用保持设计宽高不变，不缩放不变型，stage的宽高等于设计宽高。*/
		public static const SCALE_NOSCALE:String = "noscale";
		/**应用根据屏幕大小铺满全屏，非等比缩放会变型，stage的宽高等于设计宽高。*/
		public static const SCALE_EXACTFIT:String = "exactfit";
		/**应用显示全部内容，按照最小比率缩放，等比缩放不变型，一边可能会留空白，stage的宽高等于设计宽高。*/
		public static const SCALE_SHOWALL:String = "showall";
		/**应用按照最大比率缩放显示，宽或高方向会显示一部分，等比缩放不变型，stage的宽高等于设计宽高。*/
		public static const SCALE_NOBORDER:String = "noborder";
		/**应用保持设计宽高不变，不缩放不变型，stage的宽高等于屏幕宽高。*/
		public static const SCALE_FULL:String = "full";
		/**应用保持设计宽度不变，高度根据屏幕比缩放，stage的宽度等于设计宽度，高度根据屏幕比率大小而变化*/
		public static const SCALE_FIXED_WIDTH:String = "fixedwidth";
		/**应用保持设计高度不变，宽度根据屏幕比缩放，stage的高度等于设计宽度，宽度根据屏幕比率大小而变化*/
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
		/**休眠模式，以1的帧率运行*/
		public static const FRAME_SLEEP:String = "sleep";
		
		/**当前焦点对象，此对象会影响当前键盘事件的派发主体。*/
		public var focus:Node;
		/**@private 相对浏览器左上角的偏移，弃用，请使用_canvasTransform。*/
		public var offset:Point = new Point();
		///**@private 开发者自己设置的画布偏移*/
		//private var _offset:Point;
		/**帧率类型，支持三种模式：fast-60帧(默认)，slow-30帧，mouse-30帧，但鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗。*/
		public var frameRate:String = "fast";
		/**设计宽度（初始化时设置的宽度Laya.init(width,height)）*/
		public var desginWidth:Number = 0;
		/**设计高度（初始化时设置的高度Laya.init(width,height)）*/
		public var desginHeight:Number = 0;
		/**画布是否发生翻转。*/
		public var canvasRotation:Boolean = false;
		/**画布旋转角度。*/
		public var canvasDegree:int = 0;
		/**设置是否渲染，设置为false，可以停止渲染，画面会停留到最后一次渲染上，减少cpu消耗，此设置不影响时钟*/
		public var renderingEnabled:Boolean = true;
		
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
		private var _mouseMoveTime:Number = 0;
		/** @private */
		private var _renderCount:int = 0;
		/** @private */
		private var _safariOffsetY:Number = 0;
		/**@private */
		private var _frameStartTime:Number;
		/**@private */
		private var _previousOrientation:int;
		/**@private 3D场景*/
		public var _scenes:Array;
		
		public function Stage() {
			transform = Matrix.create();
			_scenes = [];
			this.mouseEnabled = true;
			this.hitTestPrior = true;
			this.autoSize = false;
			this._displayedInStage = true;
			
			var _this:Stage = this;
			var window:* = Browser.window;
			
			window.addEventListener("focus", function():void {
				_this.event(Event.FOCUS);
			});
			window.addEventListener("blur", function():void {
				_this.event(Event.BLUR);
				if (_this._isInputting()) Input["inputElement"].target.focus = false;
			});
			// 各种浏览器兼容
			var hidden:String = "hidden", state:String = "visibilityState", visibilityChange:String = "visibilitychange";
			var document:* = window.document;
			if (typeof document.hidden !== "undefined") {
				visibilityChange = "visibilitychange";
				state = "visibilityState";
			} else if (typeof document.mozHidden !== "undefined") {
				visibilityChange = "mozvisibilitychange";
				state = "mozVisibilityState";
			} else if (typeof document.msHidden !== "undefined") {
				visibilityChange = "msvisibilitychange";
				state = "msVisibilityState";
			} else if (typeof document.webkitHidden !== "undefined") {
				visibilityChange = "webkitvisibilitychange";
				state = "webkitVisibilityState";
			}
			
			window.document.addEventListener(visibilityChange, visibleChangeFun);
			function visibleChangeFun():void {
				if (Browser.document[state] == "hidden") {
					_this.event(Event.BLUR);
					if (_this._isInputting()) Input["inputElement"].target.focus = false;
				} else {
					_this.event(Event.FOCUS);
				}
			}
			window.addEventListener("resize", function():void {
				// 处理屏幕旋转。旋转后收起输入法。
				var orientation:* = Browser.window.orientation;
				if (orientation != null && orientation != _previousOrientation && _this._isInputting()) {
					Input["inputElement"].target.focus = false;
				}
				_previousOrientation = orientation;
				
				// 弹出输入法不应对画布进行resize。
				if (_this._isInputting()) return;
				
				// Safari横屏工具栏偏移
				if (Browser.onSafari)
					_this._safariOffsetY = (Browser.window.__innerHeight || Browser.document.body.clientHeight || Browser.document.documentElement.clientHeight) - Browser.window.innerHeight;
				
				_this._resetCanvas();
			});
			
			// 微信的iframe不触发orientationchange。
			window.addEventListener("orientationchange", function(e:*):void {
				_this._resetCanvas();
			});
			
			on(Event.MOUSE_MOVE, this, _onmouseMove);
			if (Browser.onMobile) on(Event.MOUSE_DOWN, this, _onmouseMove);
		}
		
		/**
		 * 在移动端输入时，输入法弹出期间不进行画布尺寸重置。
		 */
		private function _isInputting():Boolean {
			return (Browser.onMobile && Input.isInputting);
		}
		
		override public function set width(value:Number):void {
			this.desginWidth = value;
			super.width = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		override public function set height(value:Number):void {
			this.desginHeight = value;
			super.height = value;
			Laya.timer.callLater(this, _changeCanvasSize);
		}
		
		/** @private */
		private function _changeCanvasSize():void {
			setScreenSize(Browser.clientWidth * Browser.pixelRatio, Browser.clientHeight * Browser.pixelRatio);
		}
		
		/** @private */
		protected function _resetCanvas():void {
			var canvas:HTMLCanvas = Render._mainCanvas;
			var canvasStyle:* = canvas.source.style;
			canvas.size(1, 1);
			canvasStyle.transform = canvasStyle.webkitTransform = canvasStyle.msTransform = canvasStyle.mozTransform = canvasStyle.oTransform = "";
			visible = false;
			Laya.timer.once(100, this, this._changeCanvasSize);
		}
		
		/**
		 * 设置屏幕大小，场景会根据屏幕大小进行适配。
		 * @param	screenWidth		屏幕宽度。
		 * @param	screenHeight	屏幕高度。
		 */
		public function setScreenSize(screenWidth:Number, screenHeight:Number):void {
			//计算是否旋转
			var rotation:Boolean = false;
			if (_screenMode !== SCREEN_NONE) {
				var screenType:String = screenWidth / screenHeight < 1 ? SCREEN_VERTICAL : SCREEN_HORIZONTAL;
				rotation = screenType !== _screenMode;
				/*[IF-FLASH]*/
				rotation = false;
				if (rotation) {
					//宽高互换
					var temp:Number = screenHeight;
					screenHeight = screenWidth;
					screenWidth = temp;
				}
			}
			this.canvasRotation = rotation;
			
			var canvas:HTMLCanvas = Render._mainCanvas;
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
				canvasWidth = realWidth = Math.round(desginWidth * scaleX);
				canvasHeight = realHeight = Math.round(desginHeight * scaleY);
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
			scaleX *= this.scaleX;
			scaleY *= this.scaleY;
			if (scaleX === 1 && scaleY === 1) {
				transform.identity();
			} else {
				transform.a = _formatData(scaleX / (realWidth / canvasWidth));
				transform.d = _formatData(scaleY / (realHeight / canvasHeight));
				conchModel && conchModel.scale(transform.a, transform.d);//由于上面的两句通知不到微端
			}
			
			//处理canvas大小			
			canvas.size(canvasWidth, canvasHeight);
			RunDriver.changeWebGLSize(canvasWidth, canvasHeight);
			mat.scale(realWidth / canvasWidth / pixelRatio, realHeight / canvasHeight / pixelRatio);
			
			//处理水平对齐
			if (_alignH === ALIGN_LEFT) offset.x = 0;
			else if (_alignH === ALIGN_RIGHT) offset.x = screenWidth - realWidth;
			else offset.x = (screenWidth - realWidth) * 0.5 / pixelRatio;
			
			//处理垂直对齐
			if (_alignV === ALIGN_TOP) offset.y = 0;
			else if (_alignV === ALIGN_BOTTOM) offset.y = screenHeight - realHeight;
			else offset.y = (screenHeight - realHeight) * 0.5 / pixelRatio;
			
			////处理用户自行设置的画布偏移
			//if (!_offset) {
			//_offset = new Point(parseInt(canvasStyle.left) || 0, parseInt(canvasStyle.top) || 0);
			//canvasStyle.left = canvasStyle.top = "0px";
			//}
			//offset.x += _offset.x;
			//offset.y += _offset.y;
			offset.x = Math.round(offset.x);
			offset.y = Math.round(offset.y);
			mat.translate(offset.x, offset.y);
			if (_safariOffsetY && parseInt(canvasStyle.top) === 0) canvasStyle.top = _safariOffsetY + "px";
			
			//处理横竖屏
			canvasDegree = 0;
			if (rotation) {
				if (_screenMode === SCREEN_HORIZONTAL) {
					mat.rotate(Math.PI / 2);
					mat.translate(screenHeight / pixelRatio, 0);
					canvasDegree = 90;
				} else {
					mat.rotate(-Math.PI / 2);
					mat.translate(0, screenWidth / pixelRatio);
					canvasDegree = -90;
				}
			}
			
			mat.a = _formatData(mat.a);
			mat.d = _formatData(mat.d);
			mat.tx = _formatData(mat.tx);
			mat.ty = _formatData(mat.ty);
			//if (Math.abs(mat.a) < 0.00000001) mat.a = mat.d = 0;
			//if (Math.abs(mat.tx) < 0.00000001) mat.tx = 0;
			//if (Math.abs(mat.ty) < 0.00000001) mat.ty = 0;
			canvasStyle.transformOrigin = canvasStyle.webkitTransformOrigin = canvasStyle.msTransformOrigin = canvasStyle.mozTransformOrigin = canvasStyle.oTransformOrigin = "0px 0px 0px";
			canvasStyle.transform = canvasStyle.webkitTransform = canvasStyle.msTransform = canvasStyle.mozTransform = canvasStyle.oTransform = "matrix(" + mat.toString() + ")";
			//修正用户自行设置的偏移
			//var rect:* = canvas.source.getBoundingClientRect();
			mat.translate(parseInt(canvasStyle.left) || 0, parseInt(canvasStyle.top) || 0);
			visible = true;
			_repaint = 1;
			event(Event.RESIZE);
		}
		
		private function _formatData(value:Number):Number {
			if (Math.abs(value) < 0.000001) return 0;
			if (Math.abs(1 - value) < 0.001) return value > 0 ? 1 : -1;
			return value;
		}
		
		/**
		 * <p>缩放模式。</p>
		 * <p><ul>取值范围：
		 * <li>"noscale" ：不缩放；</li>
		 * <li>"exactfit" ：全屏不等比缩放；</li>
		 * <li>"showall" ：最小比例缩放；</li>
		 * <li>"noborder" ：最大比例缩放；</li>
		 * <li>"full" ：不缩放，stage的宽高等于屏幕宽高；</li>
		 * <li>"fixedwidth" ：宽度不变，高度根据屏幕比缩放；</li>
		 * <li>"fixedheight" ：高度不变，宽度根据屏幕比缩放；</li>
		 * </ul></p>
		 * 默认值为 "noscale"。
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
			conchModel && conchModel.bgColor(value);
			if (value) {
				Render.canvas.style.background = value;
			} else {
				Render.canvas.style.background = "none";
			}
		}
		
		/** 鼠标在 Stage 上的 X 轴坐标。*/
		override public function get mouseX():Number {
			// River: 加入了round.
			return Math.round(MouseManager.instance.mouseX / clientScaleX);
		}
		
		/**鼠标在 Stage 上的 Y 轴坐标。*/
		override public function get mouseY():Number {
			// River:加入了round.
			return Math.round(MouseManager.instance.mouseY / clientScaleY);
		}
		
		/**@inheritDoc */
		override public function getMousePoint():Point {
			return Point.TEMP.setTo(mouseX, mouseY);
		}
		
		/**当前视窗由缩放模式导致的 X 轴缩放系数。*/
		public function get clientScaleX():Number {
			return _transform ? _transform.getScaleX() : 1;
		}
		
		/**当前视窗由缩放模式导致的 Y 轴缩放系数。*/
		public function get clientScaleY():Number {
			return _transform ? _transform.getScaleY() : 1;
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
		override public function parentRepaint():void {
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
		
		/**获得距当前帧开始后，过了多少时间，单位为毫秒
		 * 可以用来判断函数内时间消耗，控制每帧函数处理消耗的时间过长，导致帧率下降*/
		public function getTimeFromFrameStart():Number {
			return Browser.now() - _frameStartTime;
		}
		
		public override function set visible(value:Boolean):void {
			if (this.visible !== value) {
				super.visible = value;
				var style:* = Render._mainCanvas.source.style;
				style.visibility = value ? "visible" : "hidden";
			}
		}
		
		/**@inheritDoc */
		override public function render(context:RenderContext, x:Number, y:Number):void {
			if (frameRate === FRAME_SLEEP) {
				var now:Number = Browser.now();
				if (now - _frameStartTime >= 1000) _frameStartTime = now;
				else return;
			}
			
			_renderCount++;
			Render.isFlash && repaint();
			
			if (!visible) {
				if (_renderCount % 5 === 0) {
					Stat.loopCount++;
					MouseManager.instance.runEvent();
					Laya.timer._update();
				}
				return;
			}
			
			_frameStartTime = Browser.now();
			var frameMode:String = frameRate === FRAME_MOUSE ? (((_frameStartTime - _mouseMoveTime) < 2000) ? FRAME_FAST : FRAME_SLOW) : frameRate;
			var isFastMode:Boolean = (frameMode !== FRAME_SLOW);
			var isDoubleLoop:Boolean = (_renderCount % 2 === 0);
			
			Stat.renderSlow = !isFastMode;
			
			if (isFastMode || isDoubleLoop) {
				Stat.loopCount++;
				MouseManager.instance.runEvent();
				Laya.timer._update();
				
				var i:int, n:int;
				for (i = 0, n = _scenes.length; i < n; i++) {
					var scene:* = _scenes[i];
					(scene) && (scene._updateScene());
				}
				
				if (Render.isConchNode) {//NATIVE
					var customList:Array = Sprite.CustomList;
					for (i = 0, n = customList.length; i < n; i++) {
						var customItem:* = customList[i];
						customItem.customRender(customItem.customContext, 0, 0);
					}
					return;
				}
				if (Render.isWebGL && renderingEnabled) {
					context.clear();
					super.render(context, x, y);
				}
			}
			if (Render.isConchNode) return;//NATIVE
			if (renderingEnabled && (isFastMode || !isDoubleLoop)) {
				if (Render.isWebGL) {
					RunDriver.clear(_bgColor);
					RunDriver.beginFlush();
					context.flush();
					RunDriver.endFinish();
					VectorGraphManager.instance && VectorGraphManager.getInstance().endDispose();
				} else {
					RunDriver.clear(_bgColor);
					super.render(context, x, y);
				}
			}
		}
		
		/**是否开启全屏，用户点击后进入全屏*/
		public function set fullScreenEnabled(value:Boolean):void {
			var document:* = Browser.document;
			var canvas:* = Render.canvas;
			if (value) {
				canvas.addEventListener('mousedown', _requestFullscreen);
				canvas.addEventListener('touchstart', _requestFullscreen);
				document.addEventListener("fullscreenchange", _fullScreenChanged);
				document.addEventListener("mozfullscreenchange", _fullScreenChanged);
				document.addEventListener("webkitfullscreenchange", _fullScreenChanged);
				document.addEventListener("msfullscreenchange", _fullScreenChanged);
			} else {
				canvas.removeEventListener('mousedown', _requestFullscreen);
				canvas.removeEventListener('touchstart', _requestFullscreen);
				document.removeEventListener("fullscreenchange", _fullScreenChanged);
				document.removeEventListener("mozfullscreenchange", _fullScreenChanged);
				document.removeEventListener("webkitfullscreenchange", _fullScreenChanged);
				document.removeEventListener("msfullscreenchange", _fullScreenChanged);
			}
		}
		
		/**@private */
		private function _requestFullscreen():void {
			var element:* = Browser.document.documentElement;
			if (element.requestFullscreen) {
				element.requestFullscreen();
			} else if (element.mozRequestFullScreen) {
				element.mozRequestFullScreen();
			} else if (element.webkitRequestFullscreen) {
				element.webkitRequestFullscreen();
			} else if (element.msRequestFullscreen) {
				element.msRequestFullscreen();
			}
		}
		
		/**@private */
		private function _fullScreenChanged():void {
			Laya.stage.event(Event.FULL_SCREEN_CHANGE);
		}
		
		/**退出全屏*/
		public function exitFullscreen():void {
			var document:* = Browser.document;
			if (document.exitFullscreen) {
				document.exitFullscreen();
			} else if (document.mozCancelFullScreen) {
				document.mozCancelFullScreen();
			} else if (document.webkitExitFullscreen) {
				document.webkitExitFullscreen();
			}
		}
	}
}