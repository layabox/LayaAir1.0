class CustomMaterial extends Laya.BaseMaterial {

    public static MVPMATRIX:String = "MVPMATRIX";
    public static DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
    public static WORLDMATRIX:String = "MATRIX1";

    private _tempMatrix4x40:Laya.Matrix4x4;
    private static  _diffuseTextureIndex:Number = 0;

    constructor(){

        super();
        this.setShaderName("CustomShader");
        this._tempMatrix4x40 = new Laya.Matrix4x4();
        this._diffuseTextureIndex = 0;
    }

    public getDiffuseTexture():Laya.BaseTexture{
        return this._getTexture(CustomMaterial._diffuseTextureIndex);
    }

    public setDiffuseTexture(value:Laya.BaseTexture):void{
        this._setTexture(value,CustomMaterial._diffuseTextureIndex,CustomMaterial.DIFFUSETEXTURE);
    }

    public _setLoopShaderParams(state:Laya.RenderState, projectionView:Laya.Matrix4x4, worldMatrix:Laya.Matrix4x4, mesh:Laya.IRenderable, material:Laya.BaseMaterial):void {
        var pvw:Laya.Matrix4x4 = this._tempMatrix4x40;
        Laya.Matrix4x4.multiply(projectionView, worldMatrix, pvw);
        state.shaderValue.pushValue(CustomMaterial.MVPMATRIX, pvw.elements);
        state.shaderValue.pushValue(CustomMaterial.WORLDMATRIX, worldMatrix.elements);
    }
}