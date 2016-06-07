package
{
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.particle.Particle2D;
	import laya.particle.ParticleSettings;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;

	public class Particle_T2
	{
		private var sp:Particle2D;

		public function Particle_T2()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Stat.show();
			
			Laya.loader.load("res/particles/RadiusMode.part", Handler.create(this, onAssetsLoaded), null, Loader.JSON);
		}

		public function onAssetsLoaded(settings:ParticleSettings):void
		{
			sp = new Particle2D(settings);
			sp.emitter.start(); 	
			sp.play();
			Laya.stage.addChild(sp);

			this.sp.x = Laya.stage.width / 2;
			this.sp.y = Laya.stage.height / 2;
		}
	}
}
