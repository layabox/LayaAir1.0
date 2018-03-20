package laya.particle.shader.value
{
	import laya.particle.shader.ParticleShader;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.value.Value2D;

	/**
	 *  @private 
	 */
	public class ParticleShaderValue extends Value2D
	{
		private static var pShader:ParticleShader=new ParticleShader();
		
		public var a_CornerTextureCoordinate:Array=[4, WebGLContext.FLOAT, false, 116, 0];
		public var a_Position:Array=[3, WebGLContext.FLOAT, false, 116, 16];
		public var a_Velocity:Array=[3, WebGLContext.FLOAT, false, 116, 28];
		public var a_StartColor:Array=[4, WebGLContext.FLOAT, false, 116, 40];
		public var a_EndColor:Array=[4, WebGLContext.FLOAT, false, 116, 56];
		public var a_SizeRotation:Array=[3, WebGLContext.FLOAT, false, 116, 72];
		public var a_Radius:Array = [2, WebGLContext.FLOAT, false, 116, 84];
		public var a_Radian:Array=[4, WebGLContext.FLOAT, false, 116, 92];
		public var a_AgeAddScale:Array=[1, WebGLContext.FLOAT, false, 116, 108];
		public var a_Time:Array=[1, WebGLContext.FLOAT, false, 116, 112];

		public var u_CurrentTime:Number;
		public var u_Duration:Number;
		public var u_Gravity:Float32Array; //v3
		public var u_EndVelocity:Number;
		public var u_texture:*;
		
		public function ParticleShaderValue()
		{
			super(0,0);
		}
		
		override public function upload():void
		{
			refresh();
			pShader.upload(this);
		}
	}
}