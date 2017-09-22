package laya.webgl.utils {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	
	public class RenderState2D {
		public static const _MAXSIZE:int = 99999999;
		/**@private 一个初始化的 <code>Matrix</code> 对象，不允许修改此对象内容。*/
		public static var EMPTYMAT4_ARRAY:Array =/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		public static var TEMPMAT4_ARRAY:Array =/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		public static var worldMatrix4:Array = /*[STATIC SAFE]*/ TEMPMAT4_ARRAY;
		
		public static var worldMatrix:Matrix = new Matrix();
		
		public static var worldAlpha:Number = 1.0;
		
		public static var worldScissorTest:Boolean = false;
		
		public static var worldFilters:Array;
		public static var worldShaderDefines:ShaderDefines2D;
		
		public static var worldClipRect:Rectangle = new Rectangle(0, 0, _MAXSIZE, _MAXSIZE);
		
		public static var curRenderTarget:RenderTarget2D;
		
		public static var width:Number = 0;
		public static var height:Number = 0;
		
		public static function getMatrArray():Array {
			return [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		}
		
		public static function mat2MatArray(mat:Matrix, matArray:Array):Array {
			var m:Matrix = mat;
			var m4:Array = matArray;
			m4[0] = m.a;
			m4[1] = m.b;
			m4[2] = EMPTYMAT4_ARRAY[2];
			m4[3] = EMPTYMAT4_ARRAY[3];
			m4[4] = m.c;
			m4[5] = m.d;
			m4[6] = EMPTYMAT4_ARRAY[6];
			m4[7] = EMPTYMAT4_ARRAY[7];
			m4[8] = EMPTYMAT4_ARRAY[8];
			m4[9] = EMPTYMAT4_ARRAY[9];
			m4[10] = EMPTYMAT4_ARRAY[10];
			m4[11] = EMPTYMAT4_ARRAY[11];
			m4[12] = m.tx;
			m4[13] = m.ty;
			m4[14] = EMPTYMAT4_ARRAY[14];
			m4[15] = EMPTYMAT4_ARRAY[15];
			return matArray;
		}
		
		public static function restoreTempArray():void {
			TEMPMAT4_ARRAY[0] = 1;
			TEMPMAT4_ARRAY[1] = 0;
			TEMPMAT4_ARRAY[4] = 0;
			TEMPMAT4_ARRAY[5] = 1;
			TEMPMAT4_ARRAY[12] = 0;
			TEMPMAT4_ARRAY[13] = 0;
		}
		
		public static function clear():void {
			worldScissorTest = false;
			worldShaderDefines = null;
			worldFilters = null;
			worldAlpha = 1;
			worldClipRect.x = worldClipRect.y = 0;
			worldClipRect.width = width;
			worldClipRect.height = height;
			curRenderTarget = null;
		}
	
	}

}