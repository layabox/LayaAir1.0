function CustomMaterial() {
    CustomMaterial.__super.call(this);
    this.setShaderName("CustomShader");
    this._tempMatrix4x40 = new Laya.Matrix4x4();
    this._diffuseTextureIndex = 0;
}

CustomMaterial.MVPMATRIX="MVPMATRIX";
CustomMaterial.DIFFUSETEXTURE="DIFFUSETEXTURE";
CustomMaterial.WORLDMATRIX="MATRIX1";

Laya.class(CustomMaterial, "CustomMaterial", Laya.BaseMaterial);

CustomMaterial.prototype.getDiffuseTexture = function () {
    return this._getTexture(this._diffuseTextureIndex);
}

CustomMaterial.prototype.setDiffuseTexture = function (value) {
    this._setTexture(value,this._diffuseTextureIndex,CustomMaterial.DIFFUSETEXTURE);
}

CustomMaterial.prototype._setLoopShaderParams = function (state,projectionView,worldMatrix,mesh,material) {

    var pvw = this._tempMatrix4x40;
    Laya.Matrix4x4.multiply(projectionView, worldMatrix, pvw);
    state.shaderValue.pushValue(CustomMaterial.MVPMATRIX, pvw.elements);
    state.shaderValue.pushValue(CustomMaterial.WORLDMATRIX, worldMatrix.elements);
}

