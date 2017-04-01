package laya.ani.bone {
	import laya.ani.AnimationPlayer;
	import laya.ani.AnimationState;
	import laya.ani.bone.BoneSlot;
	import laya.ani.bone.Templet;
	import laya.ani.bone.Transform;
	import laya.ani.GraphicsAni;
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Byte;
	import laya.utils.Handler;
	import laya.ani.bone.IkConstraintData;
	
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
	/**自定义事件。
	 * @eventType Event.LABEL
	 */
	[Event(name = "label", type = "laya.events.Event")]
	/**
	 * 骨骼动画由Templet,AnimationPlayer,Skeleton三部分组成
	 */
	public class Skeleton extends Sprite {
		
		protected var _templet:Templet;//动画解析器
		protected var _player:AnimationPlayer;//播放器
		protected var _curOriginalData:Float32Array;//当前骨骼的偏移数据
		private var _boneMatrixArray:Array = [];//当前骨骼动画的最终结果数据
		private var _lastTime:Number = 0;//上次的帧时间
		private var _currAniName:String = null;
		private var _currAniIndex:int = -1;
		private var _pause:Boolean = true;
		protected var _aniClipIndex:int = -1;
		protected var _clipIndex:int = -1;
		private var _skinIndex:int = 0;
		private var _skinName:String = "default";
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
		private var _indexControl:Boolean = false;
		//加载路径
		private var _aniPath:String;
		private var _texturePath:String;
		private var _complete:Handler;
		private var _loadAniMode:int;
		
		private var _yReverseMatrix:Matrix;
		
		private var _ikArr:Array;
		private var _tfArr:Array;
		private var _pathDic:Object;
		private var _rootBone:Bone;
		protected var _boneList:Vector.<Bone>;
		protected var _aniSectionDic:Object;
		private var _eventIndex:int = 0;
		private var _drawOrderIndex:int = 0;
		private var _drawOrder:Vector.<int> = null;
		private var _lastAniClipIndex:int = -1;
		private var _lastUpdateAniClipIndex:int = -1;
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
			var i:int, n:int;		
			//aniMode = 2;
			if (aniMode == 1)//使用动画自己的缓冲区
			{
				_graphicsCache = [];
				for (i = 0, n = templet.getAnimationCount(); i < n; i++) {
					_graphicsCache.push([]);
				}
			}
			_yReverseMatrix = templet.yReverseMatrix;
			_aniMode = aniMode;
			_templet = templet;
			_player = new AnimationPlayer();
			_player.cacheFrameRate = templet.rate;
			_player.templet = templet;
			_player.play();
			_parseSrcBoneMatrix();
			//骨骼数据
			_boneList = templet.mBoneArr;
			_rootBone = templet.mRootBone;
			_aniSectionDic = templet.aniSectionDic;
			//ik作用器
			if (templet.ikArr.length > 0){
				_ikArr = [];
				for (i = 0, n = templet.ikArr.length; i < n; i++)
				{
					_ikArr.push(new IkConstraint(templet.ikArr[i],_boneList));
				}
			}
			//path作用器
			if (templet.pathArr.length > 0)
			{
				var tPathData:PathConstraintData;
				var tPathConstraint:PathConstraint;
				if (_pathDic == null)_pathDic = {};
				var tBoneSlot:BoneSlot;
				for (i = 0, n = templet.pathArr.length; i < n; i++)
				{
					tPathData = templet.pathArr[i];
					tPathConstraint = new PathConstraint(tPathData, _boneList);
					tBoneSlot = _boneSlotDic[tPathData.name];
					if (tBoneSlot)
					{
						tPathConstraint = new PathConstraint(tPathData, _boneList);
						tPathConstraint.target = tBoneSlot;
					}
					_pathDic[tPathData.name] = tPathConstraint;
				}
			}
			//tf作用器
			if (templet.tfArr.length > 0) {
				_tfArr = [];
				for (i = 0, n = templet.tfArr.length; i < n; i++)
				{
					_tfArr.push(new TfConstraint(templet.tfArr[i], _boneList));
				}
			}
			if (templet.skinDataArray.length > 0)
			{
				var tSkinData:SkinData = _templet.skinDataArray[_skinIndex];
				_skinName = tSkinData.name;
			}
			_player.on(Event.PLAYED, this, _onPlay);
			_player.on(Event.STOPPED, this, _onStop);
			_player.on(Event.PAUSED, this, _onPause);
		}
		
		/**
		 * 得到资源的URL
		 */
		public function get url():String {
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
		public function load(path:String, complete:Handler = null, aniMode:int = 0):void {
			_aniPath = path;
			_complete = complete;
			_loadAniMode = aniMode;
			_texturePath = path.replace(".sk", ".png").replace(".bin", ".png");
			Laya.loader.load([{url: path, type: Loader.BUFFER}, {url: _texturePath, type: Loader.IMAGE}], Handler.create(this, _onLoaded));
		}
		
		/**
		 * 加载完成
		 */
		private function _onLoaded():void {
			var tTexture:Texture = Loader.getRes(_texturePath);
			var arraybuffer:ArrayBuffer = Loader.getRes(_aniPath);
			if (tTexture == null || arraybuffer == null) return;
			if (Templet.TEMPLET_DICTIONARY == null) {
				Templet.TEMPLET_DICTIONARY = {};
			}
			var tFactory:Templet;
			tFactory = Templet.TEMPLET_DICTIONARY[_aniPath];
			if (tFactory) {
				tFactory.isParseFail ? _parseFail() : _parseComplete();
			} else {
				tFactory = new Templet();
				tFactory.url = _aniPath;
				Templet.TEMPLET_DICTIONARY[_aniPath] = tFactory;
				tFactory.on(Event.COMPLETE, this, _parseComplete);
				tFactory.on(Event.ERROR, this, _parseFail);
				tFactory.parseData(tTexture, arraybuffer);
			}
		}
		
		/**
		 * 解析完成
		 */
		private function _parseComplete():void {
			var tTemple:Templet = Templet.TEMPLET_DICTIONARY[_aniPath];
			if (tTemple) {
				init(tTemple, _loadAniMode);
				play(0, true);
			}
			_complete && _complete.runWith(this);
		}
		
		/**
		 * 解析失败
		 */
		private function _parseFail():void {
			trace("[Error]:" + _aniPath + "解析失败");
		}
		
		/**
		 * 传递PLAY事件
		 */
		private function _onPlay():void {
			this.event(Event.PLAYED);
		}
		
		/**
		 * 传递STOP事件
		 */
		private function _onStop():void {
			//把没播的事件播完
			var tEventData:EventData;
			var tEventAniArr:Array = _templet.eventAniArr;
			var tEventArr:Vector.<EventData> = tEventAniArr[_aniClipIndex];
			if (tEventArr && _eventIndex < tEventArr.length)
			{
				for (; _eventIndex < tEventArr.length; _eventIndex++)
				{
					tEventData = tEventArr[_eventIndex];
					if (tEventData.time >= _player.playStart && tEventData.time <= _player.playEnd)
					{
						this.event(Event.LABEL,tEventData);
					}
				}
			}
			_eventIndex = 0;
			_drawOrder = null;
			this.event(Event.STOPPED);
		}
		
		/**
		 * 传递PAUSE事件
		 */
		private function _onPause():void {
			this.event(Event.PAUSED);
		}
		
		/**
		 * 创建骨骼的矩阵，保存每次计算的最终结果
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
		
		private function _emitMissedEvents(startTime:Number, endTime:Number,startIndex:int=0):void
		{
			var tEventAniArr:Array = _templet.eventAniArr;
			var tEventArr:Vector.<EventData> = tEventAniArr[_player.currentAnimationClipIndex];
			if (tEventArr)
			{
				var i:int, len:int;
				var tEventData:EventData;
				len = tEventArr.length;
				for (i = startIndex; i < len; i++)
				{
					tEventData = tEventArr[i];
				    if (tEventData.time >= _player.playStart && tEventData.time <= _player.playEnd)
				    {
						this.event(Event.LABEL, tEventData);			    
				    }
				}
			}
		}
		/**
		 * 更新动画
		 * @param	autoKey true为正常更新，false为index手动更新
		 */
		private function _update(autoKey:Boolean = true):void {
			if (_pause) return;
			if (autoKey && _indexControl) {
				return;
			}
			var tCurrTime:Number = Laya.timer.currTimer;
			var preIndex:int = _player.currentKeyframeIndex;
			if (autoKey) {
				_player.update(tCurrTime - _lastTime);
			}else{
				preIndex = -1;
			}
			_lastTime = tCurrTime;
			_index = _clipIndex = _player.currentKeyframeIndex;
			if (_index < 0) return;
			if (_clipIndex == preIndex&&_lastUpdateAniClipIndex== _aniClipIndex)
			{
				return;
			}
			_lastUpdateAniClipIndex=_aniClipIndex;
			if (preIndex > _clipIndex&&_eventIndex!=0)
			{
				_emitMissedEvents(_player.playStart, _player.playEnd, _eventIndex);
				_eventIndex = 0;
			}
			var tEventData:EventData;
			var tEventAniArr:Array = _templet.eventAniArr;
			var tEventArr:Vector.<EventData> = tEventAniArr[_aniClipIndex];
			if (tEventArr && _eventIndex < tEventArr.length)
			{
				tEventData = tEventArr[_eventIndex];
				if (tEventData.time >= _player.playStart && tEventData.time <= _player.playEnd)
				{
					if (_player.currentPlayTime >= tEventData.time)
					{
						this.event(Event.LABEL, tEventData);
						_eventIndex++;
					}
				}else {
					_eventIndex++;
				}
			}
			//if (_aniClipIndex == -1) return;
			var tGraphics:Graphics;
			
			if (_aniMode == 0) {
				tGraphics = _templet.getGrahicsDataWithCache(_aniClipIndex, _clipIndex);
				if (tGraphics) {
					if (this.graphics != tGraphics)
					{
						this.graphics = tGraphics;
					}
					return;
				}else
				{
					var i:int,minIndex:int;
					minIndex = _clipIndex;
					while ((!_templet.getGrahicsDataWithCache(_aniClipIndex, minIndex-1))&&(minIndex>0))
					{
						minIndex--;
					}
					if (minIndex < _clipIndex)
					{
						
						for (i = minIndex; i < _clipIndex; i++)
						{
							_createGraphics(i);
						}
					}
				}
			} else if (_aniMode == 1) {
				tGraphics = _getGrahicsDataWithCache(_aniClipIndex, _clipIndex);
				if (tGraphics) {
					if (this.graphics != tGraphics)
					{
						this.graphics = tGraphics;
					}
					return;
				}else
				{
					minIndex = _clipIndex;
					while ((!_getGrahicsDataWithCache(_aniClipIndex, minIndex-1))&&(minIndex>0))
					{
						minIndex--;
					}
					if (minIndex < _clipIndex)
					{
						
						for (i = minIndex; i < _clipIndex; i++)
						{
							_createGraphics(i);
						}
					}
				}
			}
			_createGraphics();
		}
		
		/**
		 * @private
		 * 创建grahics图像
		 */
		protected function _createGraphics(_clipIndex:int = -1):void {
			if (_clipIndex == -1) _clipIndex = this._clipIndex;
			var curTime:Number = _clipIndex * _player.cacheFrameRateInterval;
			//处理绘制顺序
			var tDrawOrderData:DrawOrderData;
			var tDrawOrderAniArr:Array = _templet.drawOrderAniArr;
			var tDrawOrderArr:Vector.<DrawOrderData> = tDrawOrderAniArr[_aniClipIndex];
			if (tDrawOrderArr && tDrawOrderArr.length > 0)
			{
				_drawOrderIndex = 0;
				tDrawOrderData = tDrawOrderArr[_drawOrderIndex];
				while ( curTime >= tDrawOrderData.time)
				{
					_drawOrder = tDrawOrderData.drawOrder;
					_drawOrderIndex++;
					if (_drawOrderIndex >= tDrawOrderArr.length)
					{
						break;
					}
					tDrawOrderData = tDrawOrderArr[_drawOrderIndex];
					
				}
			}
			
			//要用的graphics
			var tGraphics:GraphicsAni;
			if (_aniMode == 0 || _aniMode == 1) {
				this.graphics = new GraphicsAni();
			} else {
				if (this.graphics is GraphicsAni) {
					this.graphics.clear();
				}else {
					this.graphics = new GraphicsAni();
				}
			}
			tGraphics = this.graphics as GraphicsAni;
			//获取骨骼数据
			var bones:Vector.<*> = _templet.getNodes(_aniClipIndex);
			_templet.getOriginalData(_aniClipIndex, _curOriginalData,_player._fullFrames[_aniClipIndex], _clipIndex, curTime);
			var tSectionArr:Array = _aniSectionDic[_aniClipIndex];
			var tParentMatrix:Matrix;//父骨骼矩阵的引用
			var tStartIndex:int = 0;
			var i:int = 0, j:int = 0, k:int = 0, n:int = 0;
			var tDBBoneSlot:BoneSlot;
			var tDBBoneSlotArr:Array;
			var tParentTransform:Transform;
			var tSrcBone:Bone;
			//对骨骼数据进行计算
			var boneCount:int = _templet.srcBoneMatrixArr.length;
			for (i = 0,n = tSectionArr[0]; i < boneCount; i++) {
				tSrcBone = _boneList[i];
				tParentTransform = _templet.srcBoneMatrixArr[i];
				tSrcBone.resultTransform.scX = tParentTransform.scX * _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.skX = tParentTransform.skX + _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.skY = tParentTransform.skY + _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.scY = tParentTransform.scY * _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.x = tParentTransform.x + _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.y = tParentTransform.y + _curOriginalData[tStartIndex++];
				if (_templet.tMatrixDataLen === 8) {
					tSrcBone.resultTransform.skewX = tParentTransform.skewX + _curOriginalData[tStartIndex++];
					tSrcBone.resultTransform.skewY = tParentTransform.skewY + _curOriginalData[tStartIndex++];
				}
				
			}
			//对插槽进行插值计算
			var tSlotDic:Object = {};
			var tSlotAlphaDic:Object = {};
			var tBoneData:*;
			for (n += tSectionArr[1]; i < n; i++) {
				tBoneData = bones[i];
				tSlotDic[tBoneData.name] = _curOriginalData[tStartIndex++];
				tSlotAlphaDic[tBoneData.name] = _curOriginalData[tStartIndex++];
				//预留
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
			}
			//ik
			var tBendDirectionDic:Object = { };
			var tMixDic:Object = { };
			for (n += tSectionArr[2]; i < n; i++) {
				tBoneData = bones[i];
				tBendDirectionDic[tBoneData.name] = _curOriginalData[tStartIndex++];
				tMixDic[tBoneData.name] = _curOriginalData[tStartIndex++];
				//预留
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
				_curOriginalData[tStartIndex++];
			}
			//path
			if (_pathDic)
			{
				var tPathConstraint:PathConstraint;
				for (n += tSectionArr[3]; i < n; i++) {
					tBoneData = bones[i];
					tPathConstraint = _pathDic[tBoneData.name];
					if (tPathConstraint)
					{
						var tByte:Byte = new Byte(tBoneData.extenData);
						switch(tByte.getByte())
						{
							case 1://position
								tPathConstraint.position = _curOriginalData[tStartIndex++];
								break;
							case 2://spacing
								tPathConstraint.spacing = _curOriginalData[tStartIndex++];
								break;
							case 3://mix
								tPathConstraint.rotateMix = _curOriginalData[tStartIndex++];
								tPathConstraint.translateMix = _curOriginalData[tStartIndex++];
								break;
						}
					}
				}
			}
			if (_yReverseMatrix)
			{
				_rootBone.update(_yReverseMatrix);
			}else {
				_rootBone.update(Matrix.TEMP.identity());
			}
			//刷新IK作用器
			if (_ikArr)
			{
				var tIkConstraint:IkConstraint;
				for (i = 0, n = _ikArr.length; i < n; i++)
				{
					tIkConstraint = _ikArr[i];
					if (tBendDirectionDic.hasOwnProperty(tIkConstraint.name))
					{
						tIkConstraint.bendDirection = tBendDirectionDic[tIkConstraint.name];
					}
					if (tMixDic.hasOwnProperty(tIkConstraint.name))
					{
						tIkConstraint.mix = tMixDic[tIkConstraint.name]
					}
					tIkConstraint.apply();
					//tIkConstraint.updatePos(this.x, this.y);
				}
			}
			//刷新PATH作用器
			if (_pathDic)
			{
				for (var tPathStr:String in _pathDic)
				{
					tPathConstraint = _pathDic[tPathStr];
					tPathConstraint.apply(_boneList,tGraphics);
				}
			}
			//刷新transform作用器
			if (_tfArr)
			{
				var tTfConstraint:TfConstraint;
				for (i = 0, k = _tfArr.length; i < k; i++)
				{
					tTfConstraint = _tfArr[i];
					tTfConstraint.apply();
				}
			}
			
			for (i = 0, k = _boneList.length; i < k; i++)
			{
				tSrcBone = _boneList[i];
				tDBBoneSlotArr = _bindBoneBoneSlotDic[tSrcBone.name];
				tSrcBone.resultMatrix.copyTo(_boneMatrixArray[i]);
				if (tDBBoneSlotArr) {
					for (j = 0, n = tDBBoneSlotArr.length; j < n; j++) {
						tDBBoneSlot = tDBBoneSlotArr[j];
						if (tDBBoneSlot) {
							tDBBoneSlot.setParentMatrix(tSrcBone.resultMatrix);
						}
					}
				}
			}
			var tDeformDic:Object = { };
			//变形动画作用器
			var tDeformAniArr:Array = _templet.deformAniArr;
			var tDeformAniData:DeformAniData;
			var tDeformSlotData:DeformSlotData;
			var tDeformSlotDisplayData:DeformSlotDisplayData;
			if (tDeformAniArr && tDeformAniArr.length > 0) {	
				if (_lastAniClipIndex != _aniClipIndex) {	
					_lastAniClipIndex = _aniClipIndex;
					for (i = 0, n = _boneSlotArray.length; i < n; i++) {	
						tDBBoneSlot = _boneSlotArray[i];
						tDBBoneSlot.deformData = null;
					}
				}		
				var tSkinDeformAni:Object = tDeformAniArr[_aniClipIndex];
				//使用default数据
				tDeformAniData = (tSkinDeformAni["default"]) as DeformAniData;
				_setDeform(tDeformAniData,tDeformDic,_boneSlotArray,curTime);

				//使用其他皮肤的数据
					var tSkin:String;
					for (tSkin in tSkinDeformAni)
					{
						if (tSkin!="default"&&tSkin!=_skinName)
						{
							tDeformAniData = tSkinDeformAni[tSkin] as DeformAniData;
							_setDeform(tDeformAniData,tDeformDic,_boneSlotArray,curTime);
						}		
					}
				
				//使用自己皮肤的数据
				tDeformAniData = (tSkinDeformAni[_skinName]) as DeformAniData;
				_setDeform(tDeformAniData,tDeformDic,_boneSlotArray,curTime);
			}
			
			//_rootBone.updateDraw(this.x,this.y);
			var tSlotData2:*;
			var tSlotData3:*;
			var tObject:Object;
			//把动画按插槽顺序画出来
			if (_drawOrder)
			{
				for (i = 0, n = _drawOrder.length; i < n; i++) {
					tDBBoneSlot = _boneSlotArray[_drawOrder[i]];
					tSlotData2 = tSlotDic[tDBBoneSlot.name];
					tSlotData3 = tSlotAlphaDic[tDBBoneSlot.name];
					if (!isNaN(tSlotData3)) {
						tGraphics.save();
						tGraphics.alpha(tSlotData3);
					}
					if (!isNaN(tSlotData2)&&tSlotData2!=-2) {
						
						if (_templet.attachmentNames) {	
							tDBBoneSlot.showDisplayByName(_templet.attachmentNames[tSlotData2]);
						}else {
							tDBBoneSlot.showDisplayByIndex(tSlotData2);
						}
					}
					if (tDeformDic[_drawOrder[i]])
					{
						tObject = tDeformDic[_drawOrder[i]];
						if (tDBBoneSlot.currDisplayData && tObject[tDBBoneSlot.currDisplayData.attachmentName])
						{
							tDBBoneSlot.deformData = tObject[tDBBoneSlot.currDisplayData.attachmentName];
						}else {
							tDBBoneSlot.deformData = null;
						}
					}else {
						tDBBoneSlot.deformData = null;
					}
					if (!isNaN(tSlotData3)) {
						tDBBoneSlot.draw(tGraphics, _boneMatrixArray, _aniMode == 2,tSlotData3);
					}else {
						tDBBoneSlot.draw(tGraphics, _boneMatrixArray, _aniMode == 2);
					}
					if (!isNaN(tSlotData3)) {
						tGraphics.restore();
					}
				}
			}else {
				for (i = 0, n = _boneSlotArray.length; i < n; i++) {
					tDBBoneSlot = _boneSlotArray[i];
					tSlotData2 = tSlotDic[tDBBoneSlot.name];
					tSlotData3 = tSlotAlphaDic[tDBBoneSlot.name];
					if (!isNaN(tSlotData3)) {
						tGraphics.save();
						tGraphics.alpha(tSlotData3);
					}
					if (!isNaN(tSlotData2)&&tSlotData2!=-2) {
						if (_templet.attachmentNames) {	
							tDBBoneSlot.showDisplayByName(_templet.attachmentNames[tSlotData2]);
						}else {
							tDBBoneSlot.showDisplayByIndex(tSlotData2);
						}
					}
					if (tDeformDic[i])
					{
						tObject = tDeformDic[i];
						if (tDBBoneSlot.currDisplayData && tObject[tDBBoneSlot.currDisplayData.attachmentName])
						{
							tDBBoneSlot.deformData = tObject[tDBBoneSlot.currDisplayData.attachmentName];
						}else {
							tDBBoneSlot.deformData = null;
						}
					}else {
						tDBBoneSlot.deformData = null;
					}
					if (!isNaN(tSlotData3)) {
						tDBBoneSlot.draw(tGraphics, _boneMatrixArray, _aniMode == 2,tSlotData3);
					}else {
						tDBBoneSlot.draw(tGraphics, _boneMatrixArray, _aniMode == 2);
					}
					if (!isNaN(tSlotData3)) {
						tGraphics.restore();
					}
				}
			}
			if (_aniMode == 0) {
				_templet.setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
			} else if (_aniMode == 1) {
				_setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
			}
		}
		/**
		 * 设置deform数据
		 * @param	tDeformAniData
		 * @param	tDeformDic
		 * @param	_boneSlotArray
		 * @param	curTime
		 */
		private function _setDeform(tDeformAniData:DeformAniData,tDeformDic:Object,_boneSlotArray:Array,curTime:Number):void
		{
			if (!tDeformAniData) return;
			var tDeformSlotData:DeformSlotData;
			var tDeformSlotDisplayData:DeformSlotDisplayData;
			var tDBBoneSlot:BoneSlot;
			var i:int, n:int,j:int;			
			if (tDeformAniData) {	
					for (i = 0, n = tDeformAniData.deformSlotDataList.length; i < n; i++) {	
						tDeformSlotData = tDeformAniData.deformSlotDataList[i];
						for (j = 0; j < tDeformSlotData.deformSlotDisplayList.length; j++) {	
							tDeformSlotDisplayData = tDeformSlotData.deformSlotDisplayList[j];
							tDBBoneSlot = _boneSlotArray[tDeformSlotDisplayData.slotIndex];
							tDeformSlotDisplayData.apply(curTime, tDBBoneSlot);
							if (!tDeformDic[tDeformSlotDisplayData.slotIndex]) {	
								tDeformDic[tDeformSlotDisplayData.slotIndex] = { };
							}
							tDeformDic[tDeformSlotDisplayData.slotIndex][tDeformSlotDisplayData.attachment] = tDeformSlotDisplayData.deformData;
						}
					}
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
		 * @param	freshSlotIndex	是否将插槽纹理重置到初始化状态
		 */
		public function showSkinByName(name:String,freshSlotIndex:Boolean=true):void {
			showSkinByIndex(_templet.getSkinIndexByName(name),freshSlotIndex);
		}
		
		/**
		 * 通过索引显示一套皮肤
		 * @param	skinIndex	皮肤索引
		 * @param	freshSlotIndex	是否将插槽纹理重置到初始化状态
		 */
		public function showSkinByIndex(skinIndex:int, freshSlotIndex:Boolean = true):void {
			for (var i:int = 0; i < _boneSlotArray.length; i++)
			{
				(_boneSlotArray[i] as BoneSlot).showSlotData(null,freshSlotIndex);
			}
			if (_templet.showSkinByIndex(_boneSlotDic, skinIndex,freshSlotIndex))
			{
				var tSkinData:SkinData = _templet.skinDataArray[skinIndex];
				_skinIndex = skinIndex;
				_skinName = tSkinData.name;
			}
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
		 * 设置某插槽的皮肤
		 * @param	slotName	插槽名称
		 * @param	name	皮肤名称
		 */
		public function showSlotSkinByName(slotName:String, name:String):void {
			if (_aniMode == 0) return;
			var tBoneSlot:BoneSlot = getSlotByName(slotName);
			if (tBoneSlot) {
				tBoneSlot.showDisplayByName(name);
			}
			_clearCache();
		}
		
		/**
		 * 替换插槽贴图名
		 * @param	slotName 插槽名称
		 * @param	oldName 要替换的贴图名
		 * @param	newName 替换后的贴图名
		 */
		public function replaceSlotSkinName(slotName:String,oldName:String, newName:String):void {
			if (_aniMode == 0) return;
			var tBoneSlot:BoneSlot = getSlotByName(slotName);
			if (tBoneSlot) {
				tBoneSlot.replaceDisplayByName(oldName, newName);
			}
			_clearCache();
		}
		
		/**
		 * 替换插槽的贴图索引
		 * @param	slotName 插槽名称
		 * @param	oldIndex 要替换的索引
		 * @param	newIndex 替换后的索引
		 */
		public function replaceSlotSkinByIndex(slotName:String, oldIndex:int, newIndex:int):void {
			if (_aniMode == 0) return;
			var tBoneSlot:BoneSlot = getSlotByName(slotName);
			if (tBoneSlot) {
				tBoneSlot.replaceDisplayByIndex(oldIndex, newIndex);
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
		 * @param	start		起始时间
		 * @param	end			结束时间
		 * @param	freshSkin	是否刷新皮肤数据
		 */
		public function play(nameOrIndex:*, loop:Boolean, force:Boolean = true, start:int = 0, end:int = 0,freshSkin:Boolean=true):void {
			_indexControl = false;
			var index:int = -1;
			var duration:Number;
			if (loop) {
				duration = 2147483647;//int.MAX_VALUE;
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
				_aniClipIndex = index;
				if (force || _pause || _currAniIndex != index) {
					_currAniIndex = index;
					_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(index));
					_drawOrder = null;
					_eventIndex = 0;
					_player.play(index, _player.playbackRate, duration, start, end);
					if(freshSkin)
					this._templet.showSkinByIndex(_boneSlotDic, _skinIndex);		
					if (_pause) {
						_pause = false;
						_lastTime = Browser.now();
						Laya.stage.frameLoop(1, this, _update, null, true);
					}
					_update();
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
			_indexControl = false;
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
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_templet = null;//动画解析器
			_player.offAll();
			_player = null;// 播放器
			_curOriginalData = null;//当前骨骼的偏移数据
			_boneMatrixArray.length = 0;//当前骨骼动画的最终结果数据
			_lastTime = 0;//上次的帧时间
			Laya.timer.clear(this, _update);
		}
		
		/**
		 * @private
		 * 得到帧索引
		 */
		public function get index():int {
			return _index;
		}
		
		/**
		 * @private
		 * 设置帧索引
		 */
		public function set index(value:int):void {
			if (player) {
				_index = value;
				_player.currentTime = _index * 1000 / _player.cacheFrameRate;
				_indexControl = true;
				_update(false);
			}
		}
		
		/**
		 * 得到总帧数据
		 */
		public function get total():int {
			if (_templet && _player) {
				_total = Math.floor(_templet.getAniDuration(_player.currentAnimationClipIndex) / 1000 * _player.cacheFrameRate);
			} else {
				_total = -1;
			}
			return _total;
		}
		
		/**
		 * 得到播放器的引用
		 */
		public function get player():AnimationPlayer {
			return _player;
		}
	}
}