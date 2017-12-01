var ShaderPrecompile = /** @class */ (function () {
    function ShaderPrecompile() {
        Laya3D.init(0, 0, true);
        //开启Shader编译调试模式，可在输出宏定义编译值。
        Laya.ShaderCompile3D.debugMode = true;
        var sc = Laya.ShaderCompile3D.get("SIMPLE");
        //部分低端移动设备不支持高精度shader,所以如果在PC端或高端移动设备输出的宏定义值需做判断移除高精度宏定义
        if (Laya.WebGL.shaderHighPrecision)
            sc.precompileShaderWithShaderDefine(73, 4, 20);
        else
            sc.precompileShaderWithShaderDefine(73 - Laya.ShaderCompile3D.SHADERDEFINE_HIGHPRECISION, 4, 20);
    }
    return ShaderPrecompile;
}());
new ShaderPrecompile;
