package laya.d3Editor.shape 
{
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.PrimitiveMesh;
	import laya.ide.managers.IDEAPIS;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author zyh
	 */
	public class MeshShapeLine3D extends PixelLineSprite3D 
	{
		private var _mesh:String;
		private var color:Color = Color.GREEN;
		private var vertex1:Vector3 = new Vector3();
		private var vertex2:Vector3 = new Vector3();
		private var vertex3:Vector3 = new Vector3();
		public function MeshShapeLine3D(count:int) 
		{
			super(count);
		}
		
		private function reCreateShape(e:Mesh):void 
		{
			var mesh:Mesh = e;
				
			var vbBuffer:VertexBuffer3D = mesh._vertexBuffers ? mesh._vertexBuffers[0] : (mesh as PrimitiveMesh)._primitveGeometry._vertexBuffer;
			
			var vbBufferData:Float32Array = vbBuffer.getData();
			var ibBufferData:Uint16Array = mesh._indexBuffer ? mesh._indexBuffer.getData() : (mesh as PrimitiveMesh)._primitveGeometry._indexBuffer.getData();
			var vertexStrideCount:int = vbBuffer.vertexDeclaration.vertexStride / 4;
			var loopCount:int = 0;
			var index:int = 0;
			var lineCount:int = 0;
			for (var i:int = 0; i < ibBufferData.length; i += 3) {
				loopCount = 0;
				index = 0;
				vertex1.x = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				vertex1.y = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				vertex1.z = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				loopCount++;
				
				index = 0;
				vertex2.x = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				vertex2.y = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				vertex2.z = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				loopCount++;
				
				index = 0;
				vertex3.x = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				vertex3.y = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				vertex3.z = vbBufferData[ibBufferData[i + loopCount] * vertexStrideCount + index++];
				loopCount++;
				
				setLine(lineCount++, vertex1, vertex2, color, color);
				setLine(lineCount++, vertex2, vertex3, color, color);
				setLine(lineCount++, vertex3, vertex1, color, color);
			}
		}
		
		public function get mesh():String 
		{
			return _mesh;
		}
		
		public function set mesh(value:String):void 
		{
			_mesh = value;
			reCreateShape(Laya.loader.getRes(IDEAPIS.assetsPath + '/' + value));
		}
		
	}

}