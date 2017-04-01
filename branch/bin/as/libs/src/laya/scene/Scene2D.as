package laya.scene {
	import laya.display.Sprite;
	import laya.utils.ClassUtils;
	public class Scene2D extends Sprite {
		public function Scene2D() {
			super();
			createChildren();
		}
		
		/**
		 * <p>创建并添加控件子节点。</p>
		 * @internal 子类可在此函数内创建并添加子节点。
		 */
		protected function createChildren():void {
		}
		
		protected function createView(sceneData:Object):void {
			ClassUtils.createByJson(sceneData, this, this);
		}
	}
}