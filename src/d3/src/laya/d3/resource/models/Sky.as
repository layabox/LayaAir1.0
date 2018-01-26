package laya.d3.resource.models {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Sky</code> 类用于创建天空的父类，抽象类不允许实例。
	 */
	public class Sky {
		public static const MVPMATRIX:int = 0;
		public static const INTENSITY:int = 1;
		public static const ALPHABLENDING:int = 2;
		public static const DIFFUSETEXTURE:int = 3;
		
		/** @private */
		protected var __ownerCamera:BaseCamera;
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
		protected var _environmentDiffuse:BaseTexture;
		/** @private */
		protected var _environmentSpecular:BaseTexture;
		
		/** @private */
		public var _conchSky:*;
		
		/**
		 * @private
		 */
		public function set _ownerCamera(value:BaseCamera):void {
			__ownerCamera = value;
			(_environmentDiffuse) && (_setEnvironmentDiffuse());
			(_environmentSpecular) && (_setEnvironmentSpecular());
		}
		
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
				_conchSky.setShaderValue(Sky.ALPHABLENDING, _alphaBlending, 2);
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
				_conchSky.setShaderValue(Sky.INTENSITY, _colorIntensity, 2);
			}
		}
		
		/**
		 * 获取环境漫反射贴图。
		 * @return 环境漫反射贴图。
		 */
		public function get environmentDiffuse():BaseTexture {
			return _environmentDiffuse;
		}
		
		/**
		 * 设置环境漫反射贴图。
		 * @param value 环境漫反射贴图。
		 */
		public function set environmentDiffuse(value:BaseTexture):void {
			value.minFifter = WebGLContext.NEAREST;//TODO:临时代码？
			_environmentDiffuse = value;
			(__ownerCamera) && (_setEnvironmentDiffuse());
		}
		
		/**
		 * 获取环境高光贴图。
		 * @return 环境高光贴图。
		 */
		public function get environmentSpecular():BaseTexture {
			return _environmentSpecular;
		}
		
		public function set envDiffuseSHRed(value:Float32Array):void {
			__ownerCamera._shaderValues.setValue(BaseCamera.DIFFUSEIRRADMATR, value);
		}
		
		public function set envDiffuseSHGreen(value:Float32Array):void {
			__ownerCamera._shaderValues.setValue(BaseCamera.DIFFUSEIRRADMATG, value);
		}
		
		public function set envDiffuseSHBlue(value:Float32Array):void {
			__ownerCamera._shaderValues.setValue(BaseCamera.DIFFUSEIRRADMATB, value);
		}
		
		/**
		 * 设置环境高光贴图。
		 * @param value 环境高光贴图。
		 */
		public function set environmentSpecular(value:BaseTexture):void {
			_environmentSpecular = value;
			(__ownerCamera) && (_setEnvironmentSpecular());
		}
		
		/**
		 *
		 * 创建一个 <code>Sky</code> 实例。
		 */
		public function Sky() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_shaderValue = new ValusArray();
			if (Render.isConchNode) {
				_conchSky = __JS__("new ConchSkyMesh()");
			}
		}
		
		/**
		 * @private
		 */
		private function _setEnvironmentDiffuse():void {
			if (_environmentDiffuse.loaded) {
				__ownerCamera._shaderValues.setValue(BaseCamera.ENVIRONMENTDIFFUSE, _environmentDiffuse);
			} else {
				_environmentDiffuse.on(Event.LOADED, this, _environmentDiffuseLoaded);
			}
		}
		
		/**
		 * @private
		 */
		private function _setEnvironmentSpecular():void {
			if (_environmentSpecular.loaded) {
				var si:* = _environmentSpecular['simLodInfo'];
				if (si && si is Float32Array)
					__ownerCamera._shaderValues.setValue(BaseCamera.SIMLODINFO, si);
				__ownerCamera._shaderValues.setValue(BaseCamera.ENVIRONMENTSPECULAR, _environmentSpecular);
			} else {
				_environmentSpecular.on(Event.LOADED, this, _environmentSpecularLoaded);
			}
		}
		
		/**
		 * @private
		 */
		private function _environmentDiffuseLoaded():void {
			__ownerCamera._shaderValues.setValue(BaseCamera.ENVIRONMENTDIFFUSE, _environmentDiffuse);
		}
		
		/**
		 * @private
		 */
		private function _environmentSpecularLoaded():void {
			var si:* = _environmentSpecular['simLodInfo'];
			if (si && si is Float32Array)
				__ownerCamera._shaderValues.setValue(BaseCamera.SIMLODINFO, si);
			__ownerCamera._shaderValues.setValue(BaseCamera.ENVIRONMENTSPECULAR, _environmentSpecular);
		}
		
		/**
		 * @private
		 */
		public function _render(state:RenderState):void {
		}
		
		/**
		 * 销毁天空。
		 */
		public function destroy():void {
			__ownerCamera = null;
		}
	
	}

}