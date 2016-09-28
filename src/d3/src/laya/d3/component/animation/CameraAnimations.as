package laya.d3.component.animation {
	import laya.ani.AnimationState;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Camera;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	
	/**
	 * <code>CameraAnimations</code> 类用于创建摄像机动画组件。
	 */
	public class CameraAnimations extends KeyframeAnimations {
		/** @private */
		private var _tempVector30:Vector3 = new Vector3();
		/** @private */
		private var _tempVector31:Vector3 = new Vector3();
		/** @private */
		private var _tempVector32:Vector3 = new Vector3();
		/** @private */
		private var _tempCurAnimationData:Float32Array;
		/** @private */
		private var _lastFrameIndex:int = -1;
		/** @private */
		private var _currentTransform:Matrix4x4;
		/** @private */
		private var _originalAnimationTransform:Matrix4x4;
		/** @private */
		private var _originalFov:Number = 0;
		/** @private */
		private var _camera:Camera;
		/** @private */
		protected var _cacheAnimationDatas:Array = [];
		
		/**
		 * @private
		 * 当前动画数据。
		 */
		private var _currentAnimationData:Float32Array;//待优化,作用器应该写在subMesh中
		/**变换模式。*/
		public var localMode:Boolean = true;
		/**叠加模式。*/
		public var addMode:Boolean = true;
		
		/**
		 * 创建一个新的 <code>CameraAnimations</code> 实例。
		 */
		public function CameraAnimations() {
			super();
		}
		
		/**
		 * @private
		 * 摄像机动画作用函数。
		 */
		private function _effect():void {
			var i:int = 0;
			for (i = 0; i < 3; i++) {
				_tempVector30.elements[i] = _currentAnimationData[i];//eye
				_tempVector31.elements[i] = _currentAnimationData[i + 3];//target
				_tempVector32.elements[i] = _currentAnimationData[i + 6];//up
			}
			
			_currentTransform || (_currentTransform = new Matrix4x4());
			Matrix4x4.createLookAt(_tempVector30, _tempVector31, _tempVector32, _currentTransform);
			_currentTransform.invert(_currentTransform);
			
			if (addMode) {
				Matrix4x4.multiply(_originalAnimationTransform, _currentTransform, _currentTransform);//第二个、第三个矩阵一样在函数内部new
			}
			
			if (localMode)
				owner.transform.localMatrix = _currentTransform;
			else
				owner.transform.worldMatrix = _currentTransform;
			
			_camera.fieldOfView = _currentAnimationData[9];//更新摄像机fov
		}
		
		/**
		 * @private
		 * 初始化载入摄像机动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			if (owner is Camera)
				_camera = owner as Camera;
			else
				throw new Error("该Sprite3D并非Camera");
			
			_player.on(Event.STOPPED, this, function():void {
				if (_player.returnToZeroStopped) {
					if (localMode)
						_originalAnimationTransform && (owner.transform.localMatrix = _originalAnimationTransform);
					else
						_originalAnimationTransform && (owner.transform.worldMatrix = _originalAnimationTransform);
					
					_camera.fieldOfView = _originalFov;
				}
			});
		}
		
		/**
		 * @private
		 * 更新摄像机动画组件。
		 * @param	state 渲染状态。
		 */
		public override function _update(state:RenderState):void 
		{
			//player.update(state.elapsedTime);//需最先执行（如不则内部可能触发Stop事件等，如事件中加载新动画，可能_templet未加载完成，导致BUG）
			
			if (!_templet || !_templet.loaded || _player.state !== AnimationState.playing)
				return;
			
			var rate:Number = _player.playbackRate * state.scene.timer.scale;
			var frameIndex:int = (_player.isCache && rate >= 1.0) ? currentFrameIndex : -1;//慢动作或者不缓存时frameIndex为-1
			var animationClipIndex:int = currentAnimationClipIndex;
			
			if (frameIndex !== -1 && _lastFrameIndex === frameIndex)//与上一次更新同帧则直接返回
			{
				super._update(state);
				return;
			}
			
			if (_player.isCache && rate >= 1.0) {
				var cache:Float32Array = _templet.getAnimationDataWithCache(_player.cacheFrameRate,_cacheAnimationDatas, animationClipIndex, frameIndex);
				
				if (cache) {
					_currentAnimationData = cache;
					
					_lastFrameIndex = frameIndex;
					super._update(state);
					_effect();//动画计算模块和作用模块（待优化，需剥离）
					return;
				}
			}
			
			var nodes:Vector.<Object> = _templet.getNodes(animationClipIndex);
			var nodeCount:int = nodes.length;
			if (_player.isCache && rate >= 1.0) {
				_currentAnimationData = new Float32Array(nodeCount * 10);//eye、target、up、fov
			} else//非缓存或慢动作用临时数组做计算,只new一次
			{
				(_tempCurAnimationData) || (_tempCurAnimationData = new Float32Array(nodeCount * 10));
				_currentAnimationData = _tempCurAnimationData;
			}
			
			if (_player.isCache && rate >= 1.0)
				_templet.getOriginalData(animationClipIndex, _currentAnimationData, _player._fullFrames[animationClipIndex], frameIndex, _player.currentPlayTime);
			else//慢动作或者不缓存时
				_templet.getOriginalDataUnfixedRate(animationClipIndex, _currentAnimationData, _player.currentPlayTime);
			
			if (_player.isCache && rate >= 1.0) {
				_templet.setAnimationDataWithCache(_player.cacheFrameRate,_cacheAnimationDatas, animationClipIndex, frameIndex, _currentAnimationData);//缓存动画数据
			}
			
			_lastFrameIndex = frameIndex;
			super._update(state);
			_effect();//动画作用模块（待优化，需剥离）
		}
		
		///**
		 //* 播放动画。
		 //* @param	index 动画索引。
		 //* @param	playbackRate 播放速率。
		 //* @param	duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）。
		 //*/
		//public override function play(index:int = 0, playbackRate:Number = 1.0, duration:Number = Number.MAX_VALUE):void {
			//if (player.state === AnimationState.stopped) {
				//(_originalAnimationTransform) || (_originalAnimationTransform = new Matrix4x4());
				//localMode ? owner.transform.localMatrix.cloneTo(_originalAnimationTransform) : owner.transform.worldMatrix.cloneTo(_originalAnimationTransform);
			//}
			//
			//_originalFov = _camera.fieldOfView;
			//
			//super.play(index, playbackRate, duration);
		//}
	
	}
}