package laya.display {
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.utils.Ease;
	
	/**
	 * 动画播放完毕后调度。
	 * @eventType Event.COMPLETE
	 */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 播放到某标签后调度。
	 * @eventType Event.LABEL
	 */
	[Event(name = "label", type = "laya.events.Event")]
	/**
	 * 关键帧动画播放类。
	 */
	public class FrameAnimation extends AnimationPlayerBase {
		public function FrameAnimation() {
			if (_sortIndexFun == null) {
				_sortIndexFun = MathUtil.sortByKey("index", false, true);
			}
		}
		/**@private */
		private static var _sortIndexFun:Function;
		/**
		 * @private
		 * id对象表
		 */
		public var _targetDic:Object;
		/**
		 * @private
		 * 动画数据
		 */
		public var _animationData:Object;
		/**@private */
		protected var _animationNewFrames:Array;
		
		/**
		 * @private
		 * 初始化动画数据
		 * @param targetDic 对象表
		 * @param animationData 动画数据
		 *
		 */
		public function _setUp(targetDic:Object, animationData:Object):void {
			_labels = null;
			_animationNewFrames = null;
			this._targetDic = targetDic;
			this._animationData = animationData;
			interval = 1000 / animationData.frameRate;
			if (animationData.parsed) {
				this._count = animationData.count;
				this._labels = animationData.labels;
				this._animationNewFrames = animationData.animationNewFrames;
			} else {
				_animationNewFrames = [];
				_calculateDatas();
			}
			animationData.parsed = true;
			animationData.labels = _labels;
			animationData.count = _count;
			animationData.animationNewFrames = _animationNewFrames;
		}
		
		/**@inheritDoc */
		override public function clear():void {
			super.clear();
			_targetDic = null;
			_animationData = null;
		}
		
		/**@inheritDoc */
		override protected function _displayToIndex(value:int):void {
			if (!_animationData) return;
			if (value < 0) value = 0;
			if (value > _count) value = _count;
			var nodes:Array = _animationData.nodes, i:int, len:int = nodes.length;
			for (i = 0; i < len; i++) {
				_displayNodeToFrame(nodes[i], value);
			}
		}
		
		/**
		 * @private
		 * 将节点设置到某一帧的状态
		 * @param node 节点ID
		 * @param frame
		 * @param targetDic 节点表
		 *
		 */
		protected function _displayNodeToFrame(node:Object, frame:int, targetDic:Object = null):void {
			if (!targetDic) targetDic = this._targetDic;
			var target:Object = targetDic[node.target];
			if (!target) {
				//trace("loseTarget:",node.target);
				return;
			}
			var frames:Object = node.frames, key:String, propFrames:Array, value:*;
			var keys:Array = node.keys, i:int, len:int = keys.length;
			for (i = 0; i < len; i++) {
				key = keys[i];
				propFrames = frames[key];
				if (propFrames.length > frame) {
					value = propFrames[frame];
				} else {
					value = propFrames[propFrames.length - 1];
				}
				target[key] = value;
			}
		
		}
		
		/**
		 * @private
		 * 计算帧数据
		 *
		 */
		private function _calculateDatas():void {
			if (!_animationData) return;
			var nodes:Array = _animationData.nodes, i:int, len:int = nodes.length, tNode:Object;
			_count = 0;
			for (i = 0; i < len; i++) {
				tNode = nodes[i];
				_calculateNodeKeyFrames(tNode);
			}
			_count += 1;
		}
		
		/**
		 * @private
		 * 计算某个节点的帧数据
		 * @param node
		 *
		 */
		protected function _calculateNodeKeyFrames(node:Object):void {
			var keyFrames:Object = node.keyframes, key:String, tKeyFrames:Array, target:int = node.target;
			if (!node.frames) {
				node.frames = {};
			}
			if (!node.keys) {
				node.keys = [];
			} else {
				node.keys.length = 0;
			}
			if (!node.initValues) {
				node.initValues = {};
			}
			for (key in keyFrames) {
				tKeyFrames = keyFrames[key];
				if (!node.frames[key]) {
					node.frames[key] = [];
				}
				
				if (_targetDic && _targetDic[target]) {
					node.initValues[key] = _targetDic[target][key];
				}
				
				tKeyFrames.sort(_sortIndexFun);
				node.keys.push(key);
				_calculateNodePropFrames(tKeyFrames, node.frames[key], key, target);
			}
		}
		
		/**
		 * 将动画控制对象还原到动画控制之前的状态
		 */
		public function resetToInitState():void {
			if (!_targetDic) return;
			if (!_animationData) return;
			var nodes:Array = _animationData.nodes, i:int, len:int = nodes.length;
			var tNode:Object;
			var initValues:Object;
			for (i = 0; i < len; i++) {
				tNode = nodes[i];
				initValues = tNode.initValues;
				if (!initValues) continue;
				var target:Object = _targetDic[tNode.target];
				if (!target) continue;
				var key:String;
				for (key in initValues) {
					target[key] = initValues[key];
				}
				
			}
		}
		
		/**
		 * @private
		 * 计算节点某个属性的帧数据
		 * @param keyframes
		 * @param frames
		 * @param key
		 * @param target
		 *
		 */
		private function _calculateNodePropFrames(keyframes:Array, frames:Array, key:String, target:int):void {
			var i:int, len:int = keyframes.length - 1;
			frames.length = keyframes[len].index + 1;
			for (i = 0; i < len; i++) {
				_dealKeyFrame(keyframes[i]);
				_calculateFrameValues(keyframes[i], keyframes[i + 1], frames);
			}
			if (len == 0) {
				frames[0] = keyframes[0].value;
				if (_animationNewFrames)
					_animationNewFrames[keyframes[0].index] = true;
			}
			_dealKeyFrame(keyframes[i]);
		}
		
		/**
		 * @private
		 *
		 */
		private function _dealKeyFrame(keyFrame:Object):void {
			if (keyFrame.label && keyFrame.label != "") addLabel(keyFrame.label, keyFrame.index);
		}
		
		/**
		 * @private
		 * 计算两个关键帧直接的帧数据
		 * @param startFrame
		 * @param endFrame
		 * @param result
		 *
		 */
		private function _calculateFrameValues(startFrame:Object, endFrame:Object, result:Array):void {
			var i:int, easeFun:Function;
			var start:int = startFrame.index, end:int = endFrame.index;
			var startValue:Number = startFrame.value;
			var dValue:Number = endFrame.value - startFrame.value;
			var dLen:int = end - start;
			if (end > _count) _count = end;
			if (startFrame.tween) {
				easeFun = Ease[startFrame.tweenMethod];
				if (easeFun == null) {
					easeFun = Ease.linearNone;
				}
				for (i = start; i < end; i++) {
					result[i] = easeFun(i - start, startValue, dValue, dLen);
					if (_animationNewFrames) {
						_animationNewFrames[i] = true;
					}
				}
			} else {
				for (i = start; i < end; i++) {
					result[i] = startValue;
				}
			}
			if (_animationNewFrames) {
				_animationNewFrames[startFrame.index] = true;
				_animationNewFrames[endFrame.index] = true;
			}
			result[endFrame.index] = endFrame.value;
		}
	}
}