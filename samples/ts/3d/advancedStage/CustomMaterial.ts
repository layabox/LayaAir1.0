class CustomMaterial extends Laya.BaseMaterial {

    private _tempMatrix4x40:Laya.Matrix4x4;
    private _diffuseTextureIndex:Number = 0;
    constructor(){

        super();
        this.setShaderName("CustomShader");
        this._tempMatrix4x40 = new Laya.Matrix4x4();
        this._diffuseTextureIndex = 0;
    }

    public getDiffuseTexture():Number{
        return this._diffuseTextureIndex;
    }

    public setDiffuseTexture(value:Laya.BaseTexture):void{

        var diff = this._diffuseTextureIndex;
        this._setTexture(value,diff,Laya.Buffer2D.DIFFUSETEXTURE);
    }

    public _setLoopShaderParams(state:Laya.RenderState, projectionView:Laya.Matrix4x4, worldMatrix:Laya.Matrix4x4, mesh:Laya.IRenderable, material:Laya.BaseMaterial):void {
        var pvw:Laya.Matrix4x4 = this._tempMatrix4x40;
        Laya.Matrix4x4.multiply(projectionView, worldMatrix, pvw);
        state.shaderValue.pushValue(Laya.Buffer2D.MVPMATRIX, pvw.elements);
        state.shaderValue.pushValue(Laya.Buffer2D.MATRIX1, worldMatrix.elements);
    }
}