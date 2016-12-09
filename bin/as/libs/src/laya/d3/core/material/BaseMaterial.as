package laya.d3.core.material {
	import laya.d3.core.IClone;
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
	import laya.resource.Resource;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * <code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
	 */
	public class BaseMaterial extends Resource implements IClone {
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
		
		/**@private 所属渲染队列。*/
		private var _renderQueue:int;
		/**@private 渲染模式。*/
		private var _renderMode:int;
		
		/** @private */
		private var _sharderNameID:int;
		/** @private */
		private var _shaderDefineValue:int;
		/** @private */
		private var _disableShaderDefineValue:int;
		/** @private */
		private var _shaderValues:ValusArray;
		
		/** @private */
		private var _textureSharderIndices:Vector.<int>;
		/** @private */
		private var _colorSharderIndices:Vector.<int>;
		/** @private */
		private var _numberSharderIndices:Vector.<int>;
		/** @private */
		private var _matrix4x4SharderIndices:Vector.<int>;
		/** @private */
		private var _textures:Vector.<BaseTexture>;
		/** @private */
		private var _colors:Vector.<*>;
		/** @private */
		private var _numbers:Vector.<Number>;
		/** @private */
		private var _matrix4x4s:Vector.<Matrix4x4>;
		
		/** @private */
		public var _isInstance:Boolean;
		/** @private */
		public var shader:Shader;
		
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
			}
			
			if (_renderMode === RENDERMODE_CUTOUT || _renderMode === RENDERMODE_CUTOUTDOUBLEFACE)
				_addShaderDefine(ShaderDefines3D.ALPHATEST);
			else
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
		}
		
		/**
		 * 创建一个 <code>BaseMaterial</code> 实例。
		 */
		public function BaseMaterial() {
			super();
			_loaded = true;
			_isInstance = false;
			_shaderDefineValue = 0;
			_disableShaderDefineValue = 0;
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
		private function _getShader(stateShaderDefines:ShaderDefines3D, vertexShaderDefineValue:int):void {
			var defineValue:int = stateShaderDefines._value | vertexShaderDefineValue | _shaderDefineValue;
			_disableShaderDefineValue && (defineValue = defineValue & (~_disableShaderDefineValue));
			stateShaderDefines._value = defineValue;
			var nameID:Number = defineValue + _sharderNameID * Shader.SHADERNAME2ID;
			shader = Shader.withCompile(_sharderNameID, stateShaderDefines.toNameDic(), nameID, null);
		}
		
		/**
		 * @private
		 */
		private function _uploadTexture(shaderIndex:int, textureSource:*):void {
			_shaderValues.data[_textureSharderIndices[shaderIndex]] = textureSource;
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
		protected function _addDisableShaderDefine(value:int):void {
			_disableShaderDefineValue |= value;
		}
		
		/**
		 * 移除禁用宏定义。
		 * @param value 宏定义。
		 */
		protected function _removeDisableShaderDefine(value:int):void {
			_disableShaderDefineValue &= ~value;
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
			_getShader(state.shaderDefines, vertexDeclaration.shaderDefineValue);
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
		override public function onAsynLoaded(url:String, data:*):void {
			var jsonData:Object = data[0];
			var textureMap:Object = data[1];
			var customHandler:Handler = Handler.create(null, Utils3D._parseMaterial, [textureMap], false);
			ClassUtils.createByJson(jsonData as Object, this, null, customHandler, null);
			customHandler.recover();
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
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destBaseMaterial:BaseMaterial = destObject as BaseMaterial;
			destBaseMaterial.name = name;
			destBaseMaterial._loaded = _loaded;
			destBaseMaterial._renderQueue = _renderQueue;
			destBaseMaterial._renderMode = _renderMode;
			destBaseMaterial.shader = shader;
			destBaseMaterial._sharderNameID = _sharderNameID;
			destBaseMaterial._disableShaderDefineValue = _disableShaderDefineValue;
			destBaseMaterial._shaderDefineValue = _shaderDefineValue;
			
			var i:int, n:int;
			var shaderDataIndex:int;
			var destShaderValues:ValusArray = destBaseMaterial._shaderValues;
			destBaseMaterial._shaderValues.length = _shaderValues.length
			
			destBaseMaterial._colorSharderIndices = _colorSharderIndices.slice();
			var colorCount:int = _colors.length;
			var destColors:Vector.<*> = destBaseMaterial._colors;
			destColors.length = colorCount;
			for (i = 0, n = colorCount; i < n; i++) {
				var destColor:* = destColors[i];
				(_colors[i] as IClone).cloneTo(destColor);
				shaderDataIndex = _colorSharderIndices[i] - 1;
				destShaderValues.data[shaderDataIndex] = _shaderValues.data[shaderDataIndex];
				destShaderValues.data[shaderDataIndex + 1] = destColor.elements;
			}
			
			destBaseMaterial._numberSharderIndices = _numberSharderIndices.slice();
			var numberCount:int = _numbers.length;
			var destNumbers:Vector.<Number> = destBaseMaterial._numbers;
			destNumbers.length = numberCount;
			for (i = 0, n = numberCount; i < n; i++) {
				var number:Number = _numbers[i];
				destNumbers[i] = number;
				shaderDataIndex = _numberSharderIndices[i] - 1;
				destShaderValues.data[shaderDataIndex] = _shaderValues.data[shaderDataIndex];
				destShaderValues.data[shaderDataIndex + 1] = number;
			}
			
			destBaseMaterial._matrix4x4SharderIndices = _matrix4x4SharderIndices.slice();
			var matrixCount:int = _matrix4x4s.length;
			var destMatrixs:Vector.<Matrix4x4> = destBaseMaterial._matrix4x4s;
			destMatrixs.length = matrixCount;
			for (i = 0, n = matrixCount; i < n; i++) {
				var destMatrix:Matrix4x4 = destMatrixs[i];
				(_matrix4x4s[i] as IClone).cloneTo(destMatrix);
				shaderDataIndex = _matrix4x4SharderIndices[i] - 1;
				destShaderValues.data[shaderDataIndex] = _shaderValues.data[shaderDataIndex];
				destShaderValues.data[shaderDataIndex + 1] = destMatrix.elements;
			}
			
			destBaseMaterial._textureSharderIndices = _textureSharderIndices.slice();
			var textureCount:int = _textures.length;
			var destTextures:Vector.<BaseTexture> = destBaseMaterial._textures;
			destTextures.length = textureCount;
			for (i = 0, n = textureCount; i < n; i++) {
				destTextures[i] = _textures[i];
				shaderDataIndex = _textureSharderIndices[i] - 1;
				destShaderValues.data[shaderDataIndex] = _shaderValues.data[shaderDataIndex];
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
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	}

}