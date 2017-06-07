package laya.d3.animation {
	import laya.ani.math.BezierLerp;
	import laya.d3.animation.AnimationParser01;
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.resource.Resource;
	import laya.utils.Byte;
	
	/**
	 * <code>AnimationTemplet</code> 类用于动画模板资源。
	 */
	public class AnimationClip extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var interpolation:Array = /*[STATIC SAFE]*/ [_LinearInterpolation_0, _QuaternionInterpolation_1];
		
		/**
		 * @private
		 */
		private static function _LinearInterpolation_0(bone:AnimationNode, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			out[outOfs] = data[index] + dt * dData[index];
			return 1;
		}
		
		/**
		 * @private
		 */
		private static function _QuaternionInterpolation_1(bone:*, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			var amount:Number = duration === 0 ? 0 : dt / duration;
			MathUtil.slerpQuaternionArray(data, index, nextData, index, amount, out, outOfs);//(dt/duration)为amount比例
			return 4;
		}
		
		/**
		 * 加载动画模板。
		 * @param url 动画模板地址。
		 */
		public static function load(url:String):AnimationClip {
			return Laya.loader.create(url, null, null, AnimationClip);
		}
		
		/**@private */
		public var _aniVersion:String;
		/**@private */
		public var _nodes:Vector.<AnimationNode>;
		/**@private */
		public var _duration:Number;
		/**@private */
		public var _frameRate:int;
		/**@private */
		public var _publicExtData:ArrayBuffer;//公共扩展数据
		/**@private */
		public var _useParent:Boolean;//是否采用对象树数据格式
		/**@private */
		protected var unfixedCurrentFrameIndexes:Uint32Array;
		/**@private */
		protected var unfixedCurrentTimes:Float32Array;
		/**@private */
		protected var unfixedKeyframes:Vector.<Keyframe>;
		/**@private */
		public var _aniClassName:String;
		/**@private */
		public var _animationDatasCache:Array;
		
		public function AnimationClip() {
			_animationDatasCache = [];
		}
		
		/**
		 * @private
		 */
		private function _hermiteInterpolate(t:Number, p0:Float32Array, m0:Number, m1:Number, p1:Float32Array, out:Float32Array):void {
			var t2:Number = t * t;
			var t3:Number = t2 * t;
			var a:Number = 2.0 * t3 - 3.0 * t2 + 1.0;
			var b:Number = t3 - 2.0 * t2 + t;
			var c:Number = t3 - t2;
			var d:Number = -2.0 * t3 + 3.0 * t2;
			
			var e:Number = b * m0 + c * m1;
			for (var i:int = 0, n:int = out.length; i < n; i++)
				out[i] = a * p0[i] + e + d * p1[i];
		}
		
		/**
		 * @private
		 */
		public function _getAnimationDataWithCache(cacheRate:Number, frameIndex:int):Vector.<Float32Array> {
			var keyDatas:Array = _animationDatasCache[cacheRate];
			if (!keyDatas)
				return null;
			else {
				return keyDatas[frameIndex];
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
		public function _evaluateAnimationlDatas(nodesFrameIndices:Array, frameIndex:int, playCurTime:Number, outAnimationDatas:Vector.<Float32Array>):void {
			var nodes:Vector.<AnimationNode> = _nodes;
			
			for (var i:int = 0, n:int = nodes.length; i < n; i++) {
				var frame:Keyframe = nodes[i].keyFrames[nodesFrameIndices[i][frameIndex]];
				
				var t:Number, m1:Number, m2:Number;
				var d:Number = frame.duration;
				var nextKeyFrame:Keyframe = frame.next;
				if (d !== 0) {
					t = (playCurTime - frame.startTime) / d;
					m1 = frame.outTangent * d;
					m2 = nextKeyFrame.inTangent * d;
				} else {
					t = m1 = m2 = 0;
				}
				_hermiteInterpolate(t, frame.data, m1, m2, nextKeyFrame.data, outAnimationDatas[i]);
			}
		}
		
		public function _evaluateAnimationlDatasUnfixedRate(playCurTime:Number, outAnimationDatas:Vector.<Float32Array>):void {
			var nodes:Vector.<AnimationNode> = _nodes;
			
			if (!unfixedCurrentFrameIndexes) {//TODO:移到属性触发中
				unfixedCurrentFrameIndexes = new Uint32Array(nodes.length);
				unfixedCurrentTimes = new Float32Array(nodes.length);
				unfixedKeyframes = new Vector.<Keyframe>(nodes.length);
			}
			
			var j:int = 0;
			for (var i:int = 0, n:int = nodes.length; i < n; i++) {
				var node:AnimationNode = nodes[i];
				
				if (playCurTime < unfixedCurrentTimes[i])
					unfixedCurrentFrameIndexes[i] = 0;
				
				unfixedCurrentTimes[i] = playCurTime;
				
				while (unfixedCurrentFrameIndexes[i] < node.keyFrames.length) {
					if (node.keyFrames[unfixedCurrentFrameIndexes[i]].startTime > unfixedCurrentTimes[i])
						break;
					
					unfixedKeyframes[i] = node.keyFrames[unfixedCurrentFrameIndexes[i]];
					unfixedCurrentFrameIndexes[i]++;
				}
				
				var frame:Keyframe = unfixedKeyframes[i];
				
				var t:Number, m1:Number, m2:Number;
				var d:Number = frame.duration;
				var nextKeyFrame:Keyframe = frame.next;
				if (d !== 0) {
					t = (playCurTime - frame.startTime) / d;
					m1 = frame.outTangent * d;
					m2 = nextKeyFrame.inTangent * d;
				} else {
					t = m1 = m2 = 0;
				}
				_hermiteInterpolate(t, frame.data, m1, m2, nextKeyFrame.data, outAnimationDatas[i]);
			}
		}
		
		/**
		 * @private
		 */
		public function _endLoaded():void {
			_loaded = true;
			event(Event.LOADED, this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var reader:Byte = new Byte(data);
			_aniVersion = reader.readUTFString();
			switch (_aniVersion) {
			case "LAYAANIMATION:01": 
				AnimationParser01.parse(this, reader);
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

