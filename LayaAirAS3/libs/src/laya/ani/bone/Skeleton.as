package laya.ani.bone {
	import laya.ani.AnimationPlayer;
	import laya.ani.bone.BoneSlot;
	import laya.ani.bone.SkinData;
	import laya.ani.bone.SkinSlotDisplayData;
	import laya.ani.bone.SlotData;
	import laya.ani.bone.Templet;
	import laya.ani.bone.Transform;
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.Browser;
	
	/**
	 * 骨骼动画由KeyframesAniTemplet(LayaFactory),AnimationPlayer,Armature三部分组成
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
		private var _pause:Boolean = false;
		private var _aniClipIndex:int = -1;
		private var _clipIndex:int = -1;
		
		/**
		 * 初始化动画
		 * @param	templet
		 */
		public function init(templet:Templet, rate:int):void {
			_templet = templet;
			_player = new AnimationPlayer(rate);
			_player.templet = templet;
			_player.play();
			parseSrcBoneMatrix();
			_lastTime = Browser.now();
			Laya.stage.frameLoop(1, this, update, null, true);
		}
		
		/**
		 * 创建骨骼的矩阵，保证每次计算的最终结果
		 */
		private function parseSrcBoneMatrix():void {
			var tBoneLen:int = _templet.getNodeCount(0);
			for (var i:int = 0; i < tBoneLen; i++) {
				_boneMatrixArray.push(new Matrix());
			}
			showSkinByIndex(0);
		}
		
		/**
		 * 更新动画
		 */
		public function update():void {
			if (_pause) return;
			var tCurrTime:Number = Laya.stage.now;
			_player.update(tCurrTime - _lastTime);
			_lastTime = tCurrTime;
			_aniClipIndex = _player.currentAnimationClipIndex;
			_clipIndex = _player.currentKeyframeIndex;
			if (_aniClipIndex == -1) return;
			var tGraphics:Graphics = _templet.getGrahicsDataWithCache(_aniClipIndex, _clipIndex);
			if (tGraphics) {
				this.graphics = tGraphics;
				return;
			}
			createGraphics();
		}
		
		/**
		 * 创建grahics图像
		 */
		private function createGraphics():void {
			var bones:Vector.<*> = _templet.getNodes(_aniClipIndex);
			var boneCount:int = bones.length;
			_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(0)));
			_templet.getOriginalData(_aniClipIndex, _curOriginalData, _clipIndex, _player.currentFrameTime);
			//_templet.getOriginalDataUnfixedRate(_aniClipIndex, _curOriginalData, _player.currentTime);
			var tParentMatrix:Matrix;//父骨骼矩阵的引用
			var tResultMatrix:Matrix;//保证骨骼计算的最终结果
			var tStartIndex:int = 0;
			var i:int = 0, j:int = 0, k:int = 0, n:int = 0;
			var tDBBoneSlot:BoneSlot;
			var tTempMatrix:Matrix;
			var tParentTransform:Transform;
			for (i = 0; i < boneCount; i++) {
				tResultMatrix = _boneMatrixArray[i];
				tStartIndex = i * 6;
				tParentTransform = _templet.srcBoneMatrixArr[i];
				_tempTransform.scX = tParentTransform.scX * _curOriginalData[tStartIndex];
				_tempTransform.skX = tParentTransform.skX + _curOriginalData[tStartIndex + 1];
				_tempTransform.skY = tParentTransform.skY + _curOriginalData[tStartIndex + 2];
				_tempTransform.scY = tParentTransform.scY * _curOriginalData[tStartIndex + 3];
				_tempTransform.x = tParentTransform.x + _curOriginalData[tStartIndex + 4];
				_tempTransform.y = tParentTransform.y + _curOriginalData[tStartIndex + 5];
				tTempMatrix = _tempTransform.getMatrix();
				//骨骼数据乘以父矩阵，求出最终矩阵
				var tBone:* = bones[i];
				if (tBone.parentIndex != -1) {
					tParentMatrix = _boneMatrixArray[tBone.parentIndex];
					Matrix.mul(tTempMatrix, tParentMatrix, tResultMatrix);
				} else {
					tTempMatrix.copy(tResultMatrix);
				}
				tDBBoneSlot = _templet.boneSlotDic[tBone.name];
				if (tDBBoneSlot) {
					tDBBoneSlot.setParentMatrix(tResultMatrix);
				}
			}
			var tGraphics:Graphics;
			this.graphics = tGraphics = new Graphics();
			//把动画按插槽顺序画出来
			for (i = 0, n = _templet.boneSlotArray.length; i < n; i++) {
				tDBBoneSlot = _templet.boneSlotArray[i];
				tDBBoneSlot.draw(tGraphics);
			}
			_templet.setGrahicsDataWithCache(_aniClipIndex, _clipIndex, tGraphics);
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
		 * @param	index
		 */
		public function getAniNameByIndex(index:int):String {
			return _templet.getAniNameByIndex(index);
		}
		
		public function getSlotByName(name:String):BoneSlot {
			return null;
		}
		
		/**
		 * 显示某块皮肤
		 * @param	name
		 */
		/*public function showSkinByName(name:String):void {
			
		}*/
		
		/**
		 * 设置皮肤
		 * @param	name
		 * @param	texture
		 */
		/*public function setSlotSkin(name:String, texture:Texture):void
		{
			var tBoneSlot:BoneSlot = getSlotByName(name);
			tBoneSlot.replaceSkin(texture);
		}*/
		
		/**
		 * 设置皮肤
		 * @param	index
		 */
		/*public function setSlotSkinByIndex(index:int,texture:Texture):void
		{
			if (index > -1 && index < _templet.boneSlotArray.length)
			{
				var tBoneSlot:BoneSlot = _templet.boneSlotArray[index];
				tBoneSlot.replaceSkin(texture);
			}
		}*/
		
		/**
		 * 
		 * @param	skinIndex
		 */
		public function showSkinByIndex(skinIndex:int):void {
			if (skinIndex < _templet.skinDataArray.length) {
				var tDBSkinData:SkinData;
				var tDBSlotData:SlotData;
				var tDBDisplayData:SkinSlotDisplayData;
				tDBSkinData = _templet.skinDataArray[skinIndex];
				for (var i:int = 0, n:int = tDBSkinData.slotArr.length; i < n; i++) {
					tDBSlotData = tDBSkinData.slotArr[i];
					var tDBBoneSlot:BoneSlot = _templet.boneSlotDic[tDBSlotData.name];
					for (var j:int = 0; j < tDBSlotData.displayArr.length; j++) {
						tDBDisplayData = tDBSlotData.displayArr[j];
						var tTexture:Texture = _templet.subTextureDic[tDBDisplayData.name];
						tDBBoneSlot.addSprite(tTexture, tDBDisplayData);
					}
				}
			}
		}
		
		/**
		 * 根据动画，播放指定的动画
		 * @param	name
		 * @param	duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）
		 */
		public function gotoAndPlay(name:String, duration:Number = Number.MAX_VALUE):void {
			for (var i:int = 0, n:int = _templet.getAnimationCount(); i < n; i++) {
				var animation:* = _templet.getAnimation(i);
				if (animation && name == animation.name) {
					gotoAndPlayByIndex(i, duration);
					return;
				}
			}
		}
		
		/**
		 * 通过动画索引，播放指定的动画
		 * @param	index
		 * @param	duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）
		 */
		public function gotoAndPlayByIndex(index:int, duration:Number = Number.MAX_VALUE):void {
			if (index > -1 && index < getAnimNum()) {
				if (_currAniIndex != index) {
					_currAniIndex = index;
					_player.play(index, 1, duration);
				}
			}
		}
		
		/**
		 * 播放动画
		 */
		public function play():void {
			if (_currAniIndex == -1 && getAnimNum() > 0) {
				_currAniIndex = 0;
				gotoAndPlayByIndex(_currAniIndex);
			}
			_pause = false;
		}
		
		/**
		 * 停止动画
		 */
		public function stop():void {
			_pause = true;
		}
		
		/**
		 * 销毁当前动画
		 */
		public function destory():void {
			_templet = null;//动画解析器
			_player = null;// 播放器
			_curOriginalData = null;//当前骨骼的偏移数据
			_boneMatrixArray.length = 0;//当前骨骼动画的最终结果数据
			_lastTime = 0;//上次的帧时间
			//_tempTransform:DBTransform = new DBTransform();
			Laya.timer.clear(this, update);
		}
		
		/*****************************下面为一些兼容接口，下次大改时，会去掉************************************/
		public function Skeleton(templet:Templet):void
		{
			if(templet)
			init(templet, templet.rate);
		}
		
		public function stAnimName(name:String):void
		{
			gotoAndPlay(name);
			stop();
		}
	}
}