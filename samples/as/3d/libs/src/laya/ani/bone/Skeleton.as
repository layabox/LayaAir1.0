package laya.ani.bone {
	import laya.ani.AnimationPlayer;
	import laya.ani.bone.BoneSlot;
	import laya.ani.bone.Templet;
	import laya.ani.bone.Transform;
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	
	/**动画开始播放调度。
	 * @eventType Event.PLAYED
	 * */
	[Event(name = "played", type = "laya.events.Event")]
	/**动画停止播放调度。
	 * @eventType Event.STOPPED
	 * */
	[Event(name = "stopped", type = "laya.events.Event")]
	/**动画暂停播放调度。
	 * @eventType Event.PAUSED
	 * */
	[Event(name = "paused", type = "laya.events.Event")]
	/**
	 * 骨骼动画由Templet,AnimationPlayer,Skeleton三部分组成
	 */
	public class Skeleton extends Sprite {
		
		private var _templet:Templet;//动画解析器
		private var _player:AnimationPlayer;//播放器
		private var _curOriginalData:Float32Array;//当前骨骼的偏移数据
		private var _boneMatrixArray:Array = [];//当前骨骼动画的最终结果数据
		private var _lastTime:Number = 0;//上次的帧时间
		private var _tempTransform:Transform = new Transform();
		private var _currAniName:String = null;
		private var _currAniIndex:int = -1;
		private var _pause:Boolean = true;
		private var _aniClipIndex:int = -1;
		private var _clipIndex:int = -1;
		//0,使用模板缓冲的数据，模板缓冲的数据，不允许修改					（内存开销小，计算开销小，不支持换装）
		//1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）
		//2,使用动态方式，去实时去画										（内存开销小，计算开销大，支持换装,不建议使用）
		private var _aniMode:int = 0;//
		//当前动画自己的缓冲区
		private var _graphicsCache:Array;
		
		private var _boneSlotDic:Object;
		private var _bindBoneBoneSlotDic:Object;
		private var _boneSlotArray:Array;
		
		private var _index:int = -1;
		private var _total:int = -1;
		//加载路径
		private var _aniPath:String;
		private var _texturePath:String;
		private var _complete:Handler;
		private var _loadAniMode:int;
		/**
		 * 创建一个Skeleton对象
		 * 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改					（内存开销小，计算开销小，不支持换装）
		 * 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）
		 * 2,使用动态方式，去实时去画										（内存开销小，计算开销大，支持换装,不建议使用）
		 * @param	templet	骨骼动画模板
		 * @param	aniMode	动画模式，0:不支持换装,1,2支持换装
		 */
		public function Skeleton(templet:Templet = null, aniMode:int = 0):void {
			if (templet) init(templet, aniMode);
		}
		
		/**
		 * 初始化动画
		 * 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改					（内存开销小，计算开销小，不支持换装）
		 * 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）
		 * 2,使用动态方式，去实时去画										（内存开销小，计算开销大，支持换装,不建议使用）
		 * @param	templet		模板
		 * @param	aniMode		动画模式，0:不支持换装,1,2支持换装
		 */
		public function init(templet:Templet, aniMode:int = 0):void {
			if (aniMode == 1)//使用动画自己的缓冲区
			{
				_graphicsCache = [];
				for (var i:int = 0, n:int = templet.getAnimationCount(); i < n; i++) {
					_graphicsCache.push([]);
				}
			}
			_aniMode = aniMode;
			_templet = templet;
			_player = new AnimationPlayer(templet.rate);
			_player.templet = templet;
			_player.play();
			_parseSrcBoneMatrix();
			
			_player.on(Event.PLAYED, this, onPlay);
			_player.on(Event.STOPPED, this, onStop);
			_player.on(Event.PAUSED, this, onPause);
		}
		
		/**
		 * 得到资源的URL
		 */
		public function get url():String
		{
			return _aniPath;
		}
		
		/**
		 * 设置动画路径
		 */
		public function set url(path:String):void {
			load(path);
		}
		
		/**
		 * 通过加载直接创建动画
		 * @param	path		要加载的动画文件路径
		 * @param	complete	加载完成的回调函数
		 * @param	aniMode		 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改（内存开销小，计算开销小，不支持换装） 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）2,使用动态方式，去实时去画（内存开销小，计算开销大，支持换装,不建议使用）
		 */
		public function load(path:String,complete:Handler=null,aniMode:int = 0):void
		{
			_aniPath = path;
			_complete = complete;
			_loadAniMode = aniMode;
			_texturePath = path.replace(".sk", ".png").replace(".bin", ".png");
			Laya.loader.load([{url: path, type: Loader.BUFFER}, {url: _texturePath, type: Loader.IMAGE}], Handler.create(this, onLoaded));
		}
		
		/**
		 * 加载完成
		 */
		private function onLoaded():void {
			var tTexture:Texture = Loader.getRes(_texturePath);
			var arraybuffer:ArrayBuffer = Loader.getRes(_aniPath);
			if (tTexture == null || arraybuffer == null) return;
			if (Templet.TEMPLET_DICTIONARY == null)
			{
				Templet.TEMPLET_DICTIONARY = { };
			}
			var tFactory:Templet;
			tFactory = Templet.TEMPLET_DICTIONARY[_aniPath];
			if (tFactory)
			{
				tFactory.isParseFail ? parseFail():parseComplete();
			}else {
				tFactory = new Templet();
				tFactory.url = _aniPath;
				Templet.TEMPLET_DICTIONARY[_aniPath] = tFactory;
				tFactory.on(Event.COMPLETE, this, parseComplete);
				tFactory.on(Event.ERROR, this, parseFail);
				tFactory.parseData(tTexture, arraybuffer, 60);
			}
		}
		
		/**
		 * 解析完成
		 */
		private function parseComplete():void
		{
			var tTemple:Templet = Templet.TEMPLET_DICTIONARY[_aniPath];
			if (tTemple)
			{
				init(tTemple, _loadAniMode);
				play(0, true);
			}
			_complete && _complete.runWith(this);
		}
		
		/**
		 * 解析失败
		 */
		public function parseFail():void
		{
			trace("[Error]:"+_aniPath + "解析失败");
		}
		
		/**
		 * 传递PLAY事件
		 */
		private function onPlay():void {
			this.event(Event.PLAYED);
		}
		
		/**
		 * 传递STOP事件
		 */
		private function onStop():void {
			this.event(Event.STOPPED);
		}
		
		/**
		 * 传递PAUSE事件
		 */
		private function onPause():void {
			this.event(Event.PAUSED);
		}
		
		/**
		 * 创建骨骼的矩阵，保证每次计算的最终结果
		 */
		private function _parseSrcBoneMatrix():void {
			var i:int = 0, n:int = 0;
			n = _templet.srcBoneMatrixArr.length;
			for (i = 0; i < n; i++) {
				_boneMatrixArray.push(new Matrix());
			}
			if (_aniMode == 0) {
				_boneSlotDic = _templet.boneSlotDic;
				_bindBoneBoneSlotDic = _templet.bindBoneBoneSlotDic;
				_boneSlotArray = _templet.boneSlotArray;
			} else {
				if (_boneSlotDic == null) _boneSlotDic = {};
				if (_bindBoneBoneSlotDic == null) _bindBoneBoneSlotDic = {};
				if (_boneSlotArray == null) _boneSlotArray = [];
				var tArr:Array = _templet.boneSlotArray;
				var tBS:BoneSlot;
				var tBSArr:Array;
				for (i = 0, n = tArr.length; i < n; i++) {
					tBS = tArr[i];
					tBSArr = _bindBoneBoneSlotDic[tBS.parent];
					if (tBSArr == null) {
						_bindBoneBoneSlotDic[tBS.parent] = tBSArr = [];
					}
					_boneSlotDic[tBS.name] = tBS = tBS.copy();
					tBSArr.push(tBS);
					_boneSlotArray.push(tBS);
				}
			}
		}
		
		/**
		 * 更新动画
		 */
		private function _update():void {
			if (_pause) return;
			var tCurrTime:Number = Laya.stage.now;
			_player.update(tCurrTime - _lastTime);
			_lastTime = tCurrTime;
			_aniClipIndex = _player.currentAnimationClipIndex;
			_clipIndex = _player.currentKeyframeIndex;
			if (_aniClipIndex == -1) return;
			var tGraphics:Graphics;
			if (_aniMode == 0) {
				tGraphics = _templet.getGrahicsDataWithCache(_aniClipIndex, _clipIndex);
				if (tGraphics) {
					this.graphics = tGraphics;
					return;
				}
			} else if (_aniMode == 1) {
				tGraphics = _getGrahicsDataWithCache(_aniClipIndex, _clipIndex);
				if (tGraphics) {
					this.graphics = tGraphics;
					return;
				}
			}
			_createGraphics();
		}
		
		/**
		 * 创建grahics图像
		 */
		private function _createGraphics():void {
			var bones:Vector.<*> = _templet.getNodes(_aniClipIndex);
			//_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(0)));
			_templet.getOriginalData(_aniClipIndex, _curOriginalData, _clipIndex, _player.currentFrameTime);
			//_templet.getOriginalDataUnfixedRate(_aniClipIndex, _curOriginalData, _player.currentTime);
			var tParentMatrix:Matrix;//父骨骼矩阵的引用
			var tResultMatrix:Matrix;//保证骨骼计算的最终结果
			var tStartIndex:int = 0;
			
			var i:int = 0, j:int = 0, k:int = 0, n:int = 0;
			var tDBBoneSlot:BoneSlot;
			var tDBBoneSlotArr:Array;
			var tTempMatrix:Matrix;
			var tParentTransform:Transform;
			//对骨骼数据进行计算
			var boneCount:int = _templet.srcBoneMatrixArr.length;
			for (i = 0; i < boneCount; i++) {
				tResultMatrix = _boneMatrixArray[i];
				tParentTransform = _templet.srcBoneMatrixArr[i];
				_tempTransform.scX = tParentTransform.scX * _curOriginalData[tStartIndex++];
				_tempTransform.skX = tParentTransform.skX + _curOriginalData[tStartIndex++];
				_tempTransform.skY = tParentTransform.skY + _curOriginalData[tStartIndex++];
				_tempTransform.scY = tParentTransform.scY * _curOriginalData[tStartIndex++];
				_tempTransform.x = tParentTransform.x + _curOriginalData[tStartIndex++];
				_tempTransform.y = tParentTransform.y + _curOriginalData[tStartIndex++];
				tTempMatrix = _tempTransform.getMatrix();
				//骨骼数据乘以父矩阵，求出最终矩阵
				var tBone:* = bones[i];
				if (tBone.parentIndex != -1) {
					tParentMatrix = _boneMatrixArray[tBone.parentIndex];
					Matrix.mul(tTempMatrix, tParentMatrix, tResultMatrix);
				} else {
					tTempMatrix.copy(tResultMatrix);
				}
				tDBBoneSlotArr = _bindBoneBoneSlotDic[tBone.name];
				if (tDBBoneSlotArr) {
					for (j = 0, n = tDBBoneSlotArr.length; j < n; j++) {
						tDBBoneSlot = tDBBoneSlotArr[j];
						if (tDBBoneSlot) {
							tDBBoneSlot.setParentMatrix(tResultMatrix);
						}
					}
				}
			}
			
			//对插槽进行插值计算
			var tSlotDic:Object = {};
			var tSlotAlphaDic:Object = {};
			for (; i < bones.length; i++) {
				var tBoneData:* = bones[i];
				tSlotDic[tBoneData.name] = _curOriginalData[tStartIndex++];
				tSlotAlphaDic[tBoneData.name] = _curOriginalData[tStartIndex++];
				//预留
				_curOriginalData[tStartIndex++];
				
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
			}
			var tGraphics:Graphics;
			if (_aniMode == 0 || _aniMode == 1) {
				this.graphics = new Graphics();
			} else {
				this.graphics.clear();
			}
			tGraphics = this.graphics;
			var tSlotData2:Number;
			var tSlotData3:Number;
			//把动画按插槽顺序画出来
			for (i = 0, n = _boneSlotArray.length; i < n; i++) {
				tDBBoneSlot = _boneSlotArray[i];
				tSlotData2 = tSlotDic[tDBBoneSlot.name];
				tSlotData3 = tSlotAlphaDic[tDBBoneSlot.name];
				if (!isNaN(tSlotData3)) {
					tGraphics.save();
					tGraphics.alpha(tSlotData3);
				}
				if (!isNaN(tSlotData2)) {
					tDBBoneSlot.showDisplayByIndex(tSlotData2);
				}
				tDBBoneSlot.draw(tGraphics, _aniMode == 2);
				if (!isNaN(tSlotData3)) {
					tGraphics.restore();
						//tGraphics.alpha(1 / tSlotData3);
				}
			}
			if (_aniMode == 0) {
				_templet.setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
			} else if (_aniMode == 1) {
				_setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
			}
		}
		
		/*******************************************定义接口*************************************************/
		/**
		 * 得到当前动画的数量
		 * @return
		 */
		public function getAnimNum():int {
			return _templet.getAnimationCount();
		}
		
		/**
		 * 得到指定动画的名字
		 * @param	index	动画的索引
		 */
		public function getAniNameByIndex(index:int):String {
			return _templet.getAniNameByIndex(index);
		}
		
		/**
		 * 通过名字得到插槽的引用
		 * @param	name	动画的名字
		 * @return
		 */
		public function getSlotByName(name:String):BoneSlot {
			return _boneSlotDic[name];
		}
		
		/**
		 * 通过名字显示一套皮肤
		 * @param	name	皮肤的名字
		 */
		public function showSkinByName(name:String):void {
			_templet.showSkinByName(_boneSlotDic, name);
			_clearCache();
		}
		
		/**
		 * 通过索引显示一套皮肤
		 * @param	skinIndex	皮肤索引
		 */
		public function showSkinByIndex(skinIndex:int):void {
			_templet.showSkinByIndex(_boneSlotDic, skinIndex);
			_clearCache();
		}
		
		/**
		 * 设置某插槽的皮肤
		 * @param	slotName	插槽名称
		 * @param	index	插糟皮肤的索引
		 */
		public function showSlotSkinByIndex(slotName:String, index:int):void {
			if (_aniMode == 0) return;
			var tBoneSlot:BoneSlot = getSlotByName(slotName);
			if (tBoneSlot) {
				tBoneSlot.showDisplayByIndex(index);
			}
			_clearCache();
		}
		
		/**
		 * 设置自定义皮肤
		 * @param	name		插糟的名字
		 * @param	texture		自定义的纹理
		 */
		public function setSlotSkin(slotName:String, texture:Texture):void {
			if (_aniMode == 0) return;
			var tBoneSlot:BoneSlot = getSlotByName(slotName);
			if (tBoneSlot) {
				tBoneSlot.replaceSkin(texture);
			}
			_clearCache();
		}
		
		/**
		 * 换装的时候，需要清一下缓冲区
		 */
		private function _clearCache():void {
			if (_aniMode == 1) {
				for (var i:int = 0, n:int = _graphicsCache.length; i < n; i++) {
					_graphicsCache[i].length = 0;
				}
			}
		}
		
		/**
		 * 播放动画
		 * @param	nameOrIndex	动画名字或者索引
		 * @param	loop		是否循环播放
		 * @param	force		false,如果要播的动画跟上一个相同就不生效,true,强制生效
		 */
		public function play(nameOrIndex:*, loop:Boolean, force:Boolean = true):void {
			var index:int = -1;
			var duration:Number;
			if (loop) {
				duration = Number.MAX_VALUE;
			} else {
				duration = 0;
			}
			if (nameOrIndex is String) {
				for (var i:int = 0, n:int = _templet.getAnimationCount(); i < n; i++) {
					var animation:* = _templet.getAnimation(i);
					if (animation && nameOrIndex == animation.name) {
						index = i;
						break;
					}
				}
			} else {
				index = nameOrIndex;
			}
			if (index > -1 && index < getAnimNum()) {
				if (force || _pause || _currAniIndex != index) {
					_currAniIndex = index;
					_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(index));
					_player.play(index, 1, duration);
					this._templet.showSkinByIndex(_boneSlotDic, 0);
					if (_pause) {
						_pause = false;
						_lastTime = Browser.now();
						Laya.stage.frameLoop(1, this, _update, null, true);
					}
				}
			}
		}
		
		/**
		 * 停止动画
		 */
		public function stop():void {
			if (!_pause) {
				_pause = true;
				if (_player) {
					_player.stop(true);
				}
				Laya.timer.clear(this, _update);
			}
		}
		
		/**
		 * 设置动画播放速率
		 * @param	value	1为标准速率
		 */
		public function playbackRate(value:Number):void {
			if (_player) {
				_player.playbackRate = value;
			}
		}
		
		/**
		 * 暂停动画的播放
		 */
		public function paused():void {
			if (!_pause) {
				_pause = true;
				if (_player) {
					_player.paused = true;
				}
				Laya.timer.clear(this, _update);
			}
		}
		
		/**
		 * 恢复动画的播放
		 */
		public function resume():void {
			if (_pause) {
				_pause = false;
				if (_player) {
					_player.paused = false;
				}
				_lastTime = Browser.now();
				Laya.stage.frameLoop(1, this, _update, null, true);
			}
		
		}
		
		/**
		 * @private
		 * 得到缓冲数据
		 * @param	aniIndex
		 * @param	frameIndex
		 * @return
		 */
		private function _getGrahicsDataWithCache(aniIndex:int, frameIndex:Number):Graphics {
			return _graphicsCache[aniIndex][frameIndex];
		}
		
		/**
		 * @private
		 * 保存缓冲grahpics
		 * @param	aniIndex
		 * @param	frameIndex
		 * @param	graphics
		 */
		private function _setGrahicsDataWithCache(aniIndex:int, frameIndex:int, graphics:Graphics):void {
			_graphicsCache[aniIndex][frameIndex] = graphics;
		}
		
		/**
		 * 销毁当前动画
		 */
		public function destory():void {
			_templet = null;//动画解析器
			_player.offAll();
			_player = null;// 播放器
			_curOriginalData = null;//当前骨骼的偏移数据
			_boneMatrixArray.length = 0;//当前骨骼动画的最终结果数据
			_lastTime = 0;//上次的帧时间
			Laya.timer.clear(this, _update);
		}

		public function get player():AnimationPlayer
		{
			return _player;
		}
	}
}