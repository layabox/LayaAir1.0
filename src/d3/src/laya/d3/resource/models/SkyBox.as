package laya.d3.resource.models {
	import laya.resource.Texture;
	
	/**
	 * <code>Sky</code> 类用于创建天空盒。
	 */
	public class SkyBox extends Sky {
		/** @private */
		private static var _nameNumber:int = 1;
		
		/**  @private 透明混合度。 */
		private var _alphaBlending:Number = 1.0;
		
		/** @private 颜色强度。 */
		private var _colorIntensity:Number = 1.0;
		
		/** @private 天空立方体贴图。 */
		public var TextureCube:Texture;
		
		/**
		 * 获取透明混合度。
		 * @return 透明混合度。
		 */
		public function get alphaBlending():void {
			return _alphaBlending;
		}
		
		/**
		 * 设置透明混合度。
		 * @param value 透明混合度。
		 */
		public function set alphaBlending(value:Number):void {
			_alphaBlending = value;
			if (_alphaBlending < 0)
				_alphaBlending = 0;
			if (_alphaBlending > 1)
				_alphaBlending = 1;
		}
		
		/**
		 * 获取颜色强度。
		 * @return 颜色强度。
		 */
		public function get colorIntensity():void {
			return _colorIntensity;
		}
		
		/**
		 * 设置颜色强度。
		 * @param value 颜色强度。
		 */
		public function set colorIntensity(value:Number):void {
			_colorIntensity = value;
			if (_colorIntensity < 0)
				_colorIntensity = 0;
		}
		
		/**
		 * 创建一个 <code>SkyBox</code> 实例。
		 */
		public function SkyBox() {
			name = "Skybox-" + _nameNumber;
			_nameNumber++;
		}
	
	}

}