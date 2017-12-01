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
var CustomTerrainMaterial = /** @class */ (function (_super) {
    __extends(CustomTerrainMaterial, _super);
    function CustomTerrainMaterial() {
        var _this = _super.call(this) || this;
        _this.setShaderName("CustomTerrainShader");
        return _this;
    }
    Object.defineProperty(CustomTerrainMaterial.prototype, "splatAlphaTexture", {
        /**
         * 获取splatAlpha贴图。
         * @return splatAlpha贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.SPLATALPHATEXTURE);
        },
        /**
         * 设置splatAlpha贴图。
         * @param value splatAlpha贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.SPLATALPHATEXTURE, value);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "normalTexture", {
        /**
         * 获取normal贴图。
         * @return normal贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.NORMALTEXTURE);
        },
        /**
         * 设置normal贴图。
         * @param value normal贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.NORMALTEXTURE, value);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "lightMapTexture", {
        /**
         * 获取lightMap贴图。
         * @return lightMap贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.LIGHTMAPTEXTURE);
        },
        /**
         * 设置lightMap贴图。
         * @param value lightMap贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.LIGHTMAPTEXTURE, value);
            this._addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_LIGHTMAP);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "diffuseTexture1", {
        /**
         * 获取第一层贴图。
         * @return 第一层贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE1);
        },
        /**
         * 设置第一层贴图。
         * @param value 第一层贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE1, value);
            this._setDetailNum(1);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "diffuseTexture2", {
        /**
         * 获取第二层贴图。
         * @return 第二层贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE2);
        },
        /**
         * 设置第二层贴图。
         * @param value 第二层贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE2, value);
            this._setDetailNum(2);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "diffuseTexture3", {
        /**
         * 获取第三层贴图。
         * @return 第三层贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE3);
        },
        /**
         * 设置第三层贴图。
         * @param value 第三层贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE3, value);
            this._setDetailNum(3);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "diffuseTexture4", {
        /**
         * 获取第四层贴图。
         * @return 第四层贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE4);
        },
        /**
         * 设置第四层贴图。
         * @param value 第四层贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE4, value);
            this._setDetailNum(4);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "diffuseTexture5", {
        /**
         * 获取第五层贴图。
         * @return 第五层贴图。
         */
        get: function () {
            return this._getTexture(CustomTerrainMaterial.DIFFUSETEXTURE5);
        },
        /**
         * 设置第五层贴图。
         * @param value 第五层贴图。
         */
        set: function (value) {
            this._setTexture(CustomTerrainMaterial.DIFFUSETEXTURE5, value);
            this._setDetailNum(5);
        },
        enumerable: true,
        configurable: true
    });
    CustomTerrainMaterial.prototype.setDiffuseScale1 = function (scale1) {
        this._setVector2(CustomTerrainMaterial.DIFFUSESCALE1, scale1);
    };
    CustomTerrainMaterial.prototype.setDiffuseScale2 = function (scale2) {
        this._setVector2(CustomTerrainMaterial.DIFFUSESCALE2, scale2);
    };
    CustomTerrainMaterial.prototype.setDiffuseScale3 = function (scale3) {
        this._setVector2(CustomTerrainMaterial.DIFFUSESCALE3, scale3);
    };
    CustomTerrainMaterial.prototype.setDiffuseScale4 = function (scale4) {
        this._setVector2(CustomTerrainMaterial.DIFFUSESCALE4, scale4);
    };
    CustomTerrainMaterial.prototype.setDiffuseScale5 = function (scale5) {
        this._setVector2(CustomTerrainMaterial.DIFFUSESCALE5, scale5);
    };
    CustomTerrainMaterial.prototype.setLightmapScaleOffset = function (scaleOffset) {
        this._setColor(CustomTerrainMaterial.LIGHTMAPSCALEOFFSET, scaleOffset);
    };
    CustomTerrainMaterial.prototype._setDetailNum = function (value) {
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
    };
    Object.defineProperty(CustomTerrainMaterial.prototype, "ambientColor", {
        get: function () {
            return this._getColor(CustomTerrainMaterial.MATERIALAMBIENT);
        },
        set: function (value) {
            this._setColor(CustomTerrainMaterial.MATERIALAMBIENT, value);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "diffuseColor", {
        get: function () {
            return this._getColor(CustomTerrainMaterial.MATERIALDIFFUSE);
        },
        set: function (value) {
            this._setColor(CustomTerrainMaterial.MATERIALDIFFUSE, value);
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(CustomTerrainMaterial.prototype, "specularColor", {
        get: function () {
            return this._getColor(CustomTerrainMaterial.MATERIALSPECULAR);
        },
        set: function (value) {
            this._setColor(CustomTerrainMaterial.MATERIALSPECULAR, value);
        },
        enumerable: true,
        configurable: true
    });
    CustomTerrainMaterial.SPLATALPHATEXTURE = 0;
    CustomTerrainMaterial.NORMALTEXTURE = 1;
    CustomTerrainMaterial.LIGHTMAPTEXTURE = 2;
    CustomTerrainMaterial.DIFFUSETEXTURE1 = 3;
    CustomTerrainMaterial.DIFFUSETEXTURE2 = 4;
    CustomTerrainMaterial.DIFFUSETEXTURE3 = 5;
    CustomTerrainMaterial.DIFFUSETEXTURE4 = 6;
    CustomTerrainMaterial.DIFFUSETEXTURE5 = 7;
    CustomTerrainMaterial.DIFFUSESCALE1 = 8;
    CustomTerrainMaterial.DIFFUSESCALE2 = 9;
    CustomTerrainMaterial.DIFFUSESCALE3 = 10;
    CustomTerrainMaterial.DIFFUSESCALE4 = 11;
    CustomTerrainMaterial.DIFFUSESCALE5 = 12;
    CustomTerrainMaterial.MATERIALAMBIENT = 13;
    CustomTerrainMaterial.MATERIALDIFFUSE = 14;
    CustomTerrainMaterial.MATERIALSPECULAR = 15;
    CustomTerrainMaterial.LIGHTMAPSCALEOFFSET = 16;
    return CustomTerrainMaterial;
}(Laya.BaseMaterial));
