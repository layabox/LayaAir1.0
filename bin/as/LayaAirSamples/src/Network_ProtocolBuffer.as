package 
{
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	public class Network_ProtocolBuffer 
	{
		private var ProtoBuf:* = Browser.window.dcodeIO.ProtoBuf;
		
		public function Network_ProtocolBuffer() 
		{
			Laya.init(550, 400);
			
			Laya.loader.load("res/protobuf/user.proto", Handler.create(this, onAssetsLoaded));
		}
		
		private function onAssetsLoaded(data:String):void
		{
			var UserModel:* = ProtoBuf.loadProto(data).build('protobuf').UserModel;
			
			// 设置用户信息
			var userModel:* = new UserModel();
			userModel.set('UserNo', '10001');
			userModel.set('PassWord', 'password123');
			userModel.set('Status', '1');
			
			// 编码成二进制
			var buffer:* = userModel.encode().toBuffer();
			// 处理二进制编码...
			
			// 从二进制解码
			var userInfo:* = UserModel.decode(buffer);
			trace(userInfo.get('UserNo'));
			trace(userInfo.get('PassWord'));
			trace(userInfo.get('Status'));
		}
	}
}