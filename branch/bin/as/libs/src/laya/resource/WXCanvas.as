package laya.resource {
	
	/**
	 * @private
	 */
	public class WXCanvas {
		public static var wx:* = null;
		
		private var _ctx:*;
		private var _id:String;
		private var style:* = {};
		
		public function WXCanvas(id:*) {
			_id = id;		
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		public function getContext():* {
			var wx:* = WXCanvas.wx;
			var ctx:* = wx.createContext();
			ctx.id = _id;
			ctx.fillRect = function(x:Number, y:Number, w:Number, h:Number):void {
				this.rect(x, y, w, h);
				this.fill();
			}
			ctx.strokeRect = function(x:Number, y:Number, w:Number, h:Number):void {
				this.rect(x, y, w, h);
				this.stroke();
			}
			ctx.___drawImage = ctx.drawImage;
			ctx.drawImage = function():void
			{
				var img:Object = arguments[0].tempFilePath;
				if (img == null) return;
				
				switch(arguments.length)
				{
					case 3:
						this.___drawImage(img, arguments[1], arguments[2], arguments[0].width, arguments[0].height);
						return;
					case 5:
						this.___drawImage(img, arguments[1], arguments[2], arguments[3], arguments[4]);
						return;
					case 9:
						this.___drawImage(img, arguments[5], arguments[6], arguments[7], arguments[8]);
						return;
				}
			}
			
			//[IF-SCRIPT]Object.defineProperty(ctx, "strokeStyle", { set:function(value) { this.setStrokeStyle(value) }, enumerable:false } );
			//[IF-SCRIPT]Object.defineProperty(ctx, "fillStyle", { set:function(value) { this.setFillStyle(value) }, enumerable:false } );
			//[IF-SCRIPT]Object.defineProperty(ctx, "fontSize", { set:function(value) { this.setFontSize(value) }, enumerable:false } );
			//[IF-SCRIPT]Object.defineProperty(ctx, "lineWidth", { set:function(value) { this.setLineWidth(value) }, enumerable:false } );
			
			Context.__init__(ctx);
			ctx.flush = function():void {
				wx.drawCanvas({canvasId: this.id, actions: this.getActions()});
			}
			return ctx;
		
		}
		
		public function oncontextmenu(e:*):void {
		}
		
		public function addEventListener():void {
		}	
	}
}