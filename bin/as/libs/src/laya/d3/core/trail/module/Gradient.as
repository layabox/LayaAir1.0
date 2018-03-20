package laya.d3.core.trail.module {
	
	public class Gradient {
		
		/**
		 * 梯度模式
		 */
		private var _mode:int;
		
		/**
		 * 颜色值关键帧数据,最大长度为10
		 */
		private var _colorKeys:Vector.<GradientColorKey>;
		
		/**
		 * 透明度关键帧数据,最大长度为10
		 */
		private var _alphaKeys:Vector.<GradientAlphaKey>;
		
		public var _colorKeyData:Float32Array = new Float32Array(40);
		
		public var _alphaKeyData:Float32Array = new Float32Array(20);
		
		private var index:int = 0;
		
		/**
		 * 获取梯度模式。
		 * @return  梯度模式。
		 */
		public function get mode():int {
			return _mode;
		}
		
		/**
		 * 设置梯度模式。
		 * @param value 梯度模式。
		 */
		public function set mode(value:int):void {
			_mode = value;
		}
		
		/**
		 * 获取颜色值关键帧数据
		 */
		public function get colorKeys():Vector.<GradientColorKey>{
			return _colorKeys;
		}
		
		/**
		 * 设置颜色值关键帧数据
		 */
		public function set colorKeys(values:Vector.<GradientColorKey>):void{
			_colorKeys = values;
			index = 0;
			for (var i:int = 0; i < values.length; i++ ){
				var value:GradientColorKey = values[i];
				var color:Color = value.color;
				_colorKeyData[index ++] = color.r;
				_colorKeyData[index ++] = color.g;
				_colorKeyData[index ++] = color.b;
				_colorKeyData[index ++] = value.time;
			}
		}
		
		/**
		 * 获取透明度关键帧数据
		 */
		public function get alphaKeys():Vector.<GradientAlphaKey>{
			return _alphaKeys;
		}
		
		/**
		 * 设置透明度关键帧数据
		 */
		public function set alphaKeys(values:Vector.<GradientAlphaKey>):void{
			_alphaKeys = values;
			index = 0;
			for (var i:int = 0; i < values.length; i++ ){
				var value:GradientAlphaKey = values[i];
				_alphaKeyData[index ++] = value.alpha;
				_alphaKeyData[index ++] = value.time;
			}
		}
		
		public function Gradient() {
			_colorKeys = new Vector.<GradientColorKey>();
			_alphaKeys = new Vector.<GradientAlphaKey>(); 
		}
		
		/**
		 * 设置渐变，使用一组颜色关键帧数据和透明度关键帧数据。
		 * @param	colorKeys 渐变的颜色值关键帧数据(最大长度为10)。
		 * @param	alphaKeys 渐变的透明度关键帧数据(最大长度为10)。
		 */
		public function setKeys(colorKeys:Vector.<GradientColorKey>, alphaKeys:Vector.<GradientAlphaKey>):void {
			
			_colorKeys = colorKeys;
			index = 0;
			var gradientColorKey:GradientColorKey;
			for (var i:int = 0; i < colorKeys.length; i++ ){
				gradientColorKey = colorKeys[i];
				var color:Color = gradientColorKey.color;
				_colorKeyData[index ++] = color.r;
				_colorKeyData[index ++] = color.g;
				_colorKeyData[index ++] = color.b;
				_colorKeyData[index ++] = gradientColorKey.time;
			}
			
			_alphaKeys = alphaKeys;
			index = 0;
			var gradientAlphaKey:GradientAlphaKey;
			for (var j:int = 0; j < alphaKeys.length; j++ ){
				gradientAlphaKey = alphaKeys[j];
				_alphaKeyData[index ++] = gradientAlphaKey.alpha;
				_alphaKeyData[index ++] = gradientAlphaKey.time;
			}
		}
		
	}
}