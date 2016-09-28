package laya.webgl.shader.d2.skinAnishader {
	
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.CONST3D2D;
	public class aniShaderValue extends Value2D {
		public var texcoord:*;
		private static var _aniShaderValue:aniShaderValue;
		
		public function aniShaderValue() {
			super(0, 0);
			var _vlen:int = 8 * CONST3D2D.BYTES_PE;
			this.position = [2, WebGLContext.FLOAT, false, _vlen, 0];
			this.texcoord = [2, WebGLContext.FLOAT, false, _vlen, 2 * CONST3D2D.BYTES_PE];
			this.color = [4, WebGLContext.FLOAT, false, _vlen, 4 * CONST3D2D.BYTES_PE];
		}
		
		public static function instance():aniShaderValue {
			return _aniShaderValue ||= new aniShaderValue();
		}
	
	}

}