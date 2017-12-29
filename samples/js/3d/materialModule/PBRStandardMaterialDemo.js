Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/PBRMaterialScene/Showcase.ls"));

scene.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    var camera = scene.getChildByName("Main Camera");
    camera.addComponent(CameraMoveScript);
    camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
    var skyBox = new Laya.SkyBox();
    camera.sky = skyBox;
    skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");

    //实例PBR材质
    var mat = new Laya.PBRStandardMaterial();
    //反射贴图
    mat.albedoTexture = Laya.Texture2D.load('../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_AlbedoTransparency.png');
    //法线贴图
    mat.normalTexture = Laya.Texture2D.load('../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_Normal.png');
    //金属光滑度贴图
    mat.metallicGlossTexture = Laya.Texture2D.load('../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_MetallicSmoothness.png');
    //遮挡贴图
    mat.occlusionTexture = Laya.Texture2D.load('../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_Occlusion.png');
    //反射颜色
    mat.albedoColor = new Laya.Vector4(1, 1, 1, 1);
    //光滑度缩放系数
    mat.smoothnessTextureScale = 1.0;
    //遮挡贴图强度
    mat.occlusionTextureStrength = 1.0;
    //法线贴图缩放洗漱
    mat.normalScale = 1;
    //光滑度数据源:从金属度贴图/反射贴图获取。
    mat.smoothnessSource = Laya.PBRStandardMaterial.SmoothnessSource_MetallicGlossTexture_Alpha;

    var barrel = scene.getChildByName("Wooden_Barrel");
    var barrel1 = scene.getChildByName("Wooden_Barrel (1)");
    var barrel2 = scene.getChildByName("Wooden_Barrel (2)");
    var barrel3 = scene.getChildByName("Wooden_Barrel (3)");

    barrel.meshRender.sharedMaterial = mat;
    barrel1.meshRender.sharedMaterial = mat;
    barrel2.meshRender.sharedMaterial = mat;
    barrel3.meshRender.sharedMaterial = mat;
});