var sp;

Laya.init(laya.utils.Browser.width, laya.utils.Browser.height, laya.webgl.WebGL);
Laya.stage.bgColor = "#000000"
Laya.stage.sizeMode = laya.display.Stage.SIZE_FULL;
Laya.stage.on(laya.events.Event.RESIZE, this, this.onResize);
laya.utils.Stat.show();
this.loadParticleFile("res/particles/GravityMode.json");

function loadParticleFile(fileName)
{
	Laya.loader.load(fileName, laya.utils.Handler.create(this, this.test));
}

function test(settings)
{
	if (this.sp)
	{
		this.sp.stop();
		this.sp.removeSelf();
	}
	this.sp = new laya.particle.Particle2D(settings);
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