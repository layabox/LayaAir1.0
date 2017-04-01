(function()
{
	var Loader = Laya.Loader;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;

	var ProtoBuf = Browser.window.dcodeIO.ProtoBuf;

	Laya.init(550, 400);

	Laya.loader.load("../../res/protobuf/user.proto", Handler.create(this, onAssetsLoaded));

	function onAssetsLoaded(data)
	{
		var UserModel = ProtoBuf.loadProto(data).build('protobuf').UserModel;

		// 设置用户信息
		var userModel = new UserModel();
		userModel.set('UserNo', '10001');
		userModel.set('PassWord', 'password123');
		userModel.set('Status', '1');

		// 编码成二进制
		var buffer = userModel.encode().toBuffer();
		// 处理二进制编码...

		// 从二进制解码
		var userInfo = UserModel.decode(buffer);
		console.log(userInfo.get('UserNo'));
		console.log(userInfo.get('PassWord'));
		console.log(userInfo.get('Status'));
	}
})();