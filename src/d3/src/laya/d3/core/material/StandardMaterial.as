package laya.d3.core.material {
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.IRenderable;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderDefines3D;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StandardMaterial extends BaseMaterial {
		public static const WORLDMATRIX:String = "MATRIX1";
		public static const MVPMATRIX:String = "MVPMATRIX";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		public static const NORMALTEXTURE:String = "NORMALTEXTURE";
		public static const SPECULARTEXTURE:String = "SPECULARTEXTURE";
		public static const EMISSIVETEXTURE:String = "EMISSIVETEXTURE";
		public static const AMBIENTTEXTURE:String = "AMBIENTTEXTURE";
		public static const REFLECTTEXTURE:String = "REFLECTTEXTURE";
		public static const Bones:String = "MATRIXARRAY0";
		public static const ALBEDO:String = "ALBEDO";
		public static const ALPHATESTVALUE:String = "ALPHATESTVALUE";
		public static const UVANIAGE:String = "UVAGEX";
		
		public static const MATERIALAMBIENT:String = "MATERIALAMBIENT";
		public static const MATERIALDIFFUSE:String = "MATERIALDIFFUSE";
		public static const MATERIALSPECULAR:String = "MATERIALSPECULAR";
		public static const MATERIALREFLECT:String = "MATERIALREFLECT";
		
		public static const UVMATRIX:String = "MATRIX2";
		public static const UVAGE:String = "FLOAT0";
		
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:StandardMaterial = new StandardMaterial();
		
		/** @private */
		private static var AMBIENTCOLORVALUE:Vector3 = new Vector3(0.6, 0.6, 0.6);
		/** @private */
		private static var DIFFUSECOLORVALUE:Vector3 = new Vector3(1.0, 1.0, 1.0);
		/** @private */
		private static var SPECULARCOLORVALUE:Vector4 = new Vector4(1.0, 1.0, 1.0, 8.0);
		/** @private */
		private static var REFLECTCOLORVALUE:Vector3 = new Vector3(1.0, 1.0, 1.0);
		/** @private */
		private static var ALBEDOVALUE:Vector4 = new Vector4(1.0, 1.0, 1.0, 1.0);
		
		/** @private */
		private static const _ambientColorIndex:int = 0;
		/** @private */
		private static const _diffuseColorIndex:int = 1;
		/** @private */
		private static const _speclarColorIndex:int = 2;
		/** @private */
		private static const _reflectColorIndex:int = 3;
		/** @private */
		private static const _albedoColorIndex:int = 4;
		
		/** @private */
		private static const _alphaTestValueIndex:int = 0;
		
		/** @private */
		private static const _diffuseTextureIndex:int = 0;
		/** @private */
		private static const _normalTextureIndex:int = 1;
		/** @private */
		private static const _specularTextureIndex:int = 2;
		/** @private */
		private static const _emissiveTextureIndex:int = 3;
		/** @private */
		private static const _ambientTextureIndex:int = 4;
		/** @private */
		private static const _reflectTextureIndex:int = 5;
		
		/** @private */
		private static const TRANSFORMUV:int = 0;
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):StandardMaterial {
			return Laya.loader.create(url, null, null, StandardMaterial);
		}
		
		/** @private */
		protected var _transformUV:TransformUV = null;
		
		public function get ambientColor():Vector3 {
			return _getColor(_ambientColorIndex);
		}
		
		/**
		 * 设置环境光颜色。
		 * @param value 环境光颜色。
		 */
		public function set ambientColor(value:Vector3):void {
			_setColor(_ambientColorIndex, MATERIALAMBIENT, value);
		}
		
		public function get diffuseColor():Vector3 {
			return _getColor(_diffuseColorIndex);
		}
		
		/**
		 * 设置漫反射光颜色。
		 * @param value 漫反射光颜色。
		 */
		public function set diffuseColor(value:Vector3):void {
			_setColor(_diffuseColorIndex, MATERIALDIFFUSE, value);
		}
		
		public function get specularColor():Vector4 {
			return _getColor(_speclarColorIndex);
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_setColor(_speclarColorIndex, MATERIALSPECULAR, value);
		}
		
		public function get reflectColor():Vector3 {
			return _getColor(_reflectColorIndex);
		}
		
		/**
		 * 设置反射颜色。
		 * @param value 反射颜色。
		 */
		public function set reflectColor(value:Vector3):void {
			_setColor(_reflectColorIndex, MATERIALREFLECT, value);
		}
		
		public function get albedo():Vector4 {
			return _getColor(_albedoColorIndex);
		}
		
		/**
		 * 设置反射率。
		 * @param value 反射率。
		 */
		public function set albedo(value:Vector4):void {
			_setColor(_albedoColorIndex, ALBEDO, value);
		}
		
		/**
		 * 获取透明测试模式裁剪值。
		 * @return 透明测试模式裁剪值。
		 */
		public function get alphaTestValue():Number {
			return _getNumber(_alphaTestValueIndex);
		}
		
		/**
		 * 设置透明测试模式裁剪值。
		 * @param value 透明测试模式裁剪值。
		 */
		public function set alphaTestValue(value:Number):void {
			_setNumber(_alphaTestValueIndex, ALPHATESTVALUE, value);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(_diffuseTextureIndex);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			}
			_setTexture(value, _diffuseTextureIndex, DIFFUSETEXTURE);
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _getTexture(_normalTextureIndex);
		}
		
		/**
		 * 设置法线贴图。
		 * @param value 法线贴图。
		 */
		public function set normalTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.NORMALMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.NORMALMAP);
			}
			_setTexture(value, _normalTextureIndex, NORMALTEXTURE);
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _getTexture(_specularTextureIndex);
		}
		
		/**
		 * 设置高光贴图。
		 * @param value  高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.SPECULARMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.SPECULARMAP);
			}
			
			_setTexture(value, _specularTextureIndex, SPECULARTEXTURE);
		}
		
		/**
		 * 获取放射贴图。
		 * @return 放射贴图。
		 */
		public function get emissiveTexture():BaseTexture {
			return _getTexture(_emissiveTextureIndex);
		}
		
		/**
		 * 设置放射贴图。
		 * @param value 放射贴图。
		 */
		public function set emissiveTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.EMISSIVEMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.EMISSIVEMAP);
			}
			_setTexture(value, _emissiveTextureIndex, EMISSIVETEXTURE);
		}
		
		/**
		 * 获取环境贴图。
		 * @return 环境贴图。
		 */
		public function get ambientTexture():BaseTexture {
			return _getTexture(_ambientTextureIndex);
		}
		
		/**
		 * 设置环境贴图。
		 * @param  value 环境贴图。
		 */
		public function set ambientTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.AMBIENTMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.AMBIENTMAP);
			}
			_setTexture(value, _ambientTextureIndex, AMBIENTTEXTURE);
		}
		
		/**
		 * 获取反射贴图。
		 * @return 反射贴图。
		 */
		public function get reflectTexture():BaseTexture {
			return _getTexture(_reflectTextureIndex);
		}
		
		/**
		 * 设置反射贴图。
		 * @param value 反射贴图。
		 */
		public function set reflectTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.REFLECTMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.REFLECTMAP);
			}
			_setTexture(value, _reflectTextureIndex, REFLECTTEXTURE);
		}
		
		/**
		 * 获取UV变换。
		 * @return  UV变换。
		 */
		public function get transformUV():TransformUV {
			return _transformUV;
		}
		
		/**
		 * 设置UV变换。
		 * @param value UV变换。
		 */
		public function set transformUV(value:TransformUV):void {
			_transformUV = value;
			_setMatrix4x4(TRANSFORMUV, UVMATRIX, value.matrix);
			if (value)
				_addShaderDefine(ShaderDefines3D.UVTRANSFORM);
			else
				_removeShaderDefine(ShaderDefines3D.UVTRANSFORM);
		}
		
		public function StandardMaterial() {
			super();
			_setColor(_ambientColorIndex, MATERIALAMBIENT, AMBIENTCOLORVALUE);
			_setColor(_diffuseColorIndex, MATERIALDIFFUSE, DIFFUSECOLORVALUE);
			_setColor(_speclarColorIndex, MATERIALSPECULAR, SPECULARCOLORVALUE);
			_setColor(_reflectColorIndex, MATERIALREFLECT, REFLECTCOLORVALUE);
			_setColor(_albedoColorIndex, ALBEDO, ALBEDOVALUE);
			_setNumber(_alphaTestValueIndex, ALPHATESTVALUE, 0.5);
			setShaderName("SIMPLE");
		}
		
		/**
		 * 禁用灯光。
		 */
		public function disableLight():void {
			_addDisableShaderDefine(ShaderDefines3D.POINTLIGHT | ShaderDefines3D.SPOTLIGHT | ShaderDefines3D.DIRECTIONLIGHT);
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_addDisableShaderDefine(ShaderDefines3D.FOG);
		}
		
		override public function _setLoopShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			(_transformUV) && (_transformUV.matrix);//触发UV矩阵更新TODO:临时
			var pvw:Matrix4x4;
			if (worldMatrix === Matrix4x4.DEFAULT) {
				pvw = projectionView;//TODO:WORLD可以不传
			} else {
				pvw = _tempMatrix4x40;
				Matrix4x4.multiply(projectionView, worldMatrix, pvw);
			}
			//(_transformUV) && (_setMatrix4x4(TRANSFORMUV, Buffer2D.MATRIX2, _transformUV.matrix, id));
			state.shaderValue.pushValue(WORLDMATRIX, worldMatrix.elements/*worldTransformModifyID,从结构上应该在Mesh中更新*/);//Stat.loopCount + state.ower._ID有BUG,例：6+6=7+5,用worldTransformModifyID代替
			state.shaderValue.pushValue(MVPMATRIX, pvw.elements /*state.camera.transform._worldTransformModifyID + worldTransformModifyID + state.camera._projectionMatrixModifyID,从结构上应该在Mesh中更新*/);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		override public function cloneTo(destObject:*):void {
			var destStandardMaterial:StandardMaterial = destObject as StandardMaterial;
			destStandardMaterial._transformUV = _transformUV;
			super.cloneTo(destStandardMaterial);
		}
	}

}