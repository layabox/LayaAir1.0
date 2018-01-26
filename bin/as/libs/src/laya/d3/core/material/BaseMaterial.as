package laya.d3.core.material {
	import laya.d3.core.IClone;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	import laya.d3.shader.ValusArray;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
	 */
	public class BaseMaterial extends Resource implements IClone {
		/**剔除枚举_不剔除。*/
		public static const CULL_NONE:int = 0;
		/**剔除枚举_剔除正面。*/
		public static const CULL_FRONT:int = 1;
		/**剔除枚举_剔除背面。*/
		public static const CULL_BACK:int = 2;
		
		/**混合枚举_禁用。*/
		public static const BLEND_DISABLE:int = 0;
		/**混合枚举_启用_RGB和Alpha统一混合。*/
		public static const BLEND_ENABLE_ALL:int = 1;
		/**混合枚举_启用_RGB和Alpha单独混合。*/
		public static const BLEND_ENABLE_SEPERATE:int = 2;
		
		/**混合参数枚举_零,例：RGB(0,0,0),Alpha:(1)。*/
		public static const BLENDPARAM_ZERO:int = 0;
		/**混合参数枚举_一,例：RGB(1,1,1),Alpha:(1)。*/
		public static const BLENDPARAM_ONE:int = 1;
		/**混合参数枚举_源颜色,例：RGB(Rs, Gs, Bs)，Alpha(As)。*/
		public static const BLENDPARAM_SRC_COLOR:int = 0x0300;
		/**混合参数枚举_一减源颜色,例：RGB(1-Rs, 1-Gs, 1-Bs)，Alpha(1-As)。*/
		public static const BLENDPARAM_ONE_MINUS_SRC_COLOR:int = 0x0301;
		/**混合参数枚举_目标颜色,例：RGB(Rd, Gd, Bd),Alpha(Ad)。*/
		public static const BLENDPARAM_DST_COLOR:int = 0x0306;
		/**混合参数枚举_一减目标颜色,例：RGB(1-Rd, 1-Gd, 1-Bd)，Alpha(1-Ad)。*/
		public static const BLENDPARAM_ONE_MINUS_DST_COLOR:int = 0x0307;
		/**混合参数枚举_源透明,例:RGB(As, As, As),Alpha(1-As)。*/
		public static const BLENDPARAM_SRC_ALPHA:int = 0x0302;
		/**混合参数枚举_一减源阿尔法,例:RGB(1-As, 1-As, 1-As),Alpha(1-As)。*/
		public static const BLENDPARAM_ONE_MINUS_SRC_ALPHA:int = 0x0303;
		/**混合参数枚举_目标阿尔法，例：RGB(Ad, Ad, Ad),Alpha(Ad)。*/
		public static const BLENDPARAM_DST_ALPHA:int = 0x0304;
		/**混合参数枚举_一减目标阿尔法,例：RGB(1-Ad, 1-Ad, 1-Ad),Alpha(Ad)。*/
		public static const BLENDPARAM_ONE_MINUS_DST_ALPHA:int = 0x0305;
		/**混合参数枚举_阿尔法饱和，例：RGB(min(As, 1 - Ad), min(As, 1 - Ad), min(As, 1 - Ad)),Alpha(1)。*/
		public static const BLENDPARAM_SRC_ALPHA_SATURATE:int = 0x0308;
		
		/**混合方程枚举_加法,例：source + destination*/
		public static const BLENDEQUATION_ADD:int = 0;
		/**混合方程枚举_减法，例：source - destination*/
		public static const BLENDEQUATION_SUBTRACT:int = 1;
		/**混合方程枚举_反序减法，例：destination - source*/
		public static const BLENDEQUATION_REVERSE_SUBTRACT:int = 2;
		
		/**深度测试函数枚举_关闭深度测试。*/
		public static const DEPTHTEST_OFF:int = 0/*WebGLContext.NEVER*/;
		/**深度测试函数枚举_从不通过。*/
		public static const DEPTHTEST_NEVER:int = 0x0200/*WebGLContext.NEVER*/;
		/**深度测试函数枚举_小于时通过。*/
		public static const DEPTHTEST_LESS:int = 0x0201/*WebGLContext.LESS*/;
		/**深度测试函数枚举_等于时通过。*/
		public static const DEPTHTEST_EQUAL:int = 0x0202/*WebGLContext.EQUAL*/;
		/**深度测试函数枚举_小于等于时通过。*/
		public static const DEPTHTEST_LEQUAL:int = 0x0203/*WebGLContext.LEQUAL*/;
		/**深度测试函数枚举_大于时通过。*/
		public static const DEPTHTEST_GREATER:int = 0x0204/*WebGLContext.GREATER*/;
		/**深度测试函数枚举_不等于时通过。*/
		public static const DEPTHTEST_NOTEQUAL:int = 0x0205/*WebGLContext.NOTEQUAL*/;
		/**深度测试函数枚举_大于等于时通过。*/
		public static const DEPTHTEST_GEQUAL:int = 0x0206/*WebGLContext.GEQUAL*/;
		/**深度测试函数枚举_总是通过。*/
		public static const DEPTHTEST_ALWAYS:int = 0x0207/*WebGLContext.ALWAYS*/;
		
		/**@private 材质级着色器宏定义,透明测试。*/
		public static var SHADERDEFINE_ALPHATEST:int=0x1;
		
		/**@private 着色器变量,透明测试值。*/
		public static const ALPHATESTVALUE:int = 0;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines();
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_ALPHATEST = shaderDefines.registerDefine("ALPHATEST");
		}
		
		/** @private */
		private var _shader:Shader3D;
		/** @private */
		private var _shaderCompile:ShaderCompile3D;
		/** @private */
		private var _shaderDefineValue:int;
		/** @private */
		private var _disablePublicShaderDefine:int;
		/** @private */
		private var _alphaTest:Boolean;
		/** @private */
		private var _shaderValues:ValusArray;
		/** @private */
		private var _values:Array;
		
		/**渲染剔除状态。*/
		public var cull:int;
		/**透明混合。*/
		public var blend:int;
		/**源混合参数,在blend为BLEND_ENABLE_ALL时生效。*/
		public var srcBlend:int;
		/**目标混合参数,在blend为BLEND_ENABLE_ALL时生效。*/
		public var dstBlend:int;
		/**RGB源混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var srcBlendRGB:int;
		/**RGB目标混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var dstBlendRGB:int;
		/**Alpha源混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var srcBlendAlpha:int;
		/**Alpha目标混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var dstBlendAlpha:int;
		/**混合常量颜色。*/
		public var blendConstColor:Vector4;
		/**混合方程。*/
		public var blendEquation:int;
		/**RGB混合方程。*/
		public var blendEquationRGB:int;
		/**Alpha混合方程。*/
		public var blendEquationAlpha:int;
		/**深度测试函数。*/
		public var depthTest:int;
		/**是否深度写入。*/
		public var depthWrite:Boolean;
		/** 所属渲染队列. */
		public var renderQueue:int;
		
		/** @private */
		public var _conchMaterial:*;//NATIVE
		
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
		 * 获取是否透明裁剪。
		 * @return 是否透明裁剪。
		 */
		public function get alphaTest():Boolean {
			return _alphaTest;
		}
		
		/**
		 * 设置是否透明裁剪。
		 * @param value 是否透明裁剪。
		 */
		public function set alphaTest(value:Boolean):void {
			_alphaTest = value;
			if (value)
				_addShaderDefine(BaseMaterial.SHADERDEFINE_ALPHATEST);
			else
				_removeShaderDefine(BaseMaterial.SHADERDEFINE_ALPHATEST);
		}
		
		/**
		 * 创建一个 <code>BaseMaterial</code> 实例。
		 */
		public function BaseMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_shaderDefineValue = 0;
			_disablePublicShaderDefine = 0;
			_shaderValues = new ValusArray();
			_values = [];
			renderQueue = RenderQueue.OPAQUE;
			_alphaTest = false;
			cull = CULL_BACK;
			blend = BLEND_DISABLE;
			srcBlend = BLENDPARAM_ONE;
			dstBlend = BLENDPARAM_ZERO;
			srcBlendRGB = BLENDPARAM_ONE;
			dstBlendRGB = BLENDPARAM_ZERO;
			srcBlendAlpha = BLENDPARAM_ONE;
			dstBlendAlpha = BLENDPARAM_ZERO;
			blendConstColor = new Vector4(1, 1, 1, 1);
			blendEquation = BLENDEQUATION_ADD;
			blendEquationRGB = BLENDEQUATION_ADD;
			blendEquationAlpha = BLENDEQUATION_ADD;
			depthTest = DEPTHTEST_LESS;
			depthWrite = true;
		}
		
		/**
		 * 增加Shader宏定义。
		 * @param value 宏定义。
		 */
		protected function _addShaderDefine(value:int):void {
			_shaderDefineValue |= value;
		}
		
		/**
		 * 移除Shader宏定义。
		 * @param value 宏定义。
		 */
		protected function _removeShaderDefine(value:int):void {
			_shaderDefineValue &= ~value;
		}
		
		/**
		 * 增加禁用宏定义。
		 * @param value 宏定义。
		 */
		protected function _addDisablePublicShaderDefine(value:int):void {
			_disablePublicShaderDefine |= value;
		}
		
		/**
		 * 移除禁用宏定义。
		 * @param value 宏定义。
		 */
		protected function _removeDisablePublicShaderDefine(value:int):void {
			_disablePublicShaderDefine &= ~value;
		}
		
		/**
		 * 设置Buffer。
		 * @param	shaderIndex shader索引。
		 * @param	buffer  buffer数据。
		 */
		protected function _setBuffer(shaderIndex:int, buffer:Float32Array):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, buffer);
			_values[shaderIndex] = buffer;
		}
		
		/**
		 * 获取Buffer。
		 * @param	shaderIndex shader索引。
		 * @return
		 */
		protected function _getBuffer(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置矩阵。
		 * @param	shaderIndex shader索引。
		 * @param	matrix4x4  矩阵。
		 */
		protected function _setMatrix4x4(shaderIndex:int, matrix4x4:Matrix4x4):void {
			_shaderValues.setValue(shaderIndex, matrix4x4 ? matrix4x4.elements : null);
			_values[shaderIndex] = matrix4x4;
		}
		
		/**
		 * 获取矩阵。
		 * @param	shaderIndex shader索引。
		 * @return  矩阵。
		 */
		protected function _getMatrix4x4(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置整型。
		 * @param	shaderIndex shader索引。
		 * @param	i 整形。
		 */
		protected function _setInt(shaderIndex:int, i:int):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, i);
			_values[shaderIndex] = i;
		}
		
		/**
		 * 获取整形。
		 * @param	shaderIndex shader索引。
		 * @return  整形。
		 */
		protected function _getInt(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置浮点。
		 * @param	shaderIndex shader索引。
		 * @param	i 浮点。
		 */
		protected function _setNumber(shaderIndex:int, number:Number):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, number);
			_values[shaderIndex] = number;
		}
		
		/**
		 * 获取浮点。
		 * @param	shaderIndex shader索引。
		 * @return  浮点。
		 */
		protected function _getNumber(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置布尔。
		 * @param	shaderIndex shader索引。
		 * @param	b 布尔。
		 */
		protected function _setBool(shaderIndex:int, b:Boolean):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, b);
			_values[shaderIndex] = b;
		}
		
		/**
		 * 获取布尔。
		 * @param	shaderIndex shader索引。
		 * @return  布尔。
		 */
		protected function _getBool(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置二维向量。
		 * @param	shaderIndex shader索引。
		 * @param	vector2 二维向量。
		 */
		protected function _setVector2(shaderIndex:int, vector2:Vector2):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, vector2 ? vector2.elements : null);
			_values[shaderIndex] = vector2;
		}
		
		/**
		 * 获取二维向量。
		 * @param	shaderIndex shader索引。
		 * @return 二维向量。
		 */
		protected function _getVector2(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置颜色。
		 * @param	shaderIndex shader索引。
		 * @param	color 颜色向量。
		 */
		protected function _setColor(shaderIndex:int, color:*):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, color ? color.elements : null);
			_values[shaderIndex] = color;
		}
		
		/**
		 * 获取颜色。
		 * @param	shaderIndex shader索引。
		 * @return 颜色向量。
		 */
		protected function _getColor(shaderIndex:int):* {
			return _values[shaderIndex];
		}
		
		/**
		 * 设置纹理。
		 * @param	shaderIndex shader索引。
		 * @param	texture 纹理。
		 */
		protected function _setTexture(shaderIndex:int, texture:BaseTexture):void {
			var lastValue:BaseTexture = _values[shaderIndex];
			_values[shaderIndex] = texture;
			_shaderValues.setValue(shaderIndex, texture);
			
			if (referenceCount > 0) {
				(lastValue) && (lastValue._removeReference());
				(texture) && (texture._addReference());
			}
		}
		
		/**
		 * 获取纹理。
		 * @param	shaderIndex shader索引。
		 * @return  纹理。
		 */
		protected function _getTexture(shaderIndex:int):BaseTexture {
			return _values[shaderIndex];
		}
		
		/**
		 * 上传材质。
		 * @param state 相关渲染状态。
		 * @param bufferUsageShader Buffer相关绑定。
		 * @param shader 着色器。
		 * @return  是否成功。
		 */
		public function _upload():void {
			_shader.uploadMaterialUniforms(_shaderValues.data);
		}
		
		/**
		 * @private
		 */
		public function _getShader(sceneDefineValue:int, vertexDefineValue:int, spriteDefineValue:int):Shader3D {
			var publicDefineValue:int = (sceneDefineValue | vertexDefineValue) & (~_disablePublicShaderDefine);
			_shader = _shaderCompile.withCompile(publicDefineValue, spriteDefineValue, _shaderDefineValue);
			return _shader;
		}
		
		/**
		 * 设置渲染相关状态。
		 */
		public function _setRenderStateBlendDepth():void {
			var gl:WebGLContext = WebGL.mainContext;
			
			WebGLContext.setDepthMask(gl, depthWrite);
			if (depthTest === DEPTHTEST_OFF)
				WebGLContext.setDepthTest(gl, false);
			else {
				WebGLContext.setDepthTest(gl, true);
				WebGLContext.setDepthFunc(gl, depthTest);
			}
			
			switch (blend) {
			case BLEND_DISABLE: 
				WebGLContext.setBlend(gl, false);
				break;
			case BLEND_ENABLE_ALL: 
				WebGLContext.setBlend(gl, true);
				WebGLContext.setBlendFunc(gl, srcBlend, dstBlend);
				break;
			case BLEND_ENABLE_SEPERATE: 
				WebGLContext.setBlend(gl, true);
				//TODO:
				break;
			}
		}
		
		/**
		 * 设置渲染相关状态。
		 */
		public function _setRenderStateFrontFace(isTarget:Boolean, transform:Transform3D):void {
			var gl:WebGLContext = WebGL.mainContext;
			var forntFace:int;
			switch (cull) {
			case CULL_NONE: 
				WebGLContext.setCullFace(gl, false);
				break;
			case CULL_FRONT: 
				WebGLContext.setCullFace(gl, true);
				if (isTarget) {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CCW;
					else
						forntFace = WebGLContext.CW;
				} else {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CW;
					else
						forntFace = WebGLContext.CCW;
				}
				WebGLContext.setFrontFace(gl, forntFace);
				break;
			case CULL_BACK: 
				WebGLContext.setCullFace(gl, true);
				if (isTarget) {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CW;
					else
						forntFace = WebGLContext.CCW;
				} else {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CCW;
					else
						forntFace = WebGLContext.CW;
				}
				WebGLContext.setFrontFace(gl, forntFace);
				break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var jsonData:Object = data[0];
			var textureMap:Object = data[1];
			switch (jsonData.version) {
			case "LAYAMATERIAL:01": 
				var i:int, n:int;
				var props:Object = jsonData.props;
				for (var key:String in props) {
					switch (key) {
					case "vectors": 
						var vectors:Array = props[key];
						for (i = 0, n = vectors.length; i < n; i++) {
							var vector:Object = vectors[i];
							var vectorValue:Array = vector.value;
							switch (vectorValue.length) {
							case 2: 
								this[vector.name] = new Vector2(vectorValue[0], vectorValue[1]);
								break;
							case 3: 
								this[vector.name] = new Vector3(vectorValue[0], vectorValue[1], vectorValue[2]);
								break;
							case 4: 
								this[vector.name] = new Vector4(vectorValue[0], vectorValue[1], vectorValue[2], vectorValue[3]);
								break;
							default: 
								throw new Error("BaseMaterial:unkonwn color length.");
							}
						}
						break;
					case "textures": 
						var textures:Array = props[key];
						for (i = 0, n = textures.length; i < n; i++) {
							var texture:Object = textures[i];
							var path:String = texture.path;
							(path) && (this[texture.name] = Loader.getRes(textureMap[path]));
						}
						break;
					case "defines": 
						var defineNames:Array = props[key];
						for (i = 0, n = defineNames.length; i < n; i++) {
							var define:int = _shaderCompile.getMaterialDefineByName(defineNames[i]);
							_addShaderDefine(define);
						}
						break;
					default: 
						this[key] = props[key];
					}
				}
				break;
			default: 
				throw new Error("BaseMaterial:unkonwn version.");
			}
			_endLoaded();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addReference():void {
			super._addReference();
			var valueCount:int = _values.length;
			for (var i:int = 0, n:int = valueCount; i < n; i++) {//TODO:需要优化,杜绝is判断，慢
				var value:* = _values[i];
				if (value && value is BaseTexture)
					(value as BaseTexture)._addReference();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _removeReference():void {
			super._removeReference();
			var valueCount:int = _values.length;
			for (var i:int = 0, n:int = valueCount; i < n; i++) {//TODO:需要优化,杜绝is判断，慢
				var value:* = _values[i];
				if (value && value is BaseTexture)
					(value as BaseTexture)._removeReference();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function disposeResource():void {
			blendConstColor = null;
			_shader = null;
			_shaderValues = null;
			
			var valueCount:int = _values.length;
			for (var i:int = 0, n:int = valueCount; i < n; i++) {//TODO:需要优化,杜绝is判断，慢
				var value:* = _values[i];
				if (value && value is BaseTexture)
					(value as BaseTexture)._removeReference();
			}
			_values = null;
		}
		
		/**
		 * 设置使用Shader名字。
		 * @param name 名称。
		 */
		public function setShaderName(name:String):void {
			var nameID:int = Shader3D.nameKey.getID(name);
			if (nameID === -1)
				throw new Error("BaseMaterial: unknown shader name.");
			_shaderCompile = ShaderCompile3D._preCompileShader[nameID];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destBaseMaterial:BaseMaterial = destObject as BaseMaterial;
			destBaseMaterial.name = name;
			destBaseMaterial.cull = cull;
			destBaseMaterial.blend = blend;
			destBaseMaterial.srcBlend = srcBlend;
			destBaseMaterial.dstBlend = dstBlend;
			destBaseMaterial.srcBlendRGB = srcBlendRGB;
			destBaseMaterial.dstBlendRGB = dstBlendRGB;
			destBaseMaterial.srcBlendAlpha = srcBlendAlpha;
			destBaseMaterial.dstBlendAlpha = dstBlendAlpha;
			blendConstColor.cloneTo(destBaseMaterial.blendConstColor);
			destBaseMaterial.blendEquation = blendEquation;
			destBaseMaterial.blendEquationRGB = blendEquationRGB;
			destBaseMaterial.blendEquationAlpha = blendEquationAlpha;
			destBaseMaterial.depthTest = depthTest;
			destBaseMaterial.depthWrite = depthWrite;
			
			destBaseMaterial.renderQueue = renderQueue;
			destBaseMaterial._shader = _shader;
			destBaseMaterial._disablePublicShaderDefine = _disablePublicShaderDefine;
			destBaseMaterial._shaderDefineValue = _shaderDefineValue;
			
			var i:int, n:int;
			var destShaderValues:ValusArray = destBaseMaterial._shaderValues;
			destBaseMaterial._shaderValues.data.length = _shaderValues.data.length;
			
			var valueCount:int = _values.length;
			var destValues:Array = destBaseMaterial._values;
			destValues.length = valueCount;
			for (i = 0, n = valueCount; i < n; i++) {//TODO:需要优化,杜绝is判断，慢
				var value:* = _values[i];
				if (value) {
					if (value is Number) {
						destValues[i] = value;
						destShaderValues.data[i] = value;
					} else if (value is int) {
						destValues[i] = value;
						destShaderValues.data[i] = value;
					} else if (value is Boolean) {
						destValues[i] = value;
						destShaderValues.data[i] = value;
					} else if (value is Vector2) {
						var v2:Vector2 = (destValues[i]) || (destValues[i] = new Vector2());
						(value as Vector2).cloneTo(v2);
						destShaderValues.data[i] = v2.elements;
					} else if (value is Vector3) {
						var v3:Vector3 = (destValues[i]) || (destValues[i] = new Vector3());
						(value as Vector3).cloneTo(v3);
						destShaderValues.data[i] = v3.elements;
					} else if (value is Vector4) {
						var v4:Vector4 = (destValues[i]) || (destValues[i] = new Vector4());
						(value as Vector4).cloneTo(v4);
						destShaderValues.data[i] = v4.elements;
					} else if (value is Matrix4x4) {
						var mat:Matrix4x4 = (destValues[i]) || (destValues[i] = new Matrix4x4());
						(value as Matrix4x4).cloneTo(mat);
						destShaderValues.data[i] = mat.elements;
					} else if (value is BaseTexture) {
						destValues[i] = value;
						destShaderValues.data[i] = value;
					}
				}
			}
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destBaseMaterial:BaseMaterial = __JS__("new this.constructor()");
			cloneTo(destBaseMaterial);
			return destBaseMaterial;
		}
	}

}