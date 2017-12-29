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
var DrawBoxColliderScript = /** @class */ (function (_super) {
    __extends(DrawBoxColliderScript, _super);
    function DrawBoxColliderScript() {
        var _this = _super.call(this) || this;
        _this._corners = new Array();
        _this._color = new Laya.Vector4(1, 0, 0, 1);
        _this._corners[0] = new Laya.Vector3();
        _this._corners[1] = new Laya.Vector3();
        _this._corners[2] = new Laya.Vector3();
        _this._corners[3] = new Laya.Vector3();
        _this._corners[4] = new Laya.Vector3();
        _this._corners[5] = new Laya.Vector3();
        _this._corners[6] = new Laya.Vector3();
        _this._corners[7] = new Laya.Vector3();
        _this.phasorSpriter3D = new Laya.PhasorSpriter3D();
        return _this;
    }
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
    };
    return DrawBoxColliderScript;
}(Laya.Script));
