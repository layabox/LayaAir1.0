package laya.layagl {
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * 普通命令执行器
	 */
	public class LayaGLRunner {
		
		/**
		 * @private
		 * 批量上传ShaderUniforms。
		 */
		//TODO:coverage
		static public function uploadShaderUniforms(layaGL:LayaGL, commandEncoder:CommandEncoder, shaderData:*, uploadUnTexture:Boolean):int {
			var data:* = shaderData._data;
			var shaderUniform:Array = commandEncoder.getArrayData();
			var shaderCall:int = 0;
			for (var i:int = 0, n:int = shaderUniform.length; i < n; i++) {
				var one:*/*ShaderVariable*/ = shaderUniform[i];
				if (uploadUnTexture || one.textureID !== -1) {//如uniform为纹理切换Shader时需要重新上传
					var value:* = data[one.dataOffset];
					if (value != null)
						shaderCall += one.fun.call(one.caller, one, value);
				}
			}
			return shaderCall;
		}
		
		/**
		 * @private
		 * 上传ShaderUniform。
		 */
		//TODO:coverage
		static public function uploadCustomUniform(layaGL:LayaGL, custom:Array, index:int, data:*):int {
			var shaderCall:int = 0;
			var one:*/*ShaderVariable*/ = custom[index];
			if (one && data != null)
				shaderCall += one.fun.call(one.caller, one, data);
			return shaderCall;
		}
		
		/**
		 * @private
		 * 批量上传ShaderUniforms。
		 */
		//TODO:coverage
		static public function uploadShaderUniformsForNative(layaGL:*, commandEncoder:CommandEncoder, shaderData:*):int {
			var nType:int = LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_ID;
			if ( shaderData._runtimeCopyValues.length >= 0 )
			{
				nType = LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_DATA;
			}
			var data:* = shaderData._data;
			return layaGL.uploadShaderUniforms(commandEncoder, data,nType);
		}
	
	}
}