package laya.d3.component {
	import laya.ani.AnimationContent;
	import laya.ani.AnimationNodeContent;
	import laya.ani.AnimationState;
	import laya.d3.animation.AnimationClip;
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.BoneNode;
	import laya.d3.animation.Keyframe;
	import laya.d3.core.Avatar;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.resource.IDestroy;
	import laya.utils.Stat;
	
	/**
	 * <code>Animation</code> 类用于创建动画组件。
	 */
	public class Animation extends Component3D implements IDestroy {
		/**@private */
		private var _clipNames:Vector.<String>;
		/**@private */
		private var _clips:Vector.<AnimationClip>;
		/** @private */
		private var _clipNodesOwners:Vector.<Sprite3D>;
		/**@private */
		private var _clip:AnimationClip;
		/**@private */
		private var _cacheFrameRateInterval:Number;
		/**@private */
		private var _cacheFrameRate:int;
		/**@private */
		private var _cachePlayRate:Number;
		/**@private */
		private var _playStart:Number;
		/**@private */
		private var _playEnd:Number;
		/**@private */
		private var _playDuration:Number;
		/**@private */
		private var _overallDuration:Number;
		/**@private */
		private var _currentPlayClip:AnimationClip;
		/**@private */
		private var _currentPlayClipIndex:int;
		/**@private */
		private var _paused:Boolean;
		/**@private */
		private var _currentTime:Number;
		/**@private */
		private var _currentFrameTime:Number;
		/**@private */
		private var _currentKeyframeIndex:int;
		/**@private */
		private var _stopWhenCircleFinish:Boolean;
		/**@private */
		private var _elapsedPlaybackTime:Number;
		/**@private */
		private var _startUpdateLoopCount:Number;
		/**@private */
		private var _destroyed:Boolean;
		/** @private */
		private var _curAnimationDatas:Vector.<Float32Array>;
		/** @private */
		private var _tempCurAnimationDatas:Vector.<Float32Array>;
		
		/**@private */
		public var _cacheFullFrames:Vector.<Array>;
		
		/**@private */
		public var avatar:Avatar;
		/**是否为缓存模式。*/
		public var isCache:Boolean;
		/** 停止时是否归零*/
		public var returnToZeroStopped:Boolean;
		/** 播放速率*/
		public var playbackRate:Number;
		
		/**
		 * 获取默认动画片段。
		 * @return  默认动画片段。
		 */
		public function get clip():AnimationClip {
			return _clip;
		}
		
		/**
		 * 设置默认动画片段,AnimationClip名称为默认playName。
		 * @param value 默认动画片段。
		 */
		public function set clip(value:AnimationClip):void {
			if (_clip !== value) {
				(_clip) && (removeClip(_clip));
				(value) && (addClip(value, value.name));
				_clip = value;
			}
		}
		
		/**
		 *  获取缓存播放帧，缓存模式下生效。
		 * @return	value 缓存播放帧率。
		 */
		public function get cacheFrameRate():int {
			return _cacheFrameRate;
		}
		
		/**
		 *  设置缓存播放帧率，缓存模式下生效。注意：修改此值会有计算开销。*
		 * @return	value 缓存播放帧率
		 */
		public function set cacheFrameRate(value:int):void {
			if (_cacheFrameRate !== value) {
				_cacheFrameRate = value;
				_cacheFrameRateInterval = 1000.0 / _cacheFrameRate;
				
				for (var key:String in _clips) {
					var clip:AnimationClip = _clips[key];
					if (clip.loaded)
						_computeCacheFullKeyframeIndices(clip);
					else
						clip.once(Event.LOADED, this, _onClipLoadedComputeCacheFullKeyframeIndices[_cachePlayRate, value]);
				}
			}
		}
		
		/**
		 *  获取缓存播放速率，缓存模式下生效。*
		 * @return	 缓存播放速率。
		 */
		public function get cachePlayRate():Number {
			return _cachePlayRate;
		}
		
		/**
		 *  设置缓存播放速率，缓存模式下生效。注意：修改此值会有计算开销。*
		 * @return	value 缓存播放速率。
		 */
		public function set cachePlayRate(value:Number):void {
			if (_cachePlayRate !== value) {
				_cachePlayRate = value;
				
				for (var key:String in _clips) {
					var clip:AnimationClip = _clips[key];
					if (clip.loaded)
						_computeCacheFullKeyframeIndices(clip);
					else
						clip.once(Event.LOADED, this, _onClipLoadedComputeCacheFullKeyframeIndices[value, _cacheFrameRate]);
				}
			}
		}
		
		/**
		 * 动画播放的起始时间位置。
		 * @return	 起始时间位置。
		 */
		public function get playStart():Number {
			return _playStart;
		}
		
		/**
		 * 动画播放的结束时间位置。
		 * @return	 结束时间位置。
		 */
		public function get playEnd():Number {
			return _playEnd;
		}
		
		/**
		 * 获取动画播放一次的总时间
		 * @return	 动画播放一次的总时间
		 */
		public function get playDuration():Number {
			return _playDuration;
		}
		
		/**
		 * 获取动画播放的总总时间
		 * @return	 动画播放的总时间
		 */
		public function get overallDuration():Number {
			return _overallDuration;
		}
		
		/**
		 * 获取当前动画索引
		 * @return	value 当前动画索引
		 */
		public function get currentPlayClip():AnimationClip {
			return _currentPlayClip;
		}
		
		/**
		 * 获取当前帧数
		 * @return	 当前帧数
		 */
		public function get currentKeyframeIndex():int {
			return _currentKeyframeIndex;
		}
		
		/**
		 *  获取当前精确时间，不包括重播时间
		 * @return	value 当前时间
		 */
		public function get currentPlayTime():Number {
			return _currentTime + _playStart;
		}
		
		/**
		 *  获取当前帧时间，不包括重播时间
		 * @return	value 当前时间
		 */
		public function get currentFrameTime():Number {
			return _currentFrameTime;
		}
		
		/**
		 * 获取当前是否暂停
		 * @return	是否暂停
		 */
		public function get paused():Boolean {
			return _paused;
		}
		
		/**
		 * 设置是否暂停
		 * @param	value 是否暂停
		 */
		public function set paused(value:Boolean):void {
			_paused = value;
			value && this.event(Event.PAUSED);
		}
		
		/**
		 * 获取当前播放状态
		 * @return	当前播放状态
		 */
		public function get playState():int {
			if (_currentPlayClip == null)
				return AnimationState.stopped;
			if (_paused)
				return AnimationState.paused;
			return AnimationState.playing;
		}
		
		/**
		 * 获取骨骼数据。
		 * @return 骨骼数据。
		 */
		public function get curAnimationDatas():Vector.<Float32Array> {
			return _curAnimationDatas;
		}
		
		/**
		 * 设置当前播放位置
		 * @param	value 当前时间
		 */
		public function set currentTime(value:Number):void {
			if (_currentPlayClip == null || !_currentPlayClip || !_currentPlayClip.loaded)
				return;
			
			if (value < _playStart || value > _playEnd)
				throw new Error("AnimationPlayer:value must large than playStartTime,small than playEndTime.");
			
			_startUpdateLoopCount = Stat.loopCount;
			var cacheFrameInterval:Number = _cacheFrameRateInterval * _cachePlayRate;
			_currentTime = value /*% playDuration*/;
			_currentKeyframeIndex = Math.floor(currentPlayTime / cacheFrameInterval);
			_currentFrameTime = _currentKeyframeIndex * cacheFrameInterval;
		}
		
		/**
		 * 创建一个 <code>Animation</code> 实例。
		 */
		public function Animation() {
			super();
			_clipNames = new Vector.<String>();
			_clips = new Vector.<AnimationClip>();
			_clipNodesOwners = new Vector.<Vector.<Sprite3D>>();
			_cacheFullFrames = new Vector.<Array>();
			
			_cachePlayRate = 1.0;
			_playStart = 0;
			_playEnd = 0;
			_playDuration = 0;
			_overallDuration = Number.MAX_VALUE;
			_currentPlayClip = null;
			_currentKeyframeIndex = -1;
			_currentTime = 0.0;
			_stopWhenCircleFinish = false;
			_elapsedPlaybackTime = 0;
			_startUpdateLoopCount = -1;
			_destroyed = false;
			isCache = true;
			cacheFrameRate = 60;
			returnToZeroStopped = false;
			playbackRate = 1.0;
		}
		
		/**
		 * @private
		 */
		private function _computeCacheFullKeyframeIndices(clip:AnimationClip):void {
			var index:int = _clips.indexOf(clip);
			var clipCacheFullFrames:Array = _cacheFullFrames[index];
			(clipCacheFullFrames) || (clipCacheFullFrames = _cacheFullFrames[index] = []);
			var cacheInterval:Number = _cacheFrameRateInterval * _cachePlayRate;
			
			var nodes:Vector.<AnimationNode> = clip._nodes;
			var nodeCount:int = nodes.length;
			clipCacheFullFrames.length = nodeCount;
			var frameCount:int = Math.floor(clip._duration / cacheInterval + 0.01) + 1;
			for (var i:int = 0; i < nodeCount; i++) {
				var node:AnimationNode = nodes[i];
				var nodeFullFrames:Uint16Array = new Uint16Array(frameCount);
				var lastFrameIndex:int = -1;
				
				var keyFrames:Vector.<Keyframe> = node.keyFrames;
				for (var j:int = 0, n:int = keyFrames.length; j < n; j++) {
					var keyFrame:Keyframe = keyFrames[j];
					var tim:Number = keyFrame.startTime;
					var endTim:Number = tim + keyFrame.duration + cacheInterval;
					do {
						var frameIndex:int = Math.floor(tim / cacheInterval + 0.5);
						for (var k:int = lastFrameIndex + 1; k < frameIndex; k++)
							nodeFullFrames[k] = j;
						
						lastFrameIndex = frameIndex;
						nodeFullFrames[frameIndex] = j;
						tim += cacheInterval;
					} while (tim <= endTim);
				}
				clipCacheFullFrames[i] = nodeFullFrames;
			}
		}
		
		/**
		 * @private
		 */
		private function _calculatePlayDuration():void {
			if (playState !== AnimationState.stopped) {//防止动画已停止，异步回调导致BUG
				var oriDuration:int = _currentPlayClip._duration;
				(_playEnd === 0) && (_playEnd = oriDuration);
				
				if (_playEnd > oriDuration)//以毫秒为最小时间单位,取整。FillTextureSprite
					_playEnd = oriDuration;
				
				_playDuration = _playEnd - _playStart;
			}
		}
		
		/**
		 * @private
		 */
		private function _setPlayParams(time:Number, cacheFrameInterval:Number):void {
			_currentTime = time;
			_currentKeyframeIndex = Math.floor((currentPlayTime) / cacheFrameInterval + 0.01);
			_currentFrameTime = _currentKeyframeIndex * cacheFrameInterval;
		}
		
		/**
		 * @private
		 */
		private function _setPlayParamsWhenStop(currentAniClipPlayDuration:Number, cacheFrameInterval:Number):void {
			_currentTime = currentAniClipPlayDuration;
			_currentKeyframeIndex = Math.floor(currentAniClipPlayDuration / cacheFrameInterval + 0.01);
			_currentFrameTime = _currentKeyframeIndex * cacheFrameInterval;
			_currentPlayClip = null;//动画结束	
		}
		
		/**
		 * @private
		 */
		private function _onClipLoaded():void {
			(destroyed) || (_calculatePlayDuration());
		}
		
		/**
		 * @private
		 */
		private function _addClipNodesOwners(clip:AnimationClip):void {
			var nodes:Vector.<AnimationNode> = clip._nodes;
			var nodeCount:int = nodes.length;
			var pathSprite:Sprite3D = _owner;
			for (var i:int = 0; i < nodeCount; i++) {
				var node:AnimationNode = nodes[i];
				var path:Vector.<String> = node.path;
				for (var j:int = 0; j < path.length; j++) {//0为默认根节点
					pathSprite = pathSprite.getChildByName(path[j]);
					if (pathSprite)
						break;
				}
				
				if (node.componentType)
					var component:Component3D = pathSprite.getComponentByType(node.componentType);
					node.propertyName;
				
				//var localMatrix:Matrix4x4 = _animationSpritesInitLocalMatrix[i];
				//(localMatrix) || (localMatrix = _animationSpritesInitLocalMatrix[i] = new Matrix4x4());
				//curSprite.transform.localMatrix.cloneTo(localMatrix);
				pathSprite = _owner;
			}
		}
		
		///**
		//* @private
		//*/
		//private function _applyKeyframes():void{
		//var nodes:Vector.<AnimationNode> = _currentPlayClip._nodes;
		//for (var i:int = 0, n:int = nodes.length; i < n; i++){
		//var node:AnimationNode = nodes[i];
		//node.path;
		//}
		//}
		
		/**
		 * @private
		 */
		public function _onClipLoadedComputeCacheFullKeyframeIndices(clip:AnimationClip, cachePlayRate:Number, cacheFrameRate:Number):void {
			if (_clips.indexOf(clip) !== -1 && _cachePlayRate === cachePlayRate && _cacheFrameRate === cacheFrameRate)
				_computeCacheFullKeyframeIndices(clip);
		}
		
		/** @private */
		private function _onAnimationStop():void {
			_lastFrameIndex = -1;
			if (returnToZeroStopped) {
				_curAnimationDatas = null;
			}
		}
		
		/**
		 * @private
		 */
		public function _updatePlayer(elapsedTime:Number):void {
			if (_currentPlayClip == null || _paused || !_currentPlayClip.loaded)//动画停止或暂停，不更新
				return;
			
			var cacheFrameInterval:Number = _cacheFrameRateInterval * _cachePlayRate;
			var time:Number = 0;
			(_startUpdateLoopCount !== Stat.loopCount) && (time = elapsedTime * playbackRate, _elapsedPlaybackTime += time);//elapsedTime为距离上一帧时间,首帧播放如果_startPlayLoopCount===Stat.loopCount，则不累加时间
			
			var currentAniClipPlayDuration:Number = playDuration;
			if ((_overallDuration !== 0 && _elapsedPlaybackTime >= _overallDuration) || (_overallDuration === 0 && _elapsedPlaybackTime >= currentAniClipPlayDuration)) {
				_setPlayParamsWhenStop(currentAniClipPlayDuration, cacheFrameInterval);
				_onAnimationStop();
				this.event(Event.STOPPED);
				return;
			}
			time += _currentTime;
			if (currentAniClipPlayDuration > 0) {
				if (time >= currentAniClipPlayDuration) {
					do {//TODO:用求余改良
						time -= currentAniClipPlayDuration;
						if (_stopWhenCircleFinish) {
							_setPlayParamsWhenStop(currentAniClipPlayDuration, cacheFrameInterval);
							_stopWhenCircleFinish = false;
							_onAnimationStop();
							this.event(Event.STOPPED);
							return;
						}
						
						if (time < currentAniClipPlayDuration) {
							_setPlayParams(time, cacheFrameInterval);
							this.event(Event.COMPLETE);
						}
						
					} while (time >= currentAniClipPlayDuration)
				} else {
					_setPlayParams(time, cacheFrameInterval);
				}
			} else {
				if (_stopWhenCircleFinish) {
					_setPlayParamsWhenStop(currentAniClipPlayDuration, cacheFrameInterval);
					_stopWhenCircleFinish = false;
					_onAnimationStop();
					this.event(Event.STOPPED);
					return;
				}
				_currentTime = _currentFrameTime = _currentKeyframeIndex = 0;
				this.event(Event.COMPLETE);
			}
		}
		
		/**
		 * @private
		 * 更新蒙皮动画组件。
		 * @param	state 渲染状态参数。
		 */
		public override function _update(state:RenderState):void {
			var clip:AnimationClip = _currentPlayClip;
			if (playState !== AnimationState.playing || !clip || !clip.loaded)
				return;
			
			var rate:Number = playbackRate * Laya.timer.scale;
			var cacheRate:Number = _cachePlayRate;
			var canCache:Boolean = isCache && rate >= cacheRate;
			var frameIndex:int = -1;
			if (canCache) {
				frameIndex = _currentKeyframeIndex;
				if (_lastFrameIndex === frameIndex)
					return;
				
				var cachedAniDatas:Vector.<Float32Array> = clip._getAnimationDataWithCache(cacheRate, frameIndex);
				if (cachedAniDatas) {
					_curAnimationDatas = cachedAniDatas;
					_lastFrameIndex = frameIndex;
					//_applyKeyframes();
					return;
				}
			}
			
			var nodes:Vector.<AnimationNode> = clip._nodes;
			if (canCache) {
				_curAnimationDatas = new Vector.<Float32Array>();
				_curAnimationDatas.length = nodes.length;
			} else {//非缓存或慢动作用临时数组做计算,只new一次
				(_tempCurAnimationDatas) || (_tempCurAnimationDatas = new Vector.<Float32Array>(), _tempCurAnimationDatas.length = nodes.length);//使用临时数组，防止对已缓存数据造成破坏
				_curAnimationDatas = _tempCurAnimationDatas;
			}
			
			if (canCache) {
				clip._evaluateAnimationlDatas(_cacheFullFrames[_currentPlayClipIndex], frameIndex, _currentFrameTime, _curAnimationDatas);
				_currentPlayClip._cacheAnimationData(cacheRate, frameIndex, _curAnimationDatas);
			} else {
				clip._evaluateAnimationlDatasUnfixedRate(currentPlayTime, _curAnimationDatas);
			}
			_lastFrameIndex = frameIndex;
			//_applyKeyframes();
		}
		
		/**
		 * @private
		 * 初始化载入蒙皮动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			super._load(owner);
		}
		
		/**
		 * @private
		 * 卸载组件时执行
		 */
		override public function _unload(owner:Sprite3D):void {
			super._unload(owner);
			_tempCurAnimationDatas = null;
			_curAnimationDatas = null;
		
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			offAll();//TODO:移到父类。
			_clip = null;
			_clipNames = null;
			_clipNodesOwners = null;
			_clips = null;
			_cacheFullFrames = null;
		}
		
		/**
		 * 添加动画片段。
		 * @param	clip 动画片段。
		 * @param	playName 动画片段播放名称，如果为null,则使用clip.name作为播放名称。
		 */
		public function addClip(clip:AnimationClip, playName:String = null):void {
			playName = playName || clip.name;
			var index:int = _clipNames.indexOf(playName);
			if (index !== -1) {
				if (_clips[index] !== clip)
					throw new Error("Animation:this playName has exist with another clip.");
			} else {
				var clipIndex:int = _clips.indexOf(clip);
				if (clipIndex !== -1)
					throw new Error("Animation:this clip has exist with another playName.");
				_clipNames.push(playName);
				_clips.push(clip);
				_addClipNodesOwners(clip);
			}
		}
		
		/**
		 * 移除动画片段。
		 * @param	clip 动画片段。
		 */
		public function removeClip(clip:AnimationClip):void {
			var index:int = _clips.indexOf(clip);
			if (index !== -1) {
				_clipNames.splice(index, 1);
				_clips.splice(index, 1);
				_clipNodesOwners.splice(index, 1);
			}
		}
		
		/**
		 * 通过动画播放名字移除动画。
		 * @param	clipPlayName 动画播放名字。
		 */
		public function removeClipByName(playName:String):void {
			var index:int = _clipNames.indexOf(playName);
			if (index !== -1) {
				_clipNames.splice(index, 1);
				_clips.splice(index, 1);
				_clipNodesOwners.splice(index, 1);
			}
		}
		
		/**
		 * 播放动画。
		 * @param	index 动画索引。
		 * @param	playbackRate 播放速率。
		 * @param	duration 播放时长（0为1次,Number.MAX_VALUE为循环播放）。
		 * @param	playStart 播放的起始时间位置。
		 * @param	playEnd 播放的结束时间位置。（0为动画一次循环的最长结束时间位置）。
		 */
		public function play(playbackRate:Number = 1.0, overallDuration:int = /*int.MAX_VALUE*/ 2147483647, playStart:Number = 0, playEnd:Number = 0):void {
			if (!_clip)
				throw new Error("AnimationPlayer:templet must not be null,maybe you need to set url.");
			
			if (overallDuration < 0 || playStart < 0 || playEnd < 0)
				throw new Error("AnimationPlayer:overallDuration,playStart and playEnd must large than zero.");
			
			if ((playEnd !== 0) && (playStart > playEnd))
				throw new Error("AnimationPlayer:start must less than end.");
			
			_currentTime = 0;
			_currentFrameTime = 0;
			_elapsedPlaybackTime = 0;
			this.playbackRate = playbackRate;
			_overallDuration = overallDuration;
			_playStart = playStart;
			_playEnd = playEnd;
			_paused = false;
			_currentPlayClip = _clip;
			_currentPlayClipIndex = _clips.indexOf(_clips);
			_currentKeyframeIndex = 0;
			_startUpdateLoopCount = Stat.loopCount;
			
			//if (_templet !== value) {
			//_tempCurBonesData = null;
			//}
			
			this.event(Event.PLAYED);
			
			if (_clip.loaded)
				_calculatePlayDuration();
			else
				_clip.once(Event.LOADED, this, _onClipLoaded);
			
			_updatePlayer(0);//如果分段播放,可修正帧率
		}
		
		/**
		 * 停止播放当前动画
		 * @param	immediate 是否立即停止
		 */
		public function stop(immediate:Boolean = true):void {
			if (immediate) {
				_currentTime = _currentFrameTime = _currentKeyframeIndex = 0;
				_currentPlayClip = null;
				_onAnimationStop();
				this.event(Event.STOPPED);
			} else {
				_stopWhenCircleFinish = true;
			}
		}
		
		/**
		 * 播放动画。
		 * @param	index 动画索引。
		 * @param	playbackRate 播放速率。
		 * @param	duration 播放时长（0为1次,Number.MAX_VALUE为循环播放）。
		 * @param	playStartFrame 播放的原始起始帧率位置。
		 * @param	playEndFrame 播放的原始结束帧率位置。（0为动画一次循环的最长结束时间位置）。
		 */
		public function playByFrame(playbackRate:Number = 1.0, overallDuration:Number = /*int.MAX_VALUE*/ 2147483647, playStartFrame:Number = 0, playEndFrame:Number = 0):void {
			var interval:Number = 1000.0 / _currentPlayClip._frameRate;
			play(playbackRate, overallDuration, playStartFrame * interval, playEndFrame * interval);
		}
		
		/////////////////////////////////////////////////
		public static const BONES:int = 0;
		/**@private 精灵级着色器宏定义,骨骼动画。*/
		public static var SHADERDEFINE_BONE:int = 0x8;
		
		/** @private */
		protected var _lastFrameIndex:int = -1;
	
		//////////////////////////////////////////////////
	
	}

}