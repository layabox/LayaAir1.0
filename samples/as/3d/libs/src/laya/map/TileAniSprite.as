package laya.map {
	import laya.display.Sprite;
	
	/**
	 * TildMap的动画显示对象（一个动画（TileTexSet），可以绑定多个动画显示对象（TileAniSprite））
	 * @author ...
	 */
	public class TileAniSprite extends Sprite {
		
		private var _tileTextureSet:TileTexSet = null;//动画的引用
		private var _aniName:String = null;//当前动画显示对象的名字，名字唯一
		
		/**
		 * 确定当前显示对象的名称以及属于哪个动画
		 * @param	aniName	当前动画显示对象的名字，名字唯一
		 * @param	tileTextureSet 当前显示对象属于哪个动画（一个动画，可以绑定多个同类显示对象）
		 */
		public function setTileTextureSet(aniName:String, tileTextureSet:TileTexSet):void {
			_aniName = aniName;
			_tileTextureSet = tileTextureSet;
			tileTextureSet.addAniSprite(_aniName, this);
		}
		
		/**
		 * 把当前动画加入到对应的动画刷新列表中
		 */
		public function show():void {
			_tileTextureSet.addAniSprite(_aniName, this);
		}
		
		/**
		 * 把当前动画从对应的动画刷新列表中移除
		 */
		public function hide():void {
			_tileTextureSet.removeAniSprite(_aniName);
		}
		
		/**
		 * 清理
		 */
		public function clearAll():void {
			_tileTextureSet.removeAniSprite(_aniName);
			this.destroy();
			_tileTextureSet = null;
			_aniName = null;
		}
	}

}