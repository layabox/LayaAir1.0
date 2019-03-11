package laya.effect 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	/**
	 * @Script {name:ButtonEffect}
	 * @author ww
	 */
	public class ButtonEffect 
	{
		
		private var _tar:Sprite;
		private var _curState:int = 0;
		private var _curTween:Tween;
		/**
		 * effectScale
		 * @prop {name:effectScale,type:number, tips:"缩放值",default:"1.5"}
		 */
		public var effectScale:Number = 1.5;
		/**
		 * tweenTime
		 * @prop {name:tweenTime,type:number, tips:"缓动时长",default:"300"}
		 */
		public var tweenTime:Number = 300;
		/**
		 * effectEase
		 * @prop {name:effectEase,type:ease, tips:"效果缓动类型"}
		 */
		public var effectEase:String;
		/**
		 * backEase
		 * @prop {name:backEase,type:ease, tips:"恢复缓动类型"}
		 */
		public var backEase:String;
		
		/**
		 * 设置控制对象 
		 * @param tar
		 */		
		public function set target(tar:Sprite):void
		{
			_tar = tar;
			tar.on(Event.MOUSE_DOWN, this, toChangedState);
			tar.on(Event.MOUSE_UP, this, toInitState);
			tar.on(Event.MOUSE_OUT, this, toInitState);
		}
		
		private function toChangedState():void
		{
			_curState = 1;
			if (_curTween) Tween.clear(_curTween);
			_curTween=Tween.to(_tar, {scaleX:effectScale,scaleY:effectScale }, tweenTime, Ease[effectEase], Handler.create(this, tweenComplete));
		}
		
		private function toInitState():void
		{
			if (_curState == 2) return;
			if (_curTween) Tween.clear(_curTween);
			_curState = 2;
			_curTween=Tween.to(_tar, {scaleX:1,scaleY:1 }, tweenTime, Ease[backEase], Handler.create(this, tweenComplete));
		}
		private function tweenComplete():void
		{
			_curState = 0;
			_curTween = null;
		}
	}

}