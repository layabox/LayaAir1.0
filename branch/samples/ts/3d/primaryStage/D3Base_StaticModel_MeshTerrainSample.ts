class StaticModel_MeshTerrainSample {
    private forward: Laya.Vector3 = new Laya.Vector3(0, 0, -0.01);
    private back: Laya.Vector3 = new Laya.Vector3(0, 0, 0.01);
    private left: Laya.Vector3 = new Laya.Vector3(-0.01, 0, 0);
    private right: Laya.Vector3 = new Laya.Vector3(0.01, 0, 0);
    private skinMesh: Laya.MeshSprite3D;
    private skinAni: Laya.SkinAnimations;
    private scene: Laya.Scene;
    private terrain: Laya.Mesh;
    private terrainSprite: Laya.MeshTerrainSprite3D;
    private sphere: Laya.Mesh;
    private sphereSprite: Laya.MeshSprite3D;
    private pathFingding: Laya.PathFind;

    constructor() {

        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 4.2, 2.6));
        camera.transform.rotate(new Laya.Vector3(-45, 0, 0), true, false);

        this.terrain = Laya.Mesh.load("../../res/threeDimen/staticModel/simpleScene/B00MP001M-DEFAULT01.lm");
        this.terrainSprite = this.scene.addChild(Laya.MeshTerrainSprite3D.createFromMesh(this.terrain, 129, 129)) as Laya.MeshTerrainSprite3D;
        this.terrainSprite.transform.localScale = new Laya.Vector3(10, 10, 10);
        this.terrainSprite.transform.position = new Laya.Vector3(0, 2.6, 1.5);
        this.terrainSprite.transform.rotationEuler = new Laya.Vector3(0, 0.3, 0.4);
        this.setMeshParams(this.terrainSprite, Laya.StandardMaterial.RENDERMODE_OPAQUE, new Laya.Vector4(3.5,3.5,3.5,1.0), new Laya.Vector3(0.6823, 0.6549, 0.6352), new Laya.Vector2(25.0, 25.0), "TERRAIN");

        this.pathFingding = this.terrainSprite.addComponent(Laya.PathFind) as Laya.PathFind;
        this.pathFingding.setting = { allowDiagonal: true, dontCrossCorners: false, heuristic: PathFinding.core.Heuristic.manhattan, weight: 1 };
        this.pathFingding.grid = new PathFinding.core.Grid(64, 36);

        this.sphere = Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
        this.sphereSprite = this.scene.addChild(new Laya.MeshSprite3D(this.sphere)) as Laya.MeshSprite3D;
        this.sphereSprite.transform.localScale = new Laya.Vector3(0.1, 0.1, 0.1);

        //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
        this.terrain.once(Laya.Event.LOADED, this, function (): void {
            Laya.timer.frameLoop(1, this, this._update);
        });
    }

    private _update(): void {
        Laya.KeyBoardManager.hasKeyDown(87) && this.sphereSprite.transform.translate(this.forward, false);//W
        Laya.KeyBoardManager.hasKeyDown(83) && this.sphereSprite.transform.translate(this.back, false);//S
        Laya.KeyBoardManager.hasKeyDown(65) && this.sphereSprite.transform.translate(this.left, false);//A
        Laya.KeyBoardManager.hasKeyDown(68) && this.sphereSprite.transform.translate(this.right, false);//D
        var position = this.sphereSprite.transform.position;
        var height = this.terrainSprite.getHeight(position.x, position.z);
        isNaN(height) && (height = 0);

        position.elements[0] = position.x;
        position.elements[1] = height + 0.05;//0.05为球半径
        position.elements[2] = position.z;
        this.sphereSprite.transform.position = position;

        var array = this.pathFingding.findPath(0, 0, position.x, position.z);
        // console.log("start:", 0, 0, " end:", position.x, position.z, "path:", array.toString());
    }


    private setMeshParams(spirit3D:Laya.Sprite3D, renderMode:number, albedo:Laya.Vector4, ambientColor:Laya.Vector3, uvScale:Laya.Vector2, shaderName:String = null):void {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite = spirit3D as Laya.MeshSprite3D;
            var mesh = meshSprite.meshFilter.sharedMesh;
            if (mesh != null) {
                mesh.once(Laya.Event.LOADED, this, function (mesh:Laya.BaseMesh):void {
                    for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                        var mat:Laya.BaseMaterial = meshSprite.meshRender.sharedMaterials[i];
                        var transformUV:Laya.TransformUV = new Laya.TransformUV();
                        transformUV.tiling = uvScale;
                        (shaderName) && (mat.setShaderName(shaderName));
                        mat.transformUV = transformUV;
                        mat.ambientColor = ambientColor;
                        mat.albedo = albedo;
                        mat.renderMode = renderMode;
                    }
                });
            }
        }
        for (var i = 0; i < spirit3D._childs.length; i++)
            this.setMeshParams(spirit3D._childs[i], renderMode, albedo, ambientColor, uvScale, shaderName);
    }
}
new StaticModel_MeshTerrainSample();