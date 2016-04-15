var ROBOT_DATA_PATH = "res/robot/data.bin";
var ROBOT_TEXTURE_PATH = "res/robot/texture.png";

Laya.init(100, 100);

var assets = [];
assets.push( { url:ROBOT_DATA_PATH, type:laya.net.Loader.BUFFER } );
assets.push( { url:ROBOT_TEXTURE_PATH, type:laya.net.Loader.IMAGE } );

Laya.loader.load(assets, laya.utils.Handler.create(this, onAssetsLoaded));

function onAssetsLoaded()
{
	var robotData = Laya.loader.getRes(ROBOT_DATA_PATH);
	var robotTexture = Laya.loader.getRes(ROBOT_TEXTURE_PATH);
	// 使用资源
}