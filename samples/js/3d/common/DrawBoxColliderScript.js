var DrawBoxColliderScript = (function (_super) {
    function DrawBoxColliderScript() {
        DrawBoxColliderScript.super(this);
        this._corners = new Array();
        this._color = new Laya.Vector4(1, 0, 0, 1);
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
    Laya.class(DrawBoxColliderScript, "DrawBoxColliderScript", _super);
    DrawBoxColliderScript.prototype._postRenderUpdate = function (state) {
        var obb = this._owner.getComponentByType(Laya.BoxCollider).boundBox;
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
    return DrawBoxColliderScript;
})(Laya.Script);