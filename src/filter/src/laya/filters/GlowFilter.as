package laya.filters {
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.utils.ColorUtils;
	import laya.utils.RunDriver;
	
	/**
	 *  发光滤镜(也可以当成阴影滤使用）
	 */
	public class GlowFilter extends Filter {
		
		/**数据的存储，顺序R,G,B,A,blurWidth,offX,offY;*/
		private var _elements:Float32Array = new Float32Array(9);
		public var _sv_blurInfo1:Array = new Array(4);	//给shader用
		public var _sv_blurInfo2:Array = [0,0,1,0];
		/**滤镜的颜色*/
		private var _color:ColorUtils;
		
		public var _color_native:Float32Array;
		public var _blurInof1_native:Float32Array;
		public var _blurInof2_native:Float32Array;
		
		/**
		 * 创建发光滤镜
		 * @param	color	滤镜的颜色
		 * @param	blur	边缘模糊的大小
		 * @param	offX	X轴方向的偏移
		 * @param	offY	Y轴方向的偏移
		 */
		public function GlowFilter(color:String, blur:Number = 4, offX:Number = 6, offY:Number = 6) {
			this._color = new ColorUtils(color);
			//限制最大效果为20
			this.blur = Math.min(blur, 20);
			this.offX = offX;
			this.offY = offY;
			//_action.data = this;
			_sv_blurInfo1[0] = _sv_blurInfo1[1] = this.blur; _sv_blurInfo1[2] = offX; _sv_blurInfo1[3] =-offY;
			_glRender = new GlowFilterGLRender();
		}
		
		/**
		 * @private
		 * 滤镜类型
		 */
		override public function get type():int {
			return GLOW;
		}
		
		/**@private */
		public function get offY():Number {
			return _elements[6];
		}
		
		/**@private */
		public function set offY(value:Number):void {
			_elements[6] = value;
			_sv_blurInfo1[3] =-value;
		}
		
		/**@private */
		public function get offX():Number {
			return _elements[5];
		}
		
		/**@private */
		public function set offX(value:Number):void {
			_elements[5] = value;
			_sv_blurInfo1[2] =value;
		}
		
		/**@private */
		public function getColor():Array {
			return _color.arrColor;
		}
		
		/**@private */
		public function get blur():Number {
			return _elements[4];
		}
		
		/**@private */
		public function set blur(value:Number):void {
			_elements[4] = value;
			_sv_blurInfo1[0] = _sv_blurInfo1[1] = value;
		}
		
		public function getColorNative():Float32Array
		{
			if (!_color_native)
			{
				_color_native = new Float32Array(4);
			}
			//TODO James 不用每次赋值
			var color:Array = getColor();
			_color_native[0] = color[0];
			_color_native[1] = color[1];
			_color_native[2] = color[2];
			_color_native[3] = color[3];
			return _color_native;
		}
		public function getBlurInfo1Native():Float32Array
		{
			if (!_blurInof1_native)
			{
				_blurInof1_native = new Float32Array(4);
			}
			//TODO James 不用每次赋值
			_blurInof1_native[0] = _blurInof1_native[1] = blur;
			_blurInof1_native[2] = offX;
			_blurInof1_native[3] = offY;
			return _blurInof1_native;
		}
		public function getBlurInfo2Native():Float32Array
		{
			if (!_blurInof2_native)
			{
				_blurInof2_native = new Float32Array(4);
			}
			//TODO James 不用每次赋值
			_blurInof2_native[2] = 1;
			return _blurInof2_native;
		}
	}
}