package laya.ani.bone.canvasmesh {
	import laya.maths.Matrix;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	
	/**
	 * @private
	 * canvas mesh渲染器
	 */
	public class CanvasMeshRender{
		
		/**
		 * mesh数据 
		 */		
		public var mesh:MeshData;
		
		/**
		 * 矩阵 
		 */
		public var transform:Matrix;
		
		/**
		 * 绘图环境 
		 */		
		public var context:*;
		
		/**
		 * 绘制mesh的模式  0:顶点索引模式 1：无顶点索引模式
		 */		
		public var mode:int = 0;
	
		/**
		 * 将mesh数据渲染到context上面 
		 * @param context
		 * 
		 */		
		public function renderToContext(context:RenderContext):void {
			this.context = context.ctx||context;
			if (mesh) {
				if (mode == 0)
				{
					_renderWithIndexes(mesh);
				}else
				{
					_renderNoIndexes(mesh);
				}
				
			}
		}
		
		/**
		 * 无顶点索引的模式 
		 * @param mesh
		 * 
		 */		
		public function _renderNoIndexes(mesh:MeshData):void {	
			var i:int,len:int = mesh.vertices.length / 2;
			var index:int;
			for (i = 0; i < len - 2; i++) {
				index = i * 2;
				this._renderDrawTriangle(mesh, index, (index + 2), (index + 4));
			}
		}
		
		/**
		 * 使用顶点索引模式绘制 
		 * @param mesh
		 * 
		 */		
		public function _renderWithIndexes(mesh:MeshData):void {
			var indexes:Array = mesh.indexes;
			var i:int,len:int = indexes.length;
			
			for (i = 0; i < len; i += 3) {
				var index0:int = indexes[i] * 2;
				var index1:int = indexes[i + 1] * 2;
				var index2:int = indexes[i + 2] * 2;	
				this._renderDrawTriangle(mesh, index0, index1, index2);
			}
		}
		
		/**
		 * 绘制三角形 
		 * @param mesh mesh
		 * @param index0 顶点0
		 * @param index1 顶点1
		 * @param index2 顶点2
		 * 
		 */		
		public function _renderDrawTriangle(mesh:MeshData, index0:int, index1:int, index2:int):void {
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
			
			if (mesh.canvasPadding > 0) {//扩展区域，解决黑边问题
				var paddingX:Number = mesh.canvasPadding;
				var paddingY:Number = mesh.canvasPadding;
				var centerX:Number = (x0 + x1 + x2) / 3;
				var centerY:Number = (y0 + y1 + y2) / 3;
				
				var normX:Number = x0 - centerX;
				var normY:Number = y0 - centerY;
				
				var dist:Number = Math.sqrt((normX * normX) + (normY * normY));
				
				x0 = centerX + ((normX / dist) * (dist + paddingX));
				y0 = centerY + ((normY / dist) * (dist + paddingY));
				
				//
				
				normX = x1 - centerX;
				normY = y1 - centerY;
				
				dist = Math.sqrt((normX * normX) + (normY * normY));
				x1 = centerX + ((normX / dist) * (dist + paddingX));
				y1 = centerY + ((normY / dist) * (dist + paddingY));
				
				normX = x2 - centerX;
				normY = y2 - centerY;
				
				dist = Math.sqrt((normX * normX) + (normY * normY));
				x2 = centerX + ((normX / dist) * (dist + paddingX));
				y2 = centerY + ((normY / dist) * (dist + paddingY));
			}
			
			context.save();
			if (transform)
			{
				var mt:Matrix=transform;
				context.transform(mt.a,mt.b,mt.c,mt.d,mt.tx,mt.ty);
			}
			
			//创建三角形裁剪区域
			context.beginPath();
			
			context.moveTo(x0, y0);
			context.lineTo(x1, y1);
			context.lineTo(x2, y2);
			
			context.closePath();
			
			context.clip();
			
			// 计算矩阵，将图片变形到合适的位置
			var delta:Number = (u0 * v1) + (v0 * u2) + (u1 * v2) - (v1 * u2) - (v0 * u1) - (u0 * v2);
			var dDelta:Number = 1 / delta;
			var deltaA:Number = (x0 * v1) + (v0 * x2) + (x1 * v2) - (v1 * x2) - (v0 * x1) - (x0 * v2);
			var deltaB:Number = (u0 * x1) + (x0 * u2) + (u1 * x2) - (x1 * u2) - (x0 * u1) - (u0 * x2);
			var deltaC:Number = (u0 * v1 * x2) + (v0 * x1 * u2) + (x0 * u1 * v2) - (x0 * v1 * u2) - (v0 * u1 * x2) - (u0 * x1 * v2);
			var deltaD:Number = (y0 * v1) + (v0 * y2) + (y1 * v2) - (v1 * y2) - (v0 * y1) - (y0 * v2);
			var deltaE:Number = (u0 * y1) + (y0 * u2) + (u1 * y2) - (y1 * u2) - (y0 * u1) - (u0 * y2);
			var deltaF:Number = (u0 * v1 * y2) + (v0 * y1 * u2) + (y0 * u1 * v2) - (y0 * v1 * u2) - (v0 * u1 * y2) - (u0 * y1 * v2);
			
			context.transform(deltaA *dDelta, deltaD *dDelta, deltaB *dDelta, deltaE*dDelta, deltaC *dDelta, deltaF *dDelta);
			
			//context.drawImage(textureSource, 0, 0, textureWidth, textureHeight, 0, 0, textureWidth, textureHeight);
			context.drawImage(textureSource, texture.uv[0]*sourceWidth, texture.uv[1]*sourceHeight, textureWidth, textureHeight,texture.uv[0]*sourceWidth, texture.uv[1]*sourceHeight, textureWidth, textureHeight);
			
			context.restore();
		}
	}

}