package
{
	import laya.display.Stage;
	import laya.events.Event;
	import laya.particle.Particle2D;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;

	public class Particle_T3
	{
		private var sp:Particle2D;

		public function Particle_T3()
		{
			Laya.init(Browser.width, Browser.height, WebGL);
			Laya.stage.bgColor="#000000"
			Laya.stage.sizeMode=Stage.SIZE_FULL;
			Laya.stage.on(Event.RESIZE, this, this.onResize);
			Stat.show();
			this.loadParticleFile("res/particles/particleNew.json");
		}

		public function loadParticleFile(fileName:string):void
		{
			Laya.loader.load(fileName, Handler.create(this, this.test));
		}

		public function test(settings:ParticleSettings):void
		{
			if (this.sp)
			{
				this.sp.stop();
				this.sp.removeSelf();
			}
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
			this.sp.y=Laya.stage.height / 2;
		}
	}
}
