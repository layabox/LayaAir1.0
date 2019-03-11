package laya.d3.animation {
	import laya.d3.core.FloatArrayKeyframe;
	import laya.d3.core.FloatKeyframe;
	import laya.d3.core.Keyframe;
	import laya.d3.utils.Utils3D;
	import laya.layagl.LayaGL;
	import laya.resource.Resource;
	import laya.utils.Byte;
	import laya.utils.Handler;
	
	/**
	 * <code>AnimationClip</code> 类用于动画片段资源。
	 */
	public class AnimationClip extends Resource {
		/**@private	*/
		public static var _tempQuaternionArray0:Float32Array = new Float32Array(4);
		
		/**
		 * @inheritDoc
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):AnimationClip {
			var clip:AnimationClip = new AnimationClip();
			var reader:Byte = new Byte(data);
			clip._version = reader.readUTFString();
			switch (clip._version) {
			case "LAYAANIMATION:03": 
				AnimationClipParser03.parse(clip, reader);
				break;
			default: 
				throw "unknown animationClip version.";
			}
			return clip;
		}
		
		/**
		 * 加载动画片段。
		 * @param url 动画片段地址。
		 * @param complete  完成回掉。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.ANIMATIONCLIP);
		}
		
		/**@private */
		public var _version:String;
		/**@private */
		public var _duration:Number;
		/**@private */
		public var _frameRate:int;
		/**@private */
		public var _nodes:KeyframeNodeList = new KeyframeNodeList();
		/**@private */
		public var _nodesDic:Object;
		/**@private */
		public var _nodesMap:Object;//TODO:去掉
		/** @private */
		public var _events:Vector.<AnimationEvent>;
		
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
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_events = new Vector.<AnimationEvent>();
		}
		
		/**
		 * @private
		 */
		private function _hermiteInterpolate(frame:FloatKeyframe, nextFrame:FloatKeyframe, t:Number, dur:Number):Number {
			var t0:Number = frame.outTangent, t1:Number = nextFrame.inTangent;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)")) {
				var t2:Number = t * t;
				var t3:Number = t2 * t;
				var a:Number = 2.0 * t3 - 3.0 * t2 + 1.0;
				var b:Number = t3 - 2.0 * t2 + t;
				var c:Number = t3 - t2;
				var d:Number = -2.0 * t3 + 3.0 * t2;
				return a * frame.value + b * t0 * dur + c * t1 * dur + d * nextFrame.value;
			} else
				return frame.value;
		}
		
		/**
		 * @private
		 */
		private function _hermiteInterpolateArray(frame:FloatArrayKeyframe, nextFrame:FloatArrayKeyframe, t:Number, dur:Number, out:Float32Array):void {
			var d0:Float32Array = frame.data;
			var d1:Float32Array = nextFrame.data;
			var outTanOffset:int = out.length;
			var pOffset:int = outTanOffset * 2;
			
			var a:Number, b:Number, c:Number, d:Number;
			for (var i:int = 0, n:int = out.length; i < n; i++) {
				var t0:Number = d0[outTanOffset + i], t1:Number = d1[i];
				if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)")) {
					if (i === 0) {
						var t2:Number = t * t;
						var t3:Number = t2 * t;
						a = 2.0 * t3 - 3.0 * t2 + 1.0;
						b = t3 - 2.0 * t2 + t;
						c = t3 - t2;
						d = -2.0 * t3 + 3.0 * t2;
					}
					out[i] = a * d0[pOffset + i] + b * t0 * dur + c * t1 * dur + d * d1[pOffset + i];
				} else
					out[i] = d0[pOffset + i];
			}
		}
		
		/**
		 * @private
		 */
		public function _evaluateClipDatasRealTime(nodes:KeyframeNodeList, playCurTime:Number, realTimeCurrentFrameIndexes:Int16Array, addtive:Boolean, frontPlay:Boolean):void {
			for (var i:int = 0, n:int = nodes.count; i < n; i++) {
				var node:KeyframeNode = nodes.getNodeByIndex(i);
				var type:int = node.type;
				var nextFrameIndex:int;
				var keyFrames:Vector.<Keyframe> = node._keyFrames;
				var keyFramesCount:int = keyFrames.length;
				var frameIndex:int = realTimeCurrentFrameIndexes[i];
				
				if (frontPlay) {
					if ((frameIndex !== -1) && (playCurTime < keyFrames[frameIndex].time)) {//重置正向循环
						frameIndex = -1;
						realTimeCurrentFrameIndexes[i] = frameIndex;
					}
					
					nextFrameIndex = frameIndex + 1;
					while (nextFrameIndex < keyFramesCount) {
						if (keyFrames[nextFrameIndex].time > playCurTime)
							break;
						frameIndex++;
						nextFrameIndex++;
						realTimeCurrentFrameIndexes[i] = frameIndex;
					}
				} else {
					nextFrameIndex = frameIndex + 1;
					if ((nextFrameIndex !== keyFramesCount) && (playCurTime > keyFrames[nextFrameIndex].time)) {//重置逆向循环
						frameIndex = keyFramesCount - 1;
						realTimeCurrentFrameIndexes[i] = frameIndex;
					}
					
					nextFrameIndex = frameIndex + 1;
					while (frameIndex > -1) {
						if (keyFrames[frameIndex].time < playCurTime)
							break;
						frameIndex--;
						nextFrameIndex--;
						realTimeCurrentFrameIndexes[i] = frameIndex;
					}
				}
				
				var isEnd:Boolean = nextFrameIndex === keyFramesCount;
				switch (type) {
				case 0: 
					if (frameIndex !== -1) {
						var frame:FloatKeyframe = keyFrames[frameIndex] as FloatKeyframe;
						if (isEnd) {//如果nextFarme为空，不修改数据，保持上一帧
							node.data = frame.value;
						} else {
							var nextFarme:FloatKeyframe = keyFrames[nextFrameIndex] as FloatKeyframe;
							var d:Number = nextFarme.time - frame.time;
							var t:Number;
							if (d !== 0)
								t = (playCurTime - frame.time) / d;
							else
								t = 0;
							node.data = _hermiteInterpolate(frame, nextFarme, t, d);
						}
						
					} else {
						node.data = (keyFrames[0] as FloatKeyframe).value;
					}
					
					if (addtive)
						node.data -= (keyFrames[0] as FloatKeyframe).value;
					break;
				case 1: 
				case 4: 
					var clipData:Float32Array = node.data;
					_evaluateFrameNodeArrayDatasRealTime(keyFrames as Vector.<FloatArrayKeyframe>, frameIndex, isEnd, playCurTime, 3, clipData);
					if (addtive) {
						var firstFrameValue:Float32Array = (keyFrames[0] as FloatArrayKeyframe).data;
						clipData[0] -= firstFrameValue[6];
						clipData[1] -= firstFrameValue[7];
						clipData[2] -= firstFrameValue[8];
					}
					break;
				case 2: 
					clipData = node.data;
					_evaluateFrameNodeArrayDatasRealTime(keyFrames as Vector.<FloatArrayKeyframe>, frameIndex, isEnd, playCurTime, 4, clipData);
					if (addtive) {
						var tempQuat:Float32Array = _tempQuaternionArray0;
						firstFrameValue = (keyFrames[0] as FloatArrayKeyframe).data;
						Utils3D.quaternionConjugate(firstFrameValue, 8, tempQuat);
						Utils3D.quaternionMultiply(tempQuat, clipData, clipData);
					}
					
					break;
				case 3: 
					clipData = node.data;
					_evaluateFrameNodeArrayDatasRealTime(keyFrames as Vector.<FloatArrayKeyframe>, frameIndex, isEnd, playCurTime, 3, clipData);
					if (addtive) {
						firstFrameValue = (keyFrames[0] as FloatArrayKeyframe).data;
						clipData[0] /= firstFrameValue[6];
						clipData[1] /= firstFrameValue[7];
						clipData[2] /= firstFrameValue[8];
					}
					break;
				default: 
					throw "AnimationClip:unknown node type.";
				}
			}
		}
		
		public function _evaluateClipDatasRealTimeForNative(nodes:*, playCurTime:Number, realTimeCurrentFrameIndexes:Uint16Array, addtive:Boolean):void {
			LayaGL.instance.evaluateClipDatasRealTime(nodes._nativeObj, playCurTime, realTimeCurrentFrameIndexes, addtive);
		}
		
		/**
		 * @private
		 */
		private function _evaluateFrameNodeArrayDatasRealTime(keyFrames:Vector.<FloatArrayKeyframe>, frameIndex:int, isEnd:Boolean, playCurTime:Number, width:int, outDatas:Float32Array):void {
			var dataOffset:int = width * 2;
			if (frameIndex !== -1) {
				var frame:FloatArrayKeyframe = keyFrames[frameIndex];
				if (isEnd) {
					var frameData:Float32Array = frame.data;
					for (var j:int = 0; j < width; j++)
						outDatas[j] = frameData[dataOffset + j];//不能设为null，会造成跳过当前帧数据
				} else {
					var nextKeyFrame:FloatArrayKeyframe = keyFrames[frameIndex + 1];
					var t:Number;
					var startTime:Number = frame.time;
					var d:Number = nextKeyFrame.time - startTime;
					if (d !== 0)
						t = (playCurTime - startTime) / d;
					else
						t = 0;
					
					_hermiteInterpolateArray(frame, nextKeyFrame, t, d, outDatas);
				}
				
			} else {
				var firstFrameDatas:Float32Array = keyFrames[0].data;
				for (j = 0; j < width; j++)
					outDatas[j] = firstFrameDatas[dataOffset + j];
			}
		}
		
		/**
		 * @private
		 */
		private function _binarySearchEventIndex(time:Number):int {
			var start:int = 0;
			var end:int = _events.length - 1;
			var mid:int;
			while (start <= end) {
				mid = Math.floor((start + end) / 2);
				var midValue:int = _events[mid].time;
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
			_events.splice(index, 0, event);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _disposeResource():void {
			_version = null;
			_nodes = null;
			_nodesMap = null;
		}
	}
}

