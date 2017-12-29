class DrawBoxColliderScript extends Laya.Script {
    private phasorSpriter3D: Laya.PhasorSpriter3D;
    private _corners: Array<any> = new Array();
    private _color: Laya.Vector4 = new Laya.Vector4(1, 0, 0, 1);
    constructor() {
        super();
        this._corners[0] = new Laya.Vector3();
        this._corners[1] = new Laya.Vector3();
        this._corners[2] = new Laya.Vector3();
        this._corners[3] = new Laya.Vector3();
        this._corners[4] = new Laya.Vector3();
        this._corners[5] = new Laya.Vector3();
        this._corners[6] = new Laya.Vector3();
        this._corners[7] = new Laya.Vector3();
        this.phasorSpriter3D = new Laya.PhasorSpriter3D();
    }
    public _postRenderUpdate(state:Laya.RenderState):void {
        var obb:Laya.OrientedBoundBox = ((this._owner as Laya.Sprite3D).getComponentByType(Laya.BoxCollider) as Laya.BoxCollider).boundBox;
        obb.getCorners(this._corners);
			
        this.phasorSpriter3D.begin(Laya.WebGLContext.LINES, this._owner.camera);
        this.phasorSpriter3D.line(this._corners[0], this._color, this._corners[1], this._color);
        this.phasorSpriter3D.line(this._corners[1], this._color, this._corners[2], this._color);
        this.phasorSpriter3D.line(this._corners[2], this._color, this._corners[3], this._color);
        this.phasorSpriter3D.line(this._corners[3], this._color, this._corners[0], this._color);
        this.phasorSpriter3D.line(this._corners[4], this._color, this._corners[5], this._color);
        this.phasorSpriter3D.line(this._corners[5], this._color, this._corners[6], this._color);
        this.phasorSpriter3D.line(this._corners[6], this._color, this._corners[7], this._color);
        this.phasorSpriter3D.line(this._corners[7], this._color, this._corners[4], this._color);
        this.phasorSpriter3D.line(this._corners[0], this._color, this._corners[4], this._color);
        this.phasorSpriter3D.line(this._corners[1], this._color, this._corners[5], this._color);
        this.phasorSpriter3D.line(this._corners[2], this._color, this._corners[6], this._color);
        this.phasorSpriter3D.line(this._corners[3], this._color, this._corners[7], this._color);
			
        this.phasorSpriter3D.end();
    }
}