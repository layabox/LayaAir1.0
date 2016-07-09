var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CameraMoveScript = (function (_super) {
    __extends(CameraMoveScript, _super);
    function CameraMoveScript() {
        _super.call(this);
        this.yawPitchRoll = new Laya.Vector3();
        this.resultRotation = new Laya.Quaternion();
        this.tempRotationZ = new Laya.Quaternion();
        this.tempRotationX = new Laya.Quaternion();
        this.tempRotationY = new Laya.Quaternion();
        this.rotaionSpeed = 0.00006;
    }
    CameraMoveScript.prototype._initialize = function (owner) {
        _super.prototype._initialize.call(this, owner);
        Laya.stage.on(Laya.Event.MOUSE_DOWN, this, this.mouseDown);
        Laya.stage.on(Laya.Event.MOUSE_UP, this, this.mouseUp);
        Laya.stage.on(Laya.Event.MOUSE_OUT, this, this.mouseOut);
        var camera = owner.scene.currentCamera;
        camera.on(Laya.Event.COMPONENT_ADDED, this, function (component) {
            if (component instanceof Laya.CameraAnimations)
                this.mainCameraAnimation = component;
        });
        camera.on(Laya.Event.COMPONENT_REMOVED, this, function (component) {
            if (component instanceof Laya.CameraAnimations)
                this.mainCameraAnimation = null;
        });
    };
    CameraMoveScript.prototype._update = function (state) {
        _super.prototype._update.call(this, state);
        this.updateCamera(state.elapsedTime);
    };
    CameraMoveScript.prototype.mouseDown = function (e) {
        if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped)) {
            this.owner.scene.currentCamera.transform.localRotation.getYawPitchRoll(this.yawPitchRoll);
            this.lastMouseX = Laya.stage.mouseX;
            this.lastMouseY = Laya.stage.mouseY;
            this.isMouseDown = true;
        }
    };
    CameraMoveScript.prototype.mouseUp = function (e) {
        if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))
            this.isMouseDown = false;
    };
    CameraMoveScript.prototype.mouseOut = function (e) {
        if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))
            this.isMouseDown = false;
    };
    CameraMoveScript.prototype.updateCamera = function (elapsedTime) {
        if (!isNaN(this.lastMouseX) && !isNaN(this.lastMouseY) && (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))) {
            var scene = this.owner.scene;
            Laya.KeyBoardManager.hasKeyDown(87) && scene.currentCamera.moveForward(-0.002 * elapsedTime); //W
            Laya.KeyBoardManager.hasKeyDown(83) && scene.currentCamera.moveForward(0.002 * elapsedTime); //S
            Laya.KeyBoardManager.hasKeyDown(65) && scene.currentCamera.moveRight(-0.002 * elapsedTime); //A
            Laya.KeyBoardManager.hasKeyDown(68) && scene.currentCamera.moveRight(0.002 * elapsedTime); //D
            Laya.KeyBoardManager.hasKeyDown(81) && scene.currentCamera.moveVertical(0.002 * elapsedTime); //Q
            Laya.KeyBoardManager.hasKeyDown(69) && scene.currentCamera.moveVertical(-0.002 * elapsedTime); //E
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
    };
    CameraMoveScript.prototype.updateRotation = function () {
        var yprElem = this.yawPitchRoll.elements;
        if (Math.abs(yprElem[1]) < 1.50) {
            Laya.Quaternion.createFromYawPitchRoll(yprElem[0], yprElem[1], yprElem[2], this.tempRotationZ);
            this.owner.scene.currentCamera.transform.localRotation = this.tempRotationZ;
        }
    };
    return CameraMoveScript;
}(Laya.Script));
//# sourceMappingURL=CameraMoveScript.js.map