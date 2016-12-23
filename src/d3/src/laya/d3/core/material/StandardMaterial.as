package laya.d3.core.material {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.shader.ValusArray;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StandardMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 0;
		public static const NORMALTEXTURE:int = 1;
		public static const SPECULARTEXTURE:int = 2;
		public static const EMISSIVETEXTURE:int = 3;
		public static const AMBIENTTEXTURE:int = 4;
		public static const REFLECTTEXTURE:int = 5;
		public static const ALBEDO:int = 6;
		public static const ALPHATESTVALUE:int = 7;
		public static const UVANIAGE:int = 8;
		public static const MATERIALAMBIENT:int = 9;
		public static const MATERIALDIFFUSE:int = 10;
		public static const MATERIALSPECULAR:int = 11;
		public static const MATERIALREFLECT:int = 12;
		public static const UVMATRIX:int = 13;
		public static const UVAGE:int = 14;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:StandardMaterial = new StandardMaterial();
		
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
			return _getColor(MATERIALAMBIENT);
		}
		
		/**
		 * 设置环境光颜色。
		 * @param value 环境光颜色。
		 */
		public function set ambientColor(value:Vector3):void {
			_setColor(MATERIALAMBIENT, value);
		}
		
		public function get diffuseColor():Vector3 {
			return _getColor(MATERIALDIFFUSE);
		}
		
		/**
		 * 设置漫反射光颜色。
		 * @param value 漫反射光颜色。
		 */
		public function set diffuseColor(value:Vector3):void {
			_setColor(MATERIALDIFFUSE, value);
		}
		
		public function get specularColor():Vector4 {
			return _getColor(MATERIALSPECULAR);
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_setColor(MATERIALSPECULAR, value);
		}
		
		public function get reflectColor():Vector3 {
			return _getColor(MATERIALREFLECT);
		}
		
		/**
		 * 设置反射颜色。
		 * @param value 反射颜色。
		 */
		public function set reflectColor(value:Vector3):void {
			_setColor(MATERIALREFLECT, value);
		}
		
		public function get albedo():Vector4 {
			return _getColor(ALBEDO);
		}
		
		/**
		 * 设置反射率。
		 * @param value 反射率。
		 */
		public function set albedo(value:Vector4):void {
			_setColor(ALBEDO, value);
		}
		
		/**
		 * 获取透明测试模式裁剪值。
		 * @return 透明测试模式裁剪值。
		 */
		public function get alphaTestValue():Number {
			return _getNumber(ALPHATESTVALUE);
		}
		
		/**
		 * 设置透明测试模式裁剪值。
		 * @param value 透明测试模式裁剪值。
		 */
		public function set alphaTestValue(value:Number):void {
			_setNumber(ALPHATESTVALUE, value);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(DIFFUSETEXTURE);
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
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _getTexture(NORMALTEXTURE);
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
			_setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _getTexture(SPECULARTEXTURE);
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
			
			_setTexture(SPECULARTEXTURE, value);
		}
		
		/**
		 * 获取放射贴图。
		 * @return 放射贴图。
		 */
		public function get emissiveTexture():BaseTexture {
			return _getTexture(EMISSIVETEXTURE);
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
			_setTexture(EMISSIVETEXTURE, value);
		}
		
		/**
		 * 获取环境贴图。
		 * @return 环境贴图。
		 */
		public function get ambientTexture():BaseTexture {
			return _getTexture(AMBIENTTEXTURE);
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
			_setTexture(AMBIENTTEXTURE, value);
		}
		
		/**
		 * 获取反射贴图。
		 * @return 反射贴图。
		 */
		public function get reflectTexture():BaseTexture {
			return _getTexture(REFLECTTEXTURE);
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
			_setTexture(REFLECTTEXTURE, value);
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
			_setMatrix4x4(UVMATRIX, value.matrix);
			if (value)
				_addShaderDefine(ShaderDefines3D.UVTRANSFORM);
			else
				_removeShaderDefine(ShaderDefines3D.UVTRANSFORM);
			if (_conchMaterial) {//NATIVE//TODO:可取消
				_conchMaterial.setShaderValue(UVMATRIX, value.matrix.elements,0);
			}
		}

		
		public function StandardMaterial() {
			super();
			setShaderName("SIMPLE");
			_setColor(MATERIALAMBIENT, new Vector3(0.6, 0.6, 0.6));
			_setColor(MATERIALDIFFUSE, new Vector3(1.0, 1.0, 1.0));
			_setColor(MATERIALSPECULAR, new Vector4(1.0, 1.0, 1.0, 8.0));
			_setColor(MATERIALREFLECT, new Vector3(1.0, 1.0, 1.0));
			_setColor(ALBEDO, new Vector4(1.0, 1.0, 1.0, 1.0));
			_setNumber(ALPHATESTVALUE, 0.5);
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
		
		/**
		 * @private
		 */
		override public function _setMaterialShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			(_transformUV) && (_transformUV.matrix);//触发UV矩阵更新TODO:临时
		}
	}

}