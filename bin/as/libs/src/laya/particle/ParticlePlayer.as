package laya.particle 
{
	import laya.display.Sprite;
	import laya.net.Loader;
	import laya.utils.Handler;
	/**
	 * 
	 * <code>ParticlePlayer</code> 类是粒子播放容器类
	 * 主要用于播放UI编辑器中拖放到UI上的粒子
	 * 
	 */	
	public class ParticlePlayer extends Sprite 
	{
		/**@private */
		private var _particle:Particle2D;
		/**
		 * 创建一个新的 <code>ParticlePlayer</code> 类实例。
		 * 
		 */
		public function ParticlePlayer() 
		{
			
		}
		/**
		 * 设置 粒子文件地址
		 * @param path 粒子文件地址
		 * 
		 */		
		public function set url(url:String):void
		{
			loadParticle(url);
		}
		/**
		 * 加载粒子文件 
		 * @param url 粒子文件地址
		 * 
		 */
		public function loadParticle(url:String):void
		{
			Laya.loader.load(url, Handler.create(this, setParticleSetting),null,Loader.JSON);
		}
		/**
		 * 设置粒子配置数据 
		 * @param settings 粒子配置数据
		 * 
		 */
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