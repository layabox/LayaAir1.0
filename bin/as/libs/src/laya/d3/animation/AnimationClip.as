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
		private var _skinnedDatasCache:Array;
		
		/**@private */
		public var _version:String;
		/**@private */
		public var _nodes:Vector.<KeyframeNode>;
		/**@private */
		public var _nodesMap:Object;
		/**@private */
		public var _cachePropertyMap:Int32Array;
		/**@private */
		public var _nodeToCachePropertyMap:Int32Array;
		/**@private */
		public var _unCachePropertyMap:Int32Array;
		/**@private */
		public var _duration:Number;
		/**@private */
		public var _frameRate:int;
		/** @private */
		public var _animationEvents:Vector.<AnimationEvent>;
		/** @private */
		public var _publicClipDatas:Vector.<Float32Array>;
		
		/**是否循环。*/
		public var islooping:Boolean;
		
		/**
		 * 获取动画片段时长。
		 */
		public function duration():Number {
			return _duration;
		}
		
		/**
		 * 创建一个 <code>AnimationClip</code> 实例。
		 */
		public function AnimationClip() {
			_fullKeyframeIndicesCache = {};
			_animationDatasCache = [];
			_avatarDatasCache = [];
			_skinnedDatasCache = [];
			_animationEvents = new Vector.<AnimationEvent>();
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
		public function _getAvatarDataWithCache(avatar:Avatar, cacheRate:Number, frameIndex:int):Vector.<Float32Array> {
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
		public function _cacheAvatarData(avatar:Avatar, cacheRate:Number, frameIndex:int, datas:Vector.<Float32Array>):void {
			var clipCache:Array = (_avatarDatasCache[avatar.id]) || (_avatarDatasCache[avatar.id] = []);
			var rateCache:Array = (clipCache[cacheRate]) || (clipCache[cacheRate] = []);
			rateCache[frameIndex] = datas;
		}
		
		/**
		 * @private
		 */
		public function _evaluateAnimationlDatasCacheMode(nodeOwners:*/*Vector.<AnimationNode>或Vector.<Sprite3D>*/, nodesFrameIndices:Array, animator:Animator, clipDatas:Vector.<Float32Array>, propertyMap:Int32Array):void {
			var j:int, m:int;
			for (var i:int = 0, n:int = propertyMap ? propertyMap.length : _nodes.length; i < n; i++) {
				var nodeIndex:int = propertyMap ? propertyMap[i] : i;
				var node:KeyframeNode = _nodes[nodeIndex];
				var cacheProperty:Boolean = node._cacheProperty;
				if (!nodeOwners[nodeIndex])//动画节点丢失时，忽略该节点动画
					continue;
				
				var frameIndices:Int32Array = nodesFrameIndices[nodeIndex];
				var realFrameIndex:int = frameIndices[animator.currentFrameIndex];
				
				var outDatas:Float32Array;
				var lastFrameIndex:int;
				if (realFrameIndex !== -1) {
					var frame:Keyframe = node.keyFrames[realFrameIndex];
					//if (!frame)
					//	alert("next为空那个BUG: ",animator.currentFrameIndex," ",frameIndices.length," ",frameIndices[frameIndices.length]);
					var nextKeyFrame:Keyframe = frame.next;
					if (nextKeyFrame) {
						if (propertyMap && !cacheProperty) {
							outDatas = clipDatas[nodeIndex];
							(outDatas) || (outDatas = clipDatas[nodeIndex] = new Float32Array(node.keyFrameWidth));
						} else {
							outDatas = new Float32Array(node.keyFrameWidth);
							clipDatas[i] = outDatas;
						}
						
						var t:Number;
						var d:Number = frame.duration;
						if (d !== 0)
							t = (animator.currentFrameTime - frame.startTime) / d;
						else
							t = 0;
						_hermiteInterpolate(frame, t, d, outDatas);
					} else {
						if (propertyMap && !cacheProperty) {
							outDatas = clipDatas[nodeIndex];
							(outDatas) || (outDatas = clipDatas[nodeIndex] = new Float32Array(node.keyFrameWidth));
						} else {
							lastFrameIndex = animator._lastFrameIndex;
							if (lastFrameIndex !== -1 && frameIndices[lastFrameIndex] === realFrameIndex)//只有非公共数据可以跳过，否则公共数据会错乱
								continue;
							
							outDatas = new Float32Array(node.keyFrameWidth);
							clipDatas[i] = outDatas;
						}
						
						var frameData:Float32Array = frame.data;
						for (j = 0, m = outDatas.length; j < m; j++)
							outDatas[j] = frameData[j];//不能设为null，会造成跳过当前帧数据
					}
				} else {
					if (propertyMap && !cacheProperty) {
						outDatas = clipDatas[nodeIndex];
						(outDatas) || (outDatas = clipDatas[nodeIndex] = new Float32Array(node.keyFrameWidth));
					} else {
						lastFrameIndex = animator._lastFrameIndex;
						if (lastFrameIndex !== -1 && frameIndices[lastFrameIndex] === realFrameIndex)//只有非公共数据可以跳过，否则公共数据会错乱
							continue;
						
						outDatas = new Float32Array(node.keyFrameWidth);
						clipDatas[i] = outDatas;
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
		public function _evaluateAnimationlDatasRealTime(nodeOwners:*/*Vector.<AnimationNode>或Vector.<Sprite3D>*/, playCurTime:Number, outAnimationDatas:Vector.<Float32Array>, propertyMap:Int32Array/*propertyMap为null是无avatar模式*/):void {
			var i:int, n:int;
			var nodes:Vector.<KeyframeNode> = _nodes;
			if (!_realTimeCurrentFrameIndexes) {
				_realTimeCurrentFrameIndexes = new Int32Array(nodes.length);
				for (i = 0, n = nodes.length; i < n; i++)
					_realTimeCurrentFrameIndexes[i] = -1;
				_realTimeCurrentTimes = new Float32Array(nodes.length);
			}
			
			for (i = 0, n = propertyMap ? propertyMap.length : _nodes.length; i < n; i++) {
				var index:int = propertyMap ? propertyMap[i] : i;
				var node:KeyframeNode = nodes[index];
				if (playCurTime < _realTimeCurrentTimes[index])
					_realTimeCurrentFrameIndexes[index] = -1;
				_realTimeCurrentTimes[index] = playCurTime;
				
				var nextFrameIndex:int = _realTimeCurrentFrameIndexes[index] + 1;
				var keyFrames:Vector.<Keyframe> = node.keyFrames;
				var keyFramesCount:int = keyFrames.length;
				while (nextFrameIndex < keyFramesCount) {
					if (keyFrames[nextFrameIndex].startTime > playCurTime) {
						_realTimeCurrentFrameIndexes[index] = nextFrameIndex - 1;
						break;
					}
					nextFrameIndex++;
				}
				(nextFrameIndex === keyFramesCount) && (_realTimeCurrentFrameIndexes[index] = keyFramesCount - 1);
				var j:int = 0, m:int;
				var outDatas:Float32Array = outAnimationDatas[index];
				(outDatas) || (outDatas = outAnimationDatas[index] = new Float32Array(node.keyFrameWidth));
				var frame:Keyframe = keyFrames[_realTimeCurrentFrameIndexes[index]];
				if (frame) {
					var nextFarme:Keyframe = frame.next;
					if (nextFarme) {//如果nextFarme为空，不修改数据，保持上一帧
						var d:Number = frame.duration;
						var t:Number;
						if (d !== 0)
							t = (playCurTime - frame.startTime) / d;
						else
							t = 0;
						_hermiteInterpolate(frame, t, d, outDatas);
					} else {
						var frameData:Float32Array = frame.data;
						for (j = 0, m = outDatas.length; j < m; j++)
							outDatas[j] = frameData[j];//不能设为null，会造成跳过当前帧数据
					}
				} else {
					var firstFrameDatas:Float32Array = node.keyFrames[0].data;
					for (j = 0, m = outDatas.length; j < m; j++)
						outDatas[j] = firstFrameDatas[j];
				}
				
				var owner:* = nodeOwners[index];
				if (owner) {
					if (propertyMap)
						AnimationNode._propertySetFuncs[node.propertyNameID](owner, null, outDatas);
					else
						AnimationNode._propertySetFuncs[node.propertyNameID](null, owner, outDatas);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _binarySearchEventIndex(time:Number):int {
			var start:int = 0;
			var end:int = _animationEvents.length - 1;
			var mid:int;
			while (start <= end) {
				mid = Math.floor((start + end) / 2);
				var midValue:int = _animationEvents[mid].time;
				if (midValue == time)
					return mid;
				else if (midValue > time)
					end = mid - 1;
				else
					start = mid + 1;
			}
			return start;
		}
		
		/**
		 * 添加动画事件。
		 */
		public function addEvent(event:AnimationEvent):void {
			var index:int = _binarySearchEventIndex(event.time);
			_animationEvents.splice(index, 0, event);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var reader:Byte = new Byte(data);
			_version = reader.readUTFString();
			switch (_version) {
			case "LAYAANIMATION:01": 
				AnimationClipParser01.parse(this, reader);
				break;
			case "LAYAANIMATION:02": 
				AnimationClipParser02.parse(this, reader);
				break;
			}
			completeCreate();
			_endLoaded();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function disposeResource():void {
			_realTimeCurrentFrameIndexes = null;
			_realTimeCurrentTimes = null;
			_fullKeyframeIndicesCache = null;
			_animationDatasCache = null;
			_avatarDatasCache = null;
			_skinnedDatasCache = null;
			_version = null;
			_nodes = null;
			_nodesMap = null;
			_cachePropertyMap = null;
			_nodeToCachePropertyMap = null;
			_unCachePropertyMap = null;
			_publicClipDatas = null;
		}
	}
}

