package laya.d3.core.material {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.SubShader;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.net.Loader;
	import laya.resource.Resource;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * <code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
	 */
	public class BaseMaterial extends Resource implements IClone {
		/** 渲染队列_不透明。*/
		public static const RENDERQUEUE_OPAQUE:int = 2000;
		/** 渲染队列_阿尔法裁剪。*/
		public static const RENDERQUEUE_ALPHATEST:int = 2450;
		/** 渲染队列_透明。*/
		public static const RENDERQUEUE_TRANSPARENT:int = 3000;
		
		/**@private 着色器变量,透明测试值。*/
		public static const ALPHATESTVALUE:int = Shader3D.propertyNameToID("u_AlphaTestValue");
		
		/**@private 材质级着色器宏定义,透明测试。*/
		public static var SHADERDEFINE_ALPHATEST:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines();
		
		/**
		 * 加载材质。
		 * @param url 材质地址。
		 * @param complete 完成回掉。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.MATERIAL);
		}
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_ALPHATEST = shaderDefines.registerDefine("ALPHATEST");
		}
		
		/**
		 * @inheritDoc
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):BaseMaterial {
			var jsonData:Object = data;
			var props:Object = jsonData.props;
			
			var material:BaseMaterial;
			var classType:String = props.type;
			var clasPaths:Array = classType.split('.');
			var clas:Class = Browser.window;
			clasPaths.forEach(function(cls:*):void {
				clas = clas[cls];
			});
			if (typeof(clas) == 'function')
				material = new clas();
			else
				throw('_getSprite3DHierarchyInnerUrls 错误: ' + data.type + ' 不是类');
			
			switch (jsonData.version) {
			case "LAYAMATERIAL:01": //兼容
				props = jsonData.props;
				for (key in props) {
					switch (key) {
					case "vectors": 
						vectors = props[key];
						for (i = 0, n = vectors.length; i < n; i++) {
							vector = vectors[i];
							vectorValue = vector.value;
							switch (vectorValue.length) {
							case 2: 
								material[vector.name] = new Vector2(vectorValue[0], vectorValue[1]);
								break;
							case 3: 
								material[vector.name] = new Vector3(vectorValue[0], vectorValue[1], vectorValue[2]);
								break;
							case 4: 
								material[vector.name] = new Vector4(vectorValue[0], vectorValue[1], vectorValue[2], vectorValue[3]);
								break;
							default: 
								throw new Error("BaseMaterial:unkonwn color length.");
							}
						}
						break;
					case "textures": 
						textures = props[key];
						for (i = 0, n = textures.length; i < n; i++) {
							texture = textures[i];
							path = texture.path;
							(path) && (material[texture.name] = Loader.getRes(path));
						}
						break;
					case "defines": 
						defineNames = props[key];
						for (i = 0, n = defineNames.length; i < n; i++) {
							define = material._shader.getSubShaderAt(0).getMaterialDefineByName(defineNames[i]);//TODO:是否取消defines
							material._defineDatas.add(define);
						}
						break;
					case "cull": 
					case "blend": 
					case "srcBlend": 
					case "dstBlend": 
					case "depthWrite": 
						var value:* = props[key];
						for (i = 0, n = material._renderStates.length; i < n; i++)
							material._renderStates[i][key] = value;
						break;
					case "renderQueue": 
						var queue:int = props[key];
						switch (queue) {
						case 1: 
							material.renderQueue = RENDERQUEUE_OPAQUE;
							break;
						case 2: 
							material.renderQueue = RENDERQUEUE_TRANSPARENT;
							break;
						default: 
							material[key] = props[key];
						}
						break;
					default: 
						material[key] = props[key];
					}
				}
				break;
			case "LAYAMATERIAL:02": 
				var i:int, n:int;
				
				for (var key:String in props) {
					switch (key) {
					case "vectors": 
						var vectors:Array = props[key];
						for (i = 0, n = vectors.length; i < n; i++) {
							var vector:Object = vectors[i];
							var vectorValue:Array = vector.value;
							switch (vectorValue.length) {
							case 2: 
								material[vector.name] = new Vector2(vectorValue[0], vectorValue[1]);
								break;
							case 3: 
								material[vector.name] = new Vector3(vectorValue[0], vectorValue[1], vectorValue[2]);
								break;
							case 4: 
								material[vector.name] = new Vector4(vectorValue[0], vectorValue[1], vectorValue[2], vectorValue[3]);
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
							(path) && (material[texture.name] = Loader.getRes(path));
						}
						break;
					case "defines": 
						var defineNames:Array = props[key];
						for (i = 0, n = defineNames.length; i < n; i++) {
							var define:int = material._shader.getSubShaderAt(0).getMaterialDefineByName(defineNames[i]);//TODO:是否取消defines
							material._defineDatas.add(define);
						}
						break;
					case "renderStates": 
						var renderStatesData:Array = props[key];
						for (i = 0, n = renderStatesData.length; i < n; i++) {
							var renderStateData:Object = renderStatesData[i];
							var renderState:Object = material._renderStates[i];
							for (var stateKey:String in renderStateData)
								renderState[stateKey] = renderStateData[stateKey];
						}
						break;
					default: 
						material[key] = props[key];
					}
				}
				break;
			default: 
				throw new Error("BaseMaterial:unkonwn version.");
			}
			return material;
		}
		
		/** @private */
		private var _alphaTest:Boolean;
		/** @private */
		public var _renderStates:Vector.<RenderState>;
		
		/** @private */
		public var _defineDatas:DefineDatas;
		/** @private */
		public var _disablePublicDefineDatas:DefineDatas;
		/** @private */
		public var _shader:Shader3D;
		/** @private */
		public var _shaderValues:ShaderData;//TODO:剥离贴图ShaderValue
		
		/** 所属渲染队列. */
		public var renderQueue:int;
		
		/**
		 * 获取透明测试模式裁剪值。
		 * @return 透明测试模式裁剪值。
		 */
		public function get alphaTestValue():Number {
			return _shaderValues.getNumber(ALPHATESTVALUE);
		}
		
		/**
		 * 设置透明测试模式裁剪值。
		 * @param value 透明测试模式裁剪值。
		 */
		public function set alphaTestValue(value:Number):void {
			_shaderValues.setNumber(ALPHATESTVALUE, value);
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
				_defineDatas.add(BaseMaterial.SHADERDEFINE_ALPHATEST);
			else
				_defineDatas.remove(BaseMaterial.SHADERDEFINE_ALPHATEST);
		}
		
		/**
		 * 创建一个 <code>BaseMaterial</code> 实例。
		 */
		public function BaseMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_defineDatas = new DefineDatas();
			_disablePublicDefineDatas = new DefineDatas();
			_shaderValues = new ShaderData(this);
			renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
			_alphaTest = false;
			_renderStates = new Vector.<RenderState>();
		}
		
		/**
		 * @private
		 */
		private function _removeTetxureReference():void {
			var data:Object = _shaderValues._data;
			for (var k:String in data) {
				var value:* = data[k];
				if (value && value is BaseTexture)//TODO:需要优化,杜绝is判断，慢
					(value as BaseTexture)._removeReference();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addReference(count:int = 1):void {
			super._addReference(count);
			var data:Object = _shaderValues._data;
			for (var k:String in data) {
				var value:* = data[k];
				if (value && value is BaseTexture)//TODO:需要优化,杜绝is判断，慢
					(value as BaseTexture)._addReference();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _removeReference(count:int = 1):void {
			super._removeReference(count);
			_removeTetxureReference();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _disposeResource():void {
			if (_referenceCount > 0)
				_removeTetxureReference();
			_shaderValues = null;
		}
		
		/**
		 * 设置使用Shader名字。
		 * @param name 名称。
		 */
		public function setShaderName(name:String):void {
			_shader = Shader3D._preCompileShader[name];
			if (!_shader)
				throw new Error("BaseMaterial: unknown shader name.");
			var passCount:int = _shader.getSubShaderAt(0)._passes.length;//TODO:需要调整,现在默认取子ShaderAt0
			_renderStates.length = passCount;
			for (var i:int = 0; i < passCount; i++)
				(_renderStates[i]) || (_renderStates[i] = new RenderState());
		}
		
		/**
		 * 获取渲染状态。
		 * @param passIndex 所关联Shader的pass索引。
		 */
		public function getRenderState(passIndex:int = 0):RenderState {
			return _renderStates[passIndex];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destBaseMaterial:BaseMaterial = destObject as BaseMaterial;
			destBaseMaterial.name = name;
			destBaseMaterial.renderQueue = renderQueue;
			_disablePublicDefineDatas.cloneTo(destBaseMaterial._disablePublicDefineDatas);
			_defineDatas.cloneTo(destBaseMaterial._defineDatas);
			_shaderValues.cloneTo(destBaseMaterial._shaderValues);
			
			var destRenderStates:Vector.<RenderState> = destObject._renderStates;
			for (var i:int = 0, n:int = _renderStates.length; i < n; i++)
				_renderStates[i].cloneTo(destRenderStates[i]);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:BaseMaterial = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	}

}