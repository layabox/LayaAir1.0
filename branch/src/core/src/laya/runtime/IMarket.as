package laya.runtime {
	
	/**
	 * @private
	 */
	public interface IMarket {
		/**
		 * 登录
		 * @param	jsonParm
		 * @param	callback
		 */
		function login(jsonParm:String, callback:Function):void;
		
		/**
		 * 登出
		 * @param	jsonParm
		 * @param	callback
		 */
		function logout(jsonParm:String, callback:Function):void;
		/**
		 * 授权
		 * @param	jsonParm
		 * @param	callback
		 */
		function authorize(jsonParm:String, callback:Function):void;
		/**
		 * 进入论坛
		 * @param	jsonParm
		 * @param	callback
		 */
		function enterBBS(jsonParm:String, callback:Function):void;
		/**
		 * 刷新票据
		 * @param	jsonParm
		 * @param	callback
		 */
		function refreshToken(jsonParm:String, callback:Function):void;
		/**
		 * 支付
		 * @param	jsonParm
		 * @param	callback
		 */
		function recharge(jsonParm:String, callback:Function):void;
		/**
		 * 分享
		 * @param	jsonParm
		 * @param	callback
		 */
		function enterShareAndFeed(jsonParm:String, callback:Function):void;
		/**
		 * 邀请
		 * @param	jsonParm
		 * @param	callback
		 */
		function enterInvite(jsonParm:String, callback:Function):void;
		/**
		 * 获取游戏好友
		 * @param	jsonParm
		 * @param	callback
		 */
		function getGameFriends(jsonParm:String, callback:Function):void;
		/**
		 * 发送到桌面
		 * @param	jsonParm
		 * @param	callback
		 */
		function sendToDesktop(jsonParm:String, callback:Function):void;
		/**
		 * 发送自定义消息
		 * @param	jsonParm
		 * @param	callback
		 */
		function sendMessageToPlatform(jsonParm:String, callback:Function):void;
		/**
		 * 获取用户信息
		 * @param	jsonParm
		 * @param	callback
		 */
		function getUserInfo(jsonParm:String, callback:Function):void;
		/**
		 * 返回Market名称
		 */
		function getMarketName():String;
		/**
		 * 返回支付类型 自定义
		 */
		function getPayType():int;
		/**
		 * 返回登录类型 自定义
		 */
		function getLoginType():int;
		/**
		 *
		 */
		function getChargeType():int;
	
	}

}