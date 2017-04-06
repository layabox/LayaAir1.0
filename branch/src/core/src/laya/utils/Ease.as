package laya.utils {
	
	/**
	 * <code>Ease</code> 类定义了缓动函数，以便实现 <code>Tween</code> 动画的缓动效果。
	 */
	public class Ease {
		/**@private */
		private static const HALF_PI:Number =/*[STATIC SAFE]*/ Math.PI * 0.5;
		/**@private */
		private static const PI2:Number =  /*[STATIC SAFE]*/ Math.PI * 2;
		
		/**
		 * 定义无加速持续运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function linearNone(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
		
		/**
		 * 定义无加速持续运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function linearIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
		
		/**
		 * 定义无加速持续运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function linearInOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
		
		/**
		 * 定义无加速持续运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function linearOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * 它的运动是类似一个球落向地板又弹起后，几次逐渐减小的回弹运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function bounceIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c - bounceOut(d - t, 0, c, d) + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * 它的运动是类似一个球落向地板又弹起后，几次逐渐减小的回弹运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function bounceInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if (t < d * 0.5) return bounceIn(t * 2, 0, c, d) * .5 + b;
			else return bounceOut(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * 它的运动是类似一个球落向地板又弹起后，几次逐渐减小的回弹运动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function bounceOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d) < (1 / 2.75)) return c * (7.5625 * t * t) + b;
			else if (t < (2 / 2.75)) return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
			else if (t < (2.5 / 2.75)) return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
			else return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
		}
		
		/**
		 * 开始时往后运动，然后反向朝目标移动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @param	s 指定过冲量，此处数值越大，过冲越大。
		 * @return 指定时间的插补属性的值。
		 */
		public static function backIn(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		
		/**
		 * 开始运动时是向后跟踪，再倒转方向并朝目标移动，稍微过冲目标，然后再次倒转方向，回来朝目标移动。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @param	s 指定过冲量，此处数值越大，过冲越大。
		 * @return 指定时间的插补属性的值。
		 */
		public static function backInOut(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			if ((t /= d * 0.5) < 1) return c * 0.5 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
		
		/**
		 * 开始运动时是朝目标移动，稍微过冲，再倒转方向回来朝着目标。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @param	s 指定过冲量，此处数值越大，过冲越大。
		 * @return 指定时间的插补属性的值。
		 */
		public static function backOut(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * 其中的运动由按照指数方式衰减的正弦波来定义。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @param	a 指定正弦波的幅度。
		 * @param	p 指定正弦波的周期。
		 * @return 指定时间的插补属性的值。
		 */
		public static function elasticIn(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var s:Number;
			if (t == 0) return b;
			if ((t /= d) == 1) return b + c;
			if (!p) p = d * .3;
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) {
				a = c;
				s = p / 4;
			} else s = p / PI2 * Math.asin(c / a);
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p)) + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * 其中的运动由按照指数方式衰减的正弦波来定义。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @param	a 指定正弦波的幅度。
		 * @param	p 指定正弦波的周期。
		 * @return 指定时间的插补属性的值。
		 */
		public static function elasticInOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var s:Number;
			if (t == 0) return b;
			if ((t /= d * 0.5) == 2) return b + c;
			if (!p) p = d * (.3 * 1.5);
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) {
				a = c;
				s = p / 4;
			} else s = p / PI2 * Math.asin(c / a);
			if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p)) + b;
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p) * .5 + c + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * 其中的运动由按照指数方式衰减的正弦波来定义。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @param	a 指定正弦波的幅度。
		 * @param	p 指定正弦波的周期。
		 * @return 指定时间的插补属性的值。
		 */
		public static function elasticOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var s:Number;
			if (t == 0) return b;
			if ((t /= d) == 1) return b + c;
			if (!p) p = d * .3;
			if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) {
				a = c;
				s = p / 4;
			} else s = p / PI2 * Math.asin(c / a);
			return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * PI2 / p) + c + b);
		}
		
		/**
		 * 以零速率开始运动，然后在执行时加快运动速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function strongIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * (t /= d) * t * t * t * t + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function strongInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d * 0.5) < 1) return c * 0.5 * t * t * t * t * t + b;
			return c * 0.5 * ((t -= 2) * t * t * t * t + 2) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function strongOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * Sine 缓动方程中的运动加速度小于 Quad 方程中的运动加速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function sineInOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * 0.5 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
		
		/**
		 * 以零速率开始运动，然后在执行时加快运动速度。
		 * Sine 缓动方程中的运动加速度小于 Quad 方程中的运动加速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function sineIn(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * Math.cos(t / d * HALF_PI) + c + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * Sine 缓动方程中的运动加速度小于 Quad 方程中的运动加速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function sineOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sin(t / d * HALF_PI) + b;
		}
		
		/**
		 * 以零速率开始运动，然后在执行时加快运动速度。
		 * Quint 缓动方程的运动加速大于 Quart 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quintIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * (t /= d) * t * t * t * t + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * Quint 缓动方程的运动加速大于 Quart 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quintInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d * 0.5) < 1) return c * 0.5 * t * t * t * t * t + b;
			return c * 0.5 * ((t -= 2) * t * t * t * t + 2) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * Quint 缓动方程的运动加速大于 Quart 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quintOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * Quart 缓动方程的运动加速大于 Cubic 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quartIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * (t /= d) * t * t * t + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * Quart 缓动方程的运动加速大于 Cubic 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quartInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d * 0.5) < 1) return c * 0.5 * t * t * t * t + b;
			return -c * 0.5 * ((t -= 2) * t * t * t - 2) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * Quart 缓动方程的运动加速大于 Cubic 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quartOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * Cubic 缓动方程的运动加速大于 Quad 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function cubicIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * (t /= d) * t * t + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * Cubic 缓动方程的运动加速大于 Quad 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function cubicInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d * 0.5) < 1) return c * 0.5 * t * t * t + b;
			return c * 0.5 * ((t -= 2) * t * t + 2) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * Cubic 缓动方程的运动加速大于 Quad 缓动方程。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function cubicOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * Quad 缓动方程中的运动加速度等于 100% 缓动的时间轴补间的运动加速度，并且显著小于 Cubic 缓动方程中的运动加速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quadIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c * (t /= d) * t + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * Quad 缓动方程中的运动加速度等于 100% 缓动的时间轴补间的运动加速度，并且显著小于 Cubic 缓动方程中的运动加速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quadInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d * 0.5) < 1) return c * 0.5 * t * t + b;
			return -c * 0.5 * ((--t) * (t - 2) - 1) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * Quad 缓动方程中的运动加速度等于 100% 缓动的时间轴补间的运动加速度，并且显著小于 Cubic 缓动方程中的运动加速度。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function quadOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (t /= d) * (t - 2) + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * 其中每个时间间隔是剩余距离减去一个固定比例部分。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function expoIn(t:Number, b:Number, c:Number, d:Number):Number {
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * 其中每个时间间隔是剩余距离减去一个固定比例部分。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function expoInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if (t == 0) return b;
			if (t == d) return b + c;
			if ((t /= d * 0.5) < 1) return c * 0.5 * Math.pow(2, 10 * (t - 1)) + b;
			return c * 0.5 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * 其中每个时间间隔是剩余距离减去一个固定比例部分。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function expoOut(t:Number, b:Number, c:Number, d:Number):Number {
			return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
		}
		
		/**
		 * 方法以零速率开始运动，然后在执行时加快运动速度。
		 * 缓动方程的运动加速会产生突然的速率变化。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function circIn(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}
		
		/**
		 * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
		 * 缓动方程的运动加速会产生突然的速率变化。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function circInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t /= d * 0.5) < 1) return -c * 0.5 * (Math.sqrt(1 - t * t) - 1) + b;
			return c * 0.5 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
		}
		
		/**
		 * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
		 * 缓动方程的运动加速会产生突然的速率变化。
		 * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
		 * @param	b 指定动画属性的初始值。
		 * @param	c 指定动画属性的更改总计。
		 * @param	d 指定运动的持续时间。
		 * @return 指定时间的插补属性的值。
		 */
		public static function circOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
		}
	
	}
}