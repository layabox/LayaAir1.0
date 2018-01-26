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
var ColliderScript = /** @class */ (function (_super) {
    __extends(ColliderScript, _super);
    function ColliderScript() {
        var _this = _super.call(this) || this;
        _this._color = new Laya.Vector4(1, 0, 0, 1);
        _this._tempColor1 = new Laya.Vector4(2.5, 2.5, 2.5, 1);
        _this._tempColor2 = new Laya.Vector4(0.4, 0.4, 0.4, 1);
        return _this;
    }
    ColliderScript.prototype.onTriggerEnter = function (other) {
        _super.prototype.onTriggerEnter.call(this, other);
        var mat = other._owner.meshRender.material;
        Laya.Vector4.multiply(mat.albedoColor, this._tempColor1, this._color);
        mat.albedoColor = new Laya.Vector4(this._color.x, this._color.y, this._color.z, this._color.w);
    };
    ColliderScript.prototype.onTriggerExit = function (other) {
        _super.prototype.onTriggerExit.call(this, other);
        var mat = other._owner.meshRender.material;
        Laya.Vector4.multiply(mat.albedoColor, this._tempColor2, this._color);
        mat.albedoColor = new Laya.Vector4(this._color.x, this._color.y, this._color.z, this._color.w);
    };
    ColliderScript.prototype.onTriggerStay = function (other) {
        _super.prototype.onTriggerStay.call(this, other);
        //trace("onTriggerStay");
    };
    return ColliderScript;
}(Laya.Script));
