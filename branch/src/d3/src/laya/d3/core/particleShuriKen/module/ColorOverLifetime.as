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
			var destColor:GradientColor;
			switch (_color.type) {
			case 0: 
				destColor = GradientColor.createByConstant(_color.constant.clone());
				break;
			case 1: 
				destColor = GradientColor.createByGradient(_color.gradient.clone());
				break;
			case 2: 
				destColor = GradientColor.createByRandomTwoConstant(_color.constantMin.clone(), _color.constantMax.clone());
				break;
			case 3: 
				destColor = GradientColor.createByRandomTwoGradient(_color.gradientMin.clone(), _color.gradientMax.clone());
				break;
			}
			
			var destColorOverLifetime:ColorOverLifetime = __JS__("new this.constructor(destColor)");
			destColorOverLifetime.enbale = enbale;
			return destColorOverLifetime;
		}
	
	}

}