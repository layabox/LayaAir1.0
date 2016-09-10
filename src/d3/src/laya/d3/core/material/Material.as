package laya.d3.core.material {
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.Texture;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * <code>Material</code> 类用于创建材质。
	 */
	public class Material extends EventDispatcher {
		public static var maxMaterialCount:int = Math.floor(2147483647 / VertexDeclaration._maxVertexDeclarationBit);//需在材质中加异常判断警告
		
		/** 默认材质，禁止修改*/
		public static var defaultMaterial:Material = new Material();
		
		/** @private */
		protected static var _uniqueIDCounter:int = 1;
		/** @private */
		private static var AMBIENTCOLORVALUE:Vector3 = new Vector3(0.6, 0.6, 0.6);
		/** @private */
		private static var DIFFUSECOLORVALUE:Vector3 = new Vector3(1.0, 1.0, 1.0);
		/** @private */
		private static var SPECULARCOLORVALUE:Vector4 = new Vector4(1.0, 1.0, 1.0, 8.0);
		/** @private */
		private static var REFLECTCOLORVALUE:Vector3 = new Vector3(1.0, 1.0, 1.0);
		
		/** @private */
		private static const DIFFUSETEXTURE:int = 0;
		/** @private */
		private static const NORMALTEXTURE:int = 1;
		/** @private */
		private static const SPECULARTEXTURE:int = 2;
		/** @private */
		private static const EMISSIVETEXTURE:int = 3;
		/** @private */
		private static const AMBIENTTEXTURE:int = 4;
		/** @private */
		private static const REFLECTTEXTURE:int = 5;
		
		/** @private */
		private static const AMBIENTCOLOR:int = 0;
		/** @private */
		private static const DIFFUSECOLOR:int = 1;
		/** @private */
		private static const SPECULARCOLOR:int = 2;
		/** @private */
		private static const REFLECTCOLOR:int = 3;
		/** @private */
		private static const TRANSPARENT:int = 4;
		/** @private */
		private static const ALBEDO:int = 5;
		/** @private */
		private static const TRANSFORMUV:int = 6;
		/** @private */
		private static const ALPHATESTVALUE:int = 7;
		
		/**渲染状态_天空。*/
		public static const RENDERMODE_SKY:int = 0;
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_不透明_双面。*/
		public static const RENDERMODE_OPAQUEDOUBLEFACE:int = 2;
		/**渲染状态_透明测试。*/
		public static const RENDERMODE_CUTOUT:int = 3;
		/**渲染状态_透明测试_双面。*/
		public static const RENDERMODE_CUTOUTDOUBLEFACE:int = 4;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 5;
		/**渲染状态_透明混合_双面。*/
		public static const RENDERMODE_TRANSPARENTDOUBLEFACE:int = 6;
		/**渲染状态_加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 7;
		/**渲染状态_加色法混合_双面。*/
		public static const RENDERMODE_ADDTIVEDOUBLEFACE:int = 8;
		
		public static function createFromFile(url:String, out:Material):void {
			out._loaded = false;
			var loader:Loader = new Loader();
			var onComp:Function = function(data:String):void {
				var preBasePath:String = URL.basePath;
				
				URL.basePath = URL.getPath(URL.formatURL(url));
				ClassUtils.createByJson(data, out, null, Handler.create(null, Utils3D._parseMaterial, null, false));
				
				URL.basePath = preBasePath;
				out._eventLoaded();
			
			}
			loader.once(Event.COMPLETE, null, onComp);
			loader.load(url, Loader.JSON);
		}
		
		/**材质唯一标识id。*/
		private var _id:int;
		/**是否已加载完成*/
		private var _loaded:Boolean = true;
		/**所属渲染队列。*/
		private var _renderQueue:int;
		/**渲染模式。*/
		private var _renderMode:int;
		/** @private */
		protected var _textures:Vector.<Texture> = new Vector.<Texture>();
		/** @private */
		protected var _texturesSharderIndex:Vector.<int> = new Vector.<int>();
		/** @private */
		protected var _otherSharderIndex:Vector.<int> = new Vector.<int>();
		
		/*
		   protected var _extendTextures:Vector.<Texture>;
		   protected var _extendTexturesMap:*;
		   protected var _extendTexturesIndexShader:Vector.<int>;
		   protected var _extendTexturesIndexShaderMap:*;
		 */
		
		/** @private */
		protected var _texturesloaded:Boolean = false;
		
		/** @private */
		protected var _shader:Shader;
		/** @private */
		protected var _sharderNameID:int;
		/** @private */
		protected var _shaderValues:ValusArray = new ValusArray();
		/** @private */
		protected var _disableDefine:int = 0;
		
		/** @private */
		protected var _color:Array = [];
		
		/** @private */
		protected var _alphaTestValue:Number;
		/** @private */
		protected var _albedo:Vector4 = new Vector4(1.0, 1.0, 1.0, 1.0);
		/** @private */
		protected var _transformUV:TransformUV = null;
		/** @private */
		protected var _shaderDef:int = 0;
		/** @private */
		public var _isInstance:Boolean = false;
		/**材质名字。*/
		public var name:String;
		
		/**
		 * 获取唯一标识ID(通常用于优化或识别)。
		 * @return 唯一标识ID
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取是否已加载完成。
		 * @return 是否已加载完成
		 */
		public function get loaded():Boolean {
			return _loaded;
		}
		
		/**
		 * 获取所属渲染队列。
		 * @return 渲染队列。
		 */
		public function get renderQueue():int {
			return _renderQueue;
		}
		
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
			case RENDERMODE_SKY: 
				_renderQueue = RenderQueue.NONEWRITEDEPTH;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUE: 
				_renderQueue = RenderQueue.OPAQUE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUT: 
				_renderQueue = RenderQueue.OPAQUE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUTDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVE: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("Material:renderMode value error.");
				break;
			}
			_getShaderDefineValue();
		}
		
		/**
		 * 获取材质的ShaderDef。
		 * @return 材质的ShaderDef。
		 */
		public function get shaderDef():int {
			return _shaderDef;
		}
		
		/**
		 * 获取透明测试模式裁剪值。
		 * @return 透明测试模式裁剪值。
		 */
		public function get alphaTestValue():Number {
			return _alphaTestValue;
		}
		
		/**
		 * 设置透明测试模式裁剪值。
		 * @param value 透明测试模式裁剪值。
		 */
		public function set alphaTestValue(value:Number):void {
			_alphaTestValue = value;
			_pushShaderValue(ALPHATESTVALUE, Buffer2D.ALPHATESTVALUE, value, _id);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():Texture {
			return _textures[DIFFUSETEXTURE];
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:Texture):void {
			_setTexture(value, DIFFUSETEXTURE, Buffer2D.DIFFUSETEXTURE);
			_getShaderDefineValue();
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():Texture {
			return _textures[NORMALTEXTURE];
		}
		
		/**
		 * 设置法线贴图。
		 * @param value 法线贴图。
		 */
		public function set normalTexture(value:Texture):void {
			_setTexture(value, NORMALTEXTURE, Buffer2D.NORMALTEXTURE);
			_getShaderDefineValue();
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():Texture {
			return _textures[SPECULARTEXTURE];
		}
		
		/**
		 * 设置高光贴图。
		 * @param value  高光贴图。
		 */
		public function set specularTexture(value:Texture):void {
			_setTexture(value, SPECULARTEXTURE, Buffer2D.SPECULARTEXTURE);
			_getShaderDefineValue();
		}
		
		/**
		 * 获取放射贴图。
		 * @return 放射贴图。
		 */
		public function get emissiveTexture():Texture {
			return _textures[EMISSIVETEXTURE];
		}
		
		/**
		 * 设置放射贴图。
		 * @param value 放射贴图。
		 */
		public function set emissiveTexture(value:Texture):void {
			_setTexture(value, EMISSIVETEXTURE, Buffer2D.EMISSIVETEXTURE);
			_getShaderDefineValue();
		}
		
		/**
		 * 获取环境贴图。
		 * @return 环境贴图。
		 */
		public function get ambientTexture():Texture {
			return _textures[AMBIENTTEXTURE];
		}
		
		/**
		 * 设置环境贴图。
		 * @param  value 环境贴图。
		 */
		public function set ambientTexture(value:Texture):void {
			_setTexture(value, AMBIENTTEXTURE, Buffer2D.AMBIENTTEXTURE);
			_getShaderDefineValue();
		}
		
		/**
		 * 获取反射贴图。
		 * @return 反射贴图。
		 */
		public function get reflectTexture():Texture {
			return _textures[REFLECTTEXTURE];
		}
		
		/**
		 * 设置反射贴图。
		 * @param value 反射贴图。
		 */
		public function set reflectTexture(value:Texture):void {
			_setTexture(value, REFLECTTEXTURE, Buffer2D.REFLECTTEXTURE);
			_getShaderDefineValue();
		}
		
		/**
		 * 获取贴图数量。
		 * @return 贴图数量。
		 */
		public function get texturesCount():int {
			return _textures.length;
		}
		
		/**
		 * 设置环境光颜色。
		 * @param value 环境光颜色。
		 */
		public function set ambientColor(value:Vector3):void {
			_color[AMBIENTCOLOR] = value;
			_pushShaderValue(AMBIENTCOLOR, Buffer2D.MATERIALAMBIENT, value.elements, _id);
		}
		
		/**
		 * 设置漫反射光颜色。
		 * @param value 漫反射光颜色。
		 */
		public function set diffuseColor(value:Vector3):void {
			_color[DIFFUSECOLOR] = value;
			_pushShaderValue(DIFFUSECOLOR, Buffer2D.MATERIALDIFFUSE, value.elements, _id);
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_color[SPECULARCOLOR] = value;
			_pushShaderValue(SPECULARCOLOR, Buffer2D.MATERIALSPECULAR, value.elements, _id);
		}
		
		/**
		 * 设置反射颜色。
		 * @param value 反射颜色。
		 */
		public function set reflectColor(value:Vector3):void {
			_color[REFLECTCOLOR] = value;
			_pushShaderValue(REFLECTCOLOR, Buffer2D.MATERIALREFLECT, value.elements, _id);
		}
		
		/**
		 * 设置反射率。
		 * @param value 反射率。
		 */
		public function set albedo(value:Vector4):void {
			_albedo = value;
			_pushShaderValue(ALBEDO, Buffer2D.ALBEDO, _albedo.elements, _id);
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
			var uvMat:Matrix4x4 = _transformUV.matrix;
			_pushShaderValue(TRANSFORMUV, Buffer2D.MATRIX2, uvMat.elements, _id);
			_getShaderDefineValue();
		}
		
		/**
		 * 创建一个 <code>Material</code> 实例。
		 */
		public function Material() {
			_id = ++_uniqueIDCounter;
			if (_id > maxMaterialCount)
				throw new Error("Material: Material count should not large than ", maxMaterialCount);
			 
			_color[AMBIENTCOLOR] = AMBIENTCOLORVALUE;
			_color[DIFFUSECOLOR] = DIFFUSECOLORVALUE;
			_color[SPECULARCOLOR] = SPECULARCOLORVALUE;
			_color[REFLECTCOLOR] = REFLECTCOLORVALUE;
			
			_pushShaderValue(AMBIENTCOLOR, Buffer2D.MATERIALAMBIENT, _color[AMBIENTCOLOR].elements, _id);
			_pushShaderValue(DIFFUSECOLOR, Buffer2D.MATERIALDIFFUSE, _color[DIFFUSECOLOR].elements, _id);
			_pushShaderValue(SPECULARCOLOR, Buffer2D.MATERIALSPECULAR, _color[SPECULARCOLOR].elements, _id);
			_pushShaderValue(REFLECTCOLOR, Buffer2D.MATERIALREFLECT, _color[REFLECTCOLOR].elements, _id);
			_pushShaderValue(ALBEDO, Buffer2D.ALBEDO, _albedo.elements, _id);
			
			renderMode = RENDERMODE_OPAQUE;
			alphaTestValue = 0.5;
		}
		
		/**
		 * @private
		 */
		private function _eventLoaded():void {
			_loaded = true;
			event(Event.LOADED, this);
		}
		
		/**
		 * @private
		 */
		private function _textureLoadCompleted():Boolean {
			if (_texturesloaded)
				return true;
			
			if (diffuseTexture && !diffuseTexture.loaded/*||_diffuseTexture.loaded&&!_diffuseTexture.source*/)
				return false;
			if (normalTexture && !normalTexture.loaded/*||_normalTexture &&_normalTexture.loaded&&!_normalTexture.source*/)
				return false;
			if (specularTexture && !specularTexture.loaded/*||_specularTexture &&_specularTexture.loaded&&!_specularTexture.source*/)
				return false;
			if (emissiveTexture && !emissiveTexture.loaded/*||_emissiveTexture &&_emissiveTexture.loaded&&!_emissiveTexture.source*/)
				return false;
			if (ambientTexture && !ambientTexture.loaded/*||_ambientTexture &&_ambientTexture.loaded&&!_ambientTexture.source*/)
				return false;
			if (reflectTexture && !reflectTexture.loaded/*||_reflectTexture &&_reflectTexture.loaded&&!_reflectTexture.source*/)
				return false;
			/*
			   if (_extendTextures) {
			   for (var i:int = 0, n:int = _extendTextures.length; i < n; i++)
			   if (!_extendTextures[i].loaded/ *&&!_extendTextures[i].source* /)
			   return false;
			   }
			 */
			
			(diffuseTexture) && _uploadTexture(DIFFUSETEXTURE, diffuseTexture);
			(normalTexture) && (_uploadTexture(NORMALTEXTURE, normalTexture));
			(specularTexture) && _uploadTexture(SPECULARTEXTURE, specularTexture);
			(emissiveTexture) && (_uploadTexture(EMISSIVETEXTURE, emissiveTexture));
			(ambientTexture) && (_uploadTexture(AMBIENTTEXTURE, ambientTexture));
			(reflectTexture) && (_uploadTexture(REFLECTTEXTURE, reflectTexture));
			return _texturesloaded = true;
		}
		
		/**
		 * @private
		 * 获取材质的ShaderDefine。
		 * @param shaderIndex 在ShaderValue队列中的索引。
		 * @param name 名称。
		 * @param value 值。
		 * @param id 优化id。
		 * @return 当前ShaderValue队列的索引。
		 */
		protected function _pushShaderValue(shaderIndex:int, name:String, value:*, id:Number):int {
			var shaderValue:ValusArray = _shaderValues;
			var index:* = _otherSharderIndex[shaderIndex];
			if (!index) {
				index = shaderValue.length + 1;
				shaderValue.pushValue(name, null, -1);
				_otherSharderIndex[shaderIndex] = index;
			}
			shaderValue.data[index][0] = value;
			shaderValue.data[index][1] = id;
			return index;
		}
		
		/**
		 * @private
		 * 获取材质的ShaderDefine。
		 * @return 材质的ShaderDefine。
		 */
		protected function _getShaderDefineValue():int {
			_shaderDef = 0;
			diffuseTexture && (_shaderDef |= ShaderDefines3D.DIFFUSEMAP);
			normalTexture && (_shaderDef |= ShaderDefines3D.NORMALMAP);
			specularTexture && (_shaderDef |= ShaderDefines3D.SPECULARMAP);
			emissiveTexture && (_shaderDef |= ShaderDefines3D.EMISSIVEMAP);
			ambientTexture && (_shaderDef |= ShaderDefines3D.AMBIENTMAP);
			reflectTexture && (_shaderDef |= ShaderDefines3D.REFLECTMAP);
			
			_transformUV && (_shaderDef |= ShaderDefines3D.UVTRANSFORM);
			(_renderMode === RENDERMODE_CUTOUT || _renderMode === RENDERMODE_CUTOUTDOUBLEFACE) && (_shaderDef |= ShaderDefines3D.ALPHATEST);
			
			return _shaderDef;
		}
		
		/**
		 * @private
		 */
		protected function _setTexture(value:Texture, shaderIndex:int, shaderValue:String):int {
			var index:* = _texturesSharderIndex[shaderIndex];
			if (!index && value) {
				index = _shaderValues.length + 1;
				_shaderValues.pushValue(shaderValue, null, -1);
				_texturesSharderIndex[shaderIndex] = index;
			}
			(value) && (_texturesloaded = false);
			_textures[shaderIndex] = value;
			return index;
		}
		
		/**
		 * @private
		 */
		protected function _uploadTexture(shaderIndex:int, texture:Texture):void {
			var shaderValue:ValusArray = _shaderValues;
			var data:Array = shaderValue.data[_texturesSharderIndex[shaderIndex]];
			data[0] = texture.source;
			data[1] = texture.bitmap.id;
		}
		
		/**
		 * 通过索引获取纹理。
		 * @param index 索引。
		 * @return  纹理。
		 */
		public function getTextureByIndex(index:int):Texture {
			return _textures[index];
		}
		
		/**
		 * 获取Shader。
		 * @param state 相关渲染状态。
		 * @return  Shader。
		 */
		public function getShader(state:RenderState):Shader {
			var shaderDefs:ShaderDefines3D = state.shaderDefs;
			
			var preDef:int = shaderDefs._value;
			_disableDefine && (shaderDefs._value = preDef & (~_disableDefine));
			var nameID:Number = (shaderDefs._value | state.shadingMode) + _sharderNameID * Shader.SHADERNAME2ID;
			_shader = Shader.withCompile(_sharderNameID, state.shadingMode, shaderDefs.toNameDic(), nameID, null);
			shaderDefs._value = preDef;
			
			return _shader;
		}
		
		/**
		 * 上传材质。
		 * @param state 相关渲染状态。
		 * @param bufferUsageShader Buffer相关绑定。
		 * @param shader 着色器。
		 * @return  是否成功。
		 */
		public function upload(state:RenderState, bufferUsageShader:*, shader:Shader):Boolean {
			if (!_textureLoadCompleted()) return false;
			
			(_transformUV) && (_transformUV.matrix);//触发UV矩阵更新。
			
			shader || (shader = getShader(state));
			
			var shaderValue:ValusArray = _shaderValues;
			var _presize:int = shaderValue.length;
			
			shaderValue.pushArray(state.shaderValue);
			
			if (shader.tag._uploadMaterialID != Stat.loopCount) {
				shader.tag._uploadMaterialID = Stat.loopCount;
				shaderValue.pushArray(state.worldShaderValue);
			}
			shader.uploadArray(shaderValue.data, shaderValue.length, bufferUsageShader);
			
			shaderValue.length = _presize;
			return true;
		}
		
		/**
		 * 禁用灯光。
		 */
		public function disableLight():void {
			_disableDefine |= ShaderDefines3D.POINTLIGHT | ShaderDefines3D.SPOTLIGHT | ShaderDefines3D.DIRECTIONLIGHT;
		}
		
		/**
		 * 禁用相关Define。
		 * @param value 禁用值。
		 */
		public function disableDefine(value:int):void {
			_disableDefine = value;
		}
		
		/**
		 * 设置使用Shader名字。
		 * @param name 名称。
		 */
		public function setShaderName(name:String):void {
			_sharderNameID = Shader.nameKey.get(name);
		}
		
		
		
		/**
		 * 复制材质
		 * @param dec 目标材质
		 */
		public function copy(dec:Material):Material {
			dec._loaded = _loaded;
			dec._renderQueue = _renderQueue;
			dec._renderMode = _renderMode;
			dec._textures = _textures.slice();
			dec._texturesSharderIndex = _texturesSharderIndex;
			dec._otherSharderIndex = _otherSharderIndex;
			dec._texturesloaded = _texturesloaded;
			dec._shader = _shader;
			dec._sharderNameID = _sharderNameID;
			dec._disableDefine = _disableDefine;
			dec._color = _color;
			dec._alphaTestValue = _alphaTestValue;
			
			dec._transformUV = _transformUV;
			dec._albedo = _albedo;
			dec._shaderDef = _shaderDef;
			dec.name = name;
			
			_shaderValues.copyTo(dec._shaderValues);
			return dec;
			;
		}
	
	/*
	   public function get extendTexturesCount():int {
	   return _extendTextures.length;
	   }
	
	   public function getExtendTextureByIndex(index:int):Texture {
	   return _extendTextures[index];
	   }
	   public function setExtendTexture(key:String, texture:Texture, shaderName:String):void {
	   (_extendTexturesIndexShader) || (_extendTexturesIndexShader = new Vector.<Texture>());
	   (_extendTexturesIndexShaderMap) || (_extendTexturesIndexShaderMap = {});
	   if ((_extendTexturesIndexShaderMap[key] === undefined) && texture) {
	   _extendTexturesIndexShaderMap[key] = _extendTexturesIndexShader.length;
	   _extendTexturesIndexShader.push(_shaderValues.length + 1);
	   _shaderValues.pushValue(shaderName, null, -1);
	   }
	
	   (_extendTextures) || (_extendTextures = new Vector.<Texture>());
	   (_extendTexturesMap) || (_extendTexturesMap = {});
	   _extendTexturesMap[key] = _extendTextures.length;
	   _extendTextures.push(texture);
	   }
	   protected function uploadExtenTextures(shaderValue:ValusArray):void {
	   for (var i:int = 0, n:int = _extendTextures.length; i < n; i++)
	   uploadTexture(_extendTexturesIndexShader[i], _extendTextures[i]);
	   }
	 */
	}

}