package laya.particle 
{
	import laya.display.Sprite;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ParticlePlayer extends Sprite 
	{
		private var _particle:Particle2D;
		public function ParticlePlayer() 
		{
			
		}
		public function set file(path:String):void
		{
			loadParticleFile(path);
		}
		public function loadParticleFile(fileName:String):void
		{
			Laya.loader.load(fileName, Handler.create(this, setParticleSetting),null,Loader.JSOn);
		}
		public function setParticleSetting(settings:ParticleSettings):void
		{
			if (_particle)
			{
				_particle.stop();
				_particle.removeSelf();
			}
			_particle = new Particle2D(settings);
			_particle.emitter.start();
			_particle.play();
			addChild(_particle);
		}
	}

}