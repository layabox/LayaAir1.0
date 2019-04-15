package laya.d3.animation {
	import laya.d3.core.FloatKeyframe;
	import laya.d3.core.Keyframe;
	import laya.d3.core.QuaternionKeyframe;
	import laya.d3.core.Vector3Keyframe;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
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
		public static var _tempQuaternion0:Quaternion = new Quaternion();
		
		/**
		 * @inheritDoc
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):AnimationClip {
			var clip:AnimationClip = new AnimationClip();
			var reader:Byte = new Byte(data);
			var version:String = reader.readUTFString();
			switch (version) {
			case "LAYAANIMATION:03": 
				AnimationClipParser03.parse(clip, reader);
				break;
			case "LAYAANIMATION:04": 
			case "LAYAANIMATION:COMPRESSION_04": 
				AnimationClipParser04.parse(clip, reader,version);
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
		private function _hermiteInterpolateVector3(frame:Vector3Keyframe, nextFrame:Vector3Keyframe, t:Number, dur:Number, out:Vector3):void {
			var p0:Vector3= frame.value;
			var tan0:Vector3 = frame.outTangent;
			var p1:Vector3 = nextFrame.value;
			var tan1:Vector3 = nextFrame.inTangent;
			
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var a:Number = 2.0 * t3 - 3.0 * t2 + 1.0;
			var b:Number = t3 - 2.0 * t2 + t;
			var c:Number = t3 - t2;
			var d:Number = -2.0 * t3 + 3.0 * t2;
			
			var t0:Number = tan0.x, t1:Number = tan1.x;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.x = a * p0.x + b * t0 * dur + c * t1 * dur + d * p1.x;
			else
				out.x = p0.x;
			
			t0 = tan0.y, t1 = tan1.y;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.y = a * p0.y + b * t0 * dur + c * t1 * dur + d * p1.y;
			else
				out.y = p0.y;
			
			t0 = tan0.z, t1 = tan1.z;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.z = a * p0.z + b * t0 * dur + c * t1 * dur + d * p1.z;
			else
				out.z = p0.z;
		}
		
		/**
		 * @private
		 */
		private function _hermiteInterpolateQuaternion(frame:QuaternionKeyframe, nextFrame:QuaternionKeyframe, t:Number, dur:Number, out:Quaternion):void {
			var p0:Quaternion = frame.value;
			var tan0:Vector4 = frame.outTangent;
			var p1:Quaternion = nextFrame.value;
			var tan1:Vector4 = nextFrame.inTangent;
			
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var a:Number = 2.0 * t3 - 3.0 * t2 + 1.0;
			var b:Number = t3 - 2.0 * t2 + t;
			var c:Number = t3 - t2;
			var d:Number = -2.0 * t3 + 3.0 * t2;
			
			var t0:Number = tan0.x, t1:Number = tan1.x;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.x = a * p0.x + b * t0 * dur + c * t1 * dur + d * p1.x;
			else
				out.x = p0.x;
			
			t0 = tan0.y, t1 = tan1.y;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.y = a * p0.y + b * t0 * dur + c * t1 * dur + d * p1.y;
			else
				out.y = p0.y;
			
			t0 = tan0.z, t1 = tan1.z;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.z = a * p0.z + b * t0 * dur + c * t1 * dur + d * p1.z;
			else
				out.z = p0.z;
			
			t0 = tan0.w, t1 = tan1.w;
			if (__JS__("Number.isFinite(t0) && Number.isFinite(t1)"))
				out.w = a * p0.w + b * t0 * dur + c * t1 * dur + d * p1.w;
			else
				out.w = p0.w;
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
					var clipData:Vector3 = node.data;
					_evaluateFrameNodeVector3DatasRealTime(keyFrames as Vector.<Vector3Keyframe>, frameIndex, isEnd, playCurTime, clipData);
					if (addtive) {
						var firstFrameValue:Vector3 = (keyFrames[0] as Vector3Keyframe).value;
						clipData.x -= firstFrameValue.x;
						clipData.y -= firstFrameValue.y;
						clipData.z -= firstFrameValue.z;
					}
					break;
				case 2: 
					var clipQuat:Quaternion = node.data;
					_evaluateFrameNodeQuaternionDatasRealTime(keyFrames as Vector.<QuaternionKeyframe>, frameIndex, isEnd, playCurTime, clipQuat);
					if (addtive) {
						var tempQuat:Quaternion = _tempQuaternion0;
						var firstFrameValueQua:Quaternion = (keyFrames[0] as QuaternionKeyframe).value;
						Utils3D.quaternionConjugate(firstFrameValueQua, tempQuat);
						Quaternion.multiply(tempQuat, clipQuat, clipQuat);
					}
					
					break;
				case 3: 
					clipData = node.data;
					_evaluateFrameNodeVector3DatasRealTime(keyFrames as Vector.<Vector3Keyframe>, frameIndex, isEnd, playCurTime, clipData);
					if (addtive) {
						firstFrameValue = (keyFrames[0] as Vector3Keyframe).value;
						clipData.x /= firstFrameValue.x;
						clipData.y /= firstFrameValue.y;
						clipData.z /= firstFrameValue.z;
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
		private function _evaluateFrameNodeVector3DatasRealTime(keyFrames:Vector.<Vector3Keyframe>, frameIndex:int, isEnd:Boolean, playCurTime:Number, outDatas:Vector3):void {
			if (frameIndex !== -1) {
				var frame:Vector3Keyframe = keyFrames[frameIndex];
				if (isEnd) {
					var frameData:Vector3 = frame.value;
					outDatas.x = frameData.x;//不能设为null，会造成跳过当前帧数据
					outDatas.y = frameData.y;
					outDatas.z = frameData.z;
				} else {
					var nextKeyFrame:Vector3Keyframe = keyFrames[frameIndex + 1];
					var t:Number;
					var startTime:Number = frame.time;
					var d:Number = nextKeyFrame.time - startTime;
					if (d !== 0)
						t = (playCurTime - startTime) / d;
					else
						t = 0;
					
					_hermiteInterpolateVector3(frame, nextKeyFrame, t, d, outDatas);
				}
				
			} else {
				var firstFrameDatas:Vector3 = keyFrames[0].value;
				outDatas.x = firstFrameDatas.x;
				outDatas.y = firstFrameDatas.y;
				outDatas.z = firstFrameDatas.z;
			}
		}
		
		/**
		 * @private
		 */
		private function _evaluateFrameNodeQuaternionDatasRealTime(keyFrames:Vector.<QuaternionKeyframe>, frameIndex:int, isEnd:Boolean, playCurTime:Number, outDatas:Quaternion):void {
			if (frameIndex !== -1) {
				var frame:QuaternionKeyframe = keyFrames[frameIndex];
				if (isEnd) {
					var frameData:Quaternion = frame.value;
					outDatas.x = frameData.x;//不能设为null，会造成跳过当前帧数据
					outDatas.y = frameData.y;
					outDatas.z = frameData.z;
					outDatas.w = frameData.w;
				} else {
					var nextKeyFrame:QuaternionKeyframe = keyFrames[frameIndex + 1];
					var t:Number;
					var startTime:Number = frame.time;
					var d:Number = nextKeyFrame.time - startTime;
					if (d !== 0)
						t = (playCurTime - startTime) / d;
					else
						t = 0;
					
					_hermiteInterpolateQuaternion(frame, nextKeyFrame, t, d, outDatas);
				}
				
			} else {
				var firstFrameDatas:Quaternion = keyFrames[0].value;
				outDatas.x = firstFrameDatas.x;
				outDatas.y = firstFrameDatas.y;
				outDatas.z = firstFrameDatas.z;
				outDatas.w = firstFrameDatas.w;
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
			_nodes = null;
			_nodesMap = null;
		}
	}
}

