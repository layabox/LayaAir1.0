 package laya.webgl.utils {
	import laya.maths.Matrix;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;

	/**
	 * 与MeshQuadTexture基本相同。不过index不是固定的
	 */
	public class MeshTexture extends Mesh2D {
		public static const const_stride:int = 24;
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
		
		/**
		 * 
		 */
		public static function getAMesh():MeshTexture {
			//console.log('getmesh');
			var ret:MeshTexture;
			if (MeshTexture._POOL.length) {
				ret = MeshTexture._POOL.pop();
			}
			else ret = new MeshTexture();
			ret._vb._resizeBuffer(64 * 1024 * const_stride, false);
			return ret;
		}
		
		public function addData(vertices:Float32Array, uvs:Float32Array, idx:Uint16Array, matrix:Matrix, rgba:uint):void {
			//vb
			var vb:VertexBuffer2D = _vb;
			var ib:IndexBuffer2D = _ib;
			var vertsz:int = vertices.length >>1;
			var startpos:int = vb.needSize(vertsz * const_stride);//vb的起点。			
			var f32pos:int = startpos >> 2;
			var vbdata:Float32Array = vb._floatArray32 || vb.getFloat32Array();
			var vbu32Arr:Uint32Array = vb._uint32Array;
			var ci:int = 0;
			var m00:Number = matrix.a;
			var m01:Number = matrix.b;
			var m10:Number = matrix.c;
			var m11:Number = matrix.d;
			var tx:Number = matrix.tx;
			var ty:Number = matrix.ty;			
			var i:int = 0;
			//var clipinfo:Array = ctx.getTransedClipInfo();
			for ( i= 0; i < vertsz; i++) {
				var x:Number = vertices[ci], y:Number = vertices[ci + 1];
				vbdata[f32pos] = x * m00 + y * m10 + tx; 
				vbdata[f32pos+1] = x * m01 + y * m11 + ty;
				vbdata[f32pos+2] = uvs[ci]; 
				vbdata[f32pos+3] = uvs[ci + 1];
				vbu32Arr[f32pos+4] = rgba;
				vbu32Arr[f32pos + 5] = 0xff;
				f32pos += 6;
				//裁剪信息。
				//vbdata[f32pos++] = clipinfo[2] ; vbdata[f32pos++] = clipinfo[3]; vbdata[f32pos++] = clipinfo[4]; vbdata[f32pos++] = clipinfo[5];//cliprect的方向
				//vbdata[f32pos++] = clipinfo[0]; vbdata[f32pos++] = clipinfo[1];	//cliprect的位置
				ci += 2;
			}
			vb.setNeedUpload();
			
			var vertN:int = vertNum;
			var sz:int = idx.length;
			var stib:int = ib.needSize(idx.byteLength);
			var cidx:Uint16Array = ib.getUint16Array();
			//var cidx:Uint16Array = new Uint16Array(__JS__('ib._buffer'), stib);
			var stibid:int = stib >> 1;	// indexbuffer的起始位置
			if (vertN > 0) {
				var end:int = stibid + sz;
				var si:int = 0;
				for (i = stibid; i < end; i++,si++) {
					cidx[i] = idx[si] + vertN;	
				}
			}else {
				cidx.set(idx,stibid);
			}
			ib.setNeedUpload();
			
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