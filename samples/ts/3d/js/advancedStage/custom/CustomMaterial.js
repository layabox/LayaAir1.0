var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CustomMaterial = (function (_super) {
    __extends(CustomMaterial, _super);
    function CustomMaterial() {
        _super.call(this);
        this.setShaderName("CustomShader");
        this._DIFFUSETEXTURE_ID = 0;
    }
    CustomMaterial.prototype.getDiffuseTexture = function () {
        return this._getTexture(CustomMaterial._DIFFUSETEXTURE_ID);
    };
    CustomMaterial.prototype.setDiffuseTexture = function (value) {
        this._setTexture(CustomMaterial._DIFFUSETEXTURE_ID, value);
    };
    return CustomMaterial;
}(Laya.BaseMaterial));
