package laya.d3.component.animation {
	import laya.ani.AnimationState;
	import laya.ani.AnimationTemplet;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.d3.core.ComponentNode;
	
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
		private var _curOriginalData:Float32Array;
		/** @private */
		private var _lastFrameIndex:int = -1;
		/** @private */
		private var _curAnimationDatas:Float32Array;
		
		/**
		 * 设置url地址。
		 * @param value 地址。
		 */
		override public function set url(value:String):void {
			trace("Warning: discard property,please use templet property instead.");
			var templet:AnimationTemplet = Laya.loader.create(value, null, null, AnimationTemplet);
			if (_templet !== templet) {
				if (_player.state !== AnimationState.stopped)
					_player.stop(true);
				
				_templet = templet;
				_player.templet = templet;
				_curOriginalData = null;
				_curAnimationDatas = null;
				_tempCurAnimationData = null;
				(_templet._animationDatasCache) || (_templet._animationDatasCache = []);
				event(Event.ANIMATION_CHANGED, this);
			}
		}
		
		override public function set templet(value:AnimationTemplet):void {
			if (_templet !== value) {
				if (_player.state !== AnimationState.stopped)
					_player.stop(true);
				
				_templet = value;
				_player.templet = value;
				_curOriginalData = null;
				_curAnimationDatas = null;
				_tempCurAnimationData = null;
				(_templet._animationDatasCache) || (_templet._animationDatasCache = []);
				event(Event.ANIMATION_CHANGED, this);
			}
		}
		
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
		private function _animtionPlay():void {
			if (_templet.loaded)
				_init();
			else
				_templet.once(Event.LOADED, this, _init);
		}
		
		/**
		 * @private
		 */
		private function _animtionStop():void {
			_lastFrameIndex = -1;
			if (_player.returnToZeroStopped) {
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
		override public function _load(owner:ComponentNode):void {
			super._load(owner);
			_player.on(Event.STOPPED, this, _animtionStop);
			_player.on(Event.PLAYED, this, _animtionPlay);
		}
		
		/**
		 * @private
		 * 更新摄像机动画组件。
		 * @param	state 渲染状态。
		 */
		public override function _update(state:RenderState):void {
			if (_player.state !== AnimationState.playing || !_templet || !_templet.loaded)
				return;
			
			var rate:Number = _player.playbackRate * Laya.timer.scale;
			var cachePlayRate:Number = _player.cachePlayRate;
			var isCache:Boolean = _player.isCache && rate >= cachePlayRate;//是否可以缓存
			var frameIndex:int = isCache ? currentFrameIndex : -1;//慢动作或者不缓存时frameIndex为-1
			if (frameIndex !== -1 && _lastFrameIndex === frameIndex)//与上一次更新同帧则直接返回
				return;
			
			var animationClipIndex:int = currentAnimationClipIndex;
			var nodes:Vector.<Object> = _templet.getNodes(animationClipIndex);
			var animationDatasCache:Array = _templet._animationDatasCache;
			if (isCache) {
				var cacheData:Float32Array = _templet.getAnimationDataWithCache(cachePlayRate, animationDatasCache, animationClipIndex, frameIndex);
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
				_templet.getOriginalData(animationClipIndex, _curOriginalData, _player._fullFrames[animationClipIndex], frameIndex, _player.currentFrameTime);
			else//慢动作或者不缓存时
				_templet.getOriginalDataUnfixedRate(animationClipIndex, _curOriginalData, _player.currentPlayTime);
			
			Utils3D._computeRootAnimationData(nodes, _curOriginalData, _curAnimationDatas);
			
			if (isCache) {
				_templet.setAnimationDataWithCache(cachePlayRate, animationDatasCache, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
			}
			
			_lastFrameIndex = frameIndex;
			
			_effectAnimation(nodes);//动画作用模块（待优化，需剥离）
		}
		
		/**
		 * @private
		 * 卸载组件时执行。
		 */
		override public function _unload(owner:ComponentNode):void {
			super._unload(owner);
			_animationSprites = null;
			_animationSpritesInitLocalMatrix = null;
			_tempCurAnimationData = null;
			_curOriginalData = null;
			_curAnimationDatas = null;
		}
	}
}