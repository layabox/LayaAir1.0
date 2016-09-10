package laya.d3.component.animation {
	import laya.ani.AnimationState;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Camera;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.events.Event;
	
	/**
	 * <code>RigidAnimations</code> 类用于创建变换动画组件。
	 */
	public class RigidAnimations extends KeyframeAnimations {
		/** @private */
		private var _animationSprites:Vector.<Sprite3D>;
		/** @private */
		private var _animationSpritesInitLocalMatrix:Vector.<Matrix4x4>;
		
		/** @private */
		private var _tempCurAnimationData:Float32Array;
		/** @private */
		protected var _curOriginalData:Float32Array;
		/** @private */
		private var _lastFrameIndex:int = -1;
		/** @private */
		private var _curAnimationDatas:Float32Array;
		
		/**
		 * 创建一个新的 <code>RigidAnimations</code> 实例。
		 */
		public function RigidAnimations() {
			super();
			_animationSprites = new Vector.<Sprite3D>();
			_animationSpritesInitLocalMatrix = new Vector.<Matrix4x4>();
		}
		
		/**
		 * @private
		 */
		private function _init():void {
			var nodes:Vector.<Object> = _templet.getNodes(currentAnimationClipIndex);
			var curParentSprite:Node = _owner;//节点初始父节点
			var nodeLength:int = nodes.length;
			
			var pathStart:int = 0;
			var extentDatas:Uint16Array = new Uint16Array(_templet.getPublicExtData());
			for (var i:int = 0; i < nodeLength; i++) {
				var hierarchys:Array = extentDatas.slice(pathStart + 1, pathStart + 1 + extentDatas[pathStart]);//父节点编号队列
				pathStart += (extentDatas[pathStart] + 1);
				for (var j:int = 1; j < hierarchys.length; j++) {//0为默认根节点
					var childIndex:int = hierarchys[j];
					curParentSprite = curParentSprite._childs[hierarchys[j]];
				}
				var curSprite:Sprite3D = curParentSprite.getChildByName(nodes[i].name) as Sprite3D;
				if (!curSprite)
					break;
				_animationSprites[i] = curSprite;
				
				var localMatrix:Matrix4x4 = _animationSpritesInitLocalMatrix[i];
				(localMatrix) || (localMatrix = _animationSpritesInitLocalMatrix[i] = new Matrix4x4());
				curSprite.transform.localMatrix.cloneTo(localMatrix);
				curParentSprite = _owner;
			}
		}
		
		/**
		 * @private
		 */
		private function _animtionStop():void {
			_lastFrameIndex = -1;
			if (player.returnToZeroStopped) {
				_curAnimationDatas = null;
				
				for (var i:int = 0; i < _animationSprites.length; i++)
					_animationSprites[i].transform.localMatrix = _animationSpritesInitLocalMatrix[i];
			}
		}
		
		/**
		 * @private
		 * 摄像机动画作用函数。
		 */
		private function _effectAnimation(nodes:Vector.<Object>):void {
			for (var nodeIndex:int = 0, nodeLength:int = _animationSprites.length; nodeIndex < nodeLength; nodeIndex++) {
				var sprite:Sprite3D = _animationSprites[nodeIndex];
				
				var matrix:Matrix4x4 = sprite.transform.localMatrix;
				var matrixE:Float32Array = matrix.elements;
				for (var i:int = 0; i < 16; i++)
					matrixE[i] = _curAnimationDatas[nodeIndex * 16 + i];
				
				sprite.transform.localMatrix = matrix;
			}
		}
		
		/**
		 * @private
		 * 初始化载入摄像机动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			player.on(Event.STOPPED, this, _animtionStop);
		}
		
		/**
		 * @private
		 * 更新摄像机动画组件。
		 * @param	state 渲染状态。
		 */
		public override function _update(state:RenderState):void {
			player.update(state.elapsedTime);//需最先执行（如不则内部可能触发Stop事件等，如事件中加载新动画，可能_templet未加载完成，导致BUG）
			
			if (player.state !== AnimationState.playing || !_templet || !_templet.loaded)
				return;
			
			var rate:Number = player.playbackRate * state.scene.timer.scale;
			var isCache:Boolean = player.isCache && rate >= 1.0;//是否可以缓存
			var frameIndex:int = isCache ? currentFrameIndex : -1;//慢动作或者不缓存时frameIndex为-1
			if (frameIndex !== -1 && _lastFrameIndex === frameIndex)//与上一次更新同帧则直接返回
				return;
			
			var animationClipIndex:int = currentAnimationClipIndex;
			var nodes:Vector.<Object> = _templet.getNodes(animationClipIndex);
			
			if (isCache) {
				var cacheData:Float32Array = _templet.getAnimationDataWithCache(_templet._animationDatasCache, animationClipIndex, frameIndex);
				if (cacheData) {
					_curAnimationDatas = cacheData;
					_lastFrameIndex = frameIndex;
					
					_effectAnimation(nodes);//动画作用模块（待优化，需剥离）
					return;
				}
			}
			
			var nodeFloatCount:int = nodes.length * 16;
			if (isCache) {
				_curAnimationDatas = new Float32Array(nodeFloatCount);
			} else//非缓存或慢动作用临时数组做计算,只new一次
			{
				(_tempCurAnimationData) || (_tempCurAnimationData = new Float32Array(nodeFloatCount));//使用临时数组，防止对已缓存数据造成破坏
				_curAnimationDatas = _tempCurAnimationData;
			}
			
			_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(animationClipIndex)));
			
			if (isCache)
				_templet.getOriginalData(animationClipIndex, _curOriginalData, frameIndex, player.currentFrameTime);
			else//慢动作或者不缓存时
				_templet.getOriginalDataUnfixedRate(animationClipIndex, _curOriginalData, player.currentPlayTime);
			
			Utils3D._computeRootAnimationData(nodes, _curOriginalData, _curAnimationDatas);
			
			if (isCache) {
				_templet.setAnimationDataWithCache(_templet._animationDatasCache, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
			}
			
			_lastFrameIndex = frameIndex;
			
			_effectAnimation(nodes);//动画作用模块（待优化，需剥离）
		}
		
		/**
		 * @private
		 * 卸载组件时执行。
		 */
		override public function _unload(owner:Sprite3D):void {
			super._unload(owner);
			player.off(Event.STOPPED, this, _animtionStop);
		}
		
		/**
		 * 播放动画。
		 * @param	index 动画索引。
		 * @param	playbackRate 播放速率。
		 * @param	duration 播放时长（0为1次,Number.MAX_VALUE为循环播放）。
		 * @param	playStart 播放的起始时间位置。
		 * @param	playEnd 播放的结束时间位置。（0为动画一次循环的最长结束时间位置）。
		 */
		override public function play(index:int = 0, playbackRate:Number = 1.0, overallDuration:Number = Number.MAX_VALUE, playStart:Number = 0, playEnd:Number = 0):void {
			super.play(index, playbackRate, overallDuration, playStart, playEnd);
			
			if (_templet.loaded)
				_init();
			else
				_templet.once(Event.LOADED, this, _init);
		}
	
	}
}