function CameraMoveScript() {
	CameraMoveScript.super(this);
	this.lastMouseX = NaN;
	this.lastMouseY = NaN;
	this.yawPitchRoll = new Laya.Vector3();
	this.resultRotation = new Laya.Quaternion();
	this.tempRotationZ = new Laya.Quaternion();
	this.tempRotationX = new Laya.Quaternion();
	this.tempRotationY = new Laya.Quaternion();
	this.isMouseDown = false;
	this.rotaionSpeed = 0.00006;

	this.mainCameraAnimation = null;
	this.scene = null;
}
Laya.class(CameraMoveScript, "CameraMoveScript", Laya.Script);

CameraMoveScript.prototype._initialize = function (owner) {
	var _this = this;
	CameraMoveScript.__super.prototype._initialize.call(this,owner);
	Laya.stage.on("mousedown", this, this.mouseDown);
	Laya.stage.on("mouseup", this, this.mouseUp);
	Laya.stage.on("mouseout", this, this.mouseOut);
	var camera = owner.scene.currentCamera;
	camera.on("componentadded", this, function (component) {
		if ((component instanceof laya.d3.component.animation.CameraAnimations))
			_this.mainCameraAnimation = component;
	});
	camera.on("componentremoved", this, function (component) {
		if ((component instanceof laya.d3.component.animation.CameraAnimations))
			_this.mainCameraAnimation = null;
	});
}

CameraMoveScript.prototype._update = function (state) {
	CameraMoveScript.__super.prototype._update.call(this,state);
	this.updateCamera(state.elapsedTime);
}

CameraMoveScript.prototype.updateCamera = function (elapsedTime) {
	if (!isNaN(this.lastMouseX) && !isNaN(this.lastMouseY) && (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === 0))) {
		var scene = this.owner.scene;
		Laya.KeyBoardManager.hasKeyDown(87) && scene.currentCamera.moveForward(-0.002 * elapsedTime);
		Laya.KeyBoardManager.hasKeyDown(83) && scene.currentCamera.moveForward(0.002 * elapsedTime);
		Laya.KeyBoardManager.hasKeyDown(65) && scene.currentCamera.moveRight(-0.002 * elapsedTime);
		Laya.KeyBoardManager.hasKeyDown(68) && scene.currentCamera.moveRight(0.002 * elapsedTime);
		Laya.KeyBoardManager.hasKeyDown(81) && scene.currentCamera.moveVertical(0.002 * elapsedTime);
		Laya.KeyBoardManager.hasKeyDown(69) && scene.currentCamera.moveVertical(-0.002 * elapsedTime);
		if (this.isMouseDown) {
			var offsetX = Laya.stage.mouseX - this.lastMouseX;
			var offsetY = Laya.stage.mouseY - this.lastMouseY;
			var yprElem = this.yawPitchRoll.elements;
			yprElem[0] -= offsetX * this.rotaionSpeed * elapsedTime;
			yprElem[1] -= offsetY * this.rotaionSpeed * elapsedTime;
			this.updateRotation();
		}
	}
	this.lastMouseX = Laya.stage.mouseX;
	this.lastMouseY = Laya.stage.mouseY;
}

CameraMoveScript.prototype.updateRotation = function () {
	var yprElem = this.yawPitchRoll.elements;
	if (Math.abs(yprElem[1]) < 1.50) {
		Laya.Quaternion.createFromYawPitchRoll(yprElem[0], yprElem[1], yprElem[2], this.tempRotationZ);
		this.owner.scene.currentCamera.transform.localRotation = this.tempRotationZ;
	}
}

CameraMoveScript.prototype.mouseDown = function (e) {
	if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === 0)) {
		this.owner.scene.currentCamera.transform.localRotation.getYawPitchRoll(this.yawPitchRoll);
		this.lastMouseX = Laya.stage.mouseX;
		this.lastMouseY = Laya.stage.mouseY;
		this.isMouseDown = true;
	}
}

CameraMoveScript.prototype.mouseUp = function (e) {
	if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === 0))
		this.isMouseDown = false;
}

CameraMoveScript.prototype.mouseOut = function (e) {
	if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === 0))
		this.isMouseDown = false;
}