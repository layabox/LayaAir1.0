package laya.particle.shader {
	import laya.webgl.shader.Shader;
	
	/**
	 *  @private
	 */
	public class ParticleShader extends Shader {
		public static var vs:String = __INCLUDESTR__("files/Particle.vs");
		public static var ps:String = __INCLUDESTR__("files/Particle.ps");
		
		//TODO:coverage
		public function ParticleShader() {
			super(vs, ps, "ParticleShader",null,['a_CornerTextureCoordinate', 0, 'a_Position', 1, 'a_Velocity', 2, 'a_StartColor', 3,
									'a_EndColor',4,'a_SizeRotation',5,'a_Radius',6,'a_Radian',7,'a_AgeAddScale',8,'a_Time',9]);
		}
	}
}