function SkySampleScript() {
	SkySampleScript.super(this);
	this.skySprite = null;
	this.cameraSprite = null;
}
Laya.class(SkySampleScript, "SkySampleScript", Laya.Script);



SkySampleScript.prototype._update = function (state) {
	SkySampleScript.__super.prototype._update.call(this,state);
	this.skySprite.transform.position = this.cameraSprite.transform.position;
}

