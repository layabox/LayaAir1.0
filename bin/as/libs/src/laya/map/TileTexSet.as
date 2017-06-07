package laya.map {
	import laya.map.TileAniSprite;
	import laya.resource.Texture;
	import laya.utils.Browser;
	
	/**
	 * 此类是子纹理类，也包括同类动画的管理
	 * TiledMap会把纹理分割成无数子纹理，也可以把其中的某块子纹理替换成一个动画序列
	 * 本类的实现就是如果发现子纹理被替换成一个动画序列，animationKey会被设为true
	 * 即animationKey为true,就使用TileAniSprite来做显示，把动画序列根据时间画到TileAniSprite上
	 * @author ...
	 */
	public class TileTexSet {
		
		/**唯一标识*/
		public var gid:int = -1;
		/**子纹理的引用*/
		public var texture:Texture;
		/**纹理显示时的坐标偏移X*/
		public var offX:int = 0;
		/**纹理显示时的坐标偏移Y*/
		public var offY:int = 0;
		
		//下面是动画支持需要的
		/**当前要播放动画的纹理序列*/
		public var textureArray:Array = null;
		/** 当前动画每帧的时间间隔*/
		public var durationTimeArray:Array = null;
		/** 动画播放的总时间 */
		public var animationTotalTime:Number = 0;
		/**true表示当前纹理，是一组动画，false表示当前只有一个纹理*/
		public var isAnimation:Boolean = false;
		
		private var _spriteNum:int = 0;				//当前动画有多少个显示对象
		private var _aniDic:Object = null;			//通过显示对象的唯一名字，去保存显示显示对象
		private var _frameIndex:int = 0;			//当前动画播放到第几帧
		
		private var _time:int = 0;					//距离上次动画刷新，过了多少长时间
		private var _interval:int = 0;				//每帧刷新的时间间隔
		private var _preFrameTime:int = 0;			//上一帧刷新的时间戳
		
		/**
		 * 加入一个动画显示对象到此动画中
		 * @param	aniName	//显示对象的名字
		 * @param	sprite	//显示对象
		 */
		public function addAniSprite(aniName:String, sprite:TileAniSprite):void {
			if (animationTotalTime == 0) {
				return;
			}
			if (_aniDic == null) {
				_aniDic = {};
			}
			if (_spriteNum == 0) {
				//每3帧刷新一下吧，每帧刷新可能太耗了
				Laya.timer.frameLoop(3, this, animate);
				_preFrameTime = Browser.now();
				_frameIndex = 0;
				_time = 0;
				_interval = 0;
			}
			_spriteNum++;
			_aniDic[aniName] = sprite;
			if (textureArray && _frameIndex < textureArray.length) {
				var tTileTextureSet:TileTexSet = textureArray[_frameIndex];
				drawTexture(sprite, tTileTextureSet);
			}
		}
		
		/**
		 * 把动画画到所有注册的SPRITE上
		 */
		private function animate():void {
			if (textureArray && textureArray.length > 0 && durationTimeArray && durationTimeArray.length > 0) {
				var tNow:Number = Browser.now();
				_interval = tNow - _preFrameTime;
				_preFrameTime = tNow;
				if (_interval > animationTotalTime) {
					_interval = _interval % animationTotalTime;
				}
				_time += _interval;
				var tTime:int = durationTimeArray[_frameIndex];
				while (_time > tTime) {
					_time -= tTime;
					_frameIndex++;
					if (_frameIndex >= durationTimeArray.length || _frameIndex >= textureArray.length) {
						_frameIndex = 0;
					}
					var tTileTextureSet:TileTexSet = textureArray[_frameIndex];
					var tSprite:TileAniSprite;
					for (var p:* in _aniDic) {
						tSprite = _aniDic[p];
						drawTexture(tSprite, tTileTextureSet);
					}
					tTime = durationTimeArray[_frameIndex];
				}
			}
		}
		
		private function drawTexture(sprite:TileAniSprite, tileTextSet:TileTexSet):void {
			sprite.graphics.clear();
			//sprite.graphics.drawTexture(tileTextSet.texture, tileTextSet.offX, tileTextSet.offY, tileTextSet.texture.width, tileTextSet.texture.height);
			sprite.graphics.drawTexture(tileTextSet.texture, tileTextSet.offX, tileTextSet.offY);
		}
		
		/**
		 * 移除不需要更新的SPRITE
		 * @param	_name
		 */
		public function removeAniSprite(_name:String):void {
			if (_aniDic && _aniDic[_name]) {
				delete _aniDic[_name];
				_spriteNum--
				if (_spriteNum == 0) {
					Laya.timer.clear(this, animate);
				}
			}
		}
		
		/**
		 * 显示当前动画的使用情况
		 */
		public function showDebugInfo():String {
			var tInfo:String = null;
			if (_spriteNum > 0) {
				tInfo = "TileTextureSet::gid:" + gid.toString() + " 动画数:" + _spriteNum.toString();
			}
			return tInfo;
		}
		
		/**
		 * 清理
		 */
		public function clearAll():void {
			gid = -1;//唯一标识
			if (texture) {
				texture.destroy();
				texture = null;
			}
			offX = 0;
			offY = 0;
			
			textureArray = null;
			durationTimeArray = null;
			isAnimation = false;
			_spriteNum = 0;
			_aniDic = null;
			_frameIndex = 0;
			_preFrameTime = 0;
			_time = 0;
			_interval = 0;
		}
	
	}

}