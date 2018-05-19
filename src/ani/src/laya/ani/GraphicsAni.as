package laya.ani {
	import laya.display.Graphics;
	import laya.maths.Matrix;
	import laya.renders.Render;
	/**
	 * @private
	 */
	public class GraphicsAni extends Graphics {
		
		public function GraphicsAni() {
			super();
			if (Render.isConchNode)
			{
				this["drawSkin"] = function(skin:*):void
				{
					skin.transform || (skin.transform = Matrix.EMPTY);
					__JS__("this._addCmd([skin])");
					this.setSkinMesh&&this.setSkinMesh( skin._ps, skin.mVBData, skin.mEleNum, 0, skin.mTexture,skin.transform );
				};
			}
		}
		
		/**
		 * @private
		 * 画自定义蒙皮动画
		 * @param	skin
		 */
		public function drawSkin(skin:*):void {
			var arr:Array = [skin];
			_saveToCmd(Render._context._drawSkin, arr);
		}
		
		
		private static var _caches:Array = [];
		public static function create():GraphicsAni
		{
			var rs:GraphicsAni = _caches.pop();
			return  rs||new GraphicsAni();
		}
		
		public static function recycle(graphics:GraphicsAni):void
		{
			graphics.clear();
			_caches.push(graphics);
		}
	
	}

}