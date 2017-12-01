var Tool = /** @class */ (function () {
    function Tool() {
    }
    Tool.linearModel = function (sprite3D, phasorSpriter3D, color, vertex1, vertex2, vertex3) {
        if (sprite3D instanceof Laya.MeshSprite3D) {
            var meshSprite3D = sprite3D;
            var mesh = meshSprite3D.meshFilter.sharedMesh;
            if (!mesh.loaded)
                return;
            var vbBufferData = mesh._vertexBuffers ? mesh._vertexBuffers[0].getData() : mesh._vertexBuffer.getData();
            var ibBufferData = mesh._indexBuffer.getData();
            var vertexStrideCount = mesh._vertexBuffers ? mesh._vertexBuffers[0].vertexDeclaration.vertexStride / 4 : mesh._vertexBuffer.vertexDeclaration.vertexStride / 4;
            var loopCount = 0;
            var index = 0;
            for (var i = 0; i < ibBufferData.length; i += 3) {
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
        for (var i = 0, n = sprite3D._childs.length; i < n; i++)
            this.linearModel(sprite3D._childs[i], phasorSpriter3D, color, vertex1, vertex2, vertex3);
    };
    return Tool;
}());
