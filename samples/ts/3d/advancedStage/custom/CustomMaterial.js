var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CustomMaterial = (function (_super) {
    __extends(CustomMaterial, _super);
    function CustomMaterial() {
        _super.call(this);
        this._diffuseTextureIndex = 0;
        this.setShaderName("CustomShader");
        this._tempMatrix4x40 = new Laya.Matrix4x4();
        this._diffuseTextureIndex = 0;
    }
    CustomMaterial.prototype.getDiffuseTexture = function () {
        return this._diffuseTextureIndex;
    };
    CustomMaterial.prototype.setDiffuseTexture = function (value) {
        var diff = this._diffuseTextureIndex;
        this._setTexture(value, diff, Laya.Buffer2D.DIFFUSETEXTURE);
    };
    CustomMaterial.prototype._setLoopShaderParams = function (state, projectionView, worldMatrix, mesh, material) {
        var pvw = this._tempMatrix4x40;
        Laya.Matrix4x4.multiply(projectionView, worldMatrix, pvw);
        state.shaderValue.pushValue(Laya.Buffer2D.MVPMATRIX, pvw.elements);
        state.shaderValue.pushValue(Laya.Buffer2D.MATRIX1, worldMatrix.elements);
    };
    return CustomMaterial;
}(Laya.BaseMaterial));
