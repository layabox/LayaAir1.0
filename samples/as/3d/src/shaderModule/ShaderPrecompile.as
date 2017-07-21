package shaderModule {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class ShaderPrecompile {
		
		public function ShaderPrecompile() {
			
			Laya3D.init(0, 0, true);
			//开启Shader编译调试模式，可在输出宏定义编译值。
			ShaderCompile3D.debugMode = true;
			
			var sc:ShaderCompile3D = ShaderCompile3D.get("SIMPLE");
			//部分低端移动设备不支持高精度shader,所以如果在PC端或高端移动设备输出的宏定义值需做判断移除高精度宏定义
			if (WebGL.frameShaderHighPrecision)
				sc.precompileShaderWithShaderDefine(73,4,20);
			else
				sc.precompileShaderWithShaderDefine(73 - ShaderCompile3D.SHADERDEFINE_FSHIGHPRECISION,4,20);
			
		}
	}
}