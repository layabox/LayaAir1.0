package laya.webgl.canvas {
	import laya.display.Sprite;
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.webgl.submit.Submit;
	import laya.webgl.utils.Mesh2D;
	import laya.webgl.utils.MeshQuadTexture;
	import laya.webgl.utils.MeshTexture;
	import laya.webgl.utils.MeshVG;
	/**
	 * 对象 cacheas normal的时候，本质上只是想把submit缓存起来，以后直接执行
	 * 为了避免各种各样的麻烦，这里采用复制相应部分的submit的方法。执行环境还是在原来的context中
	 * 否则包括clip等都非常难以处理
	 */
	public class WebGLCacheAsNormalCanvas {
		public var submitStartPos:int = 0;	// 对应的context的submit的开始的地方
		public var submitEndPos:int = 0;
		public var context:WebGLContext2D = null;
		public var touches:Array = [];		//记录的文字信息。cacheas normal的话，文字要能正确touch
		public var submits:Array = [];		// 从context中剪切的submit
		public var sprite:Sprite = null;	// 对应的sprite对象

		// submit需要关联稳定独立的mesh。所以这里要创建自己的mesh对象
		public var _mesh:MeshQuadTexture;			//用Mesh2D代替_vb,_ib. 当前使用的mesh
		private var _pathMesh:MeshVG;			//矢量专用mesh。
		private var _triangleMesh:MeshTexture;	//drawTriangles专用mesh。由于ib不固定，所以不能与_mesh通用
		public var meshlist:Array = [];			//本context用到的mesh
		
		// 原始context的原始值
		private var _oldMesh:MeshQuadTexture;
		private var _oldPathMesh:MeshVG;
		private var _oldTriMesh:MeshTexture;
		private var _oldMeshList:Array;
		
		// cache的时候对应的clip
		private var cachedClipInfo:Matrix = new Matrix();	// 用来判断是否需要把cache无效
		//private var oldMatrix:Matrix = null;				//本地画的时候完全不应用矩阵，所以需要先保存老的，以便恢复		这样会丢失缩放信息，导致文字模糊，所以不用这种方式了
		private var oldTx:Number = 0;
		private var oldTy:Number = 0;
		private static var matI:Matrix = new Matrix();
		
		// 创建这个canvas的时候对应的矩阵的逆矩阵。因为要保留矩阵的缩放信息。所以采用逆矩阵的方法。
		public var  invMat:Matrix = new Matrix();
		
		public function WebGLCacheAsNormalCanvas(ctx:WebGLContext2D, sp:Sprite) {
			context = ctx;
			sprite = sp;
			ctx._globalClipMatrix.copyTo(cachedClipInfo);
		}
		
		public function startRec():void {
			// 如果有文字优化，这里要先提交一下
			if ( context._charSubmitCache._enbale) {
				context._charSubmitCache.enable(false, context);
				context._charSubmitCache.enable(true, context);
			}
			context._incache = true;
			touches.length=0;
			//记录需要touch的文字资源
			(context as Object).touches = touches;
			context._globalClipMatrix.copyTo(cachedClipInfo);
			
			submits.length = 0;
			submitStartPos = context._submits._length;
			
			// 先把之前的释放掉
			for (var i:int= 0, sz:int= meshlist.length; i < sz; i++) {
				var curm:Mesh2D = meshlist[i];
				curm.canReuse?(curm.releaseMesh()):(curm.destroy());
			}
			meshlist.length = 0;
			
			_mesh = MeshQuadTexture.getAMesh();
			_pathMesh = MeshVG.getAMesh();
			_triangleMesh = MeshTexture.getAMesh();
			
			meshlist.push(_mesh);
			meshlist.push(_pathMesh);
			meshlist.push(_triangleMesh);
			
			// 打断合并
			context._curSubmit = Submit.RENDERBASE;
			// 接管context中的一些值
			_oldMesh = context._mesh;
			_oldPathMesh = context._pathMesh;
			_oldTriMesh = context._triangleMesh;
			_oldMeshList = context.meshlist;
			
			context._mesh = _mesh;
			context._pathMesh = _pathMesh;
			context._triangleMesh = _triangleMesh;
			context.meshlist = meshlist;
			
			// 要取消位置，因为以后会再传入位置。这里好乱
			oldTx = context._curMat.tx;
			oldTy = context._curMat.ty;
			context._curMat.tx = 0;
			context._curMat.ty = 0;
			
			// 取消缩放等
			context._curMat.copyTo(invMat);
			invMat.invert();
			//oldMatrix = context._curMat;
			//context._curMat = matI;
		}
		
		public function endRec():void {
			// 如果有文字优化，这里要先提交一下
			if ( context._charSubmitCache._enbale) {
				context._charSubmitCache.enable(false, context);
				context._charSubmitCache.enable(true, context);
			}
			// copy submit
			var parsubmits:Array = (context as WebGLContext2D)._submits;
			submitEndPos = parsubmits._length;
			var num:int = submitEndPos - submitStartPos;
			for (var i:int = 0; i < num; i++) {
				submits.push(parsubmits[submitStartPos + i]);
			}
			parsubmits._length -= num;
			
			// 恢复原始context的值
			context._mesh = _oldMesh;
			context._pathMesh = _oldPathMesh;
			context._triangleMesh = _oldTriMesh;
			context.meshlist = _oldMeshList;
			
			// 打断合并
			context._curSubmit = Submit.RENDERBASE;
			// 恢复matrix
			//context._curMat = oldMatrix;
			context._curMat.tx = oldTx;
			context._curMat.ty = oldTy;
			(context as Object).touches = null;
			context._incache = false;
		}
		
		/**
		 * 当前缓存是否还有效。例如clip变了就失效了，因为clip太难自动处理
		 * @return
		 */
		public function isCacheValid():Boolean {
			var curclip:Matrix = context._globalClipMatrix;
			if (curclip.a != cachedClipInfo.a || curclip.b != cachedClipInfo.b || curclip.c != cachedClipInfo.c 
			|| curclip.d != cachedClipInfo.d || curclip.tx != cachedClipInfo.tx || curclip.ty != cachedClipInfo.ty )
				return false;
			return true;
		}
		
		public function flushsubmit():void {
			var curSubmit:Submit = Submit.RENDERBASE;
			this.submits.forEach(function(subm:Submit):void { 
				if (subm == Submit.RENDERBASE) return;
				Submit.preRender = curSubmit;
				curSubmit = subm;
				subm.renderSubmit();
			} );
		}
		
		public function releaseMem():void {
			
		}
	}
}	