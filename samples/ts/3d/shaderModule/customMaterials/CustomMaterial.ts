class CustomMaterial extends Laya.BaseMaterial {
    public static DIFFUSETEXTURE: number = 1;
    public static MARGINALCOLOR: number = 2;
    constructor() {
        super();
        this.setShaderName("CustomShader");
    }
    /**
     * 获取漫反射贴图。
     *  漫反射贴图。
     */
    public get diffuseTexture(): Laya.BaseTexture {
        return this._getTexture(CustomMaterial.DIFFUSETEXTURE);
    }

    /**
     * 设置漫反射贴图。
     * 漫反射贴图。
     */
    public set diffuseTexture(value: Laya.BaseTexture) {
        this._setTexture(CustomMaterial.DIFFUSETEXTURE, value);
    }

    /**
     * 设置边缘光照颜色。
     * 边缘光照颜色。
     */
    public set marginalColor(value: Laya.Vector3) {
        this._setColor(CustomMaterial.MARGINALCOLOR, value);
    }
}