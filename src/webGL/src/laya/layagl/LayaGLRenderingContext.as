package laya.layagl {
	
	import laya.display.Text;
	import laya.display.cmd.DrawCanvasCmd;
	import laya.display.cmd.DrawImageCmd;
	import laya.display.cmd.FillTextCmd;
	import laya.display.cmd.RestoreCmd;
	import laya.display.cmd.RotateCmd;
	import laya.display.cmd.SaveCmd;
	import laya.display.cmd.ScaleCmd;
	import laya.display.cmd.TransformCmd;
	import laya.display.cmd.TranslateCmd;
	import laya.maths.Matrix;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.RenderTexture2D;
	
	/**
	 * @private
	 * 封装GL命令
	 */
	public class LayaGLRenderingContext {
		
		//TODO:coverage
		private var _customCmds:*;//TODO:这个变量没有,下面有编译错误,临时整个
		public var _targets:RenderTexture2D;
		public var _width:int;
		public var _height:int;
		private var _cmdEncoder:*;
		//TODO:coverage
		public function drawTexture(texture:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			drawImage(texture, x, y, width, height);
		}
		
		//TODO:coverage
		public function drawImage(texture:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			this._customCmds.push( DrawImageCmd.create.call(this,texture, x, y, width, height));
		}
		
		//TODO:coverage
		public function fillText(text:String, x:Number, y:Number, font:String, color:String, textAlign:String):void 
		{
			this._customCmds.push(FillTextCmd.create.call(this,text, x, y, font||Text.defaultFontStr(), color, textAlign));
		}
		
		//TODO:coverage
		public function save():void
		{
			this._customCmds.push(SaveCmd.create.call(this));
		}
		
		//TODO:coverage
		public function restore():void
		{
			this._customCmds.push(RestoreCmd.create.call(this));
		}
		
		//TODO:coverage
		public function translate(tx:Number, ty:Number):void 
		{
			this._customCmds.push(TranslateCmd.create.call(this, tx, ty));
		}
		
		//TODO:coverage
		public function rotate(angle:Number, pivotX:Number = 0, pivotY:Number = 0):void 
		{
			this._customCmds.push(RotateCmd.create.call(this,angle, pivotX, pivotY));
		}
		
		//TODO:coverage
		public function scale(scaleX:Number, scaleY:Number, pivotX:Number = 0, pivotY:Number = 0):void 
		{
			this._customCmds.push(ScaleCmd.create.call(this,scaleX, scaleY, pivotX, pivotY));
		}
		
		//TODO:coverage
		public function transform(matrix:Matrix, pivotX:Number = 0, pivotY:Number = 0):void 
		{
			this._customCmds.push(TransformCmd.create.call(this,matrix, pivotX, pivotY));
		}
		public function set asBitmap(value:Boolean):void 
		{
			if (value)
			{
				//缺省的RGB没有a，不合理把。况且没必要自定义一个常量。
				//深度格式为-1表示不用深度缓存。
				_targets || (_targets = new RenderTexture2D(_width, _height,BaseTexture.FORMAT_R8G8B8A8,-1));
				if (!_width || !_height)
					throw Error("asBitmap no size!");
			} 
			else
			{
				_targets = null;
			}
		}
		public function get asBitmap():Boolean
		{
			return !_targets;
		}
		
		//TODO:coverage
		public function beginRT():void
		{
			RenderTexture2D.pushRT();
			_targets.start();
			this.clear();
		}
		
		public function clear():void
		{
			
		}
		
		//TODO:coverage
		public function endRT():void
		{
			RenderTexture2D.popRT();
		}
		
		//TODO:coverage
		public function drawCanvas(canvas:HTMLCanvas, x:int, y:int):void
		{
			var target:RenderTexture2D = canvas.context._targets;
			this._customCmds.push( DrawCanvasCmd.create.call(this,target, x, y, target.width, target.height));
		}
		
		//TODO:coverage
		public function drawTarget(commandEncoder:*, texture:RenderTexture2D, x:int, y:int, width:int, height:int):void
		{
			var vbData:ArrayBuffer = new ArrayBuffer(24 * 4);
			var _i32b:Int32Array = new Int32Array(vbData);
			var _fb:Float32Array = new Float32Array(vbData);
			var w:Number = width != 0 ? width :  texture.width;
			var h:Number = height != 0 ? height :  texture.height;
			var uv:Array = RenderTexture2D.flipyuv;
			var ix:int = 0;
			_fb[ix++] = x; 		_fb[ix++] = y; 		_fb[ix++] = uv[0]; 	_fb[ix++] = uv[1]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[ix++] = x + w; 	_fb[ix++] = y; 		_fb[ix++] = uv[2]; 	_fb[ix++] = uv[3]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[ix++] = x + w; 	_fb[ix++] = y + h;	_fb[ix++] = uv[4];  _fb[ix++] = uv[5]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[ix++] = x;		_fb[ix++] = y + h;  _fb[ix++] = uv[6];	_fb[ix++] = uv[7]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			
			commandEncoder.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
			commandEncoder.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
			commandEncoder.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
			commandEncoder.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
			commandEncoder.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
			commandEncoder.uniformTexture(0, WebGLContext.TEXTURE0, texture._getSource());
			commandEncoder.setRectMesh(1, vbData);
			commandEncoder.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
			commandEncoder.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
		}
		public function getImageData(x:Number, y:Number, width:Number, height:Number, callBack:Function):void {
			var w:Number = _targets.sourceWidth;
			var h:Number = _targets.sourceHeight;
			
			if (x < 0 || y < 0 || width < 0 || height < 0 || width > w || height > h)
			{
				return;
			}
			if (!_cmdEncoder)
			{
				this._cmdEncoder = LayaGL.instance.createCommandEncoder(128, 64, false);
			}
		
			var gl:* = LayaGL.instance;
			_cmdEncoder.beginEncoding();
			_cmdEncoder.clearEncoding();
			
			RenderTexture2D.pushRT();
			_targets.start();
			
			
			gl.readPixelsAsync(x, y, width, height, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, function(data:ArrayBuffer):void {
				__JS__("callBack(data)");
			});
			
			this.endRT();
			_cmdEncoder.endEncoding();
			gl.useCommandEncoder( _cmdEncoder.getPtrID(), -1, 0);
		}	
		public function toBase64(type:String, encoderOptions:Number, callBack:Function):void {		
			var width:Number = _targets.sourceWidth;
			var height:Number = _targets.sourceHeight;
			this.getImageData(0, 0, width, height, function(data:ArrayBuffer):void {
				__JS__("var base64 = conchToBase64(type, encoderOptions, data, width, height)");
				__JS__("callBack(base64)");
			});
		}
		
	}
}

