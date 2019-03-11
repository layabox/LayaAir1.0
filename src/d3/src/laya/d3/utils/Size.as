package laya.d3.utils {
	import laya.d3.core.render.RenderContext3D;
	
	public class Size {
		public static function get fullScreen():Size {
			return new Size(-1, -1);
		}
		
		private var _width:int = 0;
		private var _height:int = 0;
		
		public function get width():int {
			if (_width === -1)
				return RenderContext3D.clientWidth;
			
			return _width;
		}
		
		public function get height():int {
			if (_height === -1)
				return RenderContext3D.clientHeight;
			return _height;
		}
		
		public function Size(width:int, height:int) {
			_width = width;
			_height = height;
		}
	
	}

}