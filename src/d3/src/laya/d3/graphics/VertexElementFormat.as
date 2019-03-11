package laya.d3.graphics {
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VertexElementFormat {
		public static const Single:String = "single";
		public static const Vector2:String = "vector2";
		public static const Vector3:String = "vector3";
		public static const Vector4:String = "vector4";
		public static const Color:String = "color";
		public static const Byte4:String = "byte4";
		public static const Short2:String = "short2";
		public static const Short4:String = "short4";
		public static const NormalizedShort2:String = "normalizedshort2";
		public static const NormalizedShort4:String = "normalizedshort4";
		public static const HalfVector2:String = "halfvector2";
		public static const HalfVector4:String = "halfvector4";
		

		/** @private [组数量,数据类型,是否归一化:0为false]。*/
		private static const _elementInfos:Object = {
			"single":[1,WebGLContext.FLOAT,0],
			"vector2":[2,WebGLContext.FLOAT,0],
			"vector3":[3,WebGLContext.FLOAT,0],
			"vector4":[4,WebGLContext.FLOAT,0],
			"color":[4,WebGLContext.FLOAT,0],
			"byte4":[4,WebGLContext.UNSIGNED_BYTE,0],
			"short2":[2,WebGLContext.FLOAT,0],
			"short4":[4,WebGLContext.FLOAT,0],
			"normalizedshort2":[2,WebGLContext.FLOAT,0],
			"normalizedshort4":[4,WebGLContext.FLOAT,0],
			"halfvector2":[2,WebGLContext.FLOAT,0],
			"halfvector4":[4,WebGLContext.FLOAT,0]
		};
		
		/**
		 * 获取顶点元素格式信息。
		 */
		public static function getElementInfos(element:String):Array {
			var info:Array = _elementInfos[element];
			if (info)
				return info;
			else
				throw "VertexElementFormat: this vertexElementFormat is not implement.";
		}
	}
}