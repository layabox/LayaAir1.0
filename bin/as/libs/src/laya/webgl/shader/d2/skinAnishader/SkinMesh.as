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
		private var _tempMatrix:Matrix = new Matrix();
		public var transform:Matrix;
		
		private var _vs:Array;
		private var _ps:Array;
		private var _indexStart:int = -1;
		
		private var _verticles:Array;
		private var _uvs:Array;
		private static var _tempVS:Array = [];
		private static var _tempIB:Array = [];
		private static var _defaultPS:Array;
		private static var _tVSLen:int;
		
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
				if (!_defaultPS)
				{
					_defaultPS = [];
				    _defaultPS.push(0, 1, 3, 3, 1, 2);
				}
				_ps = _defaultPS;
			}
			mVBData = new Float32Array(_vs);
			mIBData = new Uint16Array(_ps.length);
			mIBData["start"] = -1;
			mEleNum = _ps.length;
			mTexture = texture;
		}
		
		
		public function init2(texture:Texture, vs:Array, ps:Array, verticles:Array, uvs:Array):void {
			if (transform) transform=null;
			if (ps) {
				_ps = ps;
			} else {
				_ps = [];
				_ps.push(0, 1, 3, 3, 1, 2);
			}
			_verticles = verticles;
			_uvs = uvs;
			mEleNum = _ps.length;
			mTexture = texture;
	       if (Render.isConchNode || Render.isConchApp)
	       {
			   _initMyData();
			   mVBData = new Float32Array(_vs);
		   }
		}
		
		
		private function _initMyData():void
		{
			var vsI:int=0;
			var vI:int=0;
			var vLen:int= _verticles.length;
			var tempVLen:int = vLen * 4;
			_vs = _tempVS;
			var insertNew:Boolean=false;
			if (Render.isConchNode || Render.isConchApp)
			{
				_vs.length = tempVLen;
				insertNew = true;
			}else
			{
				if (_vs.length < tempVLen)
				{
					_vs.length = tempVLen;
					insertNew = true;
				}
			}
			_tVSLen = tempVLen;
			if (insertNew)
			{
				while (vsI < tempVLen)
				{
					_vs[vsI] = _verticles[vI];
					_vs[vsI + 1] = _verticles[vI + 1];
					_vs[vsI + 2] = _uvs[vI];
					_vs[vsI + 3] = _uvs[vI + 1];
					_vs[vsI + 4] = 1;
					_vs[vsI + 5] = 1;
					_vs[vsI + 6] = 1;
					_vs[vsI + 7] = 1;
					vsI += 8;
					vI += 2;
				}
			}else
			{
				while (vsI < tempVLen)
				{
					_vs[vsI] = _verticles[vI];
					_vs[vsI + 1] = _verticles[vI + 1];
					_vs[vsI + 2] = _uvs[vI];
					_vs[vsI + 3] = _uvs[vI + 1];
					vsI += 8;
					vI += 2;
				}
			}
			
		}
		
		public function getData2(vb:VertexBuffer2D, ib:IndexBuffer2D, start:int):void {	
			mVBBuffer = vb;
			mIBBuffer = ib;
			_initMyData();

			vb.appendEx2(_vs, Float32Array,_tVSLen,4);
			
			_indexStart = ib._byteLength;
			var tIB:Array;
			tIB = _tempIB;
			if (tIB.length < _ps.length)
			{
				tIB.length = _ps.length;
			}
			

			for (var i:int = 0, n:int = _ps.length; i < n; i++) {
				tIB[i] = _ps[i] + start;
			}
			ib.appendEx2(tIB, Uint16Array, _ps.length, 2);

		}
		
		public function getData(vb:VertexBuffer2D, ib:IndexBuffer2D, start:int):void {	
			mVBBuffer = vb;
			mIBBuffer = ib;
			vb.append(mVBData);
			_indexStart = ib._byteLength;
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
				Matrix.mul(transform, context._curMat, _tempMatrix);
				transform.translate( -x, -y);
				//此处每次都创建新的数组，应该可以改成使用对象池
				
				var tShaderValue:SkinSV = tempSubmit.shaderValue as SkinSV;
				var tArray:Array = tShaderValue.u_mmat2||RenderState2D.getMatrArray();
				RenderState2D.mat2MatArray(_tempMatrix, tArray);

				tShaderValue.textureHost = mTexture;
				tShaderValue.offsetX = 0;
				tShaderValue.offsetY = 0;
				tShaderValue.u_mmat2 = tArray;
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