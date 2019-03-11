package laya.webgl.utils {
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;

	/**
	 * 用来画矢量的mesh。顶点格式固定为 x,y,rgba
	 */
	public class MeshVG extends Mesh2D {
		public static var const_stride:int = 12;// 36;
		private static var _fixattriInfo:Array = [		
			WebGLContext.FLOAT, 2, 0,	//x,y
			WebGLContext.UNSIGNED_BYTE, 4, 8//rgba
			//WebGLContext.FLOAT, 4, 12, //clip dir [dirxx,dirxy,diryx,diryy]
			//WebGLContext.FLOAT, 2, 28	//clip [x,y] x,y已经转换了
			];
		private static var _POOL:Array = [];		
		
		public function MeshVG():void {
			super(MeshVG.const_stride,4,4);	//x,y,rgba
			canReuse = true;
			setAttributes(MeshVG._fixattriInfo);
		}
		
		public static function getAMesh():MeshVG {
			//console.log('getmeshvg');
			if (MeshVG._POOL.length) {
				return MeshVG._POOL.pop();
			}
			return new MeshVG();
		}
		
		/**
		 * 往矢量mesh中添加顶点和index。会把rgba和points在mesh中合并。
		 * @param	points	顶点数组，只包含x,y。[x,y,x,y...]
		 * @param	rgba	rgba颜色
		 * @param	ib		index数组。
		 */
		public function addVertAndIBToMesh(ctx:WebGLContext2D, points:Array, rgba:uint, ib:Array):void {
			var startpos:int = _vb.needSize(points.length / 2 * const_stride);//vb的起点。
			var f32pos:int = startpos >> 2;
			var vbdata:Float32Array = _vb._floatArray32 || _vb.getFloat32Array();
			var vbu32Arr:Uint32Array = _vb._uint32Array;
			var ci:int = 0;
			//vb
			//var clipinfo:Array = ctx.getTransedClipInfo();
			var sz:int = points.length / 2;
			for (var i:int = 0; i < sz; i++) {
				vbdata[f32pos++] = points[ci]; vbdata[f32pos++] = points[ci + 1]; ci += 2;
				vbu32Arr[f32pos++] = rgba;
				/*
				//裁剪信息。
				vbdata[f32pos++] = clipinfo[2] ; vbdata[f32pos++] = clipinfo[3]; vbdata[f32pos++] = clipinfo[4]; vbdata[f32pos++] = clipinfo[5];//cliprect的方向
				vbdata[f32pos++] = clipinfo[0]; vbdata[f32pos++] = clipinfo[1]; //cliprect的位置
				*/
			}
			_vb.setNeedUpload();
			
			//ib
			//TODO 现在这种添加数据的方法效率非常低。而且会引起大量的gc
			_ib.append(new Uint16Array(ib));
			_ib.setNeedUpload();
			
			vertNum += sz;
			indexNum += ib.length;
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
			MeshVG._POOL.push(this);
		}
		
		public override function destroy():void {
			_ib.destroy();
			_vb.destroy();
			_ib.disposeResource();
			_vb.deleteBuffer();
		}
	}
}