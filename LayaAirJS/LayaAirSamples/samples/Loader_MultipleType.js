var ROBOT_DATA_PATH = "res/robot/data.bin";
var ROBOT_TEXTURE_PATH = "res/robot/texture.png";

Laya.init(100, 100);

var assets = [];
assets.push( { url:ROBOT_DATA_PATH, type:Laya.Loader.BUFFER } );
assets.push( { url:ROBOT_TEXTURE_PATH, type:Laya.Loader.IMAGE } );

Laya.loader.load(assets, Laya.Handler.create(this, onAssetsLoaded));

function onAssetsLoaded()
{
	var robotData = Laya.loader.getRes(ROBOT_DATA_PATH);
	var robotTexture = Laya.loader.getRes(ROBOT_TEXTURE_PATH);
	// 使用资源
}