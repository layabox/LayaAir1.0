class CameraMoveScript extends Laya.Script {
    protected lastMouseX: number;
    protected lastMouseY: number;
    protected yawPitchRoll = new Laya.Vector3();
    protected resultRotation = new Laya.Quaternion();
    protected tempRotationZ = new Laya.Quaternion();
    protected tempRotationX = new Laya.Quaternion();
    protected tempRotationY = new Laya.Quaternion();
    protected isMouseDown: Boolean;
    protected rotaionSpeed: number = 0.00006;

    protected mainCameraAnimation: Laya.CameraAnimations;
    protected scene: Laya.Scene;

    constructor() {
        super();
    }


    public _initialize(owner: Laya.Sprite3D): void {
        super._initialize(owner);
        Laya.stage.on(Laya.Event.MOUSE_DOWN, this, this.mouseDown);
        Laya.stage.on(Laya.Event.MOUSE_UP, this, this.mouseUp);
        Laya.stage.on(Laya.Event.MOUSE_OUT, this, this.mouseOut);

        var camera = owner.scene.currentCamera;

        camera.on(Laya.Event.COMPONENT_ADDED, this, function (component: Laya.Component3D): void {
            if (component instanceof Laya.CameraAnimations)
                this.mainCameraAnimation = component as Laya.CameraAnimations;
        });

        camera.on(Laya.Event.COMPONENT_REMOVED, this, function (component: Laya.Component3D): void {
            if (component instanceof Laya.CameraAnimations)
                this.mainCameraAnimation = null;
        });
    }

    public _update(state: Laya.RenderState): void {
        super._update(state);
        this.updateCamera(state.elapsedTime);
    }

    protected mouseDown(e: Laya.Event): void {
        if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped)) {
            this.owner.scene.currentCamera.transform.localRotation.getYawPitchRoll(this.yawPitchRoll);

            this.lastMouseX = Laya.stage.mouseX;
            this.lastMouseY = Laya.stage.mouseY;
            this.isMouseDown = true;
        }
    }

    protected mouseUp(e: Laya.Event): void {
        if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))
            this.isMouseDown = false;
    }

    protected mouseOut(e: Laya.Event): void {
        if (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))
            this.isMouseDown = false;
    }

    protected updateCamera(elapsedTime: number): void {

        if (!isNaN(this.lastMouseX) && !isNaN(this.lastMouseY) && (!this.mainCameraAnimation || (this.mainCameraAnimation && this.mainCameraAnimation.player.State === Laya.AnimationState.stopped))) {
            var scene = this.owner.scene;
            Laya.KeyBoardManager.hasKeyDown(87) && scene.currentCamera.moveForward(-0.002 * elapsedTime);//W
            Laya.KeyBoardManager.hasKeyDown(83) && scene.currentCamera.moveForward(0.002 * elapsedTime);//S
            Laya.KeyBoardManager.hasKeyDown(65) && scene.currentCamera.moveRight(-0.002 * elapsedTime);//A
            Laya.KeyBoardManager.hasKeyDown(68) && scene.currentCamera.moveRight(0.002 * elapsedTime);//D
            Laya.KeyBoardManager.hasKeyDown(81) && scene.currentCamera.moveVertical(0.002 * elapsedTime);//Q
            Laya.KeyBoardManager.hasKeyDown(69) && scene.currentCamera.moveVertical(-0.002 * elapsedTime);//E

            if (this.isMouseDown) {
                var offsetX = Laya.stage.mouseX - this.lastMouseX;
                var offsetY = Laya.stage.mouseY - this.lastMouseY;

                var yprElem: Float32Array = this.yawPitchRoll.elements;
                yprElem[0] -= offsetX * this.rotaionSpeed * elapsedTime;
                yprElem[1] -= offsetY * this.rotaionSpeed * elapsedTime;
                this.updateRotation();
            }
        }
        this.lastMouseX = Laya.stage.mouseX;
        this.lastMouseY = Laya.stage.mouseY;
    }

    protected updateRotation(): void {
        var yprElem: Float32Array = this.yawPitchRoll.elements;
        if (Math.abs(yprElem[1]) < 1.50) {
            Laya.Quaternion.createFromYawPitchRoll(yprElem[0], yprElem[1], yprElem[2], this.tempRotationZ);
            this.owner.scene.currentCamera.transform.localRotation = this.tempRotationZ;
        }
    }

}