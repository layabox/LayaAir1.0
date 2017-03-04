package laya.d3.core.material {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.events.Event;
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
		/**渲染状态_透明混合_双面。*/
		public static const RENDERMODE_TRANSPARENTDOUBLEFACE:int = 14;
		/**渲染状态_加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 15;
		/**渲染状态_加色法混合_双面。*/
		public static const RENDERMODE_ADDTIVEDOUBLEFACE:int = 16;
		/**渲染状态_只读深度_透明混合。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENT:int = 5;
		/**渲染状态_只读深度_透明混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE:int = 6;
		/**渲染状态_只读深度_加色法混合。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVE:int = 7;
		/**渲染状态_只读深度_加色法混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE:int = 8;
		/**渲染状态_无深度_透明混合。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENT:int = 9;
		/**渲染状态_无深度_透明混合_双面。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE:int = 10;
		/**渲染状态_无深度_加色法混合。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVE:int = 11;
		/**渲染状态_无深度_加色法混合_双面。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE:int = 12;
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_NORMALMAP:int;
		public static var SHADERDEFINE_SPECULARMAP:int;
		public static var SHADERDEFINE_EMISSIVEMAP:int;
		public static var SHADERDEFINE_AMBIENTMAP:int;
		public static var SHADERDEFINE_REFLECTMAP:int;
		public static var SHADERDEFINE_UVTRANSFORM:int;
		public static var SHADERDEFINE_ALPHATEST:int;
		public static var SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV:int;
		//public static var MIXUV:int;//TODO：
		
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
		
		/**@private 渲染模式。*/
		private var _renderMode:int;
		/** @private */
		protected var _transformUV:TransformUV = null;
		
		/**
		 * 获取渲染状态。
		 * @return 渲染状态。
		 */
		public function get renderMode():int {
			return _renderMode;
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			_renderMode = value;
			switch (value) {
			case RENDERMODE_OPAQUE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				_renderQueue = RenderQueue.OPAQUE;
				_addShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUTDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				_addShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
			
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
		}
		
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_DIFFUSEMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_DIFFUSEMAP);
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_NORMALMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_NORMALMAP);
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_SPECULARMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_SPECULARMAP);
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_EMISSIVEMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_EMISSIVEMAP);
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_AMBIENTMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_AMBIENTMAP);
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_REFLECTMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_REFLECTMAP);
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
				_addShaderDefine(StandardMaterial.SHADERDEFINE_UVTRANSFORM);
			else
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_UVTRANSFORM);
			if (_conchMaterial) {//NATIVE//TODO:可取消
				_conchMaterial.setShaderValue(UVMATRIX, value.matrix.elements, 0);
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
			renderMode = RENDERMODE_OPAQUE;
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
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var dest:StandardMaterial = destObject as StandardMaterial;
			dest._renderMode = _renderMode;
		}
	}

}