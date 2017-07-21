function CustomMaterial() {
    CustomMaterial.__super.call(this);
    this.setShaderName("CustomShader");
}

Laya.class(CustomMaterial, "CustomMaterial", Laya.BaseMaterial);

//获取漫反射贴图
CustomMaterial.prototype.getDiffuseTexture = function () {
    return this._getTexture(CustomMaterial.DIFFUSETEXTURE);
}

//设置漫反射贴图
CustomMaterial.prototype.setDiffuseTexture = function (value) {
    this._setTexture(CustomMaterial.DIFFUSETEXTURE,value);
}

//设置边缘光照颜色。
CustomMaterial.prototype.setMarginalColor = function (value) {
    this._setColor(CustomMaterial.MARGINALCOLOR,value);
}

CustomMaterial.DIFFUSETEXTURE=1;
CustomMaterial.MARGINALCOLOR=2;