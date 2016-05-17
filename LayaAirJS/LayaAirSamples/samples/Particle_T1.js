var sp;

Laya.init(Laya.Browser.width, Laya.Browser.height, Laya.WebGL);
Laya.Stat.show();

Laya.stage.bgColor = "#000000"
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.on(Laya.Event.RESIZE, this, this.onResize);

Laya.loader.load("res/particles/GravityMode.part", Laya.Handler.create(this, onAssetsLoaded), null, Laya.Loader.JSOn);

function onAssetsLoaded(settings)
{
	this.sp = new Laya.Particle2D(settings);
	this.sp.emitter.start();
	this.sp.play();
	onResize(null);
	Laya.stage.addChild(this.sp);
}

function onResize(e)
{
	if (!this.sp)
		return;
	this.sp.x = Laya.stage.width / 2;
	this.sp.y = Laya.stage.height / 2;
}