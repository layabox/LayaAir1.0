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
	/**
	 * 骨骼动画由Templet,AnimationPlayer,Skeleton三部分组成
	 */
	public class Skeleton extends Sprite {
		
		private var _templet:Templet;//动画解析器
		private var _player:AnimationPlayer;//播放器
		private var _curOriginalData:Float32Array;//当前骨骼的偏移数据
		private var _boneMatrixArray:Array = [];//当前骨骼动画的最终结果数据
		private var _lastTime:Number = 0;//上次的帧时间
		private var _currAniName:String = null;
		private var _currAniIndex:int = -1;
		private var _pause:Boolean = true;
		private var _aniClipIndex:int = -1;
		private var _clipIndex:int = -1;
		private var _skinIndex:int = 0;
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
		private var _rootBone:Bone;
		private var _boneList:Vector.<Bone>;
		private var _aniSectionDic:Object;
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
			_yReverseMatrix = templet.yReverseMatrix;
			_aniMode = aniMode;
			_templet = templet;
			_player = new AnimationPlayer(templet.rate);
			_player.templet = templet;
			_player.play();
			_parseSrcBoneMatrix();
			//ik跟骨骼数据
			_ikArr = templet.ikArr;
			_boneList = templet.mBoneArr;
			_rootBone = templet.mRootBone;
			_aniSectionDic = templet.aniSectionDic;
			
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
				tFactory.parseData(tTexture, arraybuffer, 60);
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
			if (autoKey) {
				_player.update(tCurrTime - _lastTime)
			}
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
			_templet.getOriginalData(_aniClipIndex, _curOriginalData, _clipIndex, _player.currentFrameTime);
			
			var tSectionArr:Array = _aniSectionDic[_aniClipIndex];
			var tParentMatrix:Matrix;//父骨骼矩阵的引用
			var tResultMatrix:Matrix;//保证骨骼计算的最终结果
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
				tResultMatrix = _boneMatrixArray[i];
				tParentTransform = _templet.srcBoneMatrixArr[i];
				tSrcBone.resultTransform.scX = tParentTransform.scX * _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.skX = tParentTransform.skX + _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.skY = tParentTransform.skY + _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.scY = tParentTransform.scY * _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.x = tParentTransform.x + _curOriginalData[tStartIndex++];
				tSrcBone.resultTransform.y = tParentTransform.y + _curOriginalData[tStartIndex++];
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
			}
			if (_yReverseMatrix)
			{
				_rootBone.update(_yReverseMatrix);
			}else {
				_rootBone.update(Matrix.TEMP.identity());
			}
			var tIkConstraintData:IkConstraintData;
			var tTargetBone:Bone;
			var tParentBone:Bone;
			var tChildBone:Bone;
			for (i = 0, n = _ikArr.length; i < n; i++)
			{
				tIkConstraintData = _ikArr[i];
				tTargetBone = _boneList[tIkConstraintData.targetBoneIndex];
				switch(tIkConstraintData.boneIndexs.length)
				{
					case 1:
						tChildBone = _boneList[tIkConstraintData.boneIndexs[0]];
						_applyIk1(tChildBone,tTargetBone.resultMatrix.tx,tTargetBone.resultMatrix.ty,tIkConstraintData.mix);
						break;
					case 2:
						tParentBone = _boneList[tIkConstraintData.boneIndexs[0]];
						tChildBone = _boneList[tIkConstraintData.boneIndexs[1]];
						if (tBendDirectionDic[tIkConstraintData.name])
						{
							_applyIk2(tParentBone, tChildBone, tTargetBone.resultMatrix.tx, tTargetBone.resultMatrix.ty, tBendDirectionDic[tIkConstraintData.name], tMixDic[tIkConstraintData.name]);
						}else {
							_applyIk2(tParentBone, tChildBone, tTargetBone.resultMatrix.tx, tTargetBone.resultMatrix.ty, tIkConstraintData.bendDirection, tIkConstraintData.mix);
						}
						break;
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
				tDBBoneSlot.draw(tGraphics, _boneMatrixArray, this, _aniMode == 2);
				if (!isNaN(tSlotData3)) {
					tGraphics.restore();
				}
			}
			if (_aniMode == 0) {
				_templet.setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
			} else if (_aniMode == 1) {
				_setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
			}
		}
		
		private function _applyIk1(bone:Bone,targetX:Number,targetY:Number,alpha:Number):void
		{
			var pp:Bone = bone._parent;
			var id:Number = 1 / (pp.resultMatrix.a * pp.resultMatrix.d - pp.resultMatrix.b * pp.resultMatrix.c);
			var x:Number = targetX - pp.resultMatrix.tx;
			var y:Number = targetY - pp.resultMatrix.ty;
			var tx:Number = (x * pp.resultMatrix.d - y * pp.resultMatrix.b) * id - bone.transform.x;
			var ty:Number = (y * pp.resultMatrix.a - x * pp.resultMatrix.c) * id - bone.transform.y;
			var rotationIK:Number = Math.atan2(ty, tx) * radDeg - 0 - bone.transform.skX;
			if (bone.transform.scX < 0) rotationIK += 180;
			if (rotationIK > 180)
				rotationIK -= 360;
			else if (rotationIK < -180) rotationIK += 360;
			bone.transform.skX = bone.transform.skY = bone.transform.skX + rotationIK * alpha;
			bone.update();
		}
		
		private function _applyIk2(parent:Bone,child:Bone,targetX:Number,targetY:Number,bendDir:int,alpha:Number):void
		{
			if (alpha == 0) {
				return;
			}
			var px:Number = parent.resultTransform.x, py:Number = parent.resultTransform.y;
			var psx:Number = parent.resultTransform.scX, psy:Number = parent.resultTransform.scY;
			var csx:Number = child.resultTransform.scX;
			var os1:int, os2:int, s2:int;
			if (psx < 0) {	
				psx = -psx;
				os1 = 180;
				s2 = -1;
			}else {
				os1 = 0;
				s2 = 1;
			}
			if (psy < 0) {	
				psy = -psy;
				s2 = -s2;
			}
			if (csx < 0) {	
				csx = -csx;
				os2 = 180;
			}else {
				os2 = 0
			}
			var cx:Number = child.resultTransform.x, cy:Number, cwx:Number, cwy:Number;
			var a:Number = parent.resultMatrix.a, b:Number = parent.resultMatrix.b;
			var c:Number = parent.resultMatrix.c, d:Number = parent.resultMatrix.d;
			var u:Boolean = Math.abs(psx - psy) <= 0.0001;
			//求子骨骼的世界坐标点
			if (!u) {
				cy = 0;
				cwx = a * cx + parent.resultMatrix.tx;
				cwy = c * cx + parent.resultMatrix.ty;
			}else {
				cy = child.resultTransform.y;
				cwx = a * cx + b * cy + parent.resultMatrix.tx;
				cwy = c * cx + d * cy + parent.resultMatrix.ty;
			}
			var pp:Bone = parent._parent;
			a = pp.resultMatrix.a;
			b = pp.resultMatrix.b;
			c = pp.resultMatrix.c;
			d = pp.resultMatrix.d;
			//逆因子
			var id:Number = 1 / (a * d - b * c);
			//求得IK中的子骨骼角度向量
			var x:Number = targetX - pp.resultMatrix.tx, y:Number = targetY - pp.resultMatrix.ty;
			var tx:Number = (x * d - y * b) * id - px;
			var ty:Number = (y * a - x * c) * id - py;
			//求得子骨骼的角度向量
			x = cwx - pp.resultMatrix.tx;
			y = cwy - pp.resultMatrix.ty;
			var dx:Number = (x * d - y * b) * id - px;
			var dy:Number = (y * a - x * c) * id - py;
			//子骨骼的实际长度
			var l1:Number = Math.sqrt(dx * dx + dy * dy);
			//子骨骼的长度
			var l2:Number = child.length * csx;
			var a1:Number, a2:Number;
			if (u)
			{
				l2 *= psx;
				//求IK的角度
				var cos:Number = (tx * tx + ty * ty - l1 * l1 - l2 * l2) / (2 * l1 * l2);
				if (cos < -1)
					cos = -1;
				else if (cos > 1) cos = 1;
				a2 = Math.acos(cos) * bendDir;
				a = l1 + l2 * cos;
				b = l2 * Math.sin(a2);
				a1 = Math.atan2(ty * a - tx * b, tx * a + ty * b);
			}else {
				a = psx * l2;
				b = psy * l2;
				var aa:Number = a * a, bb:Number = b * b, dd:Number = tx * tx + ty * ty, ta:Number = Math.atan2(ty, tx);
				c = bb * l1 * l1 + aa * dd - aa * bb;
				var c1:Number = -2 * bb * l1, c2:Number = bb -aa;
				d = c1 * c1 - 4 * c2 * c;
				if (d > 0)
				{
					var q:Number = Math.sqrt(d);
					if (c1 < 0) q = -q;
					q = -(c1 + q) / 2;
					var r0:Number = q / c2, r1:Number = c / q;
					var r:Number = Math.abs(r0) < Math.abs(r1)?r0:r1;
					if (r * r <= dd)
					{
						y = Math.sqrt(dd - r * r) * bendDir;
						a1 = ta - Math.atan2(y, r);
						a2 = Math.atan2(y / psy, (r - l1) / psx);
					}
				}
				var minAngle:Number = 0, minDist:Number = Number.MAX_VALUE, minX:Number = 0, minY:Number = 0;
				var maxAngle:Number = 0, maxDist:Number = 0, maxX:Number = 0, maxY:Number = 0;
				x = l1 + a;
				d = x * x;
				if (d > maxDist)
				{
					maxAngle = 0;
					maxDist = d;
					maxX = x;
				}
				x = l1 - a;
				d = x * x;
				if (d < minDist)
				{
					minAngle = Math.PI;
					minDist = d;
					minX = x;
				}
				var angle:Number = Math.acos( -a * l1 / (aa - bb));
				x = a * Math.cos(angle) + l1;
				y = b * Math.sin(angle);
				d = x * x + y * y;
				if (d < minDist)
				{
					minAngle = angle;
					minDist = d;
					minX = x;
					minY = y;
				}
				if (d > maxDist)
				{
					maxAngle = angle;
					maxDist = d;
					maxX = x;
					maxY = y;
				}
				if (dd <= (minDist + maxDist) / 2) {
					a1 = ta - Math.atan2(minY * bendDir, minX);
					a2 = minAngle * bendDir;
				}else {
					a1 = ta - Math.atan2(maxY * bendDir, maxX);
					a2 = maxAngle * bendDir;
				}
			}
			var os:Number = Math.atan2(cy, cx) * s2;
			var rotation:Number = parent.transform.skX;
			a1 = (a1 - os) * radDeg + os1 - rotation;
			if (a1 > 180)
				a1 -= 360;
			else if (a1 < -180) a1 += 360;
			parent.resultTransform.x = px;
			parent.resultTransform.y = py;
			parent.resultTransform.skX = parent.resultTransform.skY = rotation + a1 * alpha;
			rotation = child.transform.skX;
			rotation = rotation % 360;
			a2 = ((a2 + os) * radDeg - 0) * s2 + os2 - rotation;
			if (a2 > 180)
				a2 -= 360;
			else if (a2 < -180) a2 += 360;
			child.resultTransform.x = cx;
			child.resultTransform.y = cy;
			child.resultTransform.skX = child.resultTransform.skY = child.resultTransform.skY + a2 * alpha;
			parent.update();
		}
		static public var radDeg:Number = 180 / Math.PI;
		static public var degRad:Number = Math.PI / 180;
		
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
			_skinIndex = _templet.getSkinIndexByName(name);
			showSkinByIndex(_skinIndex);
		}
		
		/**
		 * 通过索引显示一套皮肤
		 * @param	skinIndex	皮肤索引
		 */
		public function showSkinByIndex(skinIndex:int):void {
			_skinIndex = skinIndex;
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
			_indexControl = false;
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
					_player.play(index, _player.playbackRate, duration);
					this._templet.showSkinByIndex(_boneSlotDic, _skinIndex);
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