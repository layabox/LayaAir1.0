package laya.effect {
	import laya.components.Component;
	import laya.display.Sprite;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	/**
	 * 效果插件基类，基于对象池管理
	 */
	public class EffectBase extends Component {
		/**动画持续时间，单位为毫秒*/
		public var duration:int = 1000;
		/**动画延迟时间，单位为毫秒*/
		public var delay:int = 0;
		/**重复次数，默认为播放一次*/
		public var repeat:int = 0;
		/**缓动类型，如果为空，则默认为匀速播放*/
		public var ease:String;
		/**触发事件，如果为空，则创建时触发*/
		public var eventName:String;
		/**效用作用的目标对象，如果为空，则是脚本所在的节点本身*/
		public var target:Sprite;
		/**效果结束后，是否自动移除节点*/
		public var autoDestroyAtComplete:Boolean = true;
		
		protected var _comlete:Handler;
		protected var _tween:Tween;
		
		override protected function _onAwake():void {
			target ||= owner as Sprite;
			if (autoDestroyAtComplete) _comlete = Handler.create(target, target.destroy, null, false);
			if (eventName) owner.on(eventName, this, _exeTween);
			else _exeTween();
		}
		
		protected function _exeTween():void {
			_tween = _doTween();			
			_tween.repeat = repeat;
		}
		
		protected function _doTween():Tween {
			return null;
		}
		
		override public function onReset():void {
			duration = 1000;
			delay = 0;
			repeat = 0;
			ease = null;
			target = null;
			if (eventName) {
				owner.off(eventName, this, _exeTween);
				eventName = null;
			}
			if (_comlete) {
				_comlete.recover();
				_comlete = null;
			}
			if (_tween) {
				_tween.clear();
				_tween = null;
			}
		}
	}
}