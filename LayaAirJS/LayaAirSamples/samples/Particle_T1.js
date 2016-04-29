var sp;

Laya.init(Laya.Browser.width, Laya.Browser.height, Laya.WebGL);
Laya.stage.bgColor = "#000000"
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.on(Laya.Event.RESIZE, this, this.onResize);
Laya.Stat.show();
this.loadParticleFile("res/particles/GravityMode.json");

function loadParticleFile(fileName)
{
	Laya.loader.load(fileName, Laya.Handler.create(this, this.test));
}

function test(settings)
{
	if (this.sp)
	{
		this.sp.stop();
		this.sp.removeSelf();
	}
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