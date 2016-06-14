/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya
{
	import Loader = laya.net.Loader;
	import Browser = laya.utils.Browser;
	import Handler = laya.utils.Handler;
	
	export class Network_ProtocolBuffer 
	{
		private ProtoBuf:any = Browser.window.dcodeIO.ProtoBuf;
		
		constructor()
		{
			Laya.init(550, 400);
			
			Laya.loader.load("res/protobuf/user.proto", Handler.create(this, this.onAssetsLoaded));
		}
		
		private onAssetsLoaded(data:string):void
		{
			var UserModel:any = this.ProtoBuf.loadProto(data).build('protobuf').UserModel;
			
			// 设置用户信息
			var userModel:any = new UserModel();
			userModel.set('UserNo', '10001');
			userModel.set('PassWord', 'password123');
			userModel.set('Status', '1');
			
			// 编码成二进制
			var buffer:any = userModel.encode().toBuffer();
			// 处理二进制编码...
			
			// 从二进制解码
			var userInfo:any = UserModel.decode(buffer);
			console.log(userInfo.get('UserNo'));
			console.log(userInfo.get('PassWord'));
			console.log(userInfo.get('Status'));
		}
	}
}
new laya.Network_ProtocolBuffer();