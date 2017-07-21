function CustomTerrainMaterial() {
    CustomTerrainMaterial.__super.call(this);
    this.setShaderName("CustomTerrainShader");
}

Laya.class(CustomTerrainMaterial, "CustomTerrainMaterial", Laya.BaseMaterial);

CustomTerrainMaterial.SPLATALPHATEXTURE=0;
CustomTerrainMaterial.NORMALTEXTURE=1;
CustomTerrainMaterial.LIGHTMAPTEXTURE=2;
CustomTerrainMaterial.DIFFUSETEXTURE1=3;
CustomTerrainMaterial.DIFFUSETEXTURE2=4;
CustomTerrainMaterial.DIFFUSETEXTURE3=5;
CustomTerrainMaterial.DIFFUSETEXTURE4=6;
CustomTerrainMaterial.DIFFUSETEXTURE5=7;
CustomTerrainMaterial.DIFFUSESCALE1=8;
CustomTerrainMaterial.DIFFUSESCALE2=9;
CustomTerrainMaterial.DIFFUSESCALE3=10;
CustomTerrainMaterial.DIFFUSESCALE4=11;
CustomTerrainMaterial.DIFFUSESCALE5=12;
CustomTerrainMaterial.MATERIALAMBIENT=13;
CustomTerrainMaterial.MATERIALDIFFUSE=14;
CustomTerrainMaterial.MATERIALSPECULAR=15;
CustomTerrainMaterial.LIGHTMAPSCALEOFFSET=16;

CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1;
CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2;
CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3;
CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4;
CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5;
CustomTerrainMaterial.SHADERDEFINE_LIGHTMAP;

//获取splatAlpha贴图。
CustomTerrainMaterial.prototype.getSplatAlphaTexture = function () {
    return this._getTexture(CustomTerrainMaterial.SPLATALPHATEXTURE);
}

//设置splatAlpha贴图。
CustomTerrainMaterial.prototype.setSplatAlphaTexture = function (value) {
    this._setTexture(CustomTerrainMaterial.SPLATALPHATEXTURE,value);
}

//获取normal贴图。
CustomTerrainMaterial.prototype.getNormalTexture = function () {
    return this._getTexture(CustomTerrainMaterial.NORMALTEXTURE);
}

//设置normal贴图。
CustomTerrainMaterial.prototype.setNormalTexture = function (value) {
    this._setTexture(CustomTerrainMaterial.NORMALTEXTURE,value);
}

//获取lightMap贴图。
CustomTerrainMaterial.prototype.getLightMapTexture = function () {
    return this._getTexture(CustomTerrainMaterial.LIGHTMAPTEXTURE);
}

//设置lightMap贴图。
CustomTerrainMaterial.prototype.setLightMapTexture = function (value) {
    this._setTexture(CustomTerrainMaterial.LIGHTMAPTEXTURE,value);
    this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_LIGHTMAP);
}

//获取第一层贴图。
CustomTerrainMaterial.prototype.getDiffuseTexture1 = function () {
    return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE1);
}

//设置第一层贴图。
CustomTerrainMaterial.prototype.setDiffuseTexture1 = function (value) {
    this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE1,value);
    this._setDetailNum(1);
}

//获取第二层贴图。
CustomTerrainMaterial.prototype.getDiffuseTexture2 = function () {
    return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE2);
}

//设置第二层贴图。
CustomTerrainMaterial.prototype.setDiffuseTexture2 = function (value) {
    this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE2,value);
    this._setDetailNum(2);
}

//获取第三层贴图。
CustomTerrainMaterial.prototype.getDiffuseTexture3 = function () {
    return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE3);
}

//设置第三层贴图。
CustomTerrainMaterial.prototype.setDiffuseTexture3 = function (value) {
    this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE3,value);
    this._setDetailNum(3);
}

//获取第四层贴图。
CustomTerrainMaterial.prototype.getDiffuseTexture4 = function () {
    return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE4);
}

//设置第四层贴图。
CustomTerrainMaterial.prototype.setDiffuseTexture4 = function (value) {
    this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE4,value);
    this._setDetailNum(4);
}

//获取第五层贴图。
CustomTerrainMaterial.prototype.getDiffuseTexture5 = function () {
    return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE5);
}

//设置第五层贴图。
CustomTerrainMaterial.prototype.setDiffuseTexture5 = function (value) {
    this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE5,value);
    this._setDetailNum(5);
}

CustomTerrainMaterial.prototype.setDiffuseScale1 = function (value) {
    this._setVector2(CustomTerrainMaterial.DIFFUSESCALE1,value);
}

CustomTerrainMaterial.prototype.setDiffuseScale2 = function (value) {
    this._setVector2(CustomTerrainMaterial.DIFFUSESCALE2,value);
}

CustomTerrainMaterial.prototype.setDiffuseScale3 = function (value) {
    this._setVector2(CustomTerrainMaterial.DIFFUSESCALE3,value);
}

CustomTerrainMaterial.prototype.setDiffuseScale4 = function (value) {
    this._setVector2(CustomTerrainMaterial.DIFFUSESCALE4,value);
}

CustomTerrainMaterial.prototype.setDiffuseScale5 = function (value) {
    this._setVector2(CustomTerrainMaterial.DIFFUSESCALE5,value);
}

CustomTerrainMaterial.prototype.setLightMapScaleOffset = function (value) {
    this._setColor(CustomTerrainMaterial.LIGHTMAPSCALEOFFSET,value);
}

CustomTerrainMaterial.prototype._setDetailNum = function(value) {
    switch (value) {
    case 1:
        this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
        break;
    case 2:
        this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
        break;
    case 3:
        this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
        break;
    case 4:
        this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
        break;
    case 5:
        this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
        this._removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
        break;
    }
}

CustomTerrainMaterial.prototype.getAmbientColor = function (value) {
    return this._getColor(CustomTerrainMaterial.MATERIALAMBIENT,value);
}

CustomTerrainMaterial.prototype.setAmbientColor = function (value) {
    this._setColor(CustomTerrainMaterial.MATERIALAMBIENT,value);
}

CustomTerrainMaterial.prototype.getDiffuseColor = function (value) {
    return this._getColor(CustomTerrainMaterial.MATERIALDIFFUSE,value);
}

CustomTerrainMaterial.prototype.setDiffuseColor = function (value) {
    this._setColor(CustomTerrainMaterial.MATERIALDIFFUSE,value);
}

CustomTerrainMaterial.prototype.getSpecularColor = function (value) {
    return this._getColor(CustomTerrainMaterial.MATERIALSPECULAR,value);
}

CustomTerrainMaterial.prototype.setSpecularColor = function (value) {
    this._setColor(CustomTerrainMaterial.MATERIALSPECULAR,value);
}

