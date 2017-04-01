package laya.ui {
	import laya.display.FrameAnimation;
	import laya.events.Event;
	import laya.utils.ClassUtils;
	import laya.utils.Ease;
	
	/**
	 * ...
	 * @author ww
	 */
	public class EffectAnimation extends FrameAnimation {
		public static const EffectAnimationBegin:String = "effectanimationbegin";
		
		public function EffectAnimation() {
		
		}
		
		public function set owner(v:*):void {
			target = v;
		}
		private var _target:*;
		
		public function set target(v:*):void {
			if (_target) {
				_target.off(EffectAnimationBegin, this, _onOtherBegin);
			}
			_target = v;
			if (_target) {
				_target.on(EffectAnimationBegin, this, _onOtherBegin);
			}
			addEvent();
		}
		
		private function _onOtherBegin(effect:*):void {
			if (effect == this)
				return;
			this.stop();
		}
		
		public function get target():* {
			return _target;
		}
		private var _playEvents:String;
		
		public function set playEvent(event:String):void {
			_playEvents = event;
			if (!event)
				return;
			addEvent();
		}
		
		private function addEvent():void {
			if (!_target || !_playEvents)
				return;
			_setControlNode(_target);
			_target.on(_playEvents, this, _onPlayAction);
		}
		
		private function _onPlayAction():void {
			if (!_target)
				return;
			_target.event(EffectAnimationBegin, [this]);
			_recordInitData();
			play(0, false);
		}
		private var _initData:Object = {};
		private var _aniKeys:Array;
		
		private function _recordInitData():void {
			if (!_aniKeys)
				return;
			var i:int, len:int;
			len = _aniKeys.length;
			var key:String;
			for (i = 0; i < len; i++) {
				key = _aniKeys[i];
				_initData[key] = _target[key];
			}
		}
		private var _effectClass:Class;
		
		public function set effectClass(classStr:String):void {
			_effectClass = ClassUtils.getClass(classStr);
			if (_effectClass) {
				var uiData:Object;
				uiData = _effectClass["uiView"];
				if (uiData) {
					var aniData:Array;
					aniData = uiData["animations"];
					if (aniData && aniData[0]) {
						_setUp({}, aniData[0]);
						if (aniData[0].nodes && aniData[0].nodes[0]) {
							_aniKeys = aniData[0].nodes[0].keys;
						}
					}
				}
			}
		}
		
		override protected function _displayToIndex(value:int):void {
			if (!_animationData)
				return;
			if (value < 0)
				value = 0;
			if (value > _count)
				value = _count;
			var nodes:Array = _animationData.nodes, i:int, len:int = nodes.length;
			len = len > 1 ? 1 : len;
			for (i = 0; i < len; i++) {
				_displayNodeToFrame(nodes[i], value);
			}
		}
		
		override protected function _displayNodeToFrame(node:Object, frame:int, targetDic:Object = null):void {
			if (!_target)
				return;
			var target:*;
			target = _target;
			var frames:Object = node.frames, key:String, propFrames:Array, value:*;
			var keys:Array = node.keys, i:int, len:int = keys.length;
			var secondFrames:Object;
			secondFrames = node.secondFrames;
			var tSecondFrame:int;
			var easeFun:Function;
			var tKeyFrames:Array;
			var startFrame:Object;
			var endFrame:Object;
			for (i = 0; i < len; i++) {
				key = keys[i];
				propFrames = frames[key];
				tSecondFrame = secondFrames[key];
				if (tSecondFrame == -1) {
					value = _initData[key];
				}
				else {
					if (frame < tSecondFrame) {
						tKeyFrames = node.keyframes[key];
						startFrame = tKeyFrames[0];
						if (startFrame.tween) {
							easeFun = Ease[startFrame.tweenMethod];
							if (easeFun == null) {
								easeFun = Ease.linearNone;
							}
							endFrame = tKeyFrames[1];
							value= easeFun(frame, _initData[key], endFrame.value-_initData[key], endFrame.index);
						}
						else {
							value = _initData[key];
						}
						
					}
					else {
						if (propFrames.length > frame) {
							value = propFrames[frame];
						}
						else {
							value = propFrames[propFrames.length - 1];
						}
					}
				}
				
				target[key] = value;
			}
		}
		
		override protected function _calculateNodeKeyFrames(node:Object):void {
			super._calculateNodeKeyFrames(node);
			var keyFrames:Object = node.keyframes, key:String, tKeyFrames:Array, target:int = node.target;
			
			var secondFrames:Object;
			secondFrames = {};
			node.secondFrames = secondFrames;
			for (key in keyFrames) {
				tKeyFrames = keyFrames[key];
				if (tKeyFrames.length <= 1) {
					secondFrames[key] = -1;
				}
				else {
					secondFrames[key] = tKeyFrames[1].index;
				}
			}
		}
	}

}