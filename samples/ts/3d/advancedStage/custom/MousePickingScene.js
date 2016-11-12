var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var MousePickingScene = (function (_super) {
    __extends(MousePickingScene, _super);
    function MousePickingScene() {
        _super.call(this);
        this.point = new Laya.Vector2();
        this.ray = new Laya.Ray(new Laya.Vector3(), new Laya.Vector3());
        this.raycastHit = new Laya.RaycastHit();
        this.phasorSpriter3D = new Laya.PhasorSpriter3D();
        this.camera = (this.addChild(new Laya.Camera(0, 0.1, 100)));
        this.camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        this.camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        this.sprite3d = this.addChild(new Laya.Sprite3D());
        this.sprite3d.once(Laya.Event.HIERARCHY_LOADED, this, function (spirit3D) {
            this.setMaterial(spirit3D);
        });
        this.sprite3d.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
        this.sprite3d.transform.localScale = new Laya.Vector3(10, 10, 10);
    }
    MousePickingScene.prototype.setMaterial = function (spirit3D) {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite3D = spirit3D;
            var mesh = meshSprite3D.meshFilter.sharedMesh;
            if (mesh != null) {
                mesh.once(Laya.Event.LOADED, this, function () {
                    for (var i = 0; i < mesh.materials.length; i++)
                        mesh.materials[i].albedo = new Laya.Vector4(3.0, 3.0, 3.0, 1.0);
                });
            }
        }
        for (var i = 0; i < spirit3D.numChildren; i++)
            this.setMaterial(spirit3D.getChildAt(i));
    };
    MousePickingScene.prototype.lateRender = function (state) {
        _super.prototype.lateRender.call(this, state);
        var projViewMat = this.camera.projectionViewMatrix;
        this.point.elements[0] = Laya.stage.mouseX;
        this.point.elements[1] = Laya.stage.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);
        Laya.Physics.rayCast(this.ray, this.sprite3d, this.raycastHit);
        if (this.raycastHit.distance != Number.MAX_VALUE) {
            var trianglePositions = this.raycastHit.trianglePositions;
            var vertex1 = trianglePositions[0];
            var vertex2 = trianglePositions[1];
            var vertex3 = trianglePositions[2];
            var v1X = vertex1.x, v1Y = vertex1.y, v1Z = vertex1.z;
            var v2X = vertex2.x, v2Y = vertex2.y, v2Z = vertex2.z;
            var v3X = vertex3.x, v3Y = vertex3.y, v3Z = vertex3.z;
            var position = this.raycastHit.position;
            var pX = position.x, pY = position.y, pZ = position.z;
            this.phasorSpriter3D.begin(0x0001 /*Laya.WebGLContext.LINES*/, projViewMat, state);
            var original = this.ray.origin;
            this.phasorSpriter3D.line(original.x, original.y, original.z, 1.0, 0.0, 0.0, 1.0, 0, 0, 0, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0, v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0, v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0, v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(pX, pY, pZ, 1.0, 0.0, 0.0, 1.0, v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(pX, pY, pZ, 1.0, 0.0, 0.0, 1.0, v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(pX, pY, pZ, 1.0, 0.0, 0.0, 1.0, v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.end();
        }
    };
    return MousePickingScene;
}(Laya.Scene));
