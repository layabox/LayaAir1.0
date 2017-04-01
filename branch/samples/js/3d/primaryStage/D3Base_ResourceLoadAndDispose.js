Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var processHandler = Laya.Handler.create(this, function(process){
    console.log("Process:", process);
}, null, false);//创建进度处理Handler，注意：后面要对应释放

//1:批量加载复杂模式。
//Laya.loader.create([
//{url:"../../../../res/threeDimen/staticModel/sphere/sphere.lh", clas: Laya.Sprite3D, priority:1},
//{url:"../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm", clas: Laya.Mesh, priority:1},
//{url:"../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat", clas: Laya.StandardMaterial, priority:1},
//{url:"../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg", clas: Laya.Texture2D, priority:1},
//{url:"../../../../res/threeDimen/skyBox/skyCube.ltc", clas: Laya.TextureCube, priority:1},
//{url:"../../../../res/threeDimen/skinModel/dude/dude.ani", clas: Laya.AnimationTemplet, priority:1}
//], null, processHandler);

//2:批量加载简单模式。
Laya.loader.create([
    "../../res/threeDimen/staticModel/sphere/sphere.lh",
    "../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm",
    "../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat",
    "../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg",
    "../../res/threeDimen/skyBox/skyCube.ltc",
    "../../res/threeDimen/skinModel/dude/dude.ani"], null, processHandler);

//3:单独加载模式。
//加载层级文件，与其它资源区别为通常不缓存。
var hierarchyUrl = "../../res/threeDimen/staticModel/sphere/sphere.lh";
//var sprite = Laya.loader.create(hierarchyUrl, null, null, Laya.Sprite3D, 1, false);//复杂加载。
var sprite = Laya.Sprite3D.load(hierarchyUrl);//简单加载，为复杂加载的封装。

//加载网格文件。
var meshUrl = "../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm";
//var mesh = Laya.loader.create(meshUrl, null, null, Laya.Mesh);//复杂加载。
var mesh = Laya.Mesh.load(meshUrl);//简单加载，为复杂加载的封装。

//加载材质文件。
var materialUrl = "../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat";
//var material = Laya.loader.create(materialUrl, null, null, Laya.StandardMaterial);//复杂加载。
var material = Laya.StandardMaterial.load(materialUrl);//简单加载，为复杂加载的封装。

//加载Texture2D文件。
var texture2DUrl = "../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg";
//var texture2D = Laya.loader.create(texture2DUrl, null, null, Laya.Texture2D);//复杂加载。
var texture2D = Laya.Texture2D.load(texture2DUrl);//简单加载，为复杂加载的封装。

//加载TextureCube文件。
var textureCubeUrl = "../../res/threeDimen/skyBox/skyCube.ltc";
//var textureCube = Laya.loader.create(textureCubeUrl, null, null, Laya.TextureCube);//复杂加载。
var textureCube = Laya.TextureCube.load(textureCubeUrl);//简单加载，为复杂加载的封装。*/

//加载动画模板文件。
var animationTempletUrl = "../../res/threeDimen/skinModel/dude/dude.ani";
//var animationTemplet = Laya.loader.create(keyframesAniTempletUrl, null, null, Laya.AnimationTemplet);//复杂加载。
var animationTemplet = Laya.AnimationTemplet.load(animationTempletUrl);//简单加载，为复杂加载的封装。

processHandler.recover();//释放进度处理Handler