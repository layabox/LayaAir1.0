package laya.d3.core.material {
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.SolidColorTexture2D;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * <code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
	 */
	public class BaseMaterial extends EventDispatcher {
		/** @private */
		private static var _uniqueIDCounter:int = 0;
		
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
		
		/**@private 材质唯一标识id。*/
		private var _id:int;
		/**@private 是否已加载完成*/
		private var _loaded:Boolean;
		/**@private 所属渲染队列。*/
		private var _renderQueue:int;
		/**@private 渲染模式。*/
		private var _renderMode:int;
		
		/** @private */
		private var _sharderNameID:int;
		/** @private */
		private var _shaderDefine:int;
		/** @private */
		private var _disableShaderDefine:int;
		/** @private */
		private var _shaderValues:ValusArray;
		
		/** @private */
		private var _textures:Vector.<BaseTexture>;
		/** @private */
		private var _colors:Vector.<*>;
		/** @private */
		private var _numbers:Vector.<Number>;
		/** @private */
		private var _matrix4x4s:Vector.<Matrix4x4>;
		/** @private */
		private var _textureSharderIndices:Vector.<int>;
		/** @private */
		private var _colorSharderIndices:Vector.<int>;
		/** @private */
		private var _numberSharderIndices:Vector.<int>;
		/** @private */
		private var _matrix4x4SharderIndices:Vector.<int>;
		
		/** @private */
		public var _isInstance:Boolean;
		/**材质名字。*/
		public var name:String;
		/** @private */
		public var shader:Shader;
		
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
				_renderQueue = RenderQueue.ALPHA_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.ALPHA_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVE: 
				_renderQueue = RenderQueue.ALPHA_ADDTIVE_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				_renderQueue = RenderQueue.NONDEPTH_ALPHA_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.NONDEPTH_ALPHA_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				_renderQueue = RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			
			default: 
				throw new Error("Material:renderMode value error.");
				break;
			}
			
			if (_renderMode === RENDERMODE_CUTOUT || _renderMode === RENDERMODE_CUTOUTDOUBLEFACE)
				_shaderDefine |= ShaderDefines3D.ALPHATEST;
			else
				_shaderDefine = _shaderDefine & (~ShaderDefines3D.ALPHATEST);
		}
		
		/**
		 * 创建一个 <code>BaseMaterial</code> 实例。
		 */
		public function BaseMaterial() {
			_id = ++_uniqueIDCounter;
			_loaded = true;
			_isInstance = false;
			_shaderDefine = 0;
			_disableShaderDefine = 0;
			_shaderValues = new ValusArray();
			_textures = new Vector.<BaseTexture>();
			_colors = new Vector.<*>();
			_numbers = new Vector.<Number>();
			_matrix4x4s = new Vector.<Matrix4x4>();
			_textureSharderIndices = new Vector.<int>();
			_colorSharderIndices = new Vector.<int>();
			_numberSharderIndices = new Vector.<int>();
			_matrix4x4SharderIndices = new Vector.<int>();
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @private
		 */
		private function _uploadTextures():void {//TODO:使用的时候检测
			for (var i:int = 0, n:int = _textures.length; i < n; i++) {
				var texture:BaseTexture = _textures[i];
				if (texture) {
					var source:* = texture.source;
					(source) ? _uploadTexture(i, source) : _uploadTexture(i, SolidColorTexture2D.grayTexture.source);
				}
			}
		}
		
		/**
		 * 获取Shader。
		 * @param state 相关渲染状态。
		 * @return  Shader。
		 */
		private function _getShader(state:RenderState, vertexDeclaration:VertexDeclaration):void {
			var shaderDefs:ShaderDefines3D = state.shaderDefs;
			var shaderDefsValue:int = state.shaderDefs._value;
			shaderDefsValue |= vertexDeclaration.shaderDefine | _shaderDefine;
			_disableShaderDefine && (shaderDefsValue = shaderDefsValue & (~_disableShaderDefine));
			shaderDefs._value = shaderDefsValue;
			var nameID:Number = shaderDefs._value + _sharderNameID * Shader.SHADERNAME2ID;
			shader = Shader.withCompile(_sharderNameID, shaderDefs.toNameDic(), nameID, null);
		}
		
		/**
		 * @private
		 */
		private function _uploadTexture(shaderIndex:int, textureSource:BaseTexture):void {
			_shaderValues.data[_textureSharderIndices[shaderIndex]] = textureSource;
		}
		
		/**
		 * 增加Shader宏定义。
		 * @param value 宏定义。
		 */
		protected function _addShaderDefine(value:int):void {
			_shaderDefine |= value;
		}
		
		/**
		 * 移除Shader宏定义。
		 * @param value 宏定义。
		 */
		protected function _removeShaderDefine(value:int):void {
			_shaderDefine &= ~value;
		}
		
		/**
		 * 增加禁用宏定义。
		 * @param value 宏定义。
		 */
		protected function _addDisableShaderDefine(value:int):void {
			_disableShaderDefine |= value;
		}
		
		/**
		 * 移除禁用宏定义。
		 * @param value 宏定义。
		 */
		protected function _removeDisableShaderDefine(value:int):void {
			_disableShaderDefine &= ~value;
		}
		
		protected function _setMatrix4x4(matrix4x4Index:int, shaderName:String, matrix4x4:Matrix4x4):void {
			var shaderValue:ValusArray = _shaderValues;
			var index:* = _matrix4x4SharderIndices[matrix4x4Index];
			if (!index && matrix4x4) {
				_matrix4x4SharderIndices[matrix4x4Index] = index = shaderValue.length + 1;
				shaderValue.pushValue(shaderName, null);//TODO:value为空可以加个remove,从_shaderValues中彻底移除
			}
			shaderValue.data[index] = matrix4x4.elements;
			
			_matrix4x4s[matrix4x4Index] = matrix4x4;
		}
		
		protected function _getMatrix4x4(matrix4x4Index:int):* {
			return _matrix4x4s[matrix4x4Index];
		}
		
		protected function _setNumber(numberIndex:int, shaderName:String, number:Number):void {
			var shaderValue:ValusArray = _shaderValues;
			var index:* = _numberSharderIndices[numberIndex];
			if (!index && number) {
				_numberSharderIndices[numberIndex] = index = shaderValue.length + 1;
				shaderValue.pushValue(shaderName, null);//TODO:value为空可以加个remove,从_shaderValues中彻底移除
			}
			shaderValue.data[index] = number;
			
			_numbers[numberIndex] = number;
		}
		
		protected function _getNumber(numberIndex:int):* {
			return _numbers[numberIndex];
		}
		
		protected function _setColor(colorIndex:int, shaderName:String, color:*):void {
			var shaderValue:ValusArray = _shaderValues;
			var index:* = _colorSharderIndices[colorIndex];
			if (!index && color) {
				_colorSharderIndices[colorIndex] = index = shaderValue.length + 1;
				shaderValue.pushValue(shaderName, null);//TODO:value为空可以加个remove,从_shaderValues中彻底移除
			}
			shaderValue.data[index] = color.elements;
			
			_colors[colorIndex] = color;
		}
		
		protected function _getColor(colorIndex:int):* {
			return _colors[colorIndex];
		}
		
		/**
		 * 设置纹理。
		 */
		protected function _setTexture(texture:BaseTexture, textureIndex:int, shaderName:String):void {
			var shaderValue:ValusArray = _shaderValues;
			var index:* = _textureSharderIndices[textureIndex];
			if (!index && texture) {
				_textureSharderIndices[textureIndex] = index = shaderValue.length + 1;
				shaderValue.pushValue(shaderName, null);//TODO:value为空可以加个remove,从_shaderValues中彻底移除
			}
			
			_textures[textureIndex] = texture;
		}
		
		/**
		 * 获取纹理。
		 */
		protected function _getTexture(textureIndex:int):BaseTexture {
			return _textures[textureIndex];
		}
		
		/**
		 * 上传材质。
		 * @param state 相关渲染状态。
		 * @param bufferUsageShader Buffer相关绑定。
		 * @param shader 着色器。
		 * @return  是否成功。
		 */
		public function _upload(state:RenderState, vertexDeclaration:VertexDeclaration, bufferUsageShader:*):void {
			_uploadTextures();
			
			_getShader(state, vertexDeclaration);
			var shaderValue:ValusArray = state.shaderValue;
			shaderValue.pushArray(_shaderValues);
			shader.uploadArray(shaderValue.data, shaderValue.length, bufferUsageShader);
		}
		
		public function _setLoopShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			throw new Error("Marterial:must override it.");
		}
		
		/**
		 *@private
		 */
		public function onAsynLoaded(url:String, materialData:Object):void {
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(URL.formatURL(url));
			var customHandler:Handler = Handler.create(null, Utils3D._parseMaterial, null, false);
			ClassUtils.createByJson(materialData, this, null, customHandler);
			customHandler.recover();
			URL.basePath = preBasePath;
			//_loaded = true;
			event(Event.LOADED, this);
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
		public function copy(dec:BaseMaterial):BaseMaterial {
			dec._loaded = _loaded;
			dec._renderQueue = _renderQueue;
			dec._renderMode = _renderMode;
			dec._textures = _textures.slice();
			dec._colors = _colors.slice();
			dec._numbers = _numbers.slice();
			dec._matrix4x4s = _matrix4x4s.slice();
			dec._textureSharderIndices = _textureSharderIndices.slice();
			dec._colorSharderIndices = _colorSharderIndices.slice();
			dec._numberSharderIndices = _numberSharderIndices.slice();
			dec.shader = shader;
			dec._sharderNameID = _sharderNameID;
			dec._disableShaderDefine = _disableShaderDefine;
			
			dec._shaderDefine = _shaderDefine;
			dec.name = name;
			
			_shaderValues.copyTo(dec._shaderValues);
			return dec;
		}
	}

}