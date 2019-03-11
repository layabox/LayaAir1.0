package laya.d3Extend.Cube {
	import laya.d3.core.BufferState;
	import laya.d3.core.Camera;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.resource.Resource;
	import laya.utils.Handler;
	import laya.webgl.resource.Texture2D;
	import mx.resources.ResourceManager;

	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Vector3;
	import laya.layagl.LayaGL;
	import laya.resource.ResourceManager;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.d3Extend.Cube.CubeGeometry;
	import laya.d3Extend.Cube.CubeInfo;
	
	/**
	 * <code>SubCubeGeometry</code> 类用于实现方块子几何体。
	 */
	public class SubCubeGeometry {
		/**@private */
		public static const SIZE:int = 32;
		/**@private */
		public static const MAXSUBCOUNT:int = CubeGeometry.HLAFMAXSIZE * 2 / SIZE;
		/**@private */
		public static const SUBVERTEXCOUNT:int = 65536 / 8;//8192个顶点结构,最多2048个plane
		/**@private */
		public static const MaxVertexCount:int = 0;
		/**@private */
		public static const FLOATCOUNTPERVERTEX:int = 10;
		/**@private */
		public static const FLOATCOUNTPERPLANE:int = 40;
		/**@private */
		public static const HALFMAXNumCube:int = 1600;
		
		/**@private */
		private static var _pool:Vector.<SubCubeGeometry> =/*[STATIC SAFE]*/ new Vector.<SubCubeGeometry>();
		/**@private */
		private static var _indexBuffer:IndexBuffer3D;
		
		//12.10
		/**@private */
		private static var _UVvertexBuffer:VertexBuffer3D
		
		
		/**
		 * @private
		 */
		public static function create(owner:CubeGeometry):SubCubeGeometry {
			var subCube:SubCubeGeometry;
			if (_pool.length) {
				subCube = _pool.pop();
				subCube._cubeMap = owner.cubeMap;
				subCube._currentVertexCount = 0;
			} else {
				subCube = new SubCubeGeometry();
				subCube._cubeMap = owner.cubeMap;
			}
			return subCube;
		}
		
		/**
		 * @private
		 */
		public static function recover(cube:SubCubeGeometry):void {
			_pool.push(cube);
		}
		
		/**
		 * @private
		 */
		public static function __init__():void {
			//indexBuffer
			var maxFaceNums:int = 65536 / 4;
			var indexCount:int = maxFaceNums * 6;
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, indexCount, WebGLContext.STATIC_DRAW, false);
			var indices:Uint16Array = new Uint16Array(indexCount);
			for (var i:int = 0; i < maxFaceNums; i++) {
				var indexOffset:int = i * 6;
				var pointOffset:int = i * 4;
				indices[indexOffset] = pointOffset;
				indices[indexOffset + 1] = 2 + pointOffset;
				indices[indexOffset + 2] = 1 + pointOffset;
				indices[indexOffset + 3] = pointOffset;
				indices[indexOffset + 4] = 3 + pointOffset;
				indices[indexOffset + 5] = 2 + pointOffset;
			}
			_indexBuffer.setData(indices);
			
			//UVvertexBuffer
			//12.10
			var uvArrayCount:int = maxFaceNums * 4 * 2;
			_UVvertexBuffer = new VertexBuffer3D(uvArrayCount * 4, WebGLContext.STATIC_DRAW, false);
			var uvs:Float32Array = new Float32Array(uvArrayCount);
			for (var j:int = 0; j < maxFaceNums; j++) {
				var uvoffset:int = j * 8;
				uvs[uvoffset] = 1;
				uvs[uvoffset + 1] = 0;
				
				uvs[uvoffset + 2] = 0;
				uvs[uvoffset + 3] = 0;
				
				uvs[uvoffset + 4] = 0;
				uvs[uvoffset + 5] = 1;
				
				uvs[uvoffset + 6] = 1;
				uvs[uvoffset + 7] = 1;
			}
			_UVvertexBuffer.setData(uvs);
			var verDec:VertexDeclaration = VertexMesh.getVertexDeclaration("UV");
			_UVvertexBuffer.vertexDeclaration = verDec;
		}
		
		/**
		 * @private
		 */
		public static function getKey(x:int, y:int, z:int):int {
			return (Math.floor(x / SIZE)) * MAXSUBCOUNT * MAXSUBCOUNT + (Math.floor(y / SIZE)) * MAXSUBCOUNT + Math.floor(z / SIZE);
		}
		
		/**@private 当前渲染点的数量 加减4*/
		public var _currentVertexCount:int = 0;
		/**@private */
		public var _currentVertexSize:int;
		/**@private */
		public var _vertices:Vector.<Float32Array> = new Vector.<Float32Array>();//长度一般为1,最大为4
		/**@private */
		public var _vertexbuffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();//长度一般为1,最大为4
		/**@private */
		public var _vertexUpdateFlag:Vector.<Array> = new Vector.<Array>();//长度一般为1,最大为4
		/**@private */
		public var _bufferStates:Vector.<BufferState> = new Vector.<BufferState>();//长度一般为1,最大为4
		/**@private */
		public var _cubeMap:CubeMap;
		
		/**@private */
		public var cubeCount:int = 0;
		
		/**@private */
		//public var boundBox:BoundBox = new BoundBox(new Vector3(),new Vector3());
		
		/**
		 * 创建一个新的<code>SubCubeGeometry</code> 实例
		 * @param cubeGeometry父几何体
		 */
		public function SubCubeGeometry() {
			_createVertexBuffer(SUBVERTEXCOUNT);
			_currentVertexSize = SUBVERTEXCOUNT;
			
			var memory:int = _currentVertexSize * FLOATCOUNTPERVERTEX * 4;
			Resource._addCPUMemory(memory);
			Resource._addGPUMemory(memory);
		}
		
		/**
		 * @private
		 */
		public function _clearEditerInfo():void {
			_cubeMap = null;
		}
		
		/**
		 * @private
		 */
		private function _createVertexBuffer(verticesCount:int):void {
			var verDec:VertexDeclaration = VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR"); /*VertexPositionNormalColor.vertexDeclaration*/
			var newVertices:Float32Array = new Float32Array(verticesCount * FLOATCOUNTPERVERTEX);
			var newVertecBuffer:VertexBuffer3D = new VertexBuffer3D(verDec.vertexStride * verticesCount, WebGLContext.DYNAMIC_DRAW, false);
			//
			var vertexbufferVector:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();
			var bufferState:BufferState = new BufferState();
			newVertecBuffer.vertexDeclaration = verDec;
			
			
			//12.10
			
			bufferState.bind();
			vertexbufferVector.push(newVertecBuffer);
			//bufferState.applyVertexBuffer(newVertecBuffer);
			vertexbufferVector.push(_UVvertexBuffer);

			bufferState.applyVertexBuffers(vertexbufferVector);
			bufferState.applyIndexBuffer(_indexBuffer);
			
			bufferState.unBind();
			
			_vertices.push(newVertices);
			_vertexbuffers.push(newVertecBuffer);
			_vertexUpdateFlag.push([2147483647/*int.MAX_VALUE*/, -2147483647/*int.MIN_VALUE*/]);//0:startUpdate,1:endUpdate
			_bufferStates.push(bufferState);
		}
		
		/**
		 * @private
		 */
		private function _resizeVertexBuffer(vertexCount:int):void {
			var needBufferCount:int = Math.ceil(vertexCount / 65536);
			var curBufferIndex:int = _vertexbuffers.length - 1;
			
			var curBufferResizeCount:int = Math.min(vertexCount - curBufferIndex * 65536, 65536);
			
			if (_currentVertexSize % 65536 !== 0) {
				var curVertices:Float32Array = _vertices[curBufferIndex];
				var curVertexBuffer:VertexBuffer3D = _vertexbuffers[curBufferIndex];
				var bufferState:BufferState = _bufferStates[curBufferIndex];
				var lastVertices:Float32Array = curVertices;
				curVertexBuffer.destroy();//销毁旧Buffer
				
				curVertices = new Float32Array(curBufferResizeCount * FLOATCOUNTPERVERTEX);
				curVertices.set(lastVertices, 0);//拷贝旧数据
				var verdec:VertexDeclaration = VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR");
				curVertexBuffer = new VertexBuffer3D(verdec.vertexStride* curBufferResizeCount, WebGLContext.DYNAMIC_DRAW, false);
				curVertexBuffer.vertexDeclaration = verdec/*VertexPositionNormalColor.vertexDeclaration*/;
				curVertexBuffer.setData(curVertices);
				_vertices[curBufferIndex] = curVertices;
				_vertexbuffers[curBufferIndex] = curVertexBuffer;
				
				bufferState.bind();
				bufferState.applyVertexBuffer(curVertexBuffer);
				bufferState.unBind();
			}
			for (var i:int = curBufferIndex + 1; i < needBufferCount; i++) {
				var verticesCount:int = Math.min(vertexCount - i * 65536, 65536);
				_createVertexBuffer(verticesCount);
			}
			
			var memory:int = (vertexCount - _currentVertexSize) * FLOATCOUNTPERVERTEX * 4;
		
			Resource._addCPUMemory(memory);
			Resource._addGPUMemory(memory);
			_currentVertexSize = vertexCount;
		}
		
		/**
		 * @private
		 * 增加一个面
		 */
		public function _addFaceVertex(cubeInfo:CubeInfo, FaceIndex:int):void {
		
			if (cubeInfo.getVBPointbyFaceIndex(FaceIndex) != -1) {
				return;
			}
			
			var subCube:SubCubeGeometry = cubeInfo.subCube;
			if (!subCube)
			{
				return;
			}
			if (subCube._currentVertexCount === subCube._currentVertexSize)
				subCube._resizeVertexBuffer(subCube._currentVertexSize + SUBVERTEXCOUNT);//一帧增加不会超过2048平面,扩一次够用
			
			var point1Factor:int, point2Factor:int, point3Factor:int, point4Factor:int;
			var cubeInfo1:CubeInfo, cubeInfo2:CubeInfo, cubeInfo3:CubeInfo, cubeInfo4:CubeInfo;
			var aoFactor:Vector.<Number> = CubeInfo.aoFactor;
			//获得绝对位置
			//添加面前找到对应的subCubeGeometry
			var vertices:Vector.<Float32Array> = subCube._vertices;
			var vertexUpdateFlag:Vector.<Array> = subCube._vertexUpdateFlag;
			
			var x:int = cubeInfo.x - CubeGeometry.HLAFMAXSIZE;
			var y:int = cubeInfo.y - CubeGeometry.HLAFMAXSIZE;
			var z:int = cubeInfo.z - CubeGeometry.HLAFMAXSIZE;
			var colorIndex:int = cubeInfo.color;
			
			var offset:int = Math.floor(subCube._currentVertexCount % 65536) * 10;
			
			//第几个vertexbuffer
			var verticesIndex:int = subCube._currentVertexCount==0?0:Math.ceil(subCube._currentVertexCount /65536) - 1;
			
			var vertexArray:Float32Array = vertices[verticesIndex];
			var updateFlag:Array = vertexUpdateFlag[verticesIndex];
			
			//维护StartEnd
			(updateFlag[0] > offset) && (updateFlag[0] = offset);
			(updateFlag[1] < offset + 39) && (updateFlag[1] = offset + 39);
			
			//总点+4
			subCube._currentVertexCount += 4;
			
			//将颜色值解压
			//var r:Number = ((colorIndex & 0x1f) << 3) / 255;
			//var g:Number = ((colorIndex & 0x3e0) >> 2) / 255;
			//var b:Number = ((colorIndex >> 10) << 3) / 255;
			//var a:Number = 1;
			var r:Number = (colorIndex & 0xff)/255;
			var g:Number = ((colorIndex & 0xff00) >> 8) / 255;
			var b:Number = ((colorIndex & 0xff0000) >> 16) / 255;
			var a:Number = (colorIndex & 0xff000000) >> 24;
			
			var num1:int;
			var num2:int;
			var num3:int;
			var num4:int;
			
			switch (FaceIndex) {
			case 0: 
				cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z + 1);
				cubeInfo2 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z + 1);
				cubeInfo3 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z + 1);
				cubeInfo4 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z + 1);
				num1 = CubeInfo.Objcect4front[cubeInfo1.point];
				num2 = CubeInfo.Objcect5front[cubeInfo2.point];
				num3 = CubeInfo.Objcect1front[cubeInfo3.point];
				num4 = CubeInfo.Objcect0front[cubeInfo4.point];
				//维护AO
				
				point1Factor = aoFactor[num1];
				point2Factor = aoFactor[num2];
				point3Factor = aoFactor[num3];
				point4Factor = aoFactor[num4];
				
				//_addOnePlaneVertex(0, cubeInfo, point1Factor, point2Factor, point3Factor, point4Factor);
				cubeInfo.frontVBIndex = (verticesIndex << 24) + offset;
				vertexArray[offset] = x + 1;
				vertexArray[offset + 1] = y + 1;
				vertexArray[offset + 2] = z + 1;
				vertexArray[offset + 3] = 0.0;
				vertexArray[offset + 4] = 0.0;
				vertexArray[offset + 5] = 1.0;
				vertexArray[offset + 6] = r * point1Factor;
				vertexArray[offset + 7] = g * point1Factor;
				vertexArray[offset + 8] = b * point1Factor;
				vertexArray[offset + 9] = a;
				vertexArray[offset + 10] = x;
				vertexArray[offset + 11] = y + 1;
				vertexArray[offset + 12] = z + 1;
				vertexArray[offset + 13] = 0.0;
				vertexArray[offset + 14] = 0.0;
				vertexArray[offset + 15] = 1.0;
				vertexArray[offset + 16] = r * point2Factor;
				vertexArray[offset + 17] = g * point2Factor;
				vertexArray[offset + 18] = b * point2Factor;
				vertexArray[offset + 19] = a;
				vertexArray[offset + 20] = x;
				vertexArray[offset + 21] = y;
				vertexArray[offset + 22] = z + 1;
				vertexArray[offset + 23] = 0.0;
				vertexArray[offset + 24] = 0.0;
				vertexArray[offset + 25] = 1.0;
				vertexArray[offset + 26] = r * point3Factor;
				vertexArray[offset + 27] = g * point3Factor;
				vertexArray[offset + 28] = b * point3Factor;
				vertexArray[offset + 29] = a;
				vertexArray[offset + 30] = x + 1;
				vertexArray[offset + 31] = y;
				vertexArray[offset + 32] = z + 1;
				vertexArray[offset + 33] = 0.0;
				vertexArray[offset + 34] = 0.0;
				vertexArray[offset + 35] = 1.0;
				vertexArray[offset + 36] = r * point4Factor;
				vertexArray[offset + 37] = g * point4Factor;
				vertexArray[offset + 38] = b * point4Factor;
				vertexArray[offset + 39] = a;
				break;
			case 1: 
				
				cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z + 1);
				cubeInfo2 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z + 1);
				cubeInfo3 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z);
				cubeInfo4 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z);
				num1 = CubeInfo.Objcect4right[cubeInfo1.point];
				num2 = CubeInfo.Objcect0right[cubeInfo2.point];
				num3 = CubeInfo.Objcect2right[cubeInfo3.point];
				num4 = CubeInfo.Objcect6right[cubeInfo4.point];
				point1Factor = aoFactor[num1];
				point2Factor = aoFactor[num2];
				point3Factor = aoFactor[num3];
				point4Factor = aoFactor[num4];
				//_addOnePlaneVertex(1, cubeInfo, point1Factor, point2Factor, point3Factor, point4Factor);
				cubeInfo.rightVBIndex = (verticesIndex << 24) + offset;
				vertexArray[offset] = x + 1;
				vertexArray[offset + 1] = y + 1;
				vertexArray[offset + 2] = z + 1;
				vertexArray[offset + 3] = 1.0;
				vertexArray[offset + 4] = 0.0;
				vertexArray[offset + 5] = 0.0;
				vertexArray[offset + 6] = r * point1Factor;
				vertexArray[offset + 7] = g * point1Factor;
				vertexArray[offset + 8] = b * point1Factor;
				vertexArray[offset + 9] = a;
				vertexArray[offset + 10] = x + 1;
				vertexArray[offset + 11] = y;
				vertexArray[offset + 12] = z + 1;
				vertexArray[offset + 13] = 1.0;
				vertexArray[offset + 14] = 0.0;
				vertexArray[offset + 15] = 0.0;
				vertexArray[offset + 16] = r * point2Factor;
				vertexArray[offset + 17] = g * point2Factor;
				vertexArray[offset + 18] = b * point2Factor;
				vertexArray[offset + 19] = a;
				vertexArray[offset + 20] = x + 1;
				vertexArray[offset + 21] = y;
				vertexArray[offset + 22] = z;
				vertexArray[offset + 23] = 1.0;
				vertexArray[offset + 24] = 0.0;
				vertexArray[offset + 25] = 0.0;
				vertexArray[offset + 26] = r * point3Factor;
				vertexArray[offset + 27] = g * point3Factor;
				vertexArray[offset + 28] = b * point3Factor;
				vertexArray[offset + 29] = a;
				vertexArray[offset + 30] = x + 1;
				vertexArray[offset + 31] = y + 1;
				vertexArray[offset + 32] = z;
				vertexArray[offset + 33] = 1.0;
				vertexArray[offset + 34] = 0.0;
				vertexArray[offset + 35] = 0.0;
				vertexArray[offset + 36] = r * point4Factor;
				vertexArray[offset + 37] = g * point4Factor;
				vertexArray[offset + 38] = b * point4Factor;
				vertexArray[offset + 39] = a;
				break;
			case 2: 
				cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z + 1);
				cubeInfo2 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z);
				cubeInfo3 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z);
				cubeInfo4 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z + 1);
				num1 = CubeInfo.Objcect4up[cubeInfo1.point];
				num2 = CubeInfo.Objcect6up[cubeInfo2.point];
				num3 = CubeInfo.Objcect7up[cubeInfo3.point];
				num4 = CubeInfo.Objcect5up[cubeInfo4.point];
				point1Factor = aoFactor[num1];
				point2Factor = aoFactor[num2];
				point3Factor = aoFactor[num3];
				point4Factor = aoFactor[num4];
				//_addOnePlaneVertex(2, cubeInfo, point1Factor, point2Factor, point3Factor, point4Factor);
				cubeInfo.topVBIndex = (verticesIndex << 24) + offset;
				vertexArray[offset] = x + 1;
				vertexArray[offset + 1] = y + 1;
				vertexArray[offset + 2] = z + 1;
				vertexArray[offset + 3] = 0.0;
				vertexArray[offset + 4] = 1.0;
				vertexArray[offset + 5] = 0.0;
				vertexArray[offset + 6] = r * point1Factor;
				vertexArray[offset + 7] = g * point1Factor;
				vertexArray[offset + 8] = b * point1Factor;
				vertexArray[offset + 9] = a;
				vertexArray[offset + 10] = x + 1;
				vertexArray[offset + 11] = y + 1;
				vertexArray[offset + 12] = z;
				vertexArray[offset + 13] = 0.0;
				vertexArray[offset + 14] = 1.0;
				vertexArray[offset + 15] = 0.0;
				vertexArray[offset + 16] = r * point2Factor;
				vertexArray[offset + 17] = g * point2Factor;
				vertexArray[offset + 18] = b * point2Factor;
				vertexArray[offset + 19] = a;
				vertexArray[offset + 20] = x;
				vertexArray[offset + 21] = y + 1;
				vertexArray[offset + 22] = z;
				vertexArray[offset + 23] = 0.0;
				vertexArray[offset + 24] = 1.0;
				vertexArray[offset + 25] = 0.0;
				vertexArray[offset + 26] = r * point3Factor;
				vertexArray[offset + 27] = g * point3Factor;
				vertexArray[offset + 28] = b * point3Factor;
				vertexArray[offset + 29] = a;
				vertexArray[offset + 30] = x;
				vertexArray[offset + 31] = y + 1;
				vertexArray[offset + 32] = z + 1;
				vertexArray[offset + 33] = 0.0;
				vertexArray[offset + 34] = 1.0;
				vertexArray[offset + 35] = 0.0;
				vertexArray[offset + 36] = r * point4Factor;
				vertexArray[offset + 37] = g * point4Factor;
				vertexArray[offset + 38] = b * point4Factor;
				vertexArray[offset + 39] = a;
				break;
			case 3: 
				cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z + 1);
				cubeInfo2 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z);
				cubeInfo3 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z);
				cubeInfo4 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z + 1);
				num1 = CubeInfo.Objcect5left[cubeInfo1.point];
				num2 = CubeInfo.Objcect7left[cubeInfo2.point];
				num3 = CubeInfo.Objcect3left[cubeInfo3.point];
				num4 = CubeInfo.Objcect1left[cubeInfo4.point];
				point1Factor = aoFactor[num1];
				point2Factor = aoFactor[num2];
				point3Factor = aoFactor[num3];
				point4Factor = aoFactor[num4];
				//_addOnePlaneVertex(3, cubeInfo, point1Factor, point2Factor, point3Factor, point4Factor);
				cubeInfo.leftVBIndex = (verticesIndex << 24) + offset;
				vertexArray[offset] = x;
				vertexArray[offset + 1] = y + 1;
				vertexArray[offset + 2] = z + 1;
				vertexArray[offset + 3] = -1.0;
				vertexArray[offset + 4] = 0.0;
				vertexArray[offset + 5] = 0.0;
				vertexArray[offset + 6] = r * point1Factor;
				vertexArray[offset + 7] = g * point1Factor;
				vertexArray[offset + 8] = b * point1Factor;
				vertexArray[offset + 9] = a;
				vertexArray[offset + 10] = x;
				vertexArray[offset + 11] = y + 1;
				vertexArray[offset + 12] = z;
				vertexArray[offset + 13] = -1.0;
				vertexArray[offset + 14] = 0.0;
				vertexArray[offset + 15] = 0.0;
				vertexArray[offset + 16] = r * point2Factor;
				vertexArray[offset + 17] = g * point2Factor;
				vertexArray[offset + 18] = b * point2Factor;
				vertexArray[offset + 19] = a;
				vertexArray[offset + 20] = x;
				vertexArray[offset + 21] = y;
				vertexArray[offset + 22] = z;
				vertexArray[offset + 23] = -1.0;
				vertexArray[offset + 24] = 0.0;
				vertexArray[offset + 25] = 0.0;
				vertexArray[offset + 26] = r * point3Factor;
				vertexArray[offset + 27] = g * point3Factor;
				vertexArray[offset + 28] = b * point3Factor;
				vertexArray[offset + 29] = a;
				vertexArray[offset + 30] = x;
				vertexArray[offset + 31] = y;
				vertexArray[offset + 32] = z + 1;
				vertexArray[offset + 33] = -1.0;
				vertexArray[offset + 34] = 0.0;
				vertexArray[offset + 35] = 0.0;
				vertexArray[offset + 36] = r * point4Factor;
				vertexArray[offset + 37] = g * point4Factor;
				vertexArray[offset + 38] = b * point4Factor;
				vertexArray[offset + 39] = a;
				break;
			case 4: 
				cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z);
				cubeInfo2 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z);
				cubeInfo3 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z + 1);
				cubeInfo4 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z + 1);
				num1 = CubeInfo.Objcect3down[cubeInfo1.point];
				num2 = CubeInfo.Objcect2down[cubeInfo2.point];
				num3 = CubeInfo.Objcect0down[cubeInfo3.point];
				num4 = CubeInfo.Objcect1down[cubeInfo4.point];
				point1Factor = aoFactor[num1];
				point2Factor = aoFactor[num2];
				point3Factor = aoFactor[num3];
				point4Factor = aoFactor[num4];
				//_addOnePlaneVertex(4, cubeInfo, point1Factor, point2Factor, point3Factor, point4Factor);
				cubeInfo.downVBIndex = (verticesIndex << 24) + offset;
				vertexArray[offset] = x;
				vertexArray[offset + 1] = y;
				vertexArray[offset + 2] = z;
				vertexArray[offset + 3] = 0.0;
				vertexArray[offset + 4] = -1.0;
				vertexArray[offset + 5] = 0.0;
				vertexArray[offset + 6] = r * point1Factor;
				vertexArray[offset + 7] = g * point1Factor;
				vertexArray[offset + 8] = b * point1Factor;
				vertexArray[offset + 9] = a;
				vertexArray[offset + 10] = x + 1;
				vertexArray[offset + 11] = y;
				vertexArray[offset + 12] = z;
				vertexArray[offset + 13] = 0.0;
				vertexArray[offset + 14] = -1.0;
				vertexArray[offset + 15] = 0.0;
				vertexArray[offset + 16] = r * point2Factor;
				vertexArray[offset + 17] = g * point2Factor;
				vertexArray[offset + 18] = b * point2Factor;
				vertexArray[offset + 19] = a;
				vertexArray[offset + 20] = x + 1;
				vertexArray[offset + 21] = y;
				vertexArray[offset + 22] = z + 1;
				vertexArray[offset + 23] = 0.0;
				vertexArray[offset + 24] = -1.0;
				vertexArray[offset + 25] = 0.0;
				vertexArray[offset + 26] = r * point3Factor;
				vertexArray[offset + 27] = g * point3Factor;
				vertexArray[offset + 28] = b * point3Factor;
				vertexArray[offset + 29] = a;
				vertexArray[offset + 30] = x;
				vertexArray[offset + 31] = y;
				vertexArray[offset + 32] = z + 1;
				vertexArray[offset + 33] = 0.0;
				vertexArray[offset + 34] = -1.0;
				vertexArray[offset + 35] = 0.0;
				vertexArray[offset + 36] = r * point4Factor;
				vertexArray[offset + 37] = g * point4Factor;
				vertexArray[offset + 38] = b * point4Factor;
				vertexArray[offset + 39] = a;
				break;
			case 5: 
				cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z);
				cubeInfo2 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z);
				cubeInfo3 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z);
				cubeInfo4 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z);
				
				num1 = CubeInfo.Objcect2back[cubeInfo1.point];
				num2 = CubeInfo.Objcect3back[cubeInfo2.point];
				num3 = CubeInfo.Objcect7back[cubeInfo3.point];
				num4 = CubeInfo.Objcect6back[cubeInfo4.point];
				
				point1Factor = aoFactor[num1];
				point2Factor = aoFactor[num2];
				point3Factor = aoFactor[num3];
				point4Factor = aoFactor[num4];
				//_addOnePlaneVertex(5, cubeInfo, point1Factor, point2Factor, point3Factor, point4Factor);
				cubeInfo.backVBIndex = (verticesIndex << 24) + offset;
				vertexArray[offset] = x + 1;
				vertexArray[offset + 1] = y;
				vertexArray[offset + 2] = z;
				vertexArray[offset + 3] = 0.0;
				vertexArray[offset + 4] = 0.0;
				vertexArray[offset + 5] = -1.0;
				vertexArray[offset + 6] = r * point1Factor;
				vertexArray[offset + 7] = g * point1Factor;
				vertexArray[offset + 8] = b * point1Factor;
				vertexArray[offset + 9] = a;
				vertexArray[offset + 10] = x;
				vertexArray[offset + 11] = y;
				vertexArray[offset + 12] = z;
				vertexArray[offset + 13] = 0.0;
				vertexArray[offset + 14] = 0.0;
				vertexArray[offset + 15] = -1.0;
				vertexArray[offset + 16] = r * point2Factor;
				vertexArray[offset + 17] = g * point2Factor;
				vertexArray[offset + 18] = b * point2Factor;
				vertexArray[offset + 19] = a;
				vertexArray[offset + 20] = x;
				vertexArray[offset + 21] = y + 1;
				vertexArray[offset + 22] = z;
				vertexArray[offset + 23] = 0.0;
				vertexArray[offset + 24] = 0.0;
				vertexArray[offset + 25] = -1.0;
				vertexArray[offset + 26] = r * point3Factor;
				vertexArray[offset + 27] = g * point3Factor;
				vertexArray[offset + 28] = b * point3Factor;
				vertexArray[offset + 29] = a;
				vertexArray[offset + 30] = x + 1;
				vertexArray[offset + 31] = y + 1;
				vertexArray[offset + 32] = z;
				vertexArray[offset + 33] = 0.0;
				vertexArray[offset + 34] = 0.0;
				vertexArray[offset + 35] = -1.0;
				vertexArray[offset + 36] = r * point4Factor;
				vertexArray[offset + 37] = g * point4Factor;
				vertexArray[offset + 38] = b * point4Factor;
				vertexArray[offset + 39] = a;
				break;
			}
		}
		
		public function _updataColorPropertyFaceVertex(selfCube:CubeInfo, FaceIndex:int, property:int):void
		{
			var vertexArray:Float32Array = _vertices[FaceIndex >> 24];
			var endStartArray:Array = _vertexUpdateFlag[FaceIndex >> 24];
			var offset:int = FaceIndex & 0x00ffffff;
			
			//维护StartEnd
			if (endStartArray[0] > offset) endStartArray[0] = offset
			
			if (endStartArray[1] < offset + 39) endStartArray[1] = offset + 39;

			vertexArray[offset + 9]  = property;
			vertexArray[offset + 19] = property;
			vertexArray[offset + 29] = property;
			vertexArray[offset + 39] = property;
			
		}
		
		/**
		 * @private
		 * 改变一个面的颜色，可能是改变颜色，也可能改变AO
		 */
		public function _updataColorFaceVertex(selfCube:CubeInfo, FaceIndex:int, color:int):void {
			var point1Factor:int;
			var point2Factor:int;
			var point3Factor:int;
			var point4Factor:int;
			var cubeInfo1:CubeInfo;
			var cubeInfo2:CubeInfo;
			var cubeInfo3:CubeInfo;
			var cubeInfo4:CubeInfo;
			//获得绝对位置
			
			switch (FaceIndex) {
			case 0: 
				cubeInfo1 = _cubeMap.find(selfCube.x + 1, selfCube.y + 1, selfCube.z + 1);
				cubeInfo2 = _cubeMap.find(selfCube.x, selfCube.y + 1, selfCube.z + 1);
				cubeInfo3 = _cubeMap.find(selfCube.x, selfCube.y, selfCube.z + 1);
				cubeInfo4 = _cubeMap.find(selfCube.x + 1, selfCube.y, selfCube.z + 1);
				point1Factor = CubeInfo.aoFactor[CubeInfo.Objcect4front[cubeInfo1.point]];
				point2Factor = CubeInfo.aoFactor[CubeInfo.Objcect5front[cubeInfo2.point]];
				point3Factor = CubeInfo.aoFactor[CubeInfo.Objcect1front[cubeInfo3.point]];
				point4Factor = CubeInfo.aoFactor[CubeInfo.Objcect0front[cubeInfo4.point]];
				_updataOnePlaneVertex(selfCube.frontVBIndex, color, point1Factor, point2Factor, point3Factor, point4Factor);
				break;
			case 1: 
				cubeInfo1 = _cubeMap.find(selfCube.x + 1, selfCube.y + 1, selfCube.z + 1);
				cubeInfo2 = _cubeMap.find(selfCube.x + 1, selfCube.y, selfCube.z + 1);
				cubeInfo3 = _cubeMap.find(selfCube.x + 1, selfCube.y, selfCube.z);
				cubeInfo4 = _cubeMap.find(selfCube.x + 1, selfCube.y + 1, selfCube.z);
				point1Factor = CubeInfo.aoFactor[CubeInfo.Objcect4right[cubeInfo1.point]];
				point2Factor = CubeInfo.aoFactor[CubeInfo.Objcect0right[cubeInfo2.point]];
				point3Factor = CubeInfo.aoFactor[CubeInfo.Objcect2right[cubeInfo3.point]];
				point4Factor = CubeInfo.aoFactor[CubeInfo.Objcect6right[cubeInfo4.point]];
				_updataOnePlaneVertex(selfCube.rightVBIndex, color, point1Factor, point2Factor, point3Factor, point4Factor);
				break;
			case 2: 
				cubeInfo1 = _cubeMap.find(selfCube.x + 1, selfCube.y + 1, selfCube.z + 1);
				cubeInfo2 = _cubeMap.find(selfCube.x + 1, selfCube.y + 1, selfCube.z);
				cubeInfo3 = _cubeMap.find(selfCube.x, selfCube.y + 1, selfCube.z);
				cubeInfo4 = _cubeMap.find(selfCube.x, selfCube.y + 1, selfCube.z + 1);
				point1Factor = CubeInfo.aoFactor[CubeInfo.Objcect4up[cubeInfo1.point]];
				point2Factor = CubeInfo.aoFactor[CubeInfo.Objcect6up[cubeInfo2.point]];
				point3Factor = CubeInfo.aoFactor[CubeInfo.Objcect7up[cubeInfo3.point]];
				point4Factor = CubeInfo.aoFactor[CubeInfo.Objcect5up[cubeInfo4.point]];
				_updataOnePlaneVertex(selfCube.topVBIndex, color, point1Factor, point2Factor, point3Factor, point4Factor);
				break;
			case 3: 
				cubeInfo1 = _cubeMap.find(selfCube.x, selfCube.y + 1, selfCube.z + 1);
				cubeInfo2 = _cubeMap.find(selfCube.x, selfCube.y + 1, selfCube.z);
				cubeInfo3 = _cubeMap.find(selfCube.x, selfCube.y, selfCube.z);
				cubeInfo4 = _cubeMap.find(selfCube.x, selfCube.y, selfCube.z + 1);
				point1Factor = CubeInfo.aoFactor[CubeInfo.Objcect5left[cubeInfo1.point]];
				point2Factor = CubeInfo.aoFactor[CubeInfo.Objcect7left[cubeInfo2.point]];
				point3Factor = CubeInfo.aoFactor[CubeInfo.Objcect3left[cubeInfo3.point]];
				point4Factor = CubeInfo.aoFactor[CubeInfo.Objcect1left[cubeInfo4.point]];
				_updataOnePlaneVertex(selfCube.leftVBIndex, color, point1Factor, point2Factor, point3Factor, point4Factor);
				break;
			case 4: 
				cubeInfo1 = _cubeMap.find(selfCube.x, selfCube.y, selfCube.z);
				cubeInfo2 = _cubeMap.find(selfCube.x + 1, selfCube.y, selfCube.z);
				cubeInfo3 = _cubeMap.find(selfCube.x + 1, selfCube.y, selfCube.z + 1);
				cubeInfo4 = _cubeMap.find(selfCube.x, selfCube.y, selfCube.z + 1);
				point1Factor = CubeInfo.aoFactor[CubeInfo.Objcect3down[cubeInfo1.point]];
				point2Factor = CubeInfo.aoFactor[CubeInfo.Objcect2down[cubeInfo2.point]];
				point3Factor = CubeInfo.aoFactor[CubeInfo.Objcect0down[cubeInfo3.point]];
				point4Factor = CubeInfo.aoFactor[CubeInfo.Objcect1down[cubeInfo4.point]];
				_updataOnePlaneVertex(selfCube.downVBIndex, color, point1Factor, point2Factor, point3Factor, point4Factor);
				break;
			case 5: 
				cubeInfo1 = _cubeMap.find(selfCube.x + 1, selfCube.y, selfCube.z);
				cubeInfo2 = _cubeMap.find(selfCube.x, selfCube.y, selfCube.z);
				cubeInfo3 = _cubeMap.find(selfCube.x, selfCube.y + 1, selfCube.z);
				cubeInfo4 = _cubeMap.find(selfCube.x + 1, selfCube.y + 1, selfCube.z);
				point1Factor = CubeInfo.aoFactor[CubeInfo.Objcect2back[cubeInfo1.point]];
				point2Factor = CubeInfo.aoFactor[CubeInfo.Objcect3back[cubeInfo2.point]];
				point3Factor = CubeInfo.aoFactor[CubeInfo.Objcect7back[cubeInfo3.point]];
				point4Factor = CubeInfo.aoFactor[CubeInfo.Objcect6back[cubeInfo4.point]];
				_updataOnePlaneVertex(selfCube.backVBIndex, color, point1Factor, point2Factor, point3Factor, point4Factor);
				
				break;
				
			}
		}
		
		public function _updataCubeInfoAO(cubeInfo:CubeInfo):void {
			for (var i:int = 0; i < 6; i++) {
				//传入本身cubeinfo，faceindex，frontfaceAO的
				_updataOnePlaneAO(cubeInfo, i, cubeInfo.frontFaceAO[i])
			}
		
		}
		
		private function _updataOnePlaneAO(cubeInfo:CubeInfo, faceIndex:int, UpdataData:int):void {
			
			if (UpdataData == 0) {
				return;
			}
			var VBPoint:int = cubeInfo.getVBPointbyFaceIndex(faceIndex);
			
			if (VBPoint == -1) {
				return;
			}
			var vertices:Vector.<Float32Array> = cubeInfo.subCube._vertices;
			
			var vertexUpdateFlag:Vector.<Array> = cubeInfo.subCube._vertexUpdateFlag;
			
			var vertexArray:Float32Array = vertices[VBPoint >> 24];
			var endStartArray:Array = vertexUpdateFlag[VBPoint >> 24];
			var offset:int = VBPoint & 0x00ffffff;
			
			//维护StartEnd
			if (endStartArray[0] > offset) endStartArray[0] = offset
			
			if (endStartArray[1] < offset + 39) endStartArray[1] = offset + 39;
			var colorindex:int = cubeInfo.color;
			var r:Number = (colorindex & 0xff)/255;
			var g:Number = ((colorindex & 0xff00) >> 8) / 255;
			var b:Number = ((colorindex & 0xff0000) >> 16) / 255;
			var pointFactor:int;
			var cubeInfo1:CubeInfo;
			if ((UpdataData & CubeInfo.PanduanWei[0]) != 0) {
				
				//计算pointFactor
				switch (faceIndex) {
				case 0: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect4front[cubeInfo1.point]];
					break;
				case 1: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect4right[cubeInfo1.point]];
					break;
				case 2: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect4up[cubeInfo1.point]];
					break;
				case 3: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect5left[cubeInfo1.point]];
					break;
				case 4: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect3down[cubeInfo1.point]];
					break;
				case 5: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect2back[cubeInfo1.point]];
					break;
				}
				vertexArray[offset + 6] = r * pointFactor;
				vertexArray[offset + 7] = g * pointFactor;
				vertexArray[offset + 8] = b * pointFactor;
				
			}
			if ((UpdataData & CubeInfo.PanduanWei[1]) != 0) {
				switch (faceIndex) {
				case 0: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect5front[cubeInfo1.point]];
					break;
				case 1: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect0right[cubeInfo1.point]];
					break;
				case 2: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect6up[cubeInfo1.point]];
					break;
				case 3: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect7left[cubeInfo1.point]];
					break;
				case 4: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect2down[cubeInfo1.point]];
					break;
				case 5: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect3back[cubeInfo1.point]];
					break;
				}
				vertexArray[offset + 16] = r * pointFactor;
				vertexArray[offset + 17] = g * pointFactor;
				vertexArray[offset + 18] = b * pointFactor;
				
			}
			if ((UpdataData & CubeInfo.PanduanWei[2]) != 0) {
				switch (faceIndex) {
				case 0: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect1front[cubeInfo1.point]];
					break;
				case 1: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect2right[cubeInfo1.point]];
					break;
				case 2: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect7up[cubeInfo1.point]];
					break;
				case 3: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect3left[cubeInfo1.point]];
					break;
				case 4: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect0down[cubeInfo1.point]];
					break;
				case 5: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect7back[cubeInfo1.point]];
					break;
					
				}
				vertexArray[offset + 26] = r * pointFactor;
				vertexArray[offset + 27] = g * pointFactor;
				vertexArray[offset + 28] = b * pointFactor;
				
			}
			if ((UpdataData & CubeInfo.PanduanWei[3]) != 0) {
				switch (faceIndex) {
				case 0: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect0front[cubeInfo1.point]];
					break;
				case 1: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect6right[cubeInfo1.point]];
					break;
				case 2: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y + 1, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect5up[cubeInfo1.point]];
					break;
				case 3: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect1left[cubeInfo1.point]];
					break;
				case 4: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x, cubeInfo.y, cubeInfo.z + 1);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect1down[cubeInfo1.point]];
					break;
				case 5: 
					cubeInfo1 = _cubeMap.find(cubeInfo.x + 1, cubeInfo.y + 1, cubeInfo.z);
					pointFactor = CubeInfo.aoFactor[CubeInfo.Objcect6back[cubeInfo1.point]];
					break;
					
				}
				vertexArray[offset + 36] = r * pointFactor;
				vertexArray[offset + 37] = g * pointFactor;
				vertexArray[offset + 38] = b * pointFactor;
				
			}
		
		}
		
		/*
		 * @private
		 * 画所有点的颜色
		 */
		
		/**
		 * @private
		 * 移除一个面
		 */
		public function _removeOnePlaneVertex(cubeInfo:CubeInfo, VBPoint:int):void {
			//找到最后的值
			
			if (VBPoint == -1) {
				return;
			}
			
			var This_vertices:Vector.<Float32Array> = cubeInfo.updateCube._vertices;
			
			var This_vertexUpdateFlag:Vector.<Array> = cubeInfo.updateCube._vertexUpdateFlag;
			
			var vertexArray:Float32Array = This_vertices[VBPoint >> 24];
			var endStartArray:Array = This_vertexUpdateFlag[VBPoint >> 24];
			var offset:int = VBPoint & 0x00ffffff;
			
			//找到最后的数组
			var endVertexArray:Float32Array = This_vertices[Math.ceil(cubeInfo.updateCube._currentVertexCount / 65536)-1];
			var offsetEnd:int = Math.floor((cubeInfo.updateCube._currentVertexCount - 4) % 65536) * 10;
			
			//维护StartEnd
			if (endStartArray[0] > offset) endStartArray[0] = offset
			
			if (endStartArray[1] < offset + 39) endStartArray[1] = offset + 39;
			
			//总点减4
			cubeInfo.updateCube._currentVertexCount -= 4;
			
			//换位置
			_changeCubeInfoFaceVBIndex(endVertexArray[offsetEnd], endVertexArray[offsetEnd + 1], endVertexArray[offsetEnd + 2], endVertexArray[offsetEnd + 3], endVertexArray[offsetEnd + 4], endVertexArray[offsetEnd + 5], VBPoint);
			for (var i:int = 0; i < 40; i++) {
				vertexArray[offset + i] = endVertexArray[offsetEnd + i];
			}
		
		}
		
		/*
		 * @private
		 * 换一个面的颜色
		 */
		private function _updataOnePlaneVertex(VBPoint:int, colorindex:int, point1Factor:int, point2Factor:int, point3Factor:int, point4Factor:int):void {
			
			var vertexArray:Float32Array = _vertices[VBPoint >> 24];
			var endStartArray:Array = _vertexUpdateFlag[VBPoint >> 24];
			var offset:int = VBPoint & 0x00ffffff;
			
			//维护StartEnd
			if (endStartArray[0] > offset) endStartArray[0] = offset
			
			if (endStartArray[1] < offset + 39) endStartArray[1] = offset + 39;
			
			var r:Number = (colorindex & 0xff)/255;
			var g:Number = ((colorindex & 0xff00) >> 8) / 255;
			var b:Number = ((colorindex & 0xff0000) >> 16) / 255;
			
			
			vertexArray[offset + 6] = r * point1Factor;
			vertexArray[offset + 7] = g * point1Factor;
			vertexArray[offset + 8] = b * point1Factor;
			
			vertexArray[offset + 16] = r * point2Factor;
			vertexArray[offset + 17] = g * point2Factor;
			vertexArray[offset + 18] = b * point2Factor;
			
			vertexArray[offset + 26] = r * point3Factor;
			vertexArray[offset + 27] = g * point3Factor;
			vertexArray[offset + 28] = b * point3Factor;
			
			vertexArray[offset + 36] = r * point4Factor;
			vertexArray[offset + 37] = g * point4Factor;
			vertexArray[offset + 38] = b * point4Factor;
		}
		
		//根据法线和xyz的值得到CubeInfo
		private function _changeCubeInfoFaceVBIndex(x:int, y:int, z:int, norx:int, nory:int, norz:int, VBPoint:int):void {
			var cubeinfox:int;
			var cubeinfoy:int;
			var cubeinfoz:int;
			var cubeinfo:CubeInfo;
			if (norx == 0 && nory == 0 && norz == 1) {
				//前面
				cubeinfox = x - 1;
				cubeinfoy = y - 1;
				cubeinfoz = z - 1;
				cubeinfo = _cubeMap.find(cubeinfox + HALFMAXNumCube, cubeinfoy + HALFMAXNumCube, cubeinfoz + HALFMAXNumCube);
				cubeinfo.frontVBIndex = VBPoint;
			} else if (norx == 1 && nory == 0 && norz == 0) {
				//右面
				cubeinfox = x - 1;
				cubeinfoy = y - 1;
				cubeinfoz = z - 1;
				cubeinfo = _cubeMap.find(cubeinfox + HALFMAXNumCube, cubeinfoy + HALFMAXNumCube, cubeinfoz + HALFMAXNumCube);
				cubeinfo.rightVBIndex = VBPoint;
				
			} else if (norx == 0 && nory == 1 && norz == 0) {
				//上面
				cubeinfox = x - 1;
				cubeinfoy = y - 1;
				cubeinfoz = z - 1;
				cubeinfo = _cubeMap.find(cubeinfox + HALFMAXNumCube, cubeinfoy + HALFMAXNumCube, cubeinfoz + HALFMAXNumCube);
				cubeinfo.topVBIndex = VBPoint;
				
			} else if (norx == -1 && nory == 0 && norz == 0) {
				//左面
				cubeinfox = x;
				cubeinfoy = y - 1;
				cubeinfoz = z - 1;
				cubeinfo = _cubeMap.find(cubeinfox + HALFMAXNumCube, cubeinfoy + HALFMAXNumCube, cubeinfoz + HALFMAXNumCube);
				cubeinfo.leftVBIndex = VBPoint;
				
			} else if (norx == 0 && nory == -1 && norz == 0) {
				//下面
				cubeinfox = x;
				cubeinfoy = y;
				cubeinfoz = z;
				cubeinfo = _cubeMap.find(cubeinfox + HALFMAXNumCube, cubeinfoy + HALFMAXNumCube, cubeinfoz + HALFMAXNumCube);
				cubeinfo.downVBIndex = VBPoint;
				
			} else if (norx == 0 && nory == 0 && norz == -1) {
				//后面
				cubeinfox = x - 1;
				cubeinfoy = y;
				cubeinfoz = z;
				cubeinfo = _cubeMap.find(cubeinfox + HALFMAXNumCube, cubeinfoy + HALFMAXNumCube, cubeinfoz + HALFMAXNumCube);
				cubeinfo.backVBIndex = VBPoint;
			}
		}
		
		/**
		 * @private
		 */
		private function _addCubeInfo(selfCube:CubeInfo):void {
			var x:int = selfCube.x;
			var y:int = selfCube.y;
			var z:int = selfCube.z;
			var otherCube:CubeInfo = _cubeMap.find(x + 1, y + 1, z + 1);
			var cubeInfo:CubeInfo;
			_cubeMap.data[(x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16)].save = null;
			//front
			if (otherCube.calDirectCubeExit(6) == -1) {
				//如果前面没有点，加一个面
				selfCube.frontVBIndex == -1 && _addFaceVertex(selfCube, 0);
			} else {
				cubeInfo = _cubeMap.find(x, y, z + 1);
				//如果有cube，就判断然后减面
				_removeOnePlaneVertex(cubeInfo, cubeInfo.backVBIndex);
				cubeInfo.backVBIndex = -1;
			}
			//right
			if (otherCube.calDirectCubeExit(5) == -1) {
				selfCube.rightVBIndex == -1 && _addFaceVertex(selfCube, 1);
			} else {
				cubeInfo = _cubeMap.find(x + 1, y, z);
				_removeOnePlaneVertex(cubeInfo, cubeInfo.leftVBIndex);
				cubeInfo.leftVBIndex = -1;
			}
			//up
			if (otherCube.calDirectCubeExit(0) == -1) {
				selfCube.topVBIndex == -1 && _addFaceVertex(selfCube, 2);
			} else {
				cubeInfo = _cubeMap.find(x, y + 1, z);
				_removeOnePlaneVertex(cubeInfo, cubeInfo.downVBIndex);
				cubeInfo.downVBIndex = -1;
			}
			//left
			if (selfCube.calDirectCubeExit(2) == -1) {
				selfCube.leftVBIndex == -1 && _addFaceVertex(selfCube, 3);
			} else {
				cubeInfo = _cubeMap.find(x - 1, y, z);
				_removeOnePlaneVertex(cubeInfo, cubeInfo.rightVBIndex);
				cubeInfo.rightVBIndex = -1;
			}
			//down
			if (selfCube.calDirectCubeExit(7) == -1) {
				selfCube.downVBIndex == -1 && _addFaceVertex(selfCube, 4);
			} else {
				cubeInfo = _cubeMap.find(x, y - 1, z);
				_removeOnePlaneVertex(cubeInfo, cubeInfo.topVBIndex);
				cubeInfo.topVBIndex = -1;
			}
			
			//back
			if (selfCube.calDirectCubeExit(1) == -1) {
				selfCube.backVBIndex == -1 && _addFaceVertex(selfCube, 5);
			} else {
				cubeInfo = _cubeMap.find(x, y, z - 1);
				_removeOnePlaneVertex(cubeInfo, cubeInfo.frontVBIndex);
				cubeInfo.frontVBIndex = -1;
			}
		
		}
		
		/**
		 * @private
		 */
		private function _removeCubeInfo(selfCube:CubeInfo):void {
			
			var x:int = selfCube.x;
			var y:int = selfCube.y;
			var z:int = selfCube.z;
			var otherCube:CubeInfo = _cubeMap.find(x + 1, y + 1, z + 1);
			var cubeInfo:CubeInfo;
			_cubeMap.data[(x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16)].save = null;
			//front
			if (selfCube.frontVBIndex != -1) {
				//如果前面没有点，加一个面
				_removeOnePlaneVertex(selfCube, selfCube.frontVBIndex);
				selfCube.frontVBIndex = -1;
			}
			if (otherCube.calDirectCubeExit(6) != -1) {
				cubeInfo = _cubeMap.find(x, y, z + 1);
				cubeInfo.backVBIndex == -1 && _addFaceVertex(cubeInfo, 5);
			}
			
			//right
			if (selfCube.rightVBIndex != -1) {
				_removeOnePlaneVertex(selfCube, selfCube.rightVBIndex);
				selfCube.rightVBIndex = -1;
			}
			if (otherCube.calDirectCubeExit(5) != -1) {
				cubeInfo = _cubeMap.find(x + 1, y, z);
				_addFaceVertex(cubeInfo, 3);
			}
			
			//up
			if (selfCube.topVBIndex != -1) {
				_removeOnePlaneVertex(selfCube, selfCube.topVBIndex);
				selfCube.topVBIndex = -1;
			}
			if (otherCube.calDirectCubeExit(0) != -1) {
				cubeInfo = _cubeMap.find(x, y + 1, z);
				_addFaceVertex(cubeInfo, 4);
			}
			//left
			if (selfCube.leftVBIndex != -1) {
				_removeOnePlaneVertex(selfCube, selfCube.leftVBIndex);
				selfCube.leftVBIndex = -1;
			}
			if (selfCube.calDirectCubeExit(2) != -1) {
				cubeInfo = _cubeMap.find(x - 1, y, z);
				_addFaceVertex(cubeInfo, 1);
			}
			//down
			if (selfCube.downVBIndex != -1) {
				_removeOnePlaneVertex(selfCube, selfCube.downVBIndex);
				selfCube.downVBIndex = -1;
			}
			if (selfCube.calDirectCubeExit(7) != -1) {
				cubeInfo = _cubeMap.find(x, y - 1, z);
				_addFaceVertex(cubeInfo, 2);
			}
			
			//back
			if (selfCube.backVBIndex != -1) {
				_removeOnePlaneVertex(selfCube, selfCube.backVBIndex);
				selfCube.backVBIndex = -1;
			}
			if (selfCube.calDirectCubeExit(1) != -1) {
				cubeInfo = _cubeMap.find(x, y, z - 1);
				_addFaceVertex(cubeInfo, 0);
			}
		}
		
		/**
		 * @private
		 */
		private function _updateCubeInfo(selfCube:CubeInfo):void {
			var color:int = selfCube.color;
			_cubeMap.data[(selfCube.x >> 5) + ((selfCube.y >> 5) << 8) + ((selfCube.z >> 5) << 16)].save = null;
			if (selfCube.frontVBIndex != -1) _updataColorFaceVertex(selfCube, 0, color);
			if (selfCube.rightVBIndex != -1) _updataColorFaceVertex(selfCube, 1, color);
			if (selfCube.topVBIndex != -1) _updataColorFaceVertex(selfCube, 2, color);
			if (selfCube.leftVBIndex != -1) _updataColorFaceVertex(selfCube, 3, color);
			if (selfCube.downVBIndex != -1) _updataColorFaceVertex(selfCube, 4, color);
			if (selfCube.backVBIndex != -1) _updataColorFaceVertex(selfCube, 5, color);
		
		}
		/**
		 * @private
		 * 更新cube属性
		 */
		private function _updateCubeInfoProperty(selfCube:CubeInfo):void
		{
			var color:int = (selfCube.color & 0xff000000)>>24;
			
			_cubeMap.data[(selfCube.x >> 5) + ((selfCube.y >> 5) << 8) + ((selfCube.z >> 5) << 16)].save = null;
			if (selfCube.frontVBIndex != -1) _updataColorPropertyFaceVertex(selfCube, selfCube.frontVBIndex, color);
			if (selfCube.rightVBIndex != -1) _updataColorPropertyFaceVertex(selfCube, selfCube.rightVBIndex, color);
			if (selfCube.topVBIndex != -1) _updataColorPropertyFaceVertex(selfCube, selfCube.topVBIndex, color);
			if (selfCube.leftVBIndex != -1) _updataColorPropertyFaceVertex(selfCube, selfCube.leftVBIndex, color);
			if (selfCube.downVBIndex != -1) _updataColorPropertyFaceVertex(selfCube, selfCube.downVBIndex, color);
			if (selfCube.backVBIndex != -1) _updataColorPropertyFaceVertex(selfCube, selfCube.backVBIndex, color);
		}
		
		
		/**
		 * @private
		 */
		public function updatePlane(cubeInfo:CubeInfo):void {
			var modifyFlag:int = cubeInfo.modifyFlag;
			switch (modifyFlag) {
			case CubeInfo.MODIFYE_ADD: 
				_addCubeInfo(cubeInfo);
				
				break;
			case CubeInfo.MODIFYE_REMOVE: 
				_removeCubeInfo(cubeInfo);
				//if (cubeInfo.point === 0) {//异步处理完删除数据,保证删除安全,但可能回收不干净
				//CubeInfo.recover(cubeInfo);
				//_cubeMap.remove(cubeInfo.x, cubeInfo.y, cubeInfo.z);
				//}
				break;
			case CubeInfo.MODIFYE_UPDATE: 
				_updateCubeInfo(cubeInfo);
				break;
			case CubeInfo.MODIFYE_UPDATEAO: 
				_updataCubeInfoAO(cubeInfo);
				cubeInfo.clearAoData();
				break;
			case CubeInfo.MODIFYE_UPDATEPROPERTY:
				_updateCubeInfoProperty(cubeInfo);
			}
			
			cubeInfo.modifyFlag = CubeInfo.MODIFYE_NONE;
			return;
		}
		
		/**
		 * @private
		 */
		public function updateBuffer():void {
			var count:int = Math.ceil(_currentVertexCount / 65536);
			for (var i:int = 0, n:int = _vertexUpdateFlag.length; i < n; i++) {
				var flag:Array = _vertexUpdateFlag[i];
				if (i < count) {
					var updateStart:int = flag[0];
					var updateEnd:int = flag[1]+1;
					if (updateStart !== 2147483647 && updateEnd !== -2147483647) {
						_vertexbuffers[i].setData(_vertices[i], updateStart, updateStart, updateEnd - updateStart);
						flag[0] = 2147483647; /*int.MAX_VALUE*/
						flag[1] = -2147483647; /*int.MIN_VALUE*/
					}
				} else {
					flag[0] = 2147483647; /*int.MAX_VALUE*/
					flag[1] = -2147483647; /*int.MIN_VALUE*/
				}
			}
		}
		
		/**
		 * @private
		 */
		public function render(state:RenderContext3D):void {
			//(state.camera as Camera).boundFrustum
			
			var gl:WebGLContext = LayaGL.instance;
			
			
			var count:int = Math.ceil(_currentVertexCount / 65536);
			var endIndex:int = count - 1;
			for (var i:int = 0; i < count; i++) {
				_bufferStates[i].bind();
				var renderCount:int = (i === endIndex) ? _currentVertexCount - 65536 * endIndex : 65536;
			
				gl.drawElements(WebGLContext.TRIANGLES, (renderCount / 4) * 6, WebGLContext.UNSIGNED_SHORT, 0);
			}
			
			Stat.renderBatch += count;
			Stat.trianglesFaces += _currentVertexCount / 2;
		}
		
		/**
		 * @private
		 */
		public function clear():void {
	
			_currentVertexCount = 0;
			cubeCount = 0;
		}
		
		
		/**
		 * @private
		 */
		public function destroy():void{
			for (var i:int = 0, n:int = _vertexbuffers.length; i < n; i++){
				_bufferStates[i].destroy();
				_vertexbuffers[i].destroy();
			}
			_vertexbuffers = null;
			_vertices = null;
			var memory:int = _currentVertexSize * FLOATCOUNTPERVERTEX * 4;
			Resource._addCPUMemory(-memory);
			Resource._addGPUMemory(-memory);
		}
	
	}
}