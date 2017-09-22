class Tool {
    constructor() {

    }
    public static linearModel(sprite3D: Laya.Sprite3D, phasorSpriter3D: Laya.PhasorSpriter3D, color: Laya.Vector4, vertex1: Laya.Vector3, vertex2: Laya.Vector3, vertex3: Laya.Vector3): void {

        if (sprite3D instanceof Laya.MeshSprite3D) {
            var meshSprite3D: Laya.MeshSprite3D = sprite3D as Laya.MeshSprite3D;
            var mesh: Laya.Mesh = meshSprite3D.meshFilter.sharedMesh as Laya.Mesh;

            if (!mesh.loaded)
                return;

            var vbBufferData: Float32Array = mesh._vertexBuffers ? mesh._vertexBuffers[0].getData() : mesh._vertexBuffer.getData();
            var ibBufferData: Uint16Array = mesh._indexBuffer.getData();
            var vertexStrideCount: number = mesh._vertexBuffers ? mesh._vertexBuffers[0].vertexDeclaration.vertexStride / 4 : mesh._vertexBuffer.vertexDeclaration.vertexStride / 4;
            var loopCount: number = 0;
            var index: number = 0;

            for (var i: number = 0; i < ibBufferData.length; i += 3) {
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

                Laya.Vector3.transformCoordinate(vertex1, meshSprite3D.transform.worldMatrix, vertex1);
                Laya.Vector3.transformCoordinate(vertex2, meshSprite3D.transform.worldMatrix, vertex2);
                Laya.Vector3.transformCoordinate(vertex3, meshSprite3D.transform.worldMatrix, vertex3);

                phasorSpriter3D.line(vertex1, color, vertex2, color);
                phasorSpriter3D.line(vertex2, color, vertex3, color);
                phasorSpriter3D.line(vertex3, color, vertex1, color);

            }
        }

        for (var i: number = 0, n: number = sprite3D._childs.length; i < n; i++)
            this.linearModel(sprite3D._childs[i], phasorSpriter3D, color, vertex1, vertex2, vertex3);
    }
}