var forward = new Laya.Vector3(0, 0, -0.01);
var back = new Laya.Vector3(0, 0, 0.01);
var left = new Laya.Vector3(-0.01, 0, 0);
var right = new Laya.Vector3(0.01, 0, 0);
var skinMesh;
var skinAni;
var scene;
var terrain;
var terrainSprite;
var sphere;
var sphereSprite;
var pathFingding;


//是否抗锯齿
//Config.isAntialias = true;
Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = scene.addChild(new Laya.Camera(0, 0.1, 100));
scene.currentCamera.transform.translate(new Laya.Vector3(0, 4.2, 2.6));
scene.currentCamera.transform.rotate(new Laya.Vector3(-45, 0, 0), true, false);

terrain = Laya.Mesh.load("../../res/threeDimen/staticModel/simpleScene/B00MP001M-DEFAULT01.lm");
terrainSprite = scene.addChild(new Laya.MeshTerrainSprite3D(terrain, 129, 129));
terrainSprite.transform.localScale = new Laya.Vector3(10, 10, 10);
terrainSprite.transform.position = new Laya.Vector3(0, 2.6, 1.5);
terrainSprite.transform.rotationEuler = new Laya.Vector3(0, 0.3, 0.4);
setMeshParams(terrainSprite, false, false, 3.5, new Laya.Vector3(0.6823, 0.6549, 0.6352), new Laya.Vector2(25.0, 25.0), "TERRAIN");

pathFingding = terrainSprite.addComponent(Laya.PathFind);
pathFingding.setting = { allowDiagonal: true, dontCrossCorners: false, heuristic: PathFinding.core.Heuristic.manhattan, weight: 1 };
pathFingding.grid = new PathFinding.core.Grid(64, 36);

sphere = Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
sphereSprite = scene.addChild(new Laya.MeshSprite3D(sphere));
sphereSprite.transform.localScale = new Laya.Vector3(0.1, 0.1, 0.1);

//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
terrain.once(Laya.Event.LOADED, this, function () {
				Laya.timer.frameLoop(1, this, _update);
});


function _update() {
	Laya.KeyBoardManager.hasKeyDown(87) && sphereSprite.transform.translate(forward, false);//W
	Laya.KeyBoardManager.hasKeyDown(83) && sphereSprite.transform.translate(back, false);//S
	Laya.KeyBoardManager.hasKeyDown(65) && sphereSprite.transform.translate(left, false);//A
	Laya.KeyBoardManager.hasKeyDown(68) && sphereSprite.transform.translate(right, false);//D
	var position = sphereSprite.transform.position;
	var height = terrainSprite.getHeight(position.x, position.z);
	isNaN(height) && (height = 0);

	position.elements[0] = position.x;
	position.elements[1] = height + 0.05;//0.05为球半径
	position.elements[2] = position.z;
	sphereSprite.transform.position = position;

	var array = pathFingding.findPath(0, 0, position.x, position.z);
	console.log("start:", 0, 0, " end:", position.x, position.z, "path:", array.toString());
}

function setMeshParams(spirit3D, doubleFace, alpha, luminance, ambientColor, uvScale, shaderName = null, transparentMode = 0.0, isSky = false) {
	if (spirit3D instanceof Laya.MeshSprite3D) {
		var meshSprite = spirit3D;
		var mesh = meshSprite.mesh;
		if (mesh != null) {
			//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			mesh.once(Laya.Event.LOADED, this, function (mesh) {
				for (var i = 0; i < meshSprite.shadredMaterials.length; i++) {
					var material = meshSprite.shadredMaterials[i];
					material.once(Laya.Event.LOADED, this, function (mat) {
						var transformUV = new Laya.TransformUV();
						transformUV.tiling = uvScale;
						(shaderName) && (mat.setShaderName(shaderName));
						mat.transformUV = transformUV;
						mat.ambientColor = ambientColor;
						mat.luminance = luminance;
						doubleFace && (mat.cullFace = false);
						alpha && (mat.transparent = true);
						isSky && (mat.isSky = true);
						mat.transparentMode = transparentMode;
					});

				}
			});
		}
	}
	for (var i = 0; i < spirit3D._childs.length; i++)
		setMeshParams(spirit3D._childs[i], doubleFace, alpha, luminance, ambientColor, uvScale, shaderName, transparentMode, isSky);
}

