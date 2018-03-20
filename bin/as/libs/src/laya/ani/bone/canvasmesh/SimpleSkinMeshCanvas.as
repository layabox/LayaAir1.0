package laya.ani.bone.canvasmesh {
	import laya.ani.bone.MeshTools;
	import laya.maths.Matrix;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	
	/**
	 * @private
	 * 简化mesh绘制，多顶点mesh改为四顶点mesh，只绘制矩形不绘制三角形
	 */
	public class SimpleSkinMeshCanvas extends SkinMeshCanvas {
		
		/**
		 * 当前绘制用的mesh 
		 */		
		private var tempMesh:MeshData = new MeshData();
		/**
		 * 当前mesh数据是否可用 
		 */
		private var cacheOK:Boolean = false;
		/**
		 * 当前渲染数据是否可用 
		 */		
		private var cacheCmdOK:Boolean=false;
		
		/**
		 * transform参数缓存 
		 */		
		private var transformCmds:Array=[];
		/**
		 * drawImage参数缓存 
		 */		
		private var drawCmds:Array=[]
		
		override public function init2(texture:Texture, vs:Array, ps:Array, verticles:Array, uvs:Array):void {
			super.init2(texture, vs, ps, verticles, uvs);
			cacheOK = false;
			cacheCmdOK=false;
			transformCmds.length=6;
			drawCmds.length=9;
		}
		
		override public function renderToContext(context:RenderContext):void {
			
			this.context = context.ctx || context;
			if (mesh) {
				if (mesh.uvs.length <= 8) {
					if (mode == 0) {
						_renderWithIndexes(mesh);
					}
					else {
						_renderNoIndexes(mesh);
					}
					return;
				}
				if (!cacheOK) {
					tempMesh.texture = mesh.texture;
					tempMesh.uvs = mesh.texture.uv;
					tempMesh.vertices = MeshTools.solveMesh(mesh, tempMesh.vertices);
					cacheOK = true;
				}
				
				if (mode == 0) {
					_renderWithIndexes(tempMesh);
				}
				else {
					_renderNoIndexes(tempMesh);
				}
				
			}
		}
		
		override public function _renderWithIndexes(mesh:MeshData):void {
			if(cacheCmdOK)
			{
				renderByCache(mesh);
				return;
			}
			var indexes:Array = mesh.indexes;
			var i:int, len:int = indexes.length;
			if (len > 1)
				len = 1;
			for (i = 0; i < len; i += 3) {
				var index0:int = indexes[i] * 2;
				var index1:int = indexes[i + 1] * 2;
				var index2:int = indexes[i + 2] * 2;
				this._renderDrawTriangle(mesh, index0, index1, index2);
			}
			cacheCmdOK=true;
		}
		
		override public function _renderDrawTriangle(mesh:MeshData, index0:int, index1:int, index2:int):void {
			var context:* = this.context;
			var uvs:Array = mesh.uvs;
			var vertices:Array = mesh.vertices;
			var texture:Texture = mesh.texture;
			
			var source:Texture = texture.bitmap;
			var textureSource:* = source.source;
			var textureWidth:Number = texture.width;
			var textureHeight:Number = texture.height;
			var sourceWidth:Number = source.width;
			var sourceHeight:Number = source.height;
			
			//uv数据
			var u0:Number;
			var u1:Number;
			var u2:Number;
			var v0:Number;
			var v1:Number;
			var v2:Number;
			
			if (mesh.useUvTransform) {
				var ut:Matrix = mesh.uvTransform;
				
				u0 = ((uvs[index0] * ut.a) + (uvs[index0 + 1] * ut.c) + ut.tx) * sourceWidth;
				u1 = ((uvs[index1] * ut.a) + (uvs[index1 + 1] * ut.c) + ut.tx) * sourceWidth;
				u2 = ((uvs[index2] * ut.a) + (uvs[index2 + 1] * ut.c) + ut.tx) * sourceWidth;
				v0 = ((uvs[index0] * ut.b) + (uvs[index0 + 1] * ut.d) + ut.ty) * sourceHeight;
				v1 = ((uvs[index1] * ut.b) + (uvs[index1 + 1] * ut.d) + ut.ty) * sourceHeight;
				v2 = ((uvs[index2] * ut.b) + (uvs[index2 + 1] * ut.d) + ut.ty) * sourceHeight;
			}
			else {
				u0 = uvs[index0] * sourceWidth;
				u1 = uvs[index1] * sourceWidth;
				u2 = uvs[index2] * sourceWidth;
				v0 = uvs[index0 + 1] * sourceHeight;
				v1 = uvs[index1 + 1] * sourceHeight;
				v2 = uvs[index2 + 1] * sourceHeight;
			}
			
			//绘制顶点数据
			var x0:Number = vertices[index0];
			var x1:Number = vertices[index1];
			var x2:Number = vertices[index2];
			var y0:Number = vertices[index0 + 1];
			var y1:Number = vertices[index1 + 1];
			var y2:Number = vertices[index2 + 1];
				
		
			// 计算矩阵，将图片变形到合适的位置
			var delta:Number = (u0 * v1) + (v0 * u2) + (u1 * v2) - (v1 * u2) - (v0 * u1) - (u0 * v2);
			var dDelta:Number = 1 / delta;
			var deltaA:Number = (x0 * v1) + (v0 * x2) + (x1 * v2) - (v1 * x2) - (v0 * x1) - (x0 * v2);
			var deltaB:Number = (u0 * x1) + (x0 * u2) + (u1 * x2) - (x1 * u2) - (x0 * u1) - (u0 * x2);
			var deltaC:Number = (u0 * v1 * x2) + (v0 * x1 * u2) + (x0 * u1 * v2) - (x0 * v1 * u2) - (v0 * u1 * x2) - (u0 * x1 * v2);
			var deltaD:Number = (y0 * v1) + (v0 * y2) + (y1 * v2) - (v1 * y2) - (v0 * y1) - (y0 * v2);
			var deltaE:Number = (u0 * y1) + (y0 * u2) + (u1 * y2) - (y1 * u2) - (y0 * u1) - (u0 * y2);
			var deltaF:Number = (u0 * v1 * y2) + (v0 * y1 * u2) + (y0 * u1 * v2) - (y0 * v1 * u2) - (v0 * u1 * y2) - (u0 * y1 * v2);
			
			transformCmds[0]=deltaA * dDelta;
			transformCmds[1]=deltaD * dDelta;
			transformCmds[2]=deltaB * dDelta;
			transformCmds[3]=deltaE * dDelta;
			transformCmds[4]=deltaC * dDelta;
			transformCmds[5]=deltaF * dDelta;
			
			
			drawCmds[0]=textureSource;
			drawCmds[1]=texture.uv[0] * sourceWidth;
			drawCmds[2]=texture.uv[1] * sourceHeight;
			drawCmds[3]=textureWidth;
			drawCmds[4]=textureHeight;
			drawCmds[5]=texture.uv[0] * sourceWidth;
			drawCmds[6]=texture.uv[1] * sourceHeight;
			drawCmds[7]=textureWidth;
			drawCmds[8]=textureHeight;
			
			context.save();
			if (transform) {
				var mt:Matrix = transform;
				context.transform(mt.a, mt.b, mt.c, mt.d, mt.tx, mt.ty);
			}
			context.transform.apply(context,transformCmds);
			context.drawImage.apply(context,drawCmds);
			context.restore();
		}
		

		/**
		 * 绘制缓存的命令 
		 * @param mesh
		 * 
		 */		
		private function renderByCache(mesh:MeshData):void
		{
			var context:* = this.context;
			context.save();
			if (transform) {
				var mt:Matrix = transform;
				context.transform(mt.a, mt.b, mt.c, mt.d, mt.tx, mt.ty);
			}
			context.transform.apply(context,transformCmds);
			context.drawImage.apply(context,drawCmds);
			context.restore();
		}
	}

}