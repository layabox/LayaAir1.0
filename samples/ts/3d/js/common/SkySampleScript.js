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
var SkySampleScript = (function (_super) {
    __extends(SkySampleScript, _super);
    function SkySampleScript() {
        return _super.call(this) || this;
    }
    SkySampleScript.prototype._update = function (state) {
        _super.prototype._update.call(this, state);
        this.skySprite.transform.position = this.cameraSprite.transform.position;
    };
    return SkySampleScript;
}(Laya.Script));
