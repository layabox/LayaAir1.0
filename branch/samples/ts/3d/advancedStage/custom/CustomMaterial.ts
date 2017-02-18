class CustomMaterial extends Laya.BaseMaterial {

    constructor(){
        super();
        this.setShaderName("CustomShader");
        this._DIFFUSETEXTURE_ID = 0;
    }

    public getDiffuseTexture():Laya.BaseTexture{
        return this._getTexture(CustomMaterial._DIFFUSETEXTURE_ID);
    }

    public setDiffuseTexture(value:Laya.BaseTexture):void{
        this._setTexture(CustomMaterial._DIFFUSETEXTURE_ID,value);
    }

}