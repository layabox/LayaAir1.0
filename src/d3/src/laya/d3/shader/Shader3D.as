package laya.d3.shader {
	import laya.webgl.WebGL;
	import laya.webgl.utils.ShaderCompile;
	
	/**
	 * <code>Shader3D</code> 类用于创建Shader3D。
	 */
	public class Shader3D {
		/**渲染状态_剔除。*/
		public static const RENDER_STATE_CULL:int = 0;
		/**渲染状态_混合。*/
		public static const RENDER_STATE_BLEND:int = 1;
		/**渲染状态_混合源。*/
		public static const RENDER_STATE_BLEND_SRC:int = 2;
		/**渲染状态_混合目标。*/
		public static const RENDER_STATE_BLEND_DST:int = 3;
		/**渲染状态_混合源RGB。*/
		public static const RENDER_STATE_BLEND_SRC_RGB:int = 4;
		/**渲染状态_混合目标RGB。*/
		public static const RENDER_STATE_BLEND_DST_RGB:int = 5;
		/**渲染状态_混合源ALPHA。*/
		public static const RENDER_STATE_BLEND_SRC_ALPHA:int = 6;
		/**渲染状态_混合目标ALPHA。*/
		public static const RENDER_STATE_BLEND_DST_ALPHA:int = 7;
		/**渲染状态_混合常量颜色。*/
		public static const RENDER_STATE_BLEND_CONST_COLOR:int = 8;
		/**渲染状态_混合方程。*/
		public static const RENDER_STATE_BLEND_EQUATION:int = 9;
		/**渲染状态_RGB混合方程。*/
		public static const RENDER_STATE_BLEND_EQUATION_RGB:int = 10;
		/**渲染状态_ALPHA混合方程。*/
		public static const RENDER_STATE_BLEND_EQUATION_ALPHA:int = 11;
		/**渲染状态_深度测试。*/
		public static const RENDER_STATE_DEPTH_TEST:int = 12;
		/**渲染状态_深度写入。*/
		public static const RENDER_STATE_DEPTH_WRITE:int = 13;
		
		/**shader变量提交周期，自定义。*/
		public static const PERIOD_CUSTOM:int = 0;
		/**shader变量提交周期，逐材质。*/
		public static const PERIOD_MATERIAL:int = 1;
		/**shader变量提交周期，逐精灵和相机，注：因为精灵包含MVP矩阵，为复合属性，所以摄像机发生变化时也应提交。*/
		public static const PERIOD_SPRITE:int = 2;
		/**shader变量提交周期，逐相机。*/
		public static const PERIOD_CAMERA:int = 3;
		/**shader变量提交周期，逐场景。*/
		public static const PERIOD_SCENE:int = 4;
		
		/**@private */
		public static var SHADERDEFINE_HIGHPRECISION:int;
		
		/**@private */
		private static var _propertyNameCounter:int = 0;
		/**@private */
		private static var _propertyNameMap:Object = {};
		/**@private */
		private static var _publicCounter:int = 0;
		
		/**@private */
		public static var _globleDefines:Array = [];
		/**@private */
		public static var _preCompileShader:Object = {};
		
		/**是否开启调试模式。 */
		public static var debugMode:Boolean = false;
		
		/**
		 * 通过Shader属性名称获得唯一ID。
		 * @param name Shader属性名称。
		 * @return 唯一ID。
		 */
		public static function propertyNameToID(name:String):int {
			if (_propertyNameMap[name] != null) {
				return _propertyNameMap[name];
			} else {
				var id:int = _propertyNameCounter++;
				_propertyNameMap[name] = id;
				return id;
			}
		}
		
		/**
		 * @private
		 */
		public static function addInclude(fileName:String, txt:String):void {
			ShaderCompile.addInclude(fileName, txt);
		}
		
		/**
		 * @private
		 */
		public static function registerPublicDefine(name:String):int {
			var value:int = Math.pow(2, _publicCounter++);//TODO:超界处理
			_globleDefines[value] = name;
			return value;
		}
		
		/**
		 * 编译shader。
		 * @param	name Shader名称。
		 * @param   subShaderIndex 子着色器索引。
		 * @param   passIndex  通道索引。
		 * @param	publicDefine 公共宏定义值。
		 * @param	spriteDefine 精灵宏定义值。
		 * @param	materialDefine 材质宏定义值。
		 */
		public static function compileShader(name:String, subShaderIndex:int, passIndex:int, publicDefine:int, spriteDefine:int, materialDefine:int):void {
			var shader:Shader3D = Shader3D.find(name);
			if (shader) {
				var subShader:SubShader = shader.getSubShaderAt(subShaderIndex);
				if (subShader) {
					var pass:ShaderPass = subShader._passes[passIndex];
					if (pass) {
						if (WebGL.shaderHighPrecision)//部分低端移动设备不支持高精度shader,所以如果在PC端或高端移动设备输出的宏定义值需做判断移除高精度宏定义
							pass.withCompile(publicDefine, spriteDefine, materialDefine);
						else
							pass.withCompile(publicDefine - Shader3D.SHADERDEFINE_HIGHPRECISION, spriteDefine, materialDefine);
					} else {
						console.warn("Shader3D: unknown passIndex.");
					}
				} else {
					console.warn("Shader3D: unknown subShaderIndex.");
				}
			} else {
				console.warn("Shader3D: unknown shader name.");
			}
		}
		
		/**
		 * @private
		 * 添加预编译shader文件，主要是处理宏定义
		 */
		public static function add(name:String, enableInstancing:Boolean = false):Shader3D {
			return Shader3D._preCompileShader[name] = new Shader3D(name, enableInstancing);
		}
		
		/**
		 * 获取ShaderCompile3D。
		 * @param	name
		 * @return ShaderCompile3D。
		 */
		public static function find(name:String):Shader3D {
			return Shader3D._preCompileShader[name];
		}
		
		/**@private */
		public var _name:String;
		/**@private */
		public var _enableInstancing:Boolean = false;
		
		/**@private */
		public var _subShaders:Vector.<SubShader> = new Vector.<SubShader>();
		
		/**
		 * 创建一个 <code>Shader3D</code> 实例。
		 */
		public function Shader3D(name:String, enableInstancing:Boolean) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_name = name;
			_enableInstancing = enableInstancing;
		}
		
		/**
		 * 添加子着色器。
		 * @param 子着色器。
		 */
		public function addSubShader(subShader:SubShader):void {
			_subShaders.push(subShader);
			subShader._owner = this;
		}
		
		/**
		 * 在特定索引获取子着色器。
		 * @param	index 索引。
		 * @return 子着色器。
		 */
		public function getSubShaderAt(index:int):SubShader {
			return _subShaders[index];
		}
	
	}

}