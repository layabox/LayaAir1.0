package common 
{
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	/**
	 * ...
	 * @author 
	 */
	public class Tool 
	{
		
		public function Tool() 
		{
			
		}
		
		public static function linearModel(sprite3D:Sprite3D, phasorSpriter3D:PhasorSpriter3D, color:Vector4, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3):void
		{
			if (sprite3D is MeshSprite3D)
			{
				var meshSprite3D:MeshSprite3D = sprite3D as MeshSprite3D;
				var mesh:Mesh = meshSprite3D.meshFilter.sharedMesh as Mesh;
				
				if(!mesh.loaded)
					return;
				
				var vbBufferData:Float32Array = mesh._vertexBuffers ? mesh._vertexBuffers[0].getData() : mesh._vertexBuffer.getData();
				var ibBufferData:Uint16Array = mesh._indexBuffer.getData();
				var vertexStrideCount:int = mesh._vertexBuffers ? mesh._vertexBuffers[0].vertexDeclaration.vertexStride / 4 : mesh._vertexBuffer.vertexDeclaration.vertexStride / 4 ;
				var loopCount:int = 0;
				var index:int = 0;
				
				for (var i:int = 0; i < ibBufferData.length; i += 3)
				{
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
					
					Vector3.transformCoordinate(vertex1, meshSprite3D.transform.worldMatrix, vertex1);
					Vector3.transformCoordinate(vertex2, meshSprite3D.transform.worldMatrix, vertex2);
					Vector3.transformCoordinate(vertex3, meshSprite3D.transform.worldMatrix, vertex3);
					
					phasorSpriter3D.line(vertex1, color, vertex2, color);
					phasorSpriter3D.line(vertex2, color, vertex3, color);
					phasorSpriter3D.line(vertex3, color, vertex1, color);
					
				}
			}
			
			for (var i:int = 0, n:int = sprite3D._childs.length; i < n; i++)
				linearModel(sprite3D._childs[i], phasorSpriter3D, color, vertex1, vertex2, vertex3);
			
		}
		
	}

}