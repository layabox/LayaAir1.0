function CustomMaterial() {
    CustomMaterial.__super.call(this);
    this.setShaderName("CustomShader");
    this._DIFFUSETEXTURE_ID = 0;
}

Laya.class(CustomMaterial, "CustomMaterial", Laya.BaseMaterial);

CustomMaterial.prototype.getDiffuseTexture = function () {
    return this._getTexture(this._DIFFUSETEXTURE_ID);
}

CustomMaterial.prototype.setDiffuseTexture = function (value) {
    this._setTexture(this._DIFFUSETEXTURE_ID,value);
}
