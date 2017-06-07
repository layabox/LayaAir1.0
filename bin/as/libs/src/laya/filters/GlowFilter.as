package laya.filters {
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.utils.Color;
	import laya.utils.RunDriver;
	
	/**
	 *  发光滤镜(也可以当成阴影滤使用）
	 */
	public class GlowFilter extends Filter {
		
		/**数据的存储，顺序R,G,B,A,blurWidth,offX,offY;*/
		private var _elements:Float32Array = new Float32Array(9);
		/**滤镜的颜色*/
		private var _color:Color;
		
		/**
		 * 创建发光滤镜
		 * @param	color	滤镜的颜色
		 * @param	blur	边缘模糊的大小
		 * @param	offX	X轴方向的偏移
		 * @param	offY	Y轴方向的偏移
		 */
		public function GlowFilter(color:String, blur:Number = 4, offX:Number = 6, offY:Number = 6) {
			if (Render.isWebGL) {
				WebGLFilter.enable();
			}
			this._color = new Color(color);
			//限制最大效果为20
			this.blur = Math.min(blur, 20);
			this.offX = offX;
			this.offY = offY;
			_action = RunDriver.createFilterAction(GLOW);
			_action.data = this;
		}
		
		/**
		 * @private
		 * 滤镜类型
		 */
		override public function get type():int {
			return GLOW;
		}
		
		/**@private */
		override public function get action():IFilterAction {
			return _action;
		}
		
		/**@private */
		public function get offY():Number {
			return _elements[6];
		}
		
		/**@private */
		public function set offY(value:Number):void {
			_elements[6] = value;
		}
		
		/**@private */
		public function get offX():Number {
			return _elements[5];
		}
		
		/**@private */
		public function set offX(value:Number):void {
			_elements[5] = value;
		}
		
		/**@private */
		public function getColor():Array {
			return _color._color;
		}
		
		/**@private */
		public function get blur():Number {
			return _elements[4];
		}
		
		/**@private */
		public function set blur(value:Number):void {
			_elements[4] = value;
		}
		/**
		 * @private 通知微端
		 */
		public override function callNative(sp:Sprite):void
		{
			sp.conchModel &&sp.conchModel.glowFilter&&sp.conchModel.glowFilter(_color.strColor, _elements[4], _elements[5], _elements[6]);
		}
	
	}
}