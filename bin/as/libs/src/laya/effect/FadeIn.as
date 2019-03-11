package laya.effect {
	import laya.utils.Ease;
	import laya.utils.Tween;
	
	/**
	 * 淡入效果
	 */
	public class FadeIn extends EffectBase {
		override protected function _doTween():Tween {
			target.alpha = 0;
			return Tween.to(target, {alpha: 1}, duration, Ease[ease], _comlete, delay);
		}
	}
}