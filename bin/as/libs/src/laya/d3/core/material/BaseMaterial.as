package laya.d3.core.material {
	import laya.d3.core.IClone;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.SolidColorTexture2D;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.Resource;
	import laya.renders.Render;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.utils.ShaderCompile;
	
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
		private var _values:Array;
		/** @private */
		private var _textureSharderIndices:Vector.<int>;
		/** @private */
		private var _shader:Shader3D;
		
		/** @private */
		protected var _shaderCompile:ShaderCompile3D;
		
		/** @private */
		public var _isInstance:Boolean;
		
		/** @private */
		public var _conchMaterial:*;//NATIVE
		
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
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
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
			_values = [];
			_textureSharderIndices = new Vector.<int>();
			if (Render.isConchNode) {//NATIVE
				_conchMaterial = __JS__("new ConchMaterial()");
			}
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @private
		 */
		private function _uploadTextures():void {//TODO:使用的时候检测
			for (var i:int = 0, n:int = _textureSharderIndices.length; i < n; i++) {
				var shaderIndex:int = _textureSharderIndices[i];
				var texture:BaseTexture = _values[shaderIndex];
				if (texture) {
					var source:* = texture.source;
					(source) ? _uploadTexture(shaderIndex, source) : _uploadTexture(shaderIndex, SolidColorTexture2D.grayTexture.source);
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _getShader(stateShaderDefines:ShaderDefines3D, vertexShaderDefineValue:int):Shader3D {
			var defineValue:int = (stateShaderDefines._value | vertexShaderDefineValue | _shaderDefineValue) & (~_disableShaderDefineValue);
			stateShaderDefines._value = defineValue;
			var nameID:Number = _sharderNameID * Shader3D.SHADERNAME2ID + defineValue;
			_shader = Shader3D.withCompile(_sharderNameID, stateShaderDefines, nameID);
			return _shader;
		}
		
		/**
		 * @private
		 */
		private function _uploadTexture(shaderIndex:int, textureSource:*):void {
			_shaderValues.data[shaderIndex] = textureSource;
		}
		
		/**
		 * 增加Shader宏定义。
		 * @param value 宏定义。
		 */
		public function _addShaderDefine(value:int):void {
			_shaderDefineValue |= value;
			if (_conchMaterial) {//NATIVE
				_conchMaterial.addShaderDefine(value);
			}
		}
		
		/**
		 * 移除Shader宏定义。
		 * @param value 宏定义。
		 */
		protected function _removeShaderDefine(value:int):void {
			_shaderDefineValue &= ~value;
			if (_conchMaterial) {//NATIVE
				_conchMaterial.removeShaderDefine(value);
			}
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
		
		/**
		 * 设置Buffer。
		 * @param	shaderIndex shader索引。
		 * @param	buffer  buffer数据。
		 */
		protected function _setBuffer(shaderIndex:int, buffer:Float32Array):void {
			var shaderValue:ValusArray = _shaderValues;
			shaderValue.setValue(shaderIndex, buffer);
			_values[shaderIndex] = buffer;
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, buffer,0);
			}
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
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, matrix4x4.elements,0);
			}
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
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, i,1);
			}
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
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, number,2);
			}
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
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, b,1);
			}
		}
		
		/**
		 * 获取布尔。
		 * @param	shaderIndex shader索引。
		 * @return  布尔。
		 */
		protected function _getBool(shaderIndex:Boolean):* {
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
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, vector2.elements,0);
			}
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
			if (_conchMaterial && color) {//NATIVE
				_conchMaterial.setShaderValue(shaderIndex, color.elements,0);
			}
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
			var shaderValue:ValusArray = _shaderValues;
			var value:* = _values[shaderIndex];
			if (!value && texture)
				_textureSharderIndices.push(shaderIndex);
			else if (value && !texture)
				_textureSharderIndices.splice(_textureSharderIndices.indexOf(shaderIndex), 1);
			
			_values[shaderIndex] = texture;
			
			if (_conchMaterial) {//NATIVE//TODO: texture index
				
				_conchMaterial.setTexture(texture._conchTexture, _textureSharderIndices.indexOf(shaderIndex), shaderIndex);
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
			_uploadTextures();
			_shader.uploadMaterialUniforms(_shaderValues.data);
		}
		
		public function _setMaterialShaderDefineParams(owner:Sprite3D,shaderDefine:ShaderDefines3D):void {
		}
		
		public function _setMaterialShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
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
			_sharderNameID = Shader3D.nameKey.get(name);
			_shaderCompile = Shader3D._preCompileShader[Shader3D.SHADERNAME2ID * _sharderNameID];
			if (_conchMaterial) {//NATIVE
				_conchMaterial.setShader(_shaderCompile._conchShader);
			}
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
			destBaseMaterial._shader = _shader;
			destBaseMaterial._sharderNameID = _sharderNameID;
			destBaseMaterial._disableShaderDefineValue = _disableShaderDefineValue;
			destBaseMaterial._shaderDefineValue = _shaderDefineValue;
			
			var i:int, n:int;
			var destShaderValues:ValusArray = destBaseMaterial._shaderValues;
			destBaseMaterial._shaderValues.data.length = _shaderValues.data.length;
			
			var valueCount:int = _values.length;
			var destValues:Array = destBaseMaterial._values;
			destValues.length = valueCount;
			for (i = 0, n = valueCount; i < n; i++) {
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
					}
				}
			}
			destBaseMaterial._textureSharderIndices = _textureSharderIndices.slice();
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