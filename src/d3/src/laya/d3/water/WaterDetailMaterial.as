package laya.d3.water 
{
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WaterDetailMaterial extends BaseMaterial{
		static public const CURTM:int = 1;
		public static const WAVEINFO:int = 12;
		public static const WAVEINFOD:int = 13;
		public static const WAVEMAINDIR:int = 14;
		public static const TEXWAVE_UV_SCALE:int = 15;
		
		static private var _bInited:Boolean = false;
		
		private var _startTm:Number = 0;
		
		public function WaterDetailMaterial() {
			super();
			WaterDetailMaterial.init();
			setShaderName('WaterDetail');
			cull = CULL_NONE;
			_startTm = Laya.timer.currTimer;
		}
		public static function init():void {
			if ( WaterDetailMaterial._bInited) 
				return;
			WaterDetailMaterial._bInited = true;
			var attributeMap:Object = {
				'a_position': VertexElementUsage.POSITION0, 
				'a_normal': VertexElementUsage.NORMAL0, 
				'uv': VertexElementUsage.TEXTURECOORDINATE0
			};
			var uniformMap:Object = {
				'u_curTm':[CURTM, Shader3D.PERIOD_MATERIAL],//这个要改成全局的
				'u_WaveInfo':[WAVEINFO, Shader3D.PERIOD_MATERIAL],
				'u_WaveInfoD':[WAVEINFOD, Shader3D.PERIOD_MATERIAL],
				'TEXWAVE_UV_SCALE':[TEXWAVE_UV_SCALE,Shader3D.PERIOD_MATERIAL]
			};
			var WaterDetail:int = Shader3D.nameKey.add("WaterDetail");
			var vs:String = __INCLUDESTR__("WaterDetailVS.glsl");
			var ps:String = __INCLUDESTR__("WaterDetailFS.glsl");
			var shaderCompile:ShaderCompile3D = ShaderCompile3D.add(WaterDetail, vs, ps, attributeMap, uniformMap);			
		} 
		
		public function get currentTm():Number {
			return _getNumber(CURTM);
		}
		
		public function  set currentTm(v:Number):void {
			_setNumber(CURTM, v-_startTm);
		}		
		
		public function get waveInfo():Float32Array{
			return _getBuffer(WAVEINFO);
		}
		
		public function  set waveInfo(v:Float32Array):void{
			_setBuffer(WAVEINFO, v);
		}
		public function get waveInfoD():Float32Array{
			return _getBuffer(WAVEINFOD);
		}
		
		public function  set waveInfoD(v:Float32Array):void{
			_setBuffer(WAVEINFOD, v);
		}
		
		public function get texWaveUVScale():Number {
			return _getNumber(TEXWAVE_UV_SCALE);
		}
		
		public function set texWaveUVScale(v:Number):void {
			_setNumber(TEXWAVE_UV_SCALE, v);
		}
	}
}