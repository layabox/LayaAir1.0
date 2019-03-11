package laya.ui {
	import laya.display.Stage;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	
	/**
	 * 微信开放数据展示组件，直接实例本组件，即可根据组件宽高，位置，以最优的方式显示开放域数据
	 */
	public class WXOpenDataViewer extends UIComponent {
		private var _texture:Texture;
		
		public function WXOpenDataViewer() {
			this._width = this._height = 200;
			var tex:Texture = new Texture();
			if (Laya["Texture2D"]) {
				tex.bitmap = new Laya["Texture2D"]();
				this.texture = tex;
			} else {
				throw new Error("WXOpenDataViewer:webgl not found!");
			}
		}
		
		override public function onEnable():void {
			postMsg({type: "display",rate:Laya.stage.frameRate});
			if (window.wx && window.sharedCanvas) Laya.timer.frameLoop(1, this, _onLoop);
		}
		
		override public function onDisable():void {
			postMsg({type: "undisplay"});
			Laya.timer.clear(this, _onLoop);
		}
		
		private function _onLoop():void {
			texture.bitmap.loadImageSource(window.sharedCanvas);
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if (window.sharedCanvas) window.sharedCanvas.width = value;
			callLater(_postMsg);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			if (window.sharedCanvas) window.sharedCanvas.height = value;
			callLater(_postMsg);
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			callLater(_postMsg);
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			callLater(_postMsg);
		}
		
		private function _postMsg():void {
			var mat:Matrix = new Matrix();
			mat.translate(this.x, this.y);
			var stage:Stage = Laya.stage;
			mat.scale(stage._canvasTransform.getScaleX() * this.globalScaleX * stage.transform.getScaleX(), stage._canvasTransform.getScaleY() * this.globalScaleY * stage.transform.getScaleY());
			postMsg({type: "changeMatrix", a: mat.a, b: mat.b, c: mat.c, d: mat.d, tx: mat.tx, ty: mat.ty, w: this.width, h: this.height});
		}
		
		/**向开放数据域发送消息*/
		public function postMsg(msg:Object):void {
			if (window.wx && window.wx.getOpenDataContext) {
				var openDataContext:* = window.wx.getOpenDataContext();
				openDataContext.postMessage(msg);
			}
		}
	}
}