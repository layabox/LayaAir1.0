package laya.d3.resource.models {
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.renders.Render;
	import laya.resource.Resource;
	
	/**
	 * <code>Sky</code> 类用于创建天空的父类，抽象类不允许实例。
	 */
	public class Sky extends Resource {
		public static const MVPMATRIX:int = 0;
		public static const INTENSITY:int = 1;
		public static const ALPHABLENDING:int = 2;
		public static const DIFFUSETEXTURE:int = 3;
		
		/** @private 透明混合度。 */
		protected var _alphaBlending:Number = 1.0;//TODO:可能移除
		/** @private 颜色强度。 */
		protected var _colorIntensity:Number = 1.0;
		/** @private */
		protected var _vertexBuffer:VertexBuffer3D;
		/** @private */
		protected var _indexBuffer:IndexBuffer3D;
		/** @private */
		protected var _sharderNameID:int;
		/** @private */
		protected var _shader:Shader3D;
		/** @private */
		protected var _shaderValue:ValusArray;
		/** @private */
		protected var _shaderCompile:ShaderCompile3D;
		
		/** @private */
		public var _conchSky:*;
		
		/**
		 * 获取透明混合度。
		 * @return 透明混合度。
		 */
		public function get alphaBlending():Number {
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
			if (_conchSky) {//NATIVE
				_conchSky.setShaderValue(Sky.ALPHABLENDING, _alphaBlending,2);
			}
		}
		
		/**
		 * 获取颜色强度。
		 * @return 颜色强度。
		 */
		public function get colorIntensity():Number {
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
			if (_conchSky) {//NATIVE
				_conchSky.setShaderValue(Sky.INTENSITY, _colorIntensity,2);
			}
		}
		
		public function Sky() {
			super();
			_shaderValue = new ValusArray();
			if (Render.isConchNode) {
				_conchSky = __JS__("new ConchSkyMesh()");
			}
		}
		
		public function _render(state:RenderState):void {
		
		}
	
	}

}