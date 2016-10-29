package laya.ui {
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	/**
	 * 图片加载完成后调度。
	 * @eventType Event.LOADED
	 */
	[Event(name = "loaded", type = "laya.events.Event")]
	/**
	 * 当前帧发生变化后调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Clip</code> 类是位图切片动画。</p>
	 * <p> <code>Clip</code> 可将一张图片，按横向分割数量 <code>clipX</code> 、竖向分割数量 <code>clipY</code> ，
	 * 或横向分割每个切片的宽度 <code>clipWidth</code> 、竖向分割每个切片的高度 <code>clipHeight</code> ，
	 * 从左向右，从上到下，分割组合为一个切片动画。</p>
	 *
	 * @example 以下示例代码，创建了一个 <code>Clip</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.Clip;
	 *		public class Clip_Example
	 *		{
	 *			private var clip:Clip;
	 *			public function Clip_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				onInit();
	 *			}
	 *			private function onInit():void
	 *			{
	 *				clip = new Clip("resource/ui/clip_num.png", 10, 1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
	 *				clip.autoPlay = true;//设置 clip 动画自动播放。
	 *				clip.interval = 100;//设置 clip 动画的播放时间间隔。
	 *				clip.x = 100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
	 *				clip.y = 100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
	 *				clip.on(Event.CLICK, this, onClick);//给 clip 添加点击事件函数侦听。
	 *				Laya.stage.addChild(clip);//将此 clip 对象添加到显示列表。
	 *			}
	 *			private function onClick():void
	 *			{
	 *				trace("clip 的点击事件侦听处理函数。clip.total="+ clip.total);
	 *				if (clip.isPlaying == true)
	 *				{
	 *					clip.stop();//停止动画。
	 *				}else {
	 *					clip.play();//播放动画。
	 *				}
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * var clip;
	 * Laya.loader.load("resource/ui/clip_num.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	 * function loadComplete() {
	 *     console.log("资源加载完成！");
	 *     clip = new laya.ui.Clip("resource/ui/clip_num.png",10,1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
	 *     clip.autoPlay = true;//设置 clip 动画自动播放。
	 *     clip.interval = 100;//设置 clip 动画的播放时间间隔。
	 *     clip.x =100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
	 *     clip.y =100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
	 *     clip.on(Event.CLICK,this,onClick);//给 clip 添加点击事件函数侦听。
	 *     Laya.stage.addChild(clip);//将此 clip 对象添加到显示列表。
	 * }
	 * function onClick()
	 * {
	 *     console.log("clip 的点击事件侦听处理函数。");
	 *     if(clip.isPlaying == true)
	 *     {
	 *         clip.stop();
	 *     }else {
	 *         clip.play();
	 *     }
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Clip = laya.ui.Clip;
	 * import Handler = laya.utils.Handler;
	 * class Clip_Example {
	 *     private clip: Clip;
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         this.onInit();
	 *     }
	 *     private onInit(): void {
	 *         this.clip = new Clip("resource/ui/clip_num.png", 10, 1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
	 *         this.clip.autoPlay = true;//设置 clip 动画自动播放。
	 *         this.clip.interval = 100;//设置 clip 动画的播放时间间隔。
	 *         this.clip.x = 100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
	 *         this.clip.y = 100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
	 *         this.clip.on(laya.events.Event.CLICK, this, this.onClick);//给 clip 添加点击事件函数侦听。
	 *         Laya.stage.addChild(this.clip);//将此 clip 对象添加到显示列表。
	 *     }
	 *     private onClick(): void {
	 *         console.log("clip 的点击事件侦听处理函数。clip.total=" + this.clip.total);
	 *         if (this.clip.isPlaying == true) {
	 *             this.clip.stop();//停止动画。
	 *         } else {
	 *             this.clip.play();//播放动画。
	 *         }
	 *     }
	 * }
	 *
	 * </listing>
	 */
	public class Clip extends Component {
		/**@private */
		protected var _sources:Array;
		/**@private */
		protected var _bitmap:AutoBitmap;
		/**@private */
		protected var _skin:String;
		/**@private */
		protected var _clipX:int = 1;
		/**@private */
		protected var _clipY:int = 1;
		/**@private */
		protected var _clipWidth:Number = 0;
		/**@private */
		protected var _clipHeight:Number = 0;
		/**@private */
		protected var _autoPlay:Boolean;
		/**@private */
		protected var _interval:int = 50;
		/**@private */
		protected var _complete:Handler;
		/**@private */
		protected var _isPlaying:Boolean;
		/**@private */
		protected var _index:int = 0;
		/**@private */
		protected var _clipChanged:Boolean;
		/**@private */
		protected var _group:String;
		
		/**
		 * 创建一个新的 <code>Clip</code> 示例。
		 * @param url 资源类库名或者地址
		 * @param clipX x方向分割个数
		 * @param clipY y方向分割个数
		 */
		public function Clip(url:String = null, clipX:int = 1, clipY:int = 1) {
			_clipX = clipX;
			_clipY = clipY;
			this.skin = url;
		}
		
		/**@inheritDoc */
		override public function destroy(clearFromCache:Boolean = false):void {
			super.destroy(true);
			_bitmap && _bitmap.destroy();
			_bitmap = null;
			_sources = null;
		}
		
		/**
		 * 销毁对象并释放加载的皮肤资源。
		 */
		public function dispose():void {
			destroy(true);
			Laya.loader.clearRes(_skin);
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			graphics = _bitmap = new AutoBitmap();
		}
		
		/**@inheritDoc */
		override protected function initialize():void {
			on(Event.DISPLAY, this, _onDisplay);
			on(Event.UNDISPLAY, this, _onDisplay);
		}
		
		/**@private	 */
		protected function _onDisplay(e:Event = null):void {
			if (_isPlaying) {
				if (_displayedInStage) play();
				else stop();
			} else if (_autoPlay && _displayedInStage) {
				play();
			}
		}
		
		/**
		 * @copy laya.ui.Image#skin
		 */
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				if (value) {
					_setClipChanged()
				} else {
					_bitmap.source = null;
				}
			}
		}
		
		/**X轴（横向）切片数量。*/
		public function get clipX():int {
			return _clipX;
		}
		
		public function set clipX(value:int):void {
			_clipX = value;
			_setClipChanged()
		}
		
		/**Y轴(竖向)切片数量。*/
		public function get clipY():int {
			return _clipY;
		}
		
		public function set clipY(value:int):void {
			_clipY = value;
			_setClipChanged()
		}
		
		/**
		 * 横向分割时每个切片的宽度，与 <code>clipX</code> 同时设置时优先级高于 <code>clipX</code> 。
		 */
		public function get clipWidth():Number {
			return _clipWidth;
		}
		
		public function set clipWidth(value:Number):void {
			_clipWidth = value;
			_setClipChanged()
		}
		
		/**
		 * 竖向分割时每个切片的高度，与 <code>clipY</code> 同时设置时优先级高于 <code>clipY</code> 。
		 */
		public function get clipHeight():Number {
			return _clipHeight;
		}
		
		public function set clipHeight(value:Number):void {
			_clipHeight = value;
			_setClipChanged()
		}
		
		/**
		 * @private
		 * 改变切片的资源、切片的大小。
		 */
		protected function changeClip():void {
			_clipChanged = false;
			if (!_skin) return;
			var img:* = Loader.getRes(_skin);
			if (img) {
				loadComplete(_skin, img);
			} else {
				Laya.loader.load(_skin, Handler.create(this, loadComplete, [_skin]));
			}
		}
		
		/**
		 * @private
		 * 加载切片图片资源完成函数。
		 * @param url 资源地址。
		 * @param img 纹理。
		 */
		protected function loadComplete(url:String, img:Texture):void {
			if (url === _skin && img) {
				_clipWidth || (_clipWidth = Math.ceil(img.sourceWidth / _clipX));
				_clipHeight || (_clipHeight = Math.ceil(img.sourceHeight / _clipY));
				
				var key:String = _skin + _clipWidth + _clipHeight;
				var clips:Array = AutoBitmap.getCache(key);
				if (clips) _sources = clips;
				else {
					_sources = [];
					for (var i:int = 0; i < _clipY; i++) {
						for (var j:int = 0; j < _clipX; j++) {
							_sources.push(Texture.createFromTexture(img, _clipWidth * j, _clipHeight * i, _clipWidth, _clipHeight));
						}
					}
					AutoBitmap.setCache(key, _sources);
				}
				
				index = _index;
				event(Event.LOADED);
				onCompResize();
			}
		}
		
		/**
		 * 源数据。
		 */
		public function get sources():Array {
			return _sources;
		}
		
		public function set sources(value:Array):void {
			_sources = value;
			index = _index;
			event(Event.LOADED);
		}
		
		/**
		 * 资源分组。
		 */
		public function get group():String {
			return _group;
		}
		
		public function set group(value:String):void {
			if (value && _skin) Loader.setGroup(_skin, value);
			_group = value;
		}
		
		/**@inheritDoc */
		override public function set width(value:Number):void {
			super.width = value;
			_bitmap.width = value;
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			super.height = value;
			_bitmap.height = value;
		}
		
		/**@inheritDoc */
		override protected function get measureWidth():Number {
			runCallLater(changeClip);
			return _bitmap.width;
		}
		
		/**@inheritDoc */
		override protected function get measureHeight():Number {
			runCallLater(changeClip);
			return _bitmap.height;
		}
		
		/**
		 * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
		 * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		 * <ul><li>例如："4,4,4,4,1"</li></ul></p>
		 * @see laya.ui.AutoBitmap.sizeGrid
		 */
		public function get sizeGrid():String {
			if (_bitmap.sizeGrid) return _bitmap.sizeGrid.join(",");
			return null;
		}
		
		public function set sizeGrid(value:String):void {
			_bitmap.sizeGrid = UIUtils.fillArray(Styles.defaultSizeGrid, value, Number);
		}
		
		/**
		 * 当前帧索引。
		 */
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
			_bitmap && _sources && (_bitmap.source = _sources[value]);
			event(Event.CHANGE);
		}
		
		/**
		 * 切片动画的总帧数。
		 */
		public function get total():int {
			runCallLater(changeClip);
			return _sources ? _sources.length : 0;
		}
		
		/**
		 * 表示是否自动播放动画，若自动播放值为true,否则值为false;
		 * <p>可控制切片动画的播放、停止。</p>
		 */
		public function get autoPlay():Boolean {
			return _autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void {
			if (_autoPlay != value) {
				_autoPlay = value;
				value ? play() : stop();
			}
		}
		
		/**
		 * 表示动画播放间隔时间(以毫秒为单位)。
		 */
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			if (_interval != value) {
				_interval = value;
				if (_isPlaying) play();
			}
		}
		
		/**
		 * 表示动画的当前播放状态。
		 * 如果动画正在播放中，则为true，否则为flash。
		 */
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void {
			_isPlaying = value;
		}
		
		/**
		 * 播放动画。
		 */
		public function play():void {
			_isPlaying = true;
			this.index = 0;
			this._index++;
			Laya.timer.loop(this.interval, this, _loop);
		}
		
		/**
		 * @private
		 */
		protected function _loop():void {
			if (_style.visible && this._sources) {
				this.index = _index, _index++;
				this._index >= this._sources.length && (this._index = 0);
			}
		}
		
		/**
		 * 停止动画。
		 */
		public function stop():void {
			this._isPlaying = false;
			Laya.timer.clear(this, _loop);
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is int || value is String) index = parseInt(value);
			else super.dataSource = value;
		}
		
		/**
		 * <code>AutoBitmap</code> 位图实例。
		 */
		public function get bitmap():AutoBitmap {
			return _bitmap;
		}
		
		/**@private */
		protected function _setClipChanged():void {
			if (!_clipChanged) {
				_clipChanged = true;
				callLater(changeClip);
			}
		}
	}
}