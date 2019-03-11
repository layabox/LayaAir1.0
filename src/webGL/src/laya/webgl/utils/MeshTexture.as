 package laya.webgl.utils {
	import laya.maths.Matrix;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;

	/**
	 * 与MeshQuadTexture基本相同。不过index不是固定的
	 */
	public class MeshTexture extends Mesh2D {
		public static var const_stride:int = 24;
		private static var _fixattriInfo:Array = [
			WebGLContext.FLOAT, 4, 0,	//pos,uv
			WebGLContext.UNSIGNED_BYTE, 4, 16,	//color alpha
			WebGLContext.UNSIGNED_BYTE,4,20	//flags
			];
		private static var _POOL:Array = [];
		public function MeshTexture():void {
			super(MeshTexture.const_stride,4,4);	//x,y,u,v,rgba
			canReuse = true;
			setAttributes(MeshTexture._fixattriInfo);
		}
		private static var tmpIdx:Uint16Array = new Uint16Array(4);		//用来临时修改index
		
		/**
		 * 
		 */
		public static function getAMesh():MeshTexture {
			//console.log('getmesh');
			if (MeshTexture._POOL.length) {
				return MeshTexture._POOL.pop();
			}
			return new MeshTexture();
		}
		
		public function addData(vertices:Float32Array, uvs:Float32Array, idx:Uint16Array, matrix:Matrix, rgba:uint,ctx:WebGLContext2D):void {
			//vb
			var vertsz:int = vertices.length / 2;
			var startpos:int = _vb.needSize(vertsz * const_stride);//vb的起点。			
			var f32pos:int = startpos >> 2;
			var vbdata:Float32Array = _vb._floatArray32 || _vb.getFloat32Array();
			var vbu32Arr:Uint32Array = _vb._uint32Array;
			var ci:int = 0;
			//var clipinfo:Array = ctx.getTransedClipInfo();
			for (var i:int = 0; i < vertsz; i++) {
				var x:Number = vertices[ci], y:Number = vertices[ci + 1];
				var x1:Number = x * matrix.a + y * matrix.c + matrix.tx;
				var y1:Number = x * matrix.b + y * matrix.d + matrix.ty;
				vbdata[f32pos++] = x1; vbdata[f32pos++] = y1;
				vbdata[f32pos++] = uvs[ci]; vbdata[f32pos++] = uvs[ci + 1];
				ci += 2;
				vbu32Arr[f32pos++] = rgba;
				vbu32Arr[f32pos++] = 0xff;
				//裁剪信息。
				//vbdata[f32pos++] = clipinfo[2] ; vbdata[f32pos++] = clipinfo[3]; vbdata[f32pos++] = clipinfo[4]; vbdata[f32pos++] = clipinfo[5];//cliprect的方向
				//vbdata[f32pos++] = clipinfo[0]; vbdata[f32pos++] = clipinfo[1];	//cliprect的位置
			}
			_vb.setNeedUpload();
			
			var vertN:int = vertNum;
			if (vertN > 0) {
				var sz:int = idx.length;
				if (sz > tmpIdx.length) tmpIdx = new Uint16Array(sz);
				for (var ii:int = 0; ii < sz; ii++) {
					tmpIdx[ii] = idx[ii] + vertN;
				}
				_ib.appendU16Array(tmpIdx, idx.length);
			}else {
				_ib.append(idx);	
			}
			_ib.setNeedUpload();
			
			vertNum += vertsz;
			indexNum += idx.length;
		}
		
		/**
		 * 把本对象放到回收池中，以便getMesh能用。
		 */
		public override function releaseMesh():void {
			_vb.setByteLength(0);
			_ib.setByteLength(0);
			vertNum = 0;
			indexNum = 0;
			//_applied = false;
			MeshTexture._POOL.push(this);
		}
		
		public override function destroy():void {
			_ib.destroy();
			_vb.destroy();
			_ib.disposeResource();
			_vb.deleteBuffer();
		}
	}
}