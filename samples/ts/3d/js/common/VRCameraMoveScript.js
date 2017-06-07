var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var VRCameraMoveScript = (function (_super) {
    __extends(VRCameraMoveScript, _super);
    function VRCameraMoveScript() {
        var _this = _super.call(this) || this;
        _this.q0 = new Laya.Quaternion();
        _this.q1 = new Laya.Quaternion(-Math.sqrt(0.5), 0, 0, Math.sqrt(0.5)); // - PI/2 around the x-axis
        _this.q2 = new Laya.Quaternion();
        _this.q3 = new Laya.Quaternion();
        return _this;
    }
    VRCameraMoveScript.prototype._initialize = function (owner) {
        _super.prototype._initialize.call(this, owner);
        this.camera = owner;
        this.camera.on(Laya.Event.COMPONENT_ADDED, this, function (component) {
            if (component instanceof Laya.CameraAnimations)
                this.mainCameraAnimation = component;
        });
        this.camera.on(Laya.Event.COMPONENT_REMOVED, this, function (component) {
            if (component instanceof Laya.CameraAnimations)
                this.mainCameraAnimation = null;
        });
        Laya.Browser.window.addEventListener('deviceorientation', function (e) {
            orientation = (Laya.Browser.window.orientation || 0);
            if (Laya.stage.canvasRotation) {
                if (Laya.stage.screenMode == Laya.Stage.SCREEN_HORIZONTAL)
                    this.orientation += 90;
                else if (Laya.stage.screenMode == Laya.Stage.SCREEN_VERTICAL)
                    this.orientation -= 90;
            }
            Laya.Quaternion.createFromYawPitchRoll(e.alpha / 360 * Math.PI * 2, e.beta / 360 * Math.PI * 2, -e.gamma / 360 * Math.PI * 2, this.q0);
            Laya.Quaternion.multiply(this.q0, this.q1, this.q2);
            Laya.Quaternion.createFromAxisAngle(Laya.Vector3.UnitZ, -orientation / 360 * Math.PI * 2, this.q3);
            Laya.Quaternion.multiply(this.q2, this.q3, this.camera.transform.localRotation);
        }.bind(this), false);
    };
    VRCameraMoveScript.prototype._update = function (state) {
        _super.prototype._update.call(this, state);
        this.updateCamera(state.elapsedTime);
    };
    VRCameraMoveScript.prototype.updateCamera = function (elapsedTime) {
        if ((!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))) {
            Laya.KeyBoardManager.hasKeyDown(87) && this.camera.moveForward(-0.002 * elapsedTime); //W
            Laya.KeyBoardManager.hasKeyDown(83) && this.camera.moveForward(0.002 * elapsedTime); //S
            Laya.KeyBoardManager.hasKeyDown(65) && this.camera.moveRight(-0.002 * elapsedTime); //A
            Laya.KeyBoardManager.hasKeyDown(68) && this.camera.moveRight(0.002 * elapsedTime); //D
            Laya.KeyBoardManager.hasKeyDown(81) && this.camera.moveVertical(0.002 * elapsedTime); //Q
            Laya.KeyBoardManager.hasKeyDown(69) && this.camera.moveVertical(-0.002 * elapsedTime); //E
            this.updateRotation();
        }
    };
    VRCameraMoveScript.prototype.updateRotation = function () {
        this.camera.transform.localRotation = this.camera.transform.localRotation;
    };
    return VRCameraMoveScript;
}(Laya.Script));
