package laya.d3.core.material {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	import laya.events.Event;
	
	public class PBRMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 1;
		public static const NORMALTEXTURE:int = 2;
		public static const PBRINFOTEXTURE:int = 3;
		public static const PBRLUTTEXTURE:int = 4;
		public static const UVANIAGE:int = 5;
		public static const MATERIALROUGHNESS:int = 6;
		public static const MATERIALMETALESS:int = 7;
		public static const UVMATRIX:int = 8;
		public static const UVAGE:int = 9;
		public static const AOOBJPOS:int = 14;
		
		
		public static var SHADERDEFINE_FIX_ROUGHNESS:int = 0;
		public static var SHADERDEFINE_FIX_METALESS:int = 0;
		public static var SHADERDEFINE_HAS_TANGENT:int = 0;
		public static var SHADERDEFINE_TEST_CLIPZ:int = 0;
		public static var SHADERDEFINE_HAS_PBRINFO:int = 0;
		
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_不透明_双面。*/
		public static const RENDERMODE_OPAQUEDOUBLEFACE:int = 2;
		/**渲染状态_透明测试。*/
		public static const RENDERMODE_CUTOUT:int = 3;
		/**渲染状态_透明测试_双面。*/
		public static const RENDERMODE_CUTOUTDOUBLEFACE:int = 4;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 13;
		
		public static var pbrlutTex:DataTexture2D;
		/** @private */
		protected var _transformUV:TransformUV = null;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:PBRMaterial = new PBRMaterial();
		
		/**@private 渲染模式。*/
		private var _renderMode:int;
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):PBRMaterial {
			return Laya.loader.create(url, null, null, PBRMaterial);
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
			_addShaderDefine(SHADERDEFINE_FIX_ROUGHNESS);
		}
		
		public function get metaless():Number {
			return _getNumber(MATERIALMETALESS);
		}
		
		public function set metaless(v:Number):void {
			_setNumber(MATERIALMETALESS, v);
			_addShaderDefine(SHADERDEFINE_FIX_METALESS);
		}
		
		public function set has_tangent(v:Boolean):void {
			_addShaderDefine(SHADERDEFINE_HAS_TANGENT);
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
			_addShaderDefine(SHADERDEFINE_HAS_PBRINFO);
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
				//luttex.repeat = false; 编译不过
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
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
		}
		
		/**
		 * 获取渲染状态。
		 * @return 渲染状态。
		 */
		public function get renderMode():int {
			return _renderMode;
		}
		
		public function set renderMode(value:int):void {
			_renderMode = value;
			switch (value) {
			case RENDERMODE_OPAQUE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				_renderQueue = RenderQueue.OPAQUE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("PBRMaterial:renderMode value error.");
			}
		}
		
		public function set testClipZ(v:Boolean):void {
			_addShaderDefine(SHADERDEFINE_TEST_CLIPZ);
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