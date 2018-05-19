package laya.d3.component {
	import laya.ani.AnimationState;
	import laya.d3.animation.AnimationClip;
	import laya.d3.animation.AnimationEvent;
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.animation.Keyframe;
	import laya.d3.animation.KeyframeNode;
	import laya.d3.core.Avatar;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.resource.IDestroy;
	import laya.utils.Stat;
	
	/**
	 * <code>Animations</code> 类用于创建动画组件。
	 */
	public class Animator extends Component3D implements IDestroy {
		/**无效矩阵,禁止修改*/
		public static const deafaultMatrix:Float32Array = new Float32Array([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
		
		/**@private */
		private static var _tempMatrix4x40:Float32Array = new Float32Array(16);
		
		/**@private */
		private var _updateTransformPropertyLoopCount:int;
		/**@private */
		private var _cacheFrameRateInterval:Number;
		/**@private */
		private var _cacheFrameRate:int;
		/**@private */
		private var _cachePlayRate:Number;
		/**@private */
		private var _currentPlayClip:AnimationClip;
		/**@private */
		private var _currentPlayClipIndex:int;
		/**@private */
		private var _stoped:Boolean;
		/**@private */
		private var _currentTime:Number;
		/**@private */
		private var _currentFrameTime:Number;
		/**@private */
		private var _currentFrameIndex:int;
		/**@private */
		private var _elapsedPlaybackTime:Number;
		/**@private */
		private var _startUpdateLoopCount:Number;
		
		/**@private */
		private var _clipNames:Vector.<String>;
		/**@private */
		private var _clips:Vector.<AnimationClip>;
		/**@private */
		private var _playStartFrames:Vector.<Number>;
		/**@private */
		private var _playEndFrames:Vector.<Number>;
		/**@private */
		private var _playEventIndex:int;
		
		/**@private */
		private var _defaultClipIndex:int;
		/**@private */
		private var _avatar:Avatar;
		/**@private */
		private var _cacheNodesDefaultlValues:Vector.<Vector.<Float32Array>>;
		
		/**@private 无Avatar时缓存场景树中的精灵节点。*/
		public var _cacheNodesSpriteOwners:Vector.<Vector.<Sprite3D>>;
		/**@private 有Avatar时缓存Avatar树中的AnimationNode节点。*/
		private var _cacheNodesAvatarOwners:Vector.<Vector.<AnimationNode>>;
		/**@private */
		private var _lastPlayAnimationClip:AnimationClip;
		/**@private */
		private var _lastPlayAnimationClipIndex:int;
		/** @private */
		private var _publicClipsDatas:Vector.<Vector.<Float32Array>>;
		/**@private */
		private var _publicAvatarNodeDatas:Vector.<Float32Array>;
		
		/**@private */
		public var _curAvatarNodeDatas:Vector.<Float32Array>;
		/**@private */
		public var _cacheNodesToSpriteMap:Vector.<int>;
		/**@private */
		public var _cacheSpriteToNodesMap:Vector.<int>;
		/**@private */
		public var _cacheFullFrames:Vector.<Array>;
		/**@private	*/
		public var _avatarNodeMap:Object;
		/**@private	*/
		public var _avatarNodes:Vector.<AnimationNode>;
		/**@private	*/
		public var _canCache:Boolean;
		/** @private */
		public var _lastFrameIndex:int;
		
		/**	是否为缓存模式*/
		public var isCache:Boolean;
		/** 播放速率*/
		public var playbackRate:Number;
		/**	激活时是否自动播放*/
		public var playOnWake:Boolean;
		
		/**
		 * 获取avatar。
		 * @return avator。
		 */
		public function get avatar():Avatar {
			return _avatar;
		}
		
		/**
		 * 设置avatar。
		 * @param value avatar。
		 */
		public function set avatar(value:Avatar):void {
			if (_avatar !== value) {
				var lastAvatar:Avatar = _avatar;
				_avatar = value;
				var clipLength:int = _clips.length;
				for (var i:int = 0; i < clipLength; i++)
					_offClipAndAvatarRelateEvent(lastAvatar, _clips[i]);
				
				if (value) {
					if (value.loaded)
						_getAvatarOwnersAndInitDatasAsync();
					else
						value.once(Event.LOADED, this, _getAvatarOwnersAndInitDatasAsync);
				}
			}
		}
		
		/**
		 * 获取默认动画片段。
		 * @return  默认动画片段。
		 */
		public function get clip():AnimationClip {
			return _clips[_defaultClipIndex];
		}
		
		/**
		 * 设置默认动画片段,AnimationClip名称为默认playName。
		 * @param value 默认动画片段。
		 */
		public function set clip(value:AnimationClip):void {
			var index:int = value ? _clips.indexOf(value) : -1;
			if (_defaultClipIndex !== index) {
				(_defaultClipIndex !== -1) && (removeClip(_clips[_defaultClipIndex]));
				(index !== -1) && (addClip(value, value.name));
				_defaultClipIndex = index;
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
				_cacheFrameRateInterval = 1.0 / _cacheFrameRate;
				
				for (var i:int = 0, n:int = _clips.length; i < n; i++)
					(_clips[i].loaded) && (_computeCacheFullKeyframeIndices(i));
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
				
				for (var i:int = 0, n:int = _clips.length; i < n; i++)
					(_clips[i].loaded) && (_computeCacheFullKeyframeIndices(i));
			}
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
		public function get currentFrameIndex():int {
			return _currentFrameIndex;
		}
		
		/**
		 *  获取当前精确时间，不包括重播时间
		 * @return	value 当前时间
		 */
		public function get currentPlayTime():Number {
			return _currentTime + (_playStartFrames[_currentPlayClipIndex] / _currentPlayClip._frameRate);
		}
		
		/**
		 *  获取当前帧时间，不包括重播时间
		 * @return	value 当前时间
		 */
		public function get currentFrameTime():Number {
			return _currentFrameTime;
		}
		
		/**
		 * 获取当前播放状态
		 * @return	当前播放状态
		 */
		public function get playState():int {
			if (_currentPlayClip == null)
				return AnimationState.stopped;
			if (_stoped)
				return AnimationState.stopped;
			return AnimationState.playing;
		}
		
		/**
		 * 设置当前播放位置
		 * @param	value 当前时间
		 */
		public function set playbackTime(value:Number):void {
			if (_currentPlayClip == null || !_currentPlayClip || !_currentPlayClip.loaded)
				return;
			
			//TODO:补充该操作异常处理
			//if (value < _playStarts || value > _playEnds)
			//throw new Error("AnimationPlayer:value must large than playStartTime,small than playEndTime.");
			
			_startUpdateLoopCount = Stat.loopCount;
			var cacheFrameInterval:Number = _cacheFrameRateInterval * _cachePlayRate;
			_currentTime = value /*% playDuration*/;
			_currentFrameIndex = Math.floor(currentPlayTime / cacheFrameInterval);
			_currentFrameTime = _currentFrameIndex * cacheFrameInterval;
		}
		
		/**
		 * 创建一个 <code>Animation</code> 实例。
		 */
		public function Animator() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_clipNames = new Vector.<String>();
			_clips = new Vector.<AnimationClip>();
			_playStartFrames = new Vector.<Number>();
			_playEndFrames = new Vector.<Number>();
			_cacheNodesSpriteOwners = new Vector.<Vector.<Sprite3D>>();
			_cacheNodesAvatarOwners = new Vector.<Vector.<AnimationNode>>();
			_cacheNodesDefaultlValues = new Vector.<Vector.<Float32Array>>();
			_cacheNodesToSpriteMap = new Vector.<int>();
			_cacheSpriteToNodesMap = new Vector.<int>();
			_cacheFullFrames = new Vector.<Array>();
			_publicClipsDatas = new Vector.<Vector.<Float32Array>>();
			
			_playEventIndex = -1;
			_updateTransformPropertyLoopCount = -1;
			_lastFrameIndex = -1;
			_defaultClipIndex = -1;
			_cachePlayRate = 1.0;
			_currentPlayClip = null;
			_currentFrameIndex = -1;
			_currentTime = 0.0;
			_elapsedPlaybackTime = 0;
			_startUpdateLoopCount = -1;
			isCache = true;
			cacheFrameRate = 60;
			playbackRate = 1.0;
			playOnWake = true;
		}
		
		/**
		 * @private
		 */
		private function _getAvatarOwnersByClip(clipIndex:int):void {
			var frameNodes:Vector.<KeyframeNode> = _clips[clipIndex]._nodes;
			var frameNodesCount:int = frameNodes.length;
			
			var owners:Vector.<AnimationNode> = _cacheNodesAvatarOwners[clipIndex];
			owners.length = frameNodesCount;
			var defaultValues:Vector.<Float32Array> = _cacheNodesDefaultlValues[clipIndex];
			defaultValues.length = frameNodesCount;
			
			for (var i:int = 0; i < frameNodesCount; i++) {
				var nodeOwner:AnimationNode = _avatarNodes[0];
				var node:KeyframeNode = frameNodes[i];
				var path:Vector.<String> = node.path;
				for (var j:int = 0, m:int = path.length; j < m; j++) {
					var p:String = path[j];
					if (p === "") {
						break;
					} else {
						nodeOwner = nodeOwner.getChildByName(p);
						if (!nodeOwner)
							break;
					}
				}
				if (!nodeOwner)
					continue;
				owners[i] = nodeOwner;
				
				var datas:Float32Array = AnimationNode._propertyGetFuncs[node.propertyNameID](nodeOwner);
				if (datas) {//不存在对应的实体节点时可能为空
					var cacheDatas:Float32Array = new Float32Array(node.keyFrameWidth);
					defaultValues[i] = cacheDatas;
					for (j = 0, m = datas.length; j < m; j++)
						cacheDatas[j] = datas[j];
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _handleSpriteOwnersByClip(clipIndex:int):void {
			var frameNodes:Vector.<KeyframeNode> = _clips[clipIndex]._nodes;
			var frameNodesCount:int = frameNodes.length;
			
			var owners:Vector.<Sprite3D> = _cacheNodesSpriteOwners[clipIndex];
			owners.length = frameNodesCount;
			var defaultValues:Vector.<Float32Array> = _cacheNodesDefaultlValues[clipIndex];
			defaultValues.length = frameNodesCount;
			
			for (var i:int = 0; i < frameNodesCount; i++) {
				var nodeOwner:Sprite3D = _owner as Sprite3D;
				var node:KeyframeNode = frameNodes[i];
				var path:Vector.<String> = node.path;
				var j:int, m:int;
				for (j = 0, m = path.length; j < m; j++) {
					var p:String = path[j];
					if (p === "") {
						break;
					} else {
						nodeOwner = nodeOwner.getChildByName(p) as Sprite3D;
						if (!nodeOwner)
							break;
					}
				}
				
				if (nodeOwner) {
					owners[i] = nodeOwner;
					var datas:Float32Array = AnimationNode._propertyGetFuncs[node.propertyNameID](null, nodeOwner);
					if (datas) {//不存在对应的实体节点时可能为空
						var cacheDatas:Float32Array = new Float32Array(node.keyFrameWidth);
						defaultValues[i] = cacheDatas;
						for (j = 0, m = datas.length; j < m; j++)
							cacheDatas[j] = datas[j];
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _offClipAndAvatarRelateEvent(avatar:Avatar, clip:AnimationClip):void {
			if (avatar.loaded) {
				if (!clip.loaded)
					clip.off(Event.LOADED, this, _getAvatarOwnersByClip);
			} else {
				avatar.off(Event.LOADED, this, _getAvatarOwnersAndInitDatasAsync);
			}
		}
		
		/**
		 * @private
		 */
		private function _getAvatarOwnersByClipAsync(clipIndex:int, clip:AnimationClip):void {
			if (clip.loaded)
				_getAvatarOwnersByClip(clipIndex);
			else
				clip.once(Event.LOADED, this, _getAvatarOwnersByClip, [clipIndex]);
		}
		
		/**
		 * @private
		 */
		private function _offGetSpriteOwnersByClipAsyncEvent(clip:AnimationClip):void {
			if (!clip.loaded)
				clip.off(Event.LOADED, this, _getSpriteOwnersByClipAsync);
		}
		
		/**
		 * @private
		 */
		private function _getSpriteOwnersByClipAsync(clipIndex:int, clip:AnimationClip):void {
			if (clip.loaded)
				_handleSpriteOwnersByClip(clipIndex);
			else
				clip.once(Event.LOADED, this, _handleSpriteOwnersByClip, [clipIndex]);
		}
		
		/**
		 * @private
		 */
		private function _getAvatarOwnersAndInitDatasAsync():void {
			for (var i:int = 0, n:int = _clips.length; i < n; i++)
				_getAvatarOwnersByClipAsync(i, _clips[i]);
			
			_avatar._cloneDatasToAnimator(this);
			
			for (i = 0, n = _avatarNodes.length; i < n; i++)//TODO:换成字典查询
				_checkAnimationNode(_avatarNodes[i], _owner as Sprite3D);
		}
		
		/**
		 * @private
		 */
		private function _offGetClipCacheFullKeyframeIndicesEvent(clip:AnimationClip):void {
			(clip.loaded) || (clip.off(Event.LOADED, this, _computeCacheFullKeyframeIndices));
		}
		
		/**
		 * @private
		 */
		private function _computeCacheFullKeyframeIndices(clipIndex:int):void {
			var clip:AnimationClip = _clips[clipIndex];
			var cacheInterval:Number = _cacheFrameRateInterval * _cachePlayRate;
			var clipCacheFullFrames:Array = clip._getFullKeyframeIndicesWithCache(cacheInterval);
			if (clipCacheFullFrames) {
				_cacheFullFrames[clipIndex] = clipCacheFullFrames;
				return;
			} else {
				clipCacheFullFrames = _cacheFullFrames[clipIndex] = [];
				var nodes:Vector.<KeyframeNode> = clip._nodes;
				var nodeCount:int = nodes.length;
				clipCacheFullFrames.length = nodeCount;
				var frameCount:int = Math.ceil(clip._duration / cacheInterval - 0.00001) + 1;
				for (var i:int = 0; i < nodeCount; i++) {
					var node:KeyframeNode = nodes[i];
					var nodeFullFrames:Int32Array = new Int32Array(frameCount);//使用Int32Array非UInt16Array,因为需要-1表示没到第0帧的情况
					(nodeFullFrames as *).fill(-1);
					var keyFrames:Vector.<Keyframe> = node.keyFrames;
					for (var j:int = 0, n:int = keyFrames.length; j < n; j++) {
						var keyFrame:Keyframe = keyFrames[j];
						var startTime:Number = keyFrame.startTime;
						var endTime:Number = startTime + keyFrame.duration;
						while (startTime <= endTime) {
							var frameIndex:Number = Math.ceil(startTime / cacheInterval - 0.00001);
							nodeFullFrames[frameIndex] = j;
							startTime += cacheInterval;
						}
					}
					clipCacheFullFrames[i] = nodeFullFrames;
				}
				clip._cacheFullKeyframeIndices(cacheInterval, clipCacheFullFrames);
			}
		}
		
		/**
		 * @private
		 */
		private function _updateAnimtionPlayer():void {
			_updatePlayer(Laya.timer.delta / 1000.0);
		}
		
		/**
		 * @private
		 */
		private function _onOwnerActiveHierarchyChanged():void {
			var owner:Sprite3D = _owner as Sprite3D;
			if (owner.activeInHierarchy) {
				Laya.timer.frameLoop(1, this, _updateAnimtionPlayer);//TODO:当前帧注册，下一帧执行
				(playOnWake && clip) && (play());
			} else {
				(playState !== AnimationState.stopped) && (_stoped = true);//调用stop抛事件会出BUG（在删除节点操作会触发，事件内又添加节点）
				Laya.timer.clear(this, _updateAnimtionPlayer);
			}
		}
		
		/**
		 * @private
		 */
		private function _eventScript(from:Number, to:Number):void {
			var events:Vector.<AnimationEvent> = _currentPlayClip._animationEvents;
			for (var n:int = events.length; _playEventIndex < n; _playEventIndex++) {//TODO:_playEventIndex问题
				var eve:AnimationEvent = events[_playEventIndex];
				var eventTime:Number = eve.time;
				if (from <= eventTime && eventTime < to) {
					var scripts:Vector.<Script> = _owner._scripts;
					for (var j:int = 0, m:int = scripts.length; j < m; j++) {
						var script:Script = scripts[j];
						var fun:Function = script[eve.eventName];
						(fun) && (fun.apply(script, eve.params));
					}
				} else {
					break;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _setPlayParams(time:Number, cacheFrameInterval:Number):void {
			var lastTime:Number = _currentTime;
			_currentTime = time;
			_currentFrameIndex = Math.max(Math.floor(currentPlayTime / cacheFrameInterval - 0.00001), 0);
			_currentFrameTime = _currentFrameIndex * cacheFrameInterval;
			_eventScript(lastTime, time);
		}
		
		/**
		 * @private
		 */
		private function _setPlayParamsWhenStop(aniClipPlayDuration:Number, cacheFrameInterval:Number):void {
			var lastTime:Number = _currentTime;
			_currentTime = aniClipPlayDuration;
			_currentFrameIndex = Math.max(Math.floor(aniClipPlayDuration / cacheFrameInterval - 0.00001), 0);
			_currentFrameTime = _currentFrameIndex * cacheFrameInterval;
			_eventScript(lastTime, aniClipPlayDuration);
			_currentPlayClip = null;//动画结束
		}
		
		/**
		 * @private
		 */
		private function _revertKeyframeNodes(clip:AnimationClip, clipIndex:int):void {
			var originalValues:Vector.<Float32Array> = _cacheNodesDefaultlValues[clipIndex];
			var frameNodes:Vector.<KeyframeNode> = clip._nodes;
			if (_avatar) {
				var avatarOwners:Vector.<AnimationNode> = _cacheNodesAvatarOwners[clipIndex];
				for (var i:int = 0, n:int = avatarOwners.length; i < n; i++) {
					var avatarOwner:AnimationNode = avatarOwners[i];
					(avatarOwner) && (AnimationNode._propertySetFuncs[frameNodes[i].propertyNameID](avatarOwner, null, originalValues[i]));
				}
			} else {
				var spriteOwners:Vector.<Sprite3D> = _cacheNodesSpriteOwners[clipIndex];
				for (i = 0, n = spriteOwners.length; i < n; i++) {
					var spriteOwner:Sprite3D = spriteOwners[i];
					(spriteOwner) && (AnimationNode._propertySetFuncs[frameNodes[i].propertyNameID](null, spriteOwner, originalValues[i]));
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _onAnimationStop():void {
			var i:int, n:int;
			var frameNode:KeyframeNode, keyFrames:Vector.<Keyframe>, endKeyframeData:Float32Array;
			_lastFrameIndex = -1;
			var frameNodes:Vector.<KeyframeNode> = _currentPlayClip._nodes;
			if (_avatar) {
				var avatarOwners:Vector.<AnimationNode> = _cacheNodesAvatarOwners[_currentPlayClipIndex];
				for (i = 0, n = avatarOwners.length; i < n; i++) {
					var nodeOwner:AnimationNode = avatarOwners[i];
					frameNode = frameNodes[i];
					keyFrames = frameNode.keyFrames;
					endKeyframeData = keyFrames[keyFrames.length - 1].data;
					(nodeOwner) && (AnimationNode._propertySetFuncs[frameNode.propertyNameID](nodeOwner, null, endKeyframeData));
				}
			} else {
				var spriteOwners:Vector.<Sprite3D> = _cacheNodesSpriteOwners[_currentPlayClipIndex];
				for (i = 0, n = spriteOwners.length; i < n; i++) {
					var spriteOwner:Sprite3D = spriteOwners[i];
					frameNode = frameNodes[i];
					keyFrames = frameNode.keyFrames;
					endKeyframeData = keyFrames[keyFrames.length - 1].data;
					(spriteOwner) && (AnimationNode._propertySetFuncs[frameNode.propertyNameID](null, spriteOwner, endKeyframeData));
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _setAnimationClipPropertyToAnimationNode(nodeOwners:Vector.<AnimationNode>, propertyMap:Int32Array, clipDatas:Vector.<Float32Array>):void {
			for (var i:int = 0, n:int = propertyMap.length; i < n; i++) {
				var nodexIndex:int = propertyMap[i];
				var owner:AnimationNode = nodeOwners[nodexIndex];
				if (owner) {
					var ketframeNode:KeyframeNode = _currentPlayClip._nodes[nodexIndex];
					var datas:Float32Array = clipDatas[nodexIndex];
					(datas) && (AnimationNode._propertySetFuncs[ketframeNode.propertyNameID](owner, null, datas));
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _setAnimationClipPropertyToSprite3D(nodeOwners:Vector.<Sprite3D>, curClipAnimationDatas:Vector.<Float32Array>):void {
			for (var i:int = 0, n:int = nodeOwners.length; i < n; i++) {
				var owner:Sprite3D = nodeOwners[i];
				if (owner) {
					var ketframeNode:KeyframeNode = _currentPlayClip._nodes[i];
					var datas:Float32Array = curClipAnimationDatas[i];
					(datas) && (AnimationNode._propertySetFuncs[ketframeNode.propertyNameID](null, owner, datas));
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _handleSpriteOwnersBySprite(clipIndex:int, isLink:Boolean, path:Vector.<String>, sprite:Sprite3D):void {
			var clip:AnimationClip = _clips[clipIndex];
			var nodePath:String = path.join("/");
			var ownersNodes:Vector.<KeyframeNode> = clip._nodesMap[nodePath];
			if (ownersNodes) {
				var owners:Vector.<Sprite3D> = _cacheNodesSpriteOwners[clipIndex];
				var nodes:Vector.<KeyframeNode> = clip._nodes;
				var defaultValues:Vector.<Float32Array> = _cacheNodesDefaultlValues[clipIndex];
				for (var i:int = 0, n:int = ownersNodes.length; i < n; i++) {
					var node:KeyframeNode = ownersNodes[i];
					var index:int = nodes.indexOf(node);
					if (isLink) {
						owners[index] = sprite;
						var datas:Float32Array = AnimationNode._propertyGetFuncs[node.propertyNameID](null, sprite);
						if (datas) {//不存在对应的实体节点时可能为空 
							var cacheDatas:Float32Array = defaultValues[index];
							(cacheDatas) || (defaultValues[index] = cacheDatas = new Float32Array(node.keyFrameWidth));
							for (var j:int = 0, m:int = datas.length; j < m; j++)
								cacheDatas[j] = datas[j];
						}
					} else {
						owners[index] = null;
					}
				}
			}
		}
		
		/**
		 *@private
		 */
		public function _evaluateAvatarNodesCacheMode(avatarOwners:Vector.<AnimationNode>, clip:AnimationClip, publicClipDatas:Vector.<Float32Array>, avatarNodeDatas:Vector.<Float32Array>, unCacheMap:Int32Array):void {
			clip._evaluateAnimationlDatasCacheMode(avatarOwners, _cacheFullFrames[_currentPlayClipIndex], this, publicClipDatas, unCacheMap);
			_setAnimationClipPropertyToAnimationNode(avatarOwners, unCacheMap, publicClipDatas);
			
			for (var i:int = 0, n:int = _avatarNodes.length; i < n; i++) {
				var node:AnimationNode = _avatarNodes[i];
				var nodeTransform:AnimationTransform3D = node.transform;
				if (nodeTransform._worldUpdate) {//Avatar根节点始终为false,不会更新
					var nodeMatrix:Float32Array = new Float32Array(16);
					avatarNodeDatas[i] = nodeMatrix;
					nodeTransform._setWorldMatrixAndUpdate(nodeMatrix);
				} else {
					var mat:Float32Array = nodeTransform.getWorldMatrix();
					avatarNodeDatas[i] = mat ? mat : deafaultMatrix;//如果没有动画帧必须设置其默认矩阵,根节点为空
				}
			}
		}
		
		/**
		 *@private
		 */
		public function _evaluateAvatarNodesRealTime(avatarOwners:Vector.<AnimationNode>, clip:AnimationClip, publicClipDatas:Vector.<Float32Array>, avatarNodeDatas:Vector.<Float32Array>, unCacheMap:Int32Array):void {
			clip._evaluateAnimationlDatasRealTime(avatarOwners, currentPlayTime, publicClipDatas, unCacheMap);
			_setAnimationClipPropertyToAnimationNode(avatarOwners, unCacheMap, publicClipDatas);
			
			for (var i:int = 0, n:int = _avatarNodes.length; i < n; i++) {
				var transform:AnimationTransform3D = _avatarNodes[i].transform;
				if (transform._worldUpdate) //Avatar根节点始终为false,不会更新
					transform._setWorldMatrixNoUpdate(avatarNodeDatas[i]);
				else
					avatarNodeDatas[i] = deafaultMatrix;//TODO:
			}
		}
		
		/**
		 *@private
		 */
		public function _updateAvatarNodesToSpriteCacheMode(clip:AnimationClip, avatarNodeDatas:Vector.<Float32Array>):void {
			for (var i:int = 0, n:int = _cacheSpriteToNodesMap.length; i < n; i++) {
				var nodeIndex:int = _cacheSpriteToNodesMap[i];
				var nodeMatrix:Float32Array = avatarNodeDatas[nodeIndex];
				if (nodeMatrix !== deafaultMatrix) {//TODO:
					var spriteTransform:Transform3D = _avatarNodes[nodeIndex].transform._entity;
					var spriteWorldMatrix:Matrix4x4 = spriteTransform.worldMatrix;
					Utils3D.matrix4x4MultiplyMFM((_owner as Sprite3D)._transform.worldMatrix, nodeMatrix, spriteWorldMatrix);
					spriteTransform.worldMatrix = spriteWorldMatrix;
				}
			}
		}
		
		/**
		 *@private
		 */
		public function _updateAvatarNodesToSpriteRealTime():void {
			for (var i:int = 0, n:int = _cacheSpriteToNodesMap.length; i < n; i++) {
				var node:AnimationNode = _avatarNodes[_cacheSpriteToNodesMap[i]];
				var spriteTransform:Transform3D = node.transform._entity;
				var nodeTransform:AnimationTransform3D = node.transform;
				if (nodeTransform._worldUpdate) {//Avatar跟节点始终为false,不会更新
					var nodeMatrix:Float32Array = _tempMatrix4x40;
					nodeTransform._setWorldMatrixAndUpdate(nodeMatrix);
					var spriteWorldMatrix:Matrix4x4 = spriteTransform.worldMatrix;
					Utils3D.matrix4x4MultiplyMFM((_owner as Sprite3D)._transform.worldMatrix, nodeMatrix, spriteWorldMatrix);
					spriteTransform.worldMatrix = spriteWorldMatrix;
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _updatePlayer(elapsedTime:Number):void {
			if (_currentPlayClip == null || _stoped || !_currentPlayClip.loaded)//动画停止或暂停，不更新
				return;
			
			var cacheFrameInterval:Number = _cacheFrameRateInterval * _cachePlayRate;
			var time:Number = 0;
			(_startUpdateLoopCount !== Stat.loopCount) && (time = elapsedTime * playbackRate, _elapsedPlaybackTime += time);
			
			var frameRate:Number = _currentPlayClip._frameRate;
			var playStart:Number = _playStartFrames[_currentPlayClipIndex] / frameRate;
			var playEnd:Number = Math.min(_playEndFrames[_currentPlayClipIndex] / frameRate, _currentPlayClip._duration);
			
			var aniClipPlayDuration:Number = playEnd - playStart;
			if ((!_currentPlayClip.islooping && _elapsedPlaybackTime >= aniClipPlayDuration)) {
				_onAnimationStop();
				_setPlayParamsWhenStop(aniClipPlayDuration, cacheFrameInterval);
				this.event(Event.STOPPED);//兼容
				return;
			}
			time += _currentTime;
			if (aniClipPlayDuration > 0) {
				if (time >= aniClipPlayDuration) {
					do {//TODO:用求余改良
						time -= aniClipPlayDuration;
						if (time < aniClipPlayDuration) {
							_setPlayParams(time, cacheFrameInterval);
							this.event(Event.COMPLETE);
						}
						_playEventIndex = 0;
						_eventScript(0, time);
					} while (time >= aniClipPlayDuration)
				} else {
					_setPlayParams(time, cacheFrameInterval);
				}
			} else {
				_currentTime = _currentFrameTime = _currentFrameIndex = _playEventIndex = 0;
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
			_canCache = isCache && rate >= cacheRate;
			var frameIndex:int = -1;
			var clipDatas:Vector.<Float32Array>;
			if (_canCache) {
				frameIndex = _currentFrameIndex;
				if (_lastFrameIndex === frameIndex)
					return;
				
				clipDatas = clip._getAnimationDataWithCache(cacheRate, frameIndex);
				if (_avatar) {
					var avatarOwners:Vector.<AnimationNode> = _cacheNodesAvatarOwners[_currentPlayClipIndex];
					var cacheMap:Int32Array = clip._cachePropertyMap;
					var cacheMapCount:int = cacheMap.length;
					if (cacheMapCount > 0) {//cacheMapCount>0时才进行相关计算，避免浪费,如骨骼动画
						if (!clipDatas) {
							clipDatas = new Vector.<Float32Array>();
							clipDatas.length = cacheMapCount;
							clip._cacheAnimationData(cacheRate, frameIndex, clipDatas);
							clip._evaluateAnimationlDatasCacheMode(avatarOwners, _cacheFullFrames[_currentPlayClipIndex], this, clipDatas, cacheMap);
						}
						_setAnimationClipPropertyToAnimationNode(avatarOwners, cacheMap, clipDatas);
					}
					
					_curAvatarNodeDatas = clip._getAvatarDataWithCache(_avatar, _cachePlayRate, frameIndex);
					if (!_curAvatarNodeDatas) {
						_curAvatarNodeDatas = new Vector.<Float32Array>();
						_curAvatarNodeDatas.length = _avatarNodes.length;
						clip._cacheAvatarData(_avatar, _cachePlayRate, frameIndex, _curAvatarNodeDatas);
						_evaluateAvatarNodesCacheMode(avatarOwners, clip, clip._publicClipDatas, _curAvatarNodeDatas, clip._unCachePropertyMap);
					}
					_updateAvatarNodesToSpriteCacheMode(clip, _curAvatarNodeDatas);
				} else {
					var spriteOwners:Vector.<Sprite3D> = _cacheNodesSpriteOwners[_currentPlayClipIndex];
					if (!clipDatas) {
						clipDatas = new Vector.<Float32Array>();
						clipDatas.length = _currentPlayClip._nodes.length;
						clip._evaluateAnimationlDatasCacheMode(spriteOwners, _cacheFullFrames[_currentPlayClipIndex], this, clipDatas, null);//properyMap=null则数据全都存入_curClipAnimationDatas
						clip._cacheAnimationData(cacheRate, frameIndex, clipDatas);
					}
					_setAnimationClipPropertyToSprite3D(spriteOwners, clipDatas);
				}
			} else {
				clipDatas = clip._publicClipDatas;
				if (_avatar) {
					clip._evaluateAnimationlDatasRealTime(_cacheNodesAvatarOwners[_currentPlayClipIndex], currentPlayTime, clipDatas, clip._cachePropertyMap);
					if (!_publicAvatarNodeDatas) {
						_publicAvatarNodeDatas = new Vector.<Float32Array>();
						var nodeCount:int = _avatarNodes.length;
						_publicAvatarNodeDatas.length = nodeCount;
						for (var i:int = 1; i < nodeCount; i++)//根节点无需矩阵
							_publicAvatarNodeDatas[i] = new Float32Array(16);
					}
					_curAvatarNodeDatas = _publicAvatarNodeDatas;
					_evaluateAvatarNodesRealTime(_cacheNodesAvatarOwners[_currentPlayClipIndex], clip, clipDatas, _curAvatarNodeDatas, clip._unCachePropertyMap);
					_updateAvatarNodesToSpriteRealTime();
				} else {
					clip._evaluateAnimationlDatasRealTime(_cacheNodesSpriteOwners[_currentPlayClipIndex], currentPlayTime, clipDatas, null);
				}
			}
			_lastFrameIndex = frameIndex;
		}
		
		/**
		 * @private
		 */
		private function _checkAnimationNode(node:AnimationNode, sprite:Sprite3D):void {
			if (node.name === sprite.name && !sprite._transform.dummy)//判断!sprite._transform.dummy重名节点可按顺序依次匹配。
				sprite._isLinkSpriteToAnimationNode(this, node, true);
			
			for (var i:int = 0, n:int = sprite._childs.length; i < n; i++)
				_checkAnimationNode(node, sprite.getChildAt(i) as Sprite3D);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _load(owner:ComponentNode):void {
			((owner as Sprite3D).activeInHierarchy) && (Laya.timer.frameLoop(1, this, _updateAnimtionPlayer));
			_owner.on(Event.ACTIVE_IN_HIERARCHY_CHANGED, this, _onOwnerActiveHierarchyChanged);//TODO:Stop和暂停的时候也要移除
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _unload(owner:ComponentNode):void {
			super._unload(owner);
			((owner as Sprite3D).activeInHierarchy) && (Laya.timer.clear(this, _updateAnimtionPlayer));
			_owner.off(Event.ACTIVE_IN_HIERARCHY_CHANGED, this, _onOwnerActiveHierarchyChanged);
			_curAvatarNodeDatas = null;
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			for (var i:int = 0, n:int = _clips.length; i < n; i++)
				_clips[i]._removeReference();
			
			_currentPlayClip = null;
			
			_clipNames = null;
			_cacheNodesSpriteOwners = null;
			_cacheNodesAvatarOwners = null;
			_cacheNodesDefaultlValues = null;
			_clips = null;
			_cacheFullFrames = null;
		}
		
		/**
		 * @private
		 */
		override public function _cloneTo(dest:Component3D):void {
			var animator:Animator = dest as Animator;
			animator.avatar = avatar;
			var clipCount:int = _clips.length;
			for (var i:int = 0, n:int = _clips.length; i < n; i++)
				animator.addClip(_clips[i]);
			if (clip) {
				animator.clip = clip;
			}
		}
		
		/**
		 * 添加动画片段。
		 * @param	clip 动画片段。
		 * @param	playName 动画片段播放名称，如果为null,则使用clip.name作为播放名称。
		 * @param   开始帧率。
		 * @param   结束帧率。
		 */
		public function addClip(clip:AnimationClip, playName:String = null, startFrame:int = 0, endFrame:uint = 4294967295/*int.MAX_VALUE*/):void {
			playName = playName || clip.name;
			var index:int = _clipNames.indexOf(playName);
			if (index !== -1) {
				if (_clips[index] !== clip)
					throw new Error("Animation:this playName has exist with another clip.");
			} else {
				var clipIndex:int = _clips.indexOf(clip);
				if (startFrame < 0 || endFrame < 0)
					throw new Error("Animator:startFrame and endFrame must large than zero.");
				
				if (startFrame > endFrame)
					throw new Error("Animator:startFrame must less than endFrame.");
				
				_clipNames.push(playName);
				_clips.push(clip);
				_playStartFrames.push(startFrame);
				_playEndFrames.push(endFrame);
				_cacheNodesSpriteOwners.push(new Vector.<Sprite3D>());
				_cacheNodesAvatarOwners.push(new Vector.<AnimationNode>());
				_cacheNodesDefaultlValues.push(new Vector.<Float32Array>());
				_publicClipsDatas.push(new Vector.<Float32Array>());
				clip._addReference();
				
				clipIndex = _clips.length - 1;
				if (_avatar) {
					if (_avatar.loaded)
						_getAvatarOwnersByClipAsync(clipIndex, clip);
					else
						_avatar.once(Event.LOADED, this, _getAvatarOwnersByClipAsync, [clipIndex, clip]);
				} else {
					_getSpriteOwnersByClipAsync(clipIndex, clip);
				}
				
				if (clip.loaded)
					_computeCacheFullKeyframeIndices(clipIndex);
				else
					clip.once(Event.LOADED, this, _computeCacheFullKeyframeIndices, [clipIndex]);
			}
		}
		
		/**
		 * 移除动画片段。
		 * @param	clip 动画片段。
		 */
		public function removeClip(clip:AnimationClip):void {
			var index:int = _clips.indexOf(clip);
			if (index !== -1) {
				if (_avatar)
					_offClipAndAvatarRelateEvent(_avatar, clip)
				else
					_offGetSpriteOwnersByClipAsyncEvent(clip);
				_offGetClipCacheFullKeyframeIndicesEvent(clip);
				
				_clipNames.splice(index, 1);
				_clips.splice(index, 1);
				_playStartFrames.splice(index, 1);
				_playEndFrames.splice(index, 1);
				_cacheNodesSpriteOwners.splice(index, 1);
				_cacheNodesAvatarOwners.splice(index, 1);
				_cacheNodesDefaultlValues.splice(index, 1);
				_publicClipsDatas.splice(index, 1);
				clip._removeReference();
			}
		}
		
		/**
		 * 通过播放名字移除动画片段。
		 * @param	playName 播放名字。
		 */
		public function removeClipByName(playName:String):void {
			var index:int = _clipNames.indexOf(playName);
			if (index !== -1) {
				var clip:AnimationClip = _clips[index];
				if (_avatar)
					_offClipAndAvatarRelateEvent(_avatar, clip);
				else
					_offGetSpriteOwnersByClipAsyncEvent(clip);
				_offGetClipCacheFullKeyframeIndicesEvent(clip);
				
				_clipNames.splice(index, 1);
				_clips.splice(index, 1);
				_playStartFrames.splice(index, 1);
				_playEndFrames.splice(index, 1);
				_cacheNodesSpriteOwners.splice(index, 1);
				_cacheNodesAvatarOwners.splice(index, 1);
				_cacheNodesDefaultlValues.splice(index, 1);
				_publicClipsDatas.splice(index, 1);
			}
		}
		
		/**
		 * 通过播放名字获取动画片段。
		 * @param	playName 播放名字。
		 * @return 动画片段。
		 */
		public function getClip(playName:String):AnimationClip {
			var index:int = _clipNames.indexOf(playName);
			if (index !== -1) {
				return _clips[index];
			} else {
				return null;
			}
		}
		
		/**
		 * 获取动画片段个数。
		 * @return	动画个数。
		 */
		public function getClipCount():int {
			return _clips.length;
		}
		
		/**
		 * 播放动画。
		 * @param	name 如果为null则播放默认动画，否则按名字播放动画片段。
		 * @param	playbackRate 播放速率。
		 * @param	startFrame 开始帧率。
		 * @param	endFrame 结束帧率.-1表示为最大结束帧率。
		 */
		public function play(name:String = null, playbackRate:Number = 1.0):void {
			if (!name && _defaultClipIndex == -1)
				throw new Error("Animator:must have  default clip value,please set clip property.");
			
			if (name) {
				_currentPlayClipIndex = _clipNames.indexOf(name);
				_currentPlayClip = _clips[_currentPlayClipIndex];
			} else {
				_currentPlayClipIndex = _defaultClipIndex;
				_currentPlayClip = _clips[_defaultClipIndex];
			}
			
			_currentTime = 0;
			_currentFrameTime = 0;
			_elapsedPlaybackTime = 0;
			_playEventIndex = 0;
			this.playbackRate = playbackRate;
			_stoped = false;
			
			_currentFrameIndex = 0;
			_startUpdateLoopCount = Stat.loopCount;
			
			if (_lastPlayAnimationClip) 
				(_lastPlayAnimationClip !== _currentPlayClip) && (_revertKeyframeNodes(_lastPlayAnimationClip, _lastPlayAnimationClipIndex));//TODO:还原动画节点，防止切换动作时跳帧，如果是从stop而来是否无需设置
			
			//TODO:此处是否直接设置一帧最接近的原始帧率,后面AnimationClip首帧可以设置为null了就
			_updatePlayer(0);//如果分段播放,可修正帧率
			_lastPlayAnimationClip = _currentPlayClip;
			_lastPlayAnimationClipIndex = _currentPlayClipIndex;
		}
		
		/**
		 * 停止播放当前动画
		 */
		public function stop():void {
			if (playState !== AnimationState.stopped) {
				_stoped = true;
				this.event(Event.STOPPED);//兼容
			}
		}
		
		/**
		 * 关联精灵节点到Avatar节点,此Animator必须有Avatar文件。
		 * @param nodeName 关联节点的名字。
		 * @param sprite3D 精灵节点。
		 * @return 是否关联成功。
		 */
		public function linkSprite3DToAvatarNode(nodeName:String, sprite3D:Sprite3D):Boolean {
			if (_avatar) {
				var node:AnimationNode = _avatarNodeMap[nodeName];
				if (node) {
					sprite3D._isLinkSpriteToAnimationNode(this, node, true);
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
		
		/**
		 * 解除精灵节点到Avatar节点的关联,此Animator必须有Avatar文件。
		 * @param sprite3D 精灵节点。
		 * @return 是否解除关联成功。
		 */
		public function unLinkSprite3DToAvatarNode(sprite3D:Sprite3D):Boolean {
			if (_avatar) {
				var dummy:AnimationTransform3D = sprite3D.transform.dummy;
				if (dummy) {
					var node:AnimationNode = _avatarNodeMap[dummy._owner.name];
					sprite3D._isLinkSpriteToAnimationNode(this, node, false);
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
		
		//****************************兼容性接口********************************************************
		/**
		 * 获取当前是否暂停
		 * @return	是否暂停
		 */
		public function get paused():Boolean {
			return _stoped;
		}
		
		/**
		 * 设置是否暂停
		 * @param	value 是否暂停
		 */
		public function set paused(value:Boolean):void {
			_stoped = value;
			value && this.event(Event.PAUSED);
		}
		//****************************兼容性接口********************************************************
	}

}