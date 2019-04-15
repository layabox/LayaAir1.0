package laya.display {
	import laya.Const;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.SceneLoader;
	import laya.resource.Resource;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.SceneUtils;
	import laya.utils.Timer;
	
	/**
	 * 场景类，负责场景创建，加载，销毁等功能
	 * 场景被从节点移除后，并不会被自动垃圾机制回收，如果想回收，请调用destroy接口，可以通过unDestroyedScenes属性查看还未被销毁的场景列表
	 */
	public class Scene extends Sprite {
		/**创建后，还未被销毁的场景列表，方便查看还未被销毁的场景列表，方便内存管理，本属性只读，请不要直接修改*/
		public static var unDestroyedScenes:Array = [];
		/**获取根节点*/
		private static var _root:Sprite;
		/**@private */
		private static var _loadPage:Scene;
		
		/**场景被关闭后，是否自动销毁（销毁节点和使用到的资源），默认为false*/
		public var autoDestroyAtClosed:Boolean = false;
		/**场景地址*/
		public var url:String = null;
		
		/**场景时钟*/
		private var _timer:Timer;
		/**@private */
		private var _viewCreated:Boolean = false;
		/**@private */
		public var _idMap:Object;
		/**@private */
		public var _$componentType:String = "Scene";
		
		public function Scene() {
			this._setBit(Const.NOT_READY, true);
			unDestroyedScenes.push(this);
			this._scene = this;
			createChildren();
		}
		
		/**
		 * @private 兼容老项目
		 */
		protected function createChildren():void {
		}
		
		/**
		 * @private 兼容老项目
		 * 装载场景视图。用于加载模式。
		 * @param path 场景地址。
		 */
		public function loadScene(path:String):void {
			var url:String = path.indexOf(".") > -1 ? path : path + ".scene";
			var view:Object = Laya.loader.getRes(url);
			if (view) {
				createView(view);
			} else {
				Laya.loader.resetProgress();
				var loader:SceneLoader = new SceneLoader();
				loader.on(Event.COMPLETE, this, this._onSceneLoaded, [url]);
				loader.load(url);
					//Laya.loader.load(url, Handler.create(this, createView), null, Loader.JSON);
			}
		}
		
		private function _onSceneLoaded(url:String):void {
			createView(Loader.getRes(url));
		}
		
		/**
		 * @private 兼容老项目
		 * 通过视图数据创建视图。
		 * @param uiView 视图数据信息。
		 */
		public function createView(view:Object):void {
			if (view && !_viewCreated) {
				_viewCreated = true;
				SceneUtils.createByData(this, view);
			}
		}
		
		/**
		 * 根据IDE内的节点id，获得节点实例
		 */
		public function getNodeByID(id:int):* {
			if (_idMap) return _idMap[id];
			return null;
		}
		
		/**
		 * 打开场景。【注意】被关闭的场景，如果没有设置autoDestroyAtRemoved=true，则资源可能不能被回收，需要自己手动回收
		 * @param	closeOther	是否关闭其他场景，默认为true（可选）
		 * @param	param		打开页面的参数，会传递给onOpened方法（可选）
		 */
		public function open(closeOther:Boolean = true, param:* = null):void {
			if (closeOther) closeAll();
			root.addChild(this);
			onOpened(param);
		}
		
		/**场景打开完成后，调用此方法（如果有弹出动画，则在动画完成后执行）*/
		public function onOpened(param:*):void {
			//trace("onOpened");
		}
		
		/**
		 * 关闭场景
		 * 【注意】被关闭的场景，如果没有设置autoDestroyAtRemoved=true，则资源可能不能被回收，需要自己手动回收
		 * @param type 关闭的原因，会传递给onClosed函数
		 */
		public function close(type:String = null):void {
			onClosed(type);
			if (autoDestroyAtClosed) this.destroy();
			else removeSelf();
		}
		
		/**关闭完成后，调用此方法（如果有关闭动画，则在动画完成后执行）
		 * @param type 如果是点击默认关闭按钮触发，则传入关闭按钮的名字(name)，否则为null。
		 */
		public function onClosed(type:String = null):void {
			//trace("onClosed");
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			_idMap = null;
			super.destroy(destroyChild);
			var list:Array = Scene.unDestroyedScenes;
			for (var i:int = list.length-1; i >-1; i--) {
				if (list[i] === this) {
					list.splice(i, 1);
					return;
				}
			}
		}
		
		/**@inheritDoc */
		override public function set scaleX(value:Number):void {
			if (super.scaleX == value) return;
			super.scaleX = value;
			event(Event.RESIZE);
		}
		
		/**@inheritDoc */
		override public function set scaleY(value:Number):void {
			if (super.scaleY == value) return;
			super.scaleY = value;
			event(Event.RESIZE);
		}
		
		/**@inheritDoc */
		override public function get width():Number {
			if (_width) return _width;
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:Sprite = getChildAt(i) as Sprite;
				if (comp._visible) {
					max = Math.max(comp._x + comp.width * comp.scaleX, max);
				}
			}
			return max;
		}
		
		/**@inheritDoc */
		override public function set width(value:Number):void {
			if (super.width == value) return;
			super.width = value;
			callLater(_sizeChanged);
		}
		
		/**@inheritDoc */
		override public function get height():Number {
			if (_height) return _height;
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:Sprite = getChildAt(i) as Sprite;
				if (comp._visible) {
					max = Math.max(comp._y + comp.height * comp.scaleY, max);
				}
			}
			return max;
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			if (super.height == value) return;
			super.height = value;
			callLater(_sizeChanged);
		}
		
		/**@private */
		protected function _sizeChanged():void {
			event(Event.RESIZE);
		}
		
		//////////////////////////////////////静态方法//////////////////////////////////////////
		
		/**获取场景根容器*/
		public static function get root():Sprite {
			if (!_root) {
				_root = Laya.stage.addChild(new Sprite()) as Sprite;
				_root.name = "root";
				Laya.stage.on("resize", null, resize);
				function resize():void {
					_root.size(Laya.stage.width, Laya.stage.height);
					_root.event(Event.RESIZE);
				}
				resize();
			}
			return _root;
		}
		
		/**场景时钟*/
		override public function get timer():Timer {
			return _timer || Laya.timer;
		}
		
		public function set timer(value:Timer):void {
			_timer = value;
		}
		
		/**
		 * 加载场景及场景使用到的资源
		 * @param	url			场景地址
		 * @param	complete	加载完成回调，返回场景实例（可选）
		 * @param	progress	加载进度回调（可选）
		 */
		public static function load(url:String, complete:Handler = null, progress:Handler = null):void {
			Laya.loader.resetProgress();
			var loader:SceneLoader = new SceneLoader();
			loader.on(Event.PROGRESS, null, onProgress);
			loader.once(Event.COMPLETE, null, create);
			loader.load(url);
			
			function onProgress(value:Number):void {
				if (_loadPage) _loadPage.event("progress", value);
				progress && progress.runWith(value);
			}
			
			function create():void {
				loader.off(Event.PROGRESS, null, onProgress);
				var obj:Object = Loader.getRes(url);
				if (!obj) throw "Can not find scene:" + url;
				if (!obj.props) throw "Scene data is error:" + url;
				var runtime:String = obj.props.runtime ? obj.props.runtime : obj.type;
				var clas:* = ClassUtils.getClass(runtime);
				if (obj.props.renderType == "instance") {
					var scene:Scene = clas.instance || (clas.instance = new clas());
				} else {
					scene = new clas();
				}
				if (scene && scene is Node) {
					scene.url = url;
					if (!scene._getBit(Const.NOT_READY)) {
						complete && complete.runWith(scene);
					} else {
						scene.on("onViewCreated", null, function():void {
							complete && complete.runWith(scene)
						})
						scene.createView(obj);
					}
					hideLoadingPage();
				} else {
					throw "Can not find scene:" + runtime;
				}
			}
		}
		
		/**
		 * 加载并打开场景
		 * @param	url			场景地址
		 * @param	closeOther	是否关闭其他场景，默认为true（可选），【注意】被关闭的场景，如果没有设置autoDestroyAtRemoved=true，则资源可能不能被回收，需要自己手动回收
		 * @param	param		打开页面的参数，会传递给onOpened方法（可选）
		 * @param	complete	打开完成回调，返回场景实例（可选）
		 * @param	progress	加载进度回调（可选）
		 */
		public static function open(url:String, closeOther:Boolean = true, param:* = null, complete:Handler = null, progress:Handler = null):void {
			//兼容处理
			if (param is Handler) {
				var temp:* = complete;
				complete = param;
				param = temp;
			}
			showLoadingPage();
			load(url, Handler.create(null, _onSceneLoaded, [closeOther, complete, param]), progress);
		}
		
		/**@private */
		private static function _onSceneLoaded(closeOther:Boolean, complete:Handler, param:*, scene:Scene):void {
			scene.open(closeOther, param);
			if (complete) complete.runWith(scene);
		}
		
		/**
		 * 根据地址，关闭场景（包括对话框）
		 * @param	url		场景地址
		 * @param	name	如果name不为空，name必须相同才能关闭
		 * @return	返回是否关闭成功，如果url找不到，则不成功
		 */
		public static function close(url:String, name:String = ""):Boolean {
			var flag:Boolean = false;
			var list:Array = Scene.unDestroyedScenes;
			for (var i:int = 0, n:int = list.length; i < n; i++) {
				var scene:Scene = list[i];
				if (scene && scene.parent && scene.url === url && scene.name == name) {
					scene.close();
					flag = true;
				}
			}
			return flag;
		}
		
		/**
		 * 关闭所有场景，不包括对话框，如果关闭对话框，请使用Dialog.closeAll()
		 * 【注意】被关闭的场景，如果没有设置autoDestroyAtRemoved=true，则资源可能不能被回收，需要自己手动回收
		 */
		public static function closeAll():void {
			var root:Sprite = Scene.root;
			for (var i:int = 0, n:int = root.numChildren; i < n; i++) {
				var scene:Scene = root.getChildAt(0) as Scene;
				if (scene is Scene) scene.close();
				else scene.removeSelf();
			}
		}
		
		/**
		 * 根据地址，销毁场景（包括对话框）
		 * @param	url		场景地址
		 * @param	name	如果name不为空，name必须相同才能关闭
		 * @return	返回是否销毁成功，如果url找不到，则不成功
		 */
		public static function destroy(url:String, name:String = ""):Boolean {
			var flag:Boolean = false;
			var list:Array = Scene.unDestroyedScenes;
			for (var i:int = 0, n:int = list.length; i < n; i++) {
				var scene:Scene = list[i];
				if (scene.url === url && scene.name == name) {
					scene.destroy();
					flag = true;
				}
			}
			return flag;
		}
		
		/**
		 * 销毁当前没有被使用的资源,该函数会忽略lock=true的资源。
		 */
		public static function gc():void {
			Resource.destroyUnusedResources();
		}
		
		/**
		 * 设置loading界面，引擎会在调用open方法后，延迟打开loading界面，在页面添加到舞台之后，关闭loading界面
		 * @param	loadPage 	load界面实例
		 */
		public static function setLoadingPage(loadPage:Scene):void {
			if (_loadPage != loadPage) {
				_loadPage = loadPage;
			}
		}
		
		/**
		 * 显示loading界面
		 * @param	param 打开参数，如果是scene，则会传递给onOpened方法
		 * @param	delay 延迟打开时间，默认500毫秒
		 */
		public static function showLoadingPage(param:Object = null, delay:int = 500):void {
			if (_loadPage) {
				Laya.systemTimer.clear(null, _showLoading);
				Laya.systemTimer.clear(null, _hideLoading);
				Laya.systemTimer.once(delay, null, _showLoading, [param], false);
			}
		}
		
		private static function _showLoading(param:Object):void {
			Laya.stage.addChild(_loadPage);
			_loadPage.onOpened(param);
		}
		
		private static function _hideLoading():void {
			_loadPage.close();
		}
		
		/**
		 * 隐藏loading界面
		 * @param	delay 延迟关闭时间，默认500毫秒
		 */
		public static function hideLoadingPage(delay:int = 500):void {
			if (_loadPage) {
				Laya.systemTimer.clear(null, _showLoading);
				Laya.systemTimer.clear(null, _hideLoading);
				Laya.systemTimer.once(delay, null, _hideLoading);
			}
		}
	}
}