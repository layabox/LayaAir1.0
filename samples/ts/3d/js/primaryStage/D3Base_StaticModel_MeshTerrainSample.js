var StaticModel_MeshTerrainSample = (function () {
    function StaticModel_MeshTerrainSample() {
        this.forward = new Laya.Vector3(0, 0, -0.01);
        this.back = new Laya.Vector3(0, 0, 0.01);
        this.left = new Laya.Vector3(-0.01, 0, 0);
        this.right = new Laya.Vector3(0.01, 0, 0);
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = Laya.stage.addChild(new Laya.Scene());
        this.scene.currentCamera = (this.scene.addChild(new Laya.Camera(0, 0.1, 100)));
        this.scene.currentCamera.transform.translate(new Laya.Vector3(0, 4.2, 2.6));
        this.scene.currentCamera.transform.rotate(new Laya.Vector3(-45, 0, 0), true, false);
        this.terrain = Laya.Mesh.load("../../res/threeDimen/staticModel/simpleScene/B00MP001M-DEFAULT01.lm");
        this.terrainSprite = this.scene.addChild(new Laya.MeshTerrainSprite3D(this.terrain, 129, 129));
        this.terrainSprite.transform.localScale = new Laya.Vector3(10, 10, 10);
        this.terrainSprite.transform.position = new Laya.Vector3(0, 2.6, 1.5);
        this.terrainSprite.transform.rotationEuler = new Laya.Vector3(0, 0.3, 0.4);
        this.setMeshParams(this.terrainSprite, Laya.Material.RENDERMODE_OPAQUE, new Laya.Vector4(3.5, 3.5, 3.5, 1.0), new Laya.Vector3(0.6823, 0.6549, 0.6352), new Laya.Vector2(25.0, 25.0), "TERRAIN");
        this.pathFingding = this.terrainSprite.addComponent(Laya.PathFind);
        this.pathFingding.setting = { allowDiagonal: true, dontCrossCorners: false, heuristic: PathFinding.core.Heuristic.manhattan, weight: 1 };
        this.pathFingding.grid = new PathFinding.core.Grid(64, 36);
        this.sphere = Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
        this.sphereSprite = this.scene.addChild(new Laya.MeshSprite3D(this.sphere));
        this.sphereSprite.transform.localScale = new Laya.Vector3(0.1, 0.1, 0.1);
        //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
        this.terrain.once(Laya.Event.LOADED, this, function () {
            Laya.timer.frameLoop(1, this, this._update);
        });
    }
    StaticModel_MeshTerrainSample.prototype._update = function () {
        Laya.KeyBoardManager.hasKeyDown(87) && this.sphereSprite.transform.translate(this.forward, false); //W
        Laya.KeyBoardManager.hasKeyDown(83) && this.sphereSprite.transform.translate(this.back, false); //S
        Laya.KeyBoardManager.hasKeyDown(65) && this.sphereSprite.transform.translate(this.left, false); //A
        Laya.KeyBoardManager.hasKeyDown(68) && this.sphereSprite.transform.translate(this.right, false); //D
        var position = this.sphereSprite.transform.position;
        var height = this.terrainSprite.getHeight(position.x, position.z);
        isNaN(height) && (height = 0);
        position.elements[0] = position.x;
        position.elements[1] = height + 0.05; //0.05为球半径
        position.elements[2] = position.z;
        this.sphereSprite.transform.position = position;
        var array = this.pathFingding.findPath(0, 0, position.x, position.z);
        console.log("start:", 0, 0, " end:", position.x, position.z, "path:", array.toString());
    };
    StaticModel_MeshTerrainSample.prototype.setMeshParams = function (spirit3D, renderMode, albedo, ambientColor, uvScale, shaderName) {
        if (shaderName === void 0) { shaderName = null; }
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite = spirit3D;
            var mesh = meshSprite.meshFilter.sharedMesh;
            if (mesh != null) {
                //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
                mesh.once(Laya.Event.LOADED, this, function (mesh) {
                    for (var i = 0; i < meshSprite.meshRender.shadredMaterials.length; i++) {
                        var material = meshSprite.meshRender.shadredMaterials[i];
                        material.once(Laya.Event.LOADED, null, function (mat) {
                            var transformUV = new Laya.TransformUV();
                            transformUV.tiling = uvScale;
                            (shaderName) && (mat.setShaderName(shaderName));
                            mat.transformUV = transformUV;
                            mat.ambientColor = ambientColor;
                            mat.albedo = albedo;
                            mat.renderMode = renderMode;
                        });
                    }
                });
            }
        }
        for (var i = 0; i < spirit3D._childs.length; i++)
            this.setMeshParams(spirit3D._childs[i], renderMode, albedo, ambientColor, uvScale, shaderName);
    };
    return StaticModel_MeshTerrainSample;
}());
new StaticModel_MeshTerrainSample();
