package laya.d3.animation {
	import laya.d3.component.Animator;
	import laya.d3.core.Avatar;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.resource.Resource;
	import laya.utils.Byte;
	
	/**
	 * <code>AnimationClip</code> 类用于动画片段资源。
	 */
	public class AnimationClip extends Resource {
		/**
		 * 加载动画模板。
		 * @param url 动画模板地址。
		 */
		public static function load(url:String):AnimationClip {
			return Laya.loader.create(url, null, null, AnimationClip);
		}
		
		/**@private */
		private var _realTimeCurrentFrameIndexes:Int32Array;
		/**@private */
		private var _realTimeCurrentTimes:Float32Array;
		/**@private */
		private var _fullKeyframeIndicesCache:Object;
		/**@private */
		private var _animationDatasCache:Array;
		/**@private */
		private var _avatarDatasCache:Array;
		/** @private */
		private var _skinnedDatasCache:Array
		/**@private */
		public var _nodes:Vector.<KeyframeNode>;
		/**@private */
		public var _rootTransformNodes:Vector.<KeyframeNode>;
		
		/**@private */
		public var _cachePropertyToNodeMap:Int32Array;
		/**@private */
		public var _nodeToCachePropertyMap:Int32Array;
		/**@private */
		public var _unCachePropertyToNodeMap:Int32Array;
		
		/**@private */
		public var _duration:Number;
		/**@private */
		public var _frameRate:int;
		/**是否循环。*/
		public var islooping:Boolean;
		
		/**
		 * 创建一个 <code>AnimationClip</code> 实例。
		 */
		public function AnimationClip() {
			_fullKeyframeIndicesCache = {};
			_animationDatasCache = [];
			_avatarDatasCache = [];
			_skinnedDatasCache = [];
		}
		
		/**
		 * @private
		 */
		private function _hermiteInterpolate(frame:Keyframe, t:Number, dur:Number, out:Float32Array):void {
			var p0:Float32Array = frame.data;
			var tan0:Float32Array = frame.outTangent;
			var nextFrame:Keyframe = frame.next;
			var p1:Float32Array = nextFrame.data;
			var tan1:Float32Array = nextFrame.inTangent;
			
			var isComputeParams:Boolean = false;
			var a:Number, b:Number, c:Number, d:Number;
			for (var i:int = 0, n:int = out.length; i < n; i++) {
				var t0:Number = tan0[i], t1:Number = tan1[i];
				if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)")) {//TODO:是否可以优化不计算
					if (!isComputeParams) {
						var t2:Number = t * t;
						var t3:Number = t2 * t;
						a = 2.0 * t3 - 3.0 * t2 + 1.0;
						b = t3 - 2.0 * t2 + t;
						c = t3 - t2;
						d = -2.0 * t3 + 3.0 * t2;
						isComputeParams = true;
					}
					out[i] = a * p0[i] + b * t0 * dur + c * t1 * dur + d * p1[i];
				} else
					out[i] = p0[i];
			}
		}
		
		/**
		 * @private
		 */
		public function _getFullKeyframeIndicesWithCache(cacheInterval:Number):Array {
			return _fullKeyframeIndicesCache[cacheInterval];
		}
		
		/**
		 * @private
		 */
		public function _cacheFullKeyframeIndices(cacheInterval:Number, datas:Array):void {
			_fullKeyframeIndicesCache[cacheInterval] = datas;
		}
		
		/**
		 * @private
		 */
		public function _getAnimationDataWithCache(cacheRate:Number, frameIndex:int):Vector.<Float32Array> {
			var cacheDatas:Array = _animationDatasCache[cacheRate];
			if (!cacheDatas)
				return null;
			else {
				return cacheDatas[frameIndex];
			}
		}
		
		/**
		 * @private
		 */
		public function _cacheAnimationData(cacheRate:Number, frameIndex:int, datas:Vector.<Float32Array>):void {
			var aniDatasCache:Array = (_animationDatasCache[cacheRate]) || (_animationDatasCache[cacheRate] = []);
			aniDatasCache[frameIndex] = datas;
		}
		
		/**
		 * @private
		 */
		public function _getAvatarDataWithCache(avatar:Avatar, cacheRate:Number, frameIndex:int):Vector.<Matrix4x4> {
			var clipCache:Array = _avatarDatasCache[avatar.id];
			if (!clipCache) {
				return null;
			} else {
				var rateCache:Array = clipCache[cacheRate];
				if (!rateCache)
					return null;
				else {
					return rateCache[frameIndex];
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _cacheAvatarData(avatar:Avatar, cacheRate:Number, frameIndex:int, datas:Vector.<Matrix4x4>):void {
			var clipCache:Array = (_avatarDatasCache[avatar.id]) || (_avatarDatasCache[avatar.id] = []);
			var rateCache:Array = (clipCache[cacheRate]) || (clipCache[cacheRate] = []);
			rateCache[frameIndex] = datas;
		}
		
		/** @private */
		public function _getSkinnedDatasWithCache(mesh:Mesh, avatar:Avatar, cacheRate:Number, frameIndex:int):Vector.<Vector.<Float32Array>> {
			var avatarDatasCache:Array = _skinnedDatasCache[mesh.id];
			if (!avatarDatasCache) {
				return null;
			} else {
				var clipCache:Array = avatarDatasCache[avatar.id];
				if (!clipCache) {
					return null;
				} else {
					var rateCache:Array = clipCache[cacheRate];
					if (!rateCache)
						return null;
					else {
						return rateCache[frameIndex];
					}
				}
			}
		}
		
		/** @private */
		public function _cacheSkinnedDatasWithCache(mesh:Mesh, avatar:Avatar, cacheRate:Number, frameIndex:int, datas:Vector.<Vector.<Float32Array>>):void {
			var avatarCache:Array = (_skinnedDatasCache[mesh.id]) || (_skinnedDatasCache[mesh.id] = []);
			var clipCache:Array = (avatarCache[avatar.id]) || (avatarCache[avatar.id] = []);
			var rateCache:Array = (clipCache[cacheRate]) || (clipCache[cacheRate] = []);
			rateCache[frameIndex] = datas;
		}
		
		/**
		 * @private
		 */
		public function _evaluateAnimationlDatasCacheFrame(nodesFrameIndices:Array, animator:Animator, publicAnimationDatas:Vector.<Float32Array>, cacheAnimationDatas:Vector.<Float32Array>, nodeOwners:Vector.<AnimationNode>):void {
			var j:int, m:int;
			for (var i:int = 0, n:int = _nodes.length; i < n; i++) {
				var node:KeyframeNode = _nodes[i];
				var cacheProperty:Boolean = node._cacheProperty;
				if (!nodeOwners[i] || (cacheProperty && !cacheAnimationDatas))//动画节点丢失时，忽略该节点动画
					continue;
				
				var frameIndices:Int32Array = nodesFrameIndices[i];
				var realFrameIndex:int = frameIndices[animator.currentFrameIndex];
				
				var outDatas:Float32Array;
				var lastFrameIndex:int;
				if (realFrameIndex !== -1) {
					var frame:Keyframe = node.keyFrames[realFrameIndex];
					var nextKeyFrame:Keyframe = frame.next;
					if (nextKeyFrame) {
						if (cacheProperty) {
							outDatas = new Float32Array(node.keyFrameWidth);
							cacheAnimationDatas[_nodeToCachePropertyMap[i]] = outDatas;
						} else {
							outDatas = publicAnimationDatas[i];
						}
						
						var t:Number;
						var d:Number = frame.duration;
						if (d !== 0)
							t = (animator.currentFrameTime - frame.startTime) / d;
						else
							t = 0;
						_hermiteInterpolate(frame, t, d, outDatas);
					} else {
						if (cacheProperty) {
							lastFrameIndex = animator._lastFrameIndex;
							if (lastFrameIndex !== -1 && frameIndices[lastFrameIndex] === realFrameIndex)//只有非公共数据可以跳过，否则公共数据会错乱
								continue;
							
							outDatas = new Float32Array(node.keyFrameWidth);
							cacheAnimationDatas[_nodeToCachePropertyMap[i]] = outDatas;
						} else {
							outDatas = publicAnimationDatas[i];
						}
						
						var frameData:Float32Array = frame.data;
						for (j = 0, m = outDatas.length; j < m; j++)
							outDatas[j] = frameData[j];//不能设为null，会造成跳过当前帧数据
					}
				} else {
					if (cacheProperty) {
						lastFrameIndex = animator._lastFrameIndex;
						if (lastFrameIndex !== -1 && frameIndices[lastFrameIndex] === realFrameIndex)//只有非公共数据可以跳过，否则公共数据会错乱
							continue;
						
						outDatas = new Float32Array(node.keyFrameWidth);
						cacheAnimationDatas[_nodeToCachePropertyMap[i]] = outDatas;
					} else {
						outDatas = publicAnimationDatas[i];
					}
					
					var firstFrameDatas:Float32Array = node.keyFrames[0].data;
					for (j = 0, m = outDatas.length; j < m; j++)
						outDatas[j] = firstFrameDatas[j];
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _evaluateAnimationlDatasRealTime(playCurTime:Number, outAnimationDatas:Vector.<Float32Array>):void {
			var i:int, n:int;
			var nodes:Vector.<KeyframeNode> = _nodes;
			if (!_realTimeCurrentFrameIndexes) {
				_realTimeCurrentFrameIndexes = new Int32Array(nodes.length);
				for (i = 0, n = nodes.length; i < n; i++)
					_realTimeCurrentFrameIndexes[i] = -1;
				_realTimeCurrentTimes = new Float32Array(nodes.length);
			}
			
			for (i = 0, n = nodes.length; i < n; i++) {
				var node:KeyframeNode = nodes[i];
				if (playCurTime < _realTimeCurrentTimes[i])
					_realTimeCurrentFrameIndexes[i] = -1;
				_realTimeCurrentTimes[i] = playCurTime;
				
				var nextFrameIndex:int = _realTimeCurrentFrameIndexes[i] + 1;
				var keyFrames:Vector.<Keyframe> = node.keyFrames;
				var keyFramesCount:int = keyFrames.length;
				while (nextFrameIndex < keyFramesCount) {
					if (keyFrames[nextFrameIndex].startTime > playCurTime) {
						_realTimeCurrentFrameIndexes[i] = nextFrameIndex - 1;
						break;
					}
					nextFrameIndex++;
				}
				(nextFrameIndex === keyFramesCount) && (_realTimeCurrentFrameIndexes[i] = keyFramesCount - 1);
				var frame:Keyframe = keyFrames[_realTimeCurrentFrameIndexes[i]];
				if (frame) {
					var nextFarme:Keyframe = frame.next;
					if (nextFarme) {//如果nextFarme为空，不修改数据，保持上一帧
						var d:Number = frame.duration;
						var t:Number;
						if (d !== 0)
							t = (playCurTime - frame.startTime) / d;
						else
							t = 0;
						
						_hermiteInterpolate(frame, t, d, outAnimationDatas[i]);
					}
				} else {
					var outDatas:Float32Array = outAnimationDatas[i];
					var firstFrameDatas:Float32Array = node.keyFrames[0].data;
					for (var j:int = 0, m:int = outDatas.length; j < m; j++)
						outDatas[j] = firstFrameDatas[j];
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var reader:Byte = new Byte(data);
			var version:String = reader.readUTFString();
			switch (version) {
			case "LAYAANIMATION:01": 
				AnimationClipParser01.parse(this, reader);
				break;
			}
			_endLoaded();
		}
	}
}

