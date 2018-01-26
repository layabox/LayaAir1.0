var ColliderScript = (function(_super){
    this._color = new Laya.Vector4(1, 0, 0, 1);
    this._tempColor1 = new Laya.Vector4(2.5, 2.5, 2.5, 1);
    this._tempColor2 = new Laya.Vector4(0.4, 0.4, 0.4, 1);
    function ColliderScript(){
        ColliderScript.super(this);
    }
    Laya.class(ColliderScript,"ColliderScript",_super);
    ColliderScript. onTriggerEnter = function(other) {
        var mat = other._owner.meshRender.material;
        Laya.Vector4.multiply(mat.albedoColor, this._tempColor1, this._color);
        mat.albedoColor = new Laya.Vector4(this._color.x, this._color.y, this._color.z, this._color.w);
    }

    ColliderScript.onTriggerExit = function(other) {
        var mat = other._owner.meshRender.material;
        Laya.Vector4.multiply(mat.albedoColor, this._tempColor2, this._color);
        mat.albedoColor = new Laya.Vector4(this._color.x, this._color.y, this._color.z, this._color.w);
    }

    ColliderScript.onTriggerStay = function(other) {
        //trace("onTriggerStay");
    }
    return ColliderScript;
})(Laya.Script);