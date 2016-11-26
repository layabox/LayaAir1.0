package laya.d3.core.particleShuriKen.module {
	
	/**
	 * <code>ColorOverLifetime</code> 类用于粒子的生命周期颜色。
	 */
	public class ColorOverLifetime {
		/**@private */
		private var _color:GradientColor;
		
		/**是否启用。*/
		public var enbale:Boolean;
		
		/**
		 *获取颜色。
		 */
		public function get color():GradientColor {
			return _color;
		}
		
		/**
		 * 创建一个 <code>ColorOverLifetime</code> 实例。
		 */
		public function ColorOverLifetime(color:GradientColor) {
			_color = color;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destColorOverLifetime:ColorOverLifetime = destObject as ColorOverLifetime;
			_color.cloneTo(destColorOverLifetime._color);
			destColorOverLifetime.enbale = enbale;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destColorOverLifetime:ColorOverLifetime = __JS__("new this.constructor()");
			cloneTo(destColorOverLifetime);
			return destColorOverLifetime;
		}
	
	}

}