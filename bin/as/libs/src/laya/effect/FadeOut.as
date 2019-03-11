package laya.effect {
	import laya.utils.Ease;
	import laya.utils.Tween;
	
	/**
	 * 淡出效果
	 */
	public class FadeOut extends EffectBase {		
		override protected function _doTween():Tween {
			target.alpha = 1;
			return Tween.to(target, {alpha: 0}, duration, Ease[ease], _comlete, delay);
		}
	}
}