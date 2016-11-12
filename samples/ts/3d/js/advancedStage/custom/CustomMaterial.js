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
        this._tempMatrix4x40 = new Laya.Matrix4x4();
        this._diffuseTextureIndex = 0;
    }
    CustomMaterial.prototype.getDiffuseTexture = function () {
        return this._getTexture(CustomMaterial._diffuseTextureIndex);
    };
    CustomMaterial.prototype.setDiffuseTexture = function (value) {
        this._setTexture(value, CustomMaterial._diffuseTextureIndex, CustomMaterial.DIFFUSETEXTURE);
    };
    CustomMaterial.prototype._setLoopShaderParams = function (state, projectionView, worldMatrix, mesh, material) {
        var pvw = this._tempMatrix4x40;
        Laya.Matrix4x4.multiply(projectionView, worldMatrix, pvw);
        state.shaderValue.pushValue(CustomMaterial.MVPMATRIX, pvw.elements);
        state.shaderValue.pushValue(CustomMaterial.WORLDMATRIX, worldMatrix.elements);
    };
    CustomMaterial.MVPMATRIX = "MVPMATRIX";
    CustomMaterial.DIFFUSETEXTURE = "DIFFUSETEXTURE";
    CustomMaterial.WORLDMATRIX = "MATRIX1";
    CustomMaterial._diffuseTextureIndex = 0;
    return CustomMaterial;
}(Laya.BaseMaterial));
