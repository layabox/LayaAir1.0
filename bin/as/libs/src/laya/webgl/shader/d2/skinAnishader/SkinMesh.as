package laya.webgl.shader.d2.skinAnishader {
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	/**
	 * 这里销毁的问题，后面待确认
	 */
	public class SkinMesh {
		
		private var mVBBuffer:VertexBuffer2D;
		private var mIBBuffer:IndexBuffer2D;
		private var mVBData:Float32Array;
		private var mIBData:Uint16Array;
		private var mEleNum:int = 0;
		private var mTexture:Texture;
		private var _tempMat16:Array = RenderState2D.getMatrArray();
		public var transform:Matrix;
		
		private var _vs:Array;
		private var _ps:Array;
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
			mIBData = new Uint16Array(_ps.length);
			mIBData["start"] = -1;
			mEleNum = _ps.length;
			mTexture = texture;
		}
		
		public function getData(vb:VertexBuffer2D, ib:IndexBuffer2D, start:int):void {	
			mVBBuffer = vb;
			mIBBuffer = ib;
			vb.append(mVBData);
			_indexStart = ib.byteLength;
			if (mIBData["start"] != start)
			{
				for (var i:int = 0, n:int = _ps.length; i < n; i++) {
					mIBData[i] = _ps[i] + start;
				}
				mIBData["start"] = start;
			}
			ib.append(mIBData);
		}
		
		public function render(context:*, x:Number, y:Number):void {
			if (Render.isWebGL && mTexture) {
				context._renderKey = 0;
				context._shader2D.glTexture = null;
				SkinMeshBuffer.getInstance().addSkinMesh(this);
				var tempSubmit:Submit = Submit.createShape(context, mIBBuffer, mVBBuffer, mEleNum, _indexStart, Value2D.create(ShaderDefines2D.SKINMESH, 0));
				transform || (transform = Matrix.EMPTY);
				transform.translate(x, y);
				Matrix.mul16(transform, context._curMat, _tempMat16);
				transform.translate( -x, -y);
				var tShaderValue:SkinSV = tempSubmit.shaderValue as SkinSV;
				tShaderValue.textureHost = mTexture;
				tShaderValue.offsetX = 0;
				tShaderValue.offsetY = 0;
				tShaderValue.u_mmat2 = _tempMat16;
				tShaderValue.ALPHA = context._shader2D.ALPHA;
				context._submits[context._submits._length++] = tempSubmit;
			}
			else if (Render.isConchApp&&mTexture)
			{
				transform || (transform=Matrix.EMPTY);
				context.setSkinMesh&&context.setSkinMesh(x, y, _ps, mVBData, mEleNum, 0, mTexture,this.transform );
			}
			
		}
	
	}

}