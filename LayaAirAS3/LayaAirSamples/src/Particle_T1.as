package
{
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.particle.Particle2D;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;

	public class Particle_T1
	{
		private var sp:Particle2D;

		public function Particle_T1()
		{
			Laya.init(Browser.width, Browser.height, WebGL);
			Stat.show();
			
			Laya.stage.bgColor="#000000"
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.on(Event.RESIZE, this, this.onResize);
			
			Laya.loader.load("res/particles/GravityMode.part", Handler.create(this, onAssetsLoaded), null, Loader.JSOn);
		}

		public function onAssetsLoaded(settings:ParticleSettings):void
		{
			this.sp=new Particle2D(settings);
			this.sp.emitter.start(); 	
			this.sp.play();
			onResize(null);
			Laya.stage.addChild(this.sp);
		}

		private function onResize(e:Event):void
		{
			if (!this.sp)
				return;
				
			this.sp.x=Laya.stage.width / 2;
			this.sp.y = Laya.stage.height / 2;
		}
	}
}
