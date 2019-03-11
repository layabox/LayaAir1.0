package laya.webgl.utils {
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	/**
	 * drawImage，fillRect等会用到的简单的mesh。每次添加必然是一个四边形。
	 */
	public class MeshQuadTexture extends Mesh2D {
		public static var const_stride:int = 24;// 48;  24是不带clip的
		private static var _fixib:IndexBuffer2D;
		private static var _maxIB:int = 16 * 1024;
		private static var _fixattriInfo:Array = [
			WebGLContext.FLOAT, 4, 0,	//pos,uv
			WebGLContext.UNSIGNED_BYTE, 4, 16,	//color alpha
			WebGLContext.UNSIGNED_BYTE,4,20	//flags
			//WebGLContext.FLOAT, 4, 24,//clip dir [dirxx,dirxy,diryx,diryy] 都是缩放过的，并且*(w,h)了
			//WebGLContext.FLOAT, 2, 40	//clip [x,y] x,y已经转换了
			];
		private static var _POOL:Array = [];
		//private static var _num;
		public function MeshQuadTexture():void {
			super(MeshQuadTexture.const_stride,4,4);	//x,y,u,v,rgba
			canReuse = true;
			setAttributes(MeshQuadTexture._fixattriInfo);
			if(!MeshQuadTexture._fixib){
				createQuadIB(_maxIB);	//每个quad 4个顶点。正好达到64k的索引。
				MeshQuadTexture._fixib = _ib;
			}else {
				this._ib = MeshQuadTexture._fixib;
				this._quadNum = _maxIB;
			}
		}
		
		/**
		 * 
		 */
		public static function getAMesh():MeshQuadTexture {
			//console.log('getmesh');
			if (MeshQuadTexture._POOL.length) {
				return MeshQuadTexture._POOL.pop();
			}
			return new MeshQuadTexture();
		}
		
		/**
		 * 把本对象放到回收池中，以便getMesh能用。
		 */
		public override function releaseMesh():void {
			_vb.setByteLength(0);
			vertNum = 0;
			indexNum = 0;
			//_applied = false;
			MeshQuadTexture._POOL.push(this);
		}
		
		public override function destroy():void {
			//_ib.destroy(); ib是公用的。
			_vb.destroy();
			_vb.deleteBuffer();
		}
		
		/**
		 * 
		 * @param	pos
		 * @param	uv
		 * @param	color
		 * @param	clip   ox,oy,xx,xy,yx,yy
		 * @param 	useTex 是否使用贴图。false的话是给fillRect用的
		 */
		public function addQuad(pos:Array, uv:Array, color:uint, useTex:Boolean):void {
			var vb:VertexBuffer2D = _vb;
			var vpos:int = (vb._byteLength >> 2);	//float数组的下标
			//x,y,u,v,rgba
			vb.setByteLength((vpos + MeshQuadTexture.const_stride)<<2); //是一个四边形的大小，也是这里填充的大小
			var vbdata:Float32Array = vb._floatArray32 || vb.getFloat32Array();
			var vbu32Arr:Uint32Array = vb._uint32Array;
			var cpos:int = vpos;
			var useTexVal:int = useTex?0xff:0;
			vbdata[cpos++] = pos[0]; vbdata[cpos++] = pos[1]; vbdata[cpos++] = uv[0]; vbdata[cpos++] = uv[1]; vbu32Arr[cpos++] = color; vbu32Arr[cpos++] = useTexVal;
			vbdata[cpos++] = pos[2]; vbdata[cpos++] = pos[3]; vbdata[cpos++] = uv[2]; vbdata[cpos++] = uv[3]; vbu32Arr[cpos++] = color; vbu32Arr[cpos++] = useTexVal;
			vbdata[cpos++] = pos[4]; vbdata[cpos++] = pos[5]; vbdata[cpos++] = uv[4]; vbdata[cpos++] = uv[5]; vbu32Arr[cpos++] = color; vbu32Arr[cpos++] = useTexVal;
			vbdata[cpos++] = pos[6]; vbdata[cpos++] = pos[7]; vbdata[cpos++] = uv[6]; vbdata[cpos++] = uv[7]; vbu32Arr[cpos++] = color; vbu32Arr[cpos++] = useTexVal;
			vb._upload = true;
		}		
	}
}