package laya.webgl.shader.d2.fillTexture {
	import laya.maths.Matrix;
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	public class FillTextureSprite {
		
		private var mVBBuffer:VertexBuffer2D;
		private var mIBBuffer:IndexBuffer2D;
		private var mVBData:Float32Array;
		private var mIBData:Uint16Array;
		private var mEleNum:int = 0;
		private var mShaderValue:FillTextureSV;
		private var mTexture:Texture;
		private var _tempMatrix:Matrix = new Matrix();
		public var transform:Matrix;
		
		private var _start:int = -1;
		private var _indexStart:int = -1;
		private var _resultPs:Array;
		private var _ps:Array;
		private var _vb:Array;
		
		public var u_texRange:Array = [0, 1, 0, 1];
		public var u_offset:Array = [0, 0];
		
		
		public function FillTextureSprite() {
		
		}
		
		public function initTexture(texture:Texture, x:Number, y:Number, width:Number, height:Number, offsetX:Number, offsetY:Number):void {
			mTexture = texture;
			if (_vb == null)_vb = [];
			_vb.length = 0;
			var w:Number = texture.bitmap.width, h:Number = texture.bitmap.height, uv:Array = texture.uv;
			var tTextureX:Number = uv[0] * w;
			var tTextureY:Number = uv[1] * h;
			var tTextureW:Number = (uv[2] - uv[0]) * w;
			var tTextureH:Number = (uv[5] - uv[3]) * h;
			var tU:Number = width / tTextureW;
			var tV:Number = height / tTextureH;
			var tWidth:int = width;
			var tHeight:int = height;
			var tRed:Number = 1;
			var tGreed:Number = 1;
			var tBlue:Number = 1;
			var tAlpha:Number = 1;
			
			_vb.push(x, y, 0, 0, tRed, tGreed, tBlue, tAlpha);
			_vb.push(x + tWidth, y, tU, 0, tRed, tGreed, tBlue, tAlpha);
			_vb.push(x + tWidth, y + tHeight, tU, tV, tRed, tGreed, tBlue, tAlpha);
			_vb.push(x, y + tHeight, 0, tV, tRed, tGreed, tBlue, tAlpha);
			if (_ps == null) _ps = [];
			_ps.length = 0;
			_ps.push(0, 1, 3, 3, 1, 2);
			
			mEleNum = _ps.length;	
			mVBData = new Float32Array(_vb);
			u_offset[0] = -offsetX / tTextureW;
			u_offset[1] = -offsetY / tTextureH;
			u_texRange[0] = tTextureX / w;
			u_texRange[1] = tTextureW / w;
			u_texRange[2] = tTextureY / h;
			u_texRange[3] = tTextureH / h;
		}
		
		public function getData(vb:VertexBuffer2D, ib:IndexBuffer2D, start:int):void {
			mVBBuffer = vb;
			mIBBuffer = ib;
			vb.append(mVBData);
			_start = start;
			_indexStart = ib.byteLength;
			if (_resultPs == null)_resultPs = [];
			_resultPs.length = 0;
			for (var i:int = 0, n:int = _ps.length; i < n; i++) {	
				_resultPs.push(_ps[i] + start);
			}
			mIBData = new Uint16Array(_resultPs);
			ib.append(mIBData);
		}
		
		public function render(context:*, x:Number, y:Number):void {
			if (Render.isWebGL) {
				SkinMeshBuffer.getInstance().addFillTexture(this);
				if (mIBBuffer && mIBBuffer)
				{
					context._shader2D.glTexture = null;
					var tempSubmit:Submit = Submit.createShape(context, mIBBuffer, mVBBuffer, mEleNum, _indexStart, Value2D.create(ShaderDefines2D.FILLTEXTURE, 0));
					Matrix.TEMP.identity();
					transform || (transform = Matrix.EMPTY);
					transform.translate(x, y);
					Matrix.mul(transform, context._curMat, _tempMatrix);
					transform.translate(-x, -y);
					var tArray:Array = RenderState2D.getMatrArray();
					RenderState2D.mat2MatArray(_tempMatrix, tArray);
				
					var tShaderValue:FillTextureSV = tempSubmit.shaderValue as FillTextureSV;
					tShaderValue.textureHost = mTexture;
					tShaderValue.u_offset[0] = u_offset[0];
					tShaderValue.u_offset[1] = u_offset[1];
					tShaderValue.u_texRange[0] = u_texRange[0];
					tShaderValue.u_texRange[1] = u_texRange[1];
					tShaderValue.u_texRange[2] = u_texRange[2];
					tShaderValue.u_texRange[3] = u_texRange[3];
					tShaderValue.ALPHA = context._shader2D.ALPHA;
					tShaderValue.u_mmat2 = tArray;
					(context as WebGLContext2D)._submits[(context as WebGLContext2D)._submits._length++] = tempSubmit;
				}
			}
		
		}
	
	}

}