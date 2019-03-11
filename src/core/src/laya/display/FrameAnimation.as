package laya.display {
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
	 * 节点关键帧动画播放类。解析播放IDE内制作的节点动画。
	 */
	public class FrameAnimation extends AnimationBase {
		
		/**@private */
		private static var _sortIndexFun:Function;
		
		/**@private id对象表*/
		public var _targetDic:Object;
		/**@private 动画数据*/
		public var _animationData:Object;
		/**@private */
		protected var _usedFrames:Array;
		
		public function FrameAnimation() {
			if (_sortIndexFun === null) {
				_sortIndexFun = MathUtil.sortByKey("index", false, true);
			}
		}
		
		/**
		 * @private
		 * 初始化动画数据
		 * @param targetDic 节点ID索引
		 * @param animationData 动画数据
		 */
		public function _setUp(targetDic:Object, animationData:Object):void {
			this._targetDic = targetDic;
			this._animationData = animationData;
			interval = 1000 / animationData.frameRate;
			if (animationData.parsed) {
				this._count = animationData.count;
				this._labels = animationData.labels;
				this._usedFrames = animationData.animationNewFrames;
			} else {
				_usedFrames = [];
				_calculateDatas();
				
				animationData.parsed = true;
				animationData.labels = _labels;
				animationData.count = _count;
				animationData.animationNewFrames = _usedFrames;
			}
		}
		
		/**@inheritDoc */
		override public function clear():AnimationBase {
			super.clear();
			_targetDic = null;
			_animationData = null;
			return this;
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
			var funkeys:Array = node.funkeys;
			len = funkeys.length;
			var funFrames:Object;
			if (len == 0) return;
			for (i = 0; i < len; i++){
				key = funkeys[i];
				funFrames = frames[key];
				if (funFrames[frame] !== undefined)
				{
					target[key]&&target[key].apply(target, funFrames[frame]);
				}
			}
		
		}
		
		/**
		 * @private
		 * 计算帧数据
		 */
		private function _calculateDatas():void {
			if (!_animationData) return;
			var nodes:Array = _animationData.nodes, i:int, len:int = nodes.length, tNode:Object;
			_count = 0;
			for (i = 0; i < len; i++) {
				tNode = nodes[i];
				_calculateKeyFrames(tNode);
			}
			_count += 1;
		}
		
		/**
		 * @private
		 * 计算某个节点的帧数据
		 */
		protected function _calculateKeyFrames(node:Object):void {
			var keyFrames:Object = node.keyframes, key:String, tKeyFrames:Array, target:int = node.target;
			if (!node.frames) node.frames = {};
			if (!node.keys) node.keys = [];
			else node.keys.length = 0;
			
			if (!node.funkeys) node.funkeys = [];
			else node.funkeys.length = 0;
			
			if (!node.initValues) node.initValues = {};
			for (key in keyFrames) {
				var isFun:Boolean = key.indexOf("()") !=-1;
				tKeyFrames = keyFrames[key];
				if (isFun) key = key.substr(0, key.length - 2);
				if (!node.frames[key]) {
					node.frames[key] = [];
				}
				if (!isFun)
				{
					if (_targetDic && _targetDic[target]) {
						node.initValues[key] = _targetDic[target][key];
					}
					
					tKeyFrames.sort(_sortIndexFun);
					node.keys.push(key);
					_calculateNodePropFrames(tKeyFrames, node.frames[key], key, target);
				}
				else{
					node.funkeys.push(key);
					var map:Array = node.frames[key];
					for (var i:int = 0; i < tKeyFrames.length; i++){
						var temp:Object = tKeyFrames[i];
						map[temp.index] = temp.value;
						if (temp.index > _count) _count = temp.index;
					}
				}
		
			}
		}
		
		/**
		 * 重置节点，使节点恢复到动画之前的状态，方便其他动画控制
		 */
		public function resetNodes():void {
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
				if (_usedFrames) _usedFrames[keyframes[0].index] = true;
			}
			_dealKeyFrame(keyframes[i]);
		}
		
		/**
		 * @private
		 */
		private function _dealKeyFrame(keyFrame:Object):void {
			if (keyFrame.label && keyFrame.label != "") addLabel(keyFrame.label, keyFrame.index);
		}
		
		/**
		 * @private
		 * 计算两个关键帧直接的帧数据
		 */
		private function _calculateFrameValues(startFrame:Object, endFrame:Object, result:Array):void {
			var i:int, easeFun:Function;
			var start:int = startFrame.index, end:int = endFrame.index;
			var startValue:Number = startFrame.value;
			var dValue:Number = endFrame.value - startFrame.value;
			var dLen:int = end - start;
			var frames:Array = _usedFrames;
			if (end > _count) _count = end;
			if (startFrame.tween) {
				easeFun = Ease[startFrame.tweenMethod];
				if (easeFun == null) easeFun = Ease.linearNone;
				for (i = start; i < end; i++) {
					result[i] = easeFun(i - start, startValue, dValue, dLen);
					if (frames) frames[i] = true;
				}
			} else {
				for (i = start; i < end; i++) {
					result[i] = startValue;
				}
			}
			if (frames) {
				frames[startFrame.index] = true;
				frames[endFrame.index] = true;
			}
			result[endFrame.index] = endFrame.value;
		}
	}
}