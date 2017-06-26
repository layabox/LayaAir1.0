package laya.d3.animation {
	import laya.ani.math.BezierLerp;
	import laya.d3.animation.AnimationClipParser01;
	import laya.d3.core.Avatar;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.resource.Resource;
	import laya.utils.Byte;
	import laya.utils.Stat;
	
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
		public var _cacheUnTransformPropertyToNodeMap:Int32Array;
		/**@private */
		public var _cacheNodeToUnTransformPropertyMap:Int32Array;
		
		/**@private */
		public var _duration:Number;
		/**@private */
		public var _frameRate:int;
		
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
			
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var a:Number = 2.0 * t3 - 3.0 * t2 + 1.0;
			var b:Number = t3 - 2.0 * t2 + t;
			var c:Number = t3 - t2;
			var d:Number = -2.0 * t3 + 3.0 * t2;
			for (var i:int = 0, n:int = out.length; i < n; i++)
				out[i] = a * p0[i] + b * tan0[i] * dur + c * tan1[i] * dur + d * p1[i];
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
		public function _evaluateAnimationlDatasCacheFrame(nodesFrameIndices:Array, frameIndex:int, playCurTime:Number, cacheNodesOriginalValue:Vector.<Float32Array>, publicAnimationDatas:Vector.<Float32Array>, cacheAnimationDatas:Vector.<Float32Array>):void {
			var nodes:Vector.<KeyframeNode> = _nodes;
			var j:int, m:int;
			for (var i:int = 0, n:int = nodes.length; i < n; i++) {
				var node:KeyframeNode = nodes[i];
				var realFrameIndex:int = nodesFrameIndices[i][frameIndex];
				var isTransformproperty:Boolean = node.isTransformproperty;
				
				var outDatas:Float32Array;
				if (realFrameIndex !== -1) {
					if (isTransformproperty) {
						outDatas = publicAnimationDatas[i];
					} else {
						outDatas = new Float32Array(node.keyFrameWidth);
						cacheAnimationDatas[_cacheNodeToUnTransformPropertyMap[i]] = outDatas;
					}
					
					var frame:Keyframe = node.keyFrames[realFrameIndex];
					var nextKeyFrame:Keyframe = frame.next;
					if (nextKeyFrame) {
						var t:Number;
						var d:Number = frame.duration;
						
						if (d !== 0)
							t = (playCurTime - frame.startTime) / d;
						else
							t = 0;
						_hermiteInterpolate(frame, t, d, outDatas);
					} else {
						for (j = 0, m = outDatas.length; j < m; j++)
							outDatas[j] = frame.data[j];//设置当前帧数据，不能设为null，会造成跳过当前帧数据
					}
				} else {
					if (isTransformproperty) {
						outDatas = publicAnimationDatas[i];
						for (j = 0, m = outDatas.length; j < m; j++)
							outDatas[j] = cacheNodesOriginalValue[i][j];
					} else {
						//cacheAnimationDatas[_cacheNodeToUnTransformPropertyMap[i]] = null;
					}
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
					var outDatas:Float32Array = outAnimationDatas[i];
					var nextFarme:Keyframe = frame.next;
					if (nextFarme) {//如果nextFarme为空，不修改数据，保持上一帧
						var d:Number = frame.duration;
						var t:Number;
						if (d !== 0)
							t = (playCurTime - frame.startTime) / d;
						else
							t = 0;
						
						_hermiteInterpolate(frame, t, d, outDatas);
					}
				} else {
					outDatas = null;//TODO:这里有问题，不能置空，导致丢失
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
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			if (resourceManager)
				resourceManager.removeResource(this);
			super.dispose();
		}
	
	}
}

