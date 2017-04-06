class SkySampleScript extends Laya.Script {
    public skySprite: Laya.Sprite3D;
    public cameraSprite: Laya.BaseCamera;
    constructor() {
        super();
    }

    public _update(state: Laya.RenderState): void {
        super._update(state);
        this.skySprite.transform.position = this.cameraSprite.transform.position;
    }

}