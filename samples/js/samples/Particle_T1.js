(function()
{
	var Stage            = Laya.Stage;
	var Loader           = Laya.Loader;
	var Particle2D       = Laya.Particle2D;
	var ParticleSettings = Laya.ParticleSettings;
	var Browser          = Laya.Browser;
	var Handler          = Laya.Handler;
	var Stat             = Laya.Stat;
	var WebGL            = Laya.WebGL;

	var sp;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Stat.show();

		Laya.loader.load("res/particles/GravityMode.part", Handler.create(this, onAssetsLoaded), null, Loader.JSON);
	})();

	function onAssetsLoaded(settings)
	{
		sp = new Particle2D(settings);
		sp.emitter.start();
		sp.play();
		Laya.stage.addChild(sp);

		sp.x = Laya.stage.width / 2;
		sp.y = Laya.stage.height / 2;
	}
})();