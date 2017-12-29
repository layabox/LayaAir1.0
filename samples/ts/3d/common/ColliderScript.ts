class ColliderScript extends Laya.Script {
    private _color: Laya.Vector4 = new Laya.Vector4(1, 0, 0, 1);
    private _tempColor1: Laya.Vector4 = new Laya.Vector4(2.5, 2.5, 2.5, 1);
    private _tempColor2: Laya.Vector4 = new Laya.Vector4(0.4, 0.4, 0.4, 1);
    constructor() {
        super();
    }
    public onTriggerEnter(other: Laya.Collider): void {
        super.onTriggerEnter(other);
        var mat:any = (other._owner as Laya.MeshSprite3D).meshRender.material;
        Laya.Vector4.multiply(mat.albedoColor, this._tempColor1, this._color);
        mat.albedoColor = new Laya.Vector4(this._color.x, this._color.y, this._color.z, this._color.w);
    }

    public onTriggerExit(other: Laya.Collider): void {
        super.onTriggerExit(other);
        var mat:any = (other._owner as Laya.MeshSprite3D).meshRender.material;
        Laya.Vector4.multiply(mat.albedoColor, this._tempColor2, this._color);
        mat.albedoColor = new Laya.Vector4(this._color.x, this._color.y, this._color.z, this._color.w);
    }

    public onTriggerStay(other: Laya.Collider): void {
        super.onTriggerStay(other);
        //trace("onTriggerStay");
    }
}