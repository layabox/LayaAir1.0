package laya.webgl.shader.d2.skinAnishader {
	import laya.maths.Matrix;
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.skinAnishader.SkinAniShader;
	import laya.webgl.shader.d2.skinAnishader.aniShaderValue;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	/**
	 * 这里销毁的问题，后面待确认
	 */
	public class SkinMesh {
		
		private var mShaderValue:aniShaderValue;
		
		private var mVBBuffer:VertexBuffer2D;
		private var mIBBuffer:IndexBuffer2D;
		private var mVBData:Float32Array;
		private var mIBData:Uint16Array;
		private var mEleNum:int = 0;
		private var mTexture:Texture;
		public var transform:Matrix;
		
		private var _vs:Array;
		private var _ps:Array;
		private var _resultPs:Array;
		private var _start:int = -1;
		private var _indexStart:int = -1;
		
		public function SkinMesh() {
		
		}
		
		public function init(texture:Texture, vs:Array, ps:Array):void {
			if (vs) {
				_vs = vs;
			} else {
				_vs = [];
				var tWidth:int = texture.width;
				var tHeight:int = texture.height;
				var tRed:Number = 1;
				var tGreed:Number = 1;
				var tBlue:Number = 1;
				var tAlpha:Number = 1;
				_vs.push(0, 0, 0, 0, tRed, tGreed, tBlue, tAlpha);
				_vs.push(tWidth, 0, 1, 0, tRed, tGreed, tBlue, tAlpha);
				_vs.push(tWidth, tHeight, 1, 1, tRed, tGreed, tBlue, tAlpha);
				_vs.push(0, tHeight, 0, 1, tRed, tGreed, tBlue, tAlpha);
			}
			if (ps) {
				_ps = ps;
			} else {
				_ps = [];
				_ps.push(0, 1, 3, 3, 1, 2);
			}
			mVBData = new Float32Array(_vs);
			mEleNum = _ps.length;
			mTexture = texture;
			if (mShaderValue == null) {
				mShaderValue = new aniShaderValue();
			}
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
				mShaderValue.textureHost = mTexture;
				SkinMeshBuffer.getInstance().addSkinMesh(this);
				(context as WebGLContext2D).setIBVB(x, y, mIBBuffer, mVBBuffer, mEleNum, transform, SkinAniShader.getInstance(), mShaderValue, _indexStart, 0, 1);
			}
			
		}
	
	}

}