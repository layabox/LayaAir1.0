package laya.particle.shader {
	import laya.webgl.shader.Shader;
	
	/**
	 *  @private
	 */
	public class ParticleShader extends Shader {
		public static var vs:String = __INCLUDESTR__("files/Particle.vs");
		public static var ps:String = __INCLUDESTR__("files/Particle.ps");
		
		public function ParticleShader() {
			super(vs, ps, "ParticleShader");
		}
	}
}