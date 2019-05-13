package laya.d3.shader {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.ShaderCompile;
	
	/**
	 * <code>SubShader</code> 类用于创建SubShader。
	 */
	public class SubShader {
		/**@private */
		public var _attributeMap:Object;
		/**@private */
		public var _uniformMap:Object;
		/**@private */
		public var _publicDefines:Array;
		/**@private */
		public var _publicDefinesMap:Object;
		/**@private */
		public var _spriteDefines:Array;
		/**@private */
		public var _spriteDefinesMap:Object;
		/**@private */
		public var _materialDefines:Array;
		/**@private */
		public var _materialDefinesMap:Object;
		
		/**@private */
		public var _owner:Shader3D;
		/**@private */
		public var _flags:Object = {};
		/**@private */
		public var _passes:Vector.<ShaderPass> = new Vector.<ShaderPass>();
		
		/**
		 * @private
		 */
		public function SubShader(attributeMap:Object, uniformMap:Object, spriteDefines:ShaderDefines = null, materialDefines:ShaderDefines = null) {
			_publicDefines = [];
			_publicDefinesMap = {};
			_spriteDefines = [];
			_spriteDefinesMap = {};
			_materialDefines = [];
			_materialDefinesMap = {};
			_addDefines(_publicDefines, _publicDefinesMap, Shader3D._globleDefines);
			(spriteDefines) && (_addDefines(_spriteDefines, _spriteDefinesMap, spriteDefines.defines));
			(materialDefines) && (_addDefines(_materialDefines, _materialDefinesMap, materialDefines.defines));
			
			_attributeMap = attributeMap;
			_uniformMap = uniformMap;
		}
		
		/**
		 * @private
		 */
		private function _addDefines(defines:Array, definesMap:Object, supportDefines:Array):void {
			for (var k:String in supportDefines) {
				var name:String = supportDefines[k];
				var i:int = parseInt(k);
				defines[i] = name;
				definesMap[name] = i;
			}
		}
		
		/**
		 * 通过名称获取宏定义值。
		 * @param	name 名称。
		 * @return 宏定义值。
		 */
		public function getMaterialDefineByName(name:String):int {
			return _materialDefinesMap[name];
		}
		
		/**
		 *添加标记。
		 * @param key 标记键。
		 * @param value 标记值。
		 */
		public function setFlag(key:String, value:String):void {
			if (value)
				_flags[key] = value;
			else
				delete _flags[key];
		}
		
		/**
		 * 获取标记值。
		 * @return key 标记键。
		 */
		public function getFlag(key:String):String {
			return _flags[key];
		}
		
		/**
		 * @private
		 */
		public function addShaderPass(vs:String, ps:String, stateMap:Object = null):ShaderPass {
			var shaderPass:ShaderPass = new ShaderPass(this, vs, ps, stateMap);
			_passes.push(shaderPass);
			return shaderPass;
		}
	
	}

}
