package laya.webgl.utils {
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	/**
	 * drawImage，fillRect等会用到的简单的mesh。每次添加必然是一个四边形。
	 */
	public class MeshParticle2D extends Mesh2D {
		public static var const_stride:int = 29*4;
		private static var _fixattriInfo:Array = [
				WebGLContext.FLOAT, 4, 0,	//CornerTextureCoordinate
				WebGLContext.FLOAT, 3, 16,//pos
				WebGLContext.FLOAT, 3, 28,//vel
				WebGLContext.FLOAT, 4, 40,//start color
				WebGLContext.FLOAT, 4, 56,//end color
				WebGLContext.FLOAT, 3, 72,//size,rot
				WebGLContext.FLOAT, 2, 84,//radius
				WebGLContext.FLOAT, 4, 92,//radian
				WebGLContext.FLOAT, 1, 108,//AgeAddScale
				WebGLContext.FLOAT, 1, 112//birth time
			];
		private static var _POOL:Array = [];
		//TODO:coverage
		public function MeshParticle2D(maxNum:int):void {
			super(MeshParticle2D.const_stride,maxNum*4*const_stride,4);		//ib 先4
			canReuse = true;
			setAttributes(MeshParticle2D._fixattriInfo);
			createQuadIB(maxNum);
			_quadNum = maxNum;
		}
		
		public function setMaxParticleNum(maxNum:int):void {
			_vb._resizeBuffer(maxNum * 4 * const_stride,false);
			createQuadIB(maxNum);
		}
		
		/**
		 * 
		 */
		//TODO:coverage
		public static function getAMesh(maxNum:int):MeshParticle2D {
			//console.log('getmesh');
			if (MeshParticle2D._POOL.length) {
				var ret:MeshParticle2D = MeshParticle2D._POOL.pop();
				ret.setMaxParticleNum(maxNum);
				return ret;
			}
			return new MeshParticle2D(maxNum);
		}
		
		/**
		 * 把本对象放到回收池中，以便getMesh能用。
		 */
		//TODO:coverage
		public override function releaseMesh():void {
			debugger;
			_vb.setByteLength(0);
			vertNum = 0;
			indexNum = 0;
			//_applied = false;
			MeshParticle2D._POOL.push(this);
		}
		
		//TODO:coverage
		public override function destroy():void {
			_ib.destroy(); 
			_vb.destroy();
			_vb.deleteBuffer();
			//ib用deletebuffer么
		}
	}
}