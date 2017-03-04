package laya.d3.core.material {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.IRenderable;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	
	public class PBRMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 0;
		public static const NORMALTEXTURE:int = 1;
		public static const PBRINFOTEXTURE:int = 2;
		public static const PBRLUTTEXTURE:int = 3;
		public static const ALPHATESTVALUE:int = 4;
		public static const UVANIAGE:int = 5;
		public static const MATERIALROUGHNESS:int = 6;
		public static const UVMATRIX:int = 7;
		public static const UVAGE:int = 8;
		
		public static var pbrlutTex:DataTexture2D;
		/** @private */
		protected var _transformUV:TransformUV = null;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:PBRMaterial = new PBRMaterial();
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):PBRMaterial {
			return Laya.loader.create(url, null, null, PBRMaterial);
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
		 * 获取粗糙度的值，0为特别光滑，1为特别粗糙。
		 * @return 粗糙度的值。
		 */
		public function get roughness():Number {
			return _getNumber(MATERIALROUGHNESS);
		}
		
		/**
		 * 设置粗糙度的值，0为特别光滑，1为特别粗糙。
		 * @param value 粗糙度。
		 */
		public function set roughness(value:Number):void {
			_setNumber(MATERIALROUGHNESS, value);
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
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		/**
		 * 获取PBRLUT贴图。
		 * @return PBRLUT贴图。
		 */
		public function get pbrlutTexture():BaseTexture {
			return _getTexture(PBRLUTTEXTURE);
		}
		
		/**
		 * 设置PBRLUT贴图。
		 * @param value PBRLUT贴图。
		 */
		public function set pbrlutTexture(value:BaseTexture):void {
			_setTexture(PBRLUTTEXTURE, value);
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
			_setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取pbr信息贴图。
		 * @return pbr信息贴图。
		 */
		public function get pbrInfoTexture():BaseTexture {
			return _getTexture(PBRINFOTEXTURE);
		}
		
		/**
		 * 设置pbr信息贴图。
		 * @param value pbr信息贴图。
		 */
		public function set pbrInfoTexture(value:BaseTexture):void {
			_setTexture(PBRINFOTEXTURE, value);
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
			if (_conchMaterial) {//NATIVE//TODO:可取消
				_conchMaterial.setShaderValue(UVMATRIX, value.matrix.elements, 0);
			}
		}
		
		public function PBRMaterial() {
			super();
			if (!PBRMaterial.pbrlutTex) {
				var lutdt:Array = Browser.window['__pbrlutdata'];
				if (!lutdt) {
					alert('no pbr lutdata, need pbrlut.js');
					throw 'no pbr lutdata, need pbrlut.js';
				}
				var luttex:DataTexture2D = DataTexture2D.create((new Uint32Array(lutdt)).buffer, 256, 256, WebGLContext.NEAREST, WebGLContext.NEAREST, false);
				PBRMaterial.pbrlutTex = luttex;
			}
			_setTexture(PBRLUTTEXTURE, PBRMaterial.pbrlutTex);
			setShaderName("PBR");
			_setNumber(ALPHATESTVALUE, 0.5);
		}
		
		/**
		 * 禁用灯光。
		 */
		public function disableLight():void {
			_addDisableShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_addDisableShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
		}
		
		/**
		 * @private
		 */
		override public function _setMaterialShaderParams(state:RenderState):void {
			(_transformUV) && (_transformUV.matrix);//触发UV矩阵更新TODO:临时
		}
		
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			super.onAsynLoaded(url, data, params);
		}
	}
}