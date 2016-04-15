package laya.particle 
{
	import laya.display.Sprite;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ParticlePlayer extends Sprite 
	{
		
		public function ParticlePlayer() 
		{
			
		}
		private var particle:Particle2D;
		public function set file(path:String):void
		{
			loadParticleFile(path);
		}
		public function loadParticleFile(fileName:String):void
		{
			Laya.loader.load(fileName, Handler.create(this, setParticleSetting));
		}
		public function setParticleSetting(settings:ParticleSettings):void
		{
			if (particle)
			{
				particle.stop();
				particle.removeSelf();
			}
			particle = new Particle2D(settings);
			particle.emitter.start();
			particle.play();
			addChild(particle);
		}
	}

}