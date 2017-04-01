package laya.d3.core {
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * @private
	 * <code>PhasorSpriter3D</code> 类用于创建矢量笔刷。
	 */
	public class PhasorSpriter3D {
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(28, [new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0), new VertexElement(12, VertexElementFormat.Vector4, VertexElementUsage.COLOR0)]);
		
		private var _tempInt0:int;
		private var _tempInt1:int;
		private var _tempUint0:uint;
		private var _tempUint1:uint;
		private var _tempUint2:uint;
		private var _tempUint3:uint;
		private var _tempUint4:uint;
		private var _tempUint5:uint;
		private var _tempUint6:uint;
		private var _tempUint7:uint;
		private var _tempNumver0:Number;
		private var _tempNumver1:Number;
		private var _tempNumver2:Number;
		private var _tempNumver3:Number;
		
		private const _floatSizePerVer:int = 7;//顶点结构为Position(3个float)+Color(4个float)
		private const _defaultBufferSize:int = 600 * _floatSizePerVer;
		
		private var _vbData:Float32Array = new Float32Array(_defaultBufferSize);
		private var _vb:VertexBuffer3D;
		private var _posInVBData:uint;
		
		private var _ibData:Uint16Array = new Uint16Array(_defaultBufferSize);
		private var _ib:IndexBuffer3D;
		private var _posInIBData:uint;
		
		private var _primitiveType:Number;
		private var _hasBegun:Boolean;
		private var _numVertsPerPrimitive:uint;
		
		private var _renderState:RenderState;
		
		private var _sharderNameID:int;
		private var _shader:Shader3D;
		/** @private */
		protected var _shaderCompile:ShaderCompile3D;
		/** @private */
		private var _spriteShaderValue:ValusArray = new ValusArray();
		
		public function PhasorSpriter3D() {
			super();
			_vb = VertexBuffer3D.create(_vertexDeclaration,_defaultBufferSize/_floatSizePerVer, WebGLContext.DYNAMIC_DRAW);
			_ib = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _defaultBufferSize, WebGLContext.DYNAMIC_DRAW);
			_sharderNameID = Shader3D.nameKey.getID("LINE");
			_shaderCompile = ShaderCompile3D._preCompileShader[ShaderCompile3D.SHADERNAME2ID * _sharderNameID];
		}
		
		public function line(startX:Number, startY:Number, startZ:Number, startR:Number, startG:Number, startB:Number, startA:Number, endX:Number, endY:Number, endZ:Number, endR:Number, endG:Number, endB:Number, endA:Number):PhasorSpriter3D {
			if (!_hasBegun || _primitiveType !== WebGLContext.LINES)
				drawLinesException();
			
			if (_posInVBData + 2 * _floatSizePerVer > _vbData.length || _posInIBData + 2 > _ibData.length)
				flush();
			
			_tempUint0 = _posInVBData / _floatSizePerVer;//_tempUint0为curVBPosVertex
			addVertex(startX, startY, startZ, startR, startG, startB, startA); // start
			addVertex(endX, endY, endZ, endR, endG, endB, endA); // end
			addIndexes(_tempUint0, _tempUint0 + 1);
			
			return this;
		}
		
		public function circle(radius:Number, numberOfPoints:uint, r:Number, g:Number, b:Number, a:Number):PhasorSpriter3D {
			if (!_hasBegun || (_primitiveType !== WebGLContext.LINES))
				drawLinesException();
			
			_tempUint0 = numberOfPoints * 2;//_tempUint0为总顶点数
			
			if (_posInVBData + _tempUint0 * _floatSizePerVer > _vbData.length || _posInIBData + 2 * _tempUint0 > _ibData.length)
				flush();
			
			_tempUint1 = _posInVBData / _floatSizePerVer;//_tempUint1为curVBPosVertex
			
			for (_tempNumver0 = 0, _tempInt0 = 0; _tempNumver0 < 3.1416 * 2; _tempNumver0 = _tempNumver0 + (3.1416 / numberOfPoints), _tempInt0++) {
				addVertex(Math.sin(_tempNumver0) * radius, Math.cos(_tempNumver0) * radius, 0, r, g, b, a);
				if (_tempInt0 === 0) {
					addIndexes(_tempUint1);
				} else if (_tempInt0 === _tempUint0 - 1) {
					_tempUint2 = _tempUint1 + _tempInt0;//_tempUit2为当前索引数
					addIndexes(_tempUint2, _tempUint2, _tempUint1);
				} else {
					_tempUint2 = _tempUint1 + _tempInt0;	//_tempUint2为当前索引数
					addIndexes(_tempUint2, _tempUint2);
				}
				
			}
			return this;
		}
		
		public function plane(positionX:Number, positionY:Number, positionZ:Number, width:Number, height:Number, r:Number, g:Number, b:Number, a:Number):PhasorSpriter3D {
			if (!_hasBegun || _primitiveType !== WebGLContext.TRIANGLES)
				drawTrianglesException();
			
			if (_posInVBData + 4 * _floatSizePerVer > _vbData.length || _posInIBData + 6 > _ibData.length)
				flush();
			
			_tempNumver0 = width / 2;//tempNumver0为halfWidth
			_tempNumver1 = height / 2;//tempNumver1为halfHeight
			
			_tempUint0 = _posInVBData / _floatSizePerVer;//_tempUint0为curVBPosVertex
			addVertex(positionX - _tempNumver0, positionY + _tempNumver1, positionZ, r, g, b, a); // LeftUp
			addVertex(positionX + _tempNumver0, positionY + _tempNumver1, positionZ, r, g, b, a); // RightUp
			addVertex(positionX - _tempNumver0, positionY - _tempNumver1, positionZ, r, g, b, a); // LeftBottom
			addVertex(positionX + _tempNumver0, positionY - _tempNumver1, positionZ, r, g, b, a); // RightBottom
			
			_tempUint1 = _tempUint0 + 1;//_tempUint0为curVBPosVertex1
			_tempUint2 = _tempUint0 + 2;//_tempUint1为curVBPosVertex2
			addIndexes(_tempUint0, _tempUint1, _tempUint2, _tempUint2, _tempUint1, _tempUint0 + 3);
			
			return this;
		}
		
		public function box(positionX:Number, positionY:Number, positionZ:Number, width:Number, height:Number, depth:Number, r:Number, g:Number, b:Number, a:Number):PhasorSpriter3D {
			if (!_hasBegun || _primitiveType !== WebGLContext.TRIANGLES)
				drawTrianglesException();
			
			if (_posInVBData + 8 * _floatSizePerVer > _vbData.length || _posInIBData + 36 > _ibData.length)
				flush();
			
			_tempNumver0 = width / 2;//tempNumver0为halfWidth
			_tempNumver1 = height / 2;//tempNumver1为halfHeight
			_tempNumver2 = depth / 2;//tempNumver2为halfDepth
			
			_tempUint0 = _posInVBData / _floatSizePerVer;//_tempUint0为curVBPosVertex
			//frontVertex
			addVertex(positionX - _tempNumver0, positionY + _tempNumver1, positionZ + _tempNumver2, r, g, b, a); // V0
			addVertex(positionX + _tempNumver0, positionY + _tempNumver1, positionZ + _tempNumver2, r, g, b, a); // V1
			addVertex(positionX - _tempNumver0, positionY - _tempNumver1, positionZ + _tempNumver2, r, g, b, a); // V2
			addVertex(positionX + _tempNumver0, positionY - _tempNumver1, positionZ + _tempNumver2, r, g, b, a); // V3
			
			//backVertex
			addVertex(positionX + _tempNumver0, positionY + _tempNumver1, positionZ - _tempNumver2, r, g, b, a); // V4
			addVertex(positionX - _tempNumver0, positionY + _tempNumver1, positionZ - _tempNumver2, r, g, b, a); // V5
			addVertex(positionX + _tempNumver0, positionY - _tempNumver1, positionZ - _tempNumver2, r, g, b, a); // V6
			addVertex(positionX - _tempNumver0, positionY - _tempNumver1, positionZ - _tempNumver2, r, g, b, a); // V7
			
			//    v5----- v4
			//   /|            /|
			//  v0----- v1|
			//  | |            | |
			//  | |v7--   -|-|v6
			//  |/            |/
			//  v2------v3
			
			_tempUint1 = _tempUint0 + 1;//_tempUint1为curVBPosVertex1
			_tempUint2 = _tempUint0 + 2;//_tempUint2为curVBPosVertex2
			_tempUint3 = _tempUint0 + 3;//_tempUint3为curVBPosVertex3
			_tempUint4 = _tempUint0 + 4;//_tempUint4为curVBPosVertex4
			_tempUint5 = _tempUint0 + 5;//_tempUint5为curVBPosVertex5
			_tempUint6 = _tempUint0 + 6;//_tempUint6为curVBPosVertex6
			_tempUint7 = _tempUint0 + 7;//_tempUint7为curVBPosVertex7
			
			//Front
			addIndexes(_tempUint0, _tempUint1, _tempUint2, _tempUint2, _tempUint1, _tempUint3, 
			//Back
			_tempUint4, _tempUint5, _tempUint6, _tempUint6, _tempUint5, _tempUint7, 
			//Left
			_tempUint5, _tempUint0, _tempUint7, _tempUint7, _tempUint0, _tempUint2, 
			//Right
			_tempUint1, _tempUint4, _tempUint3, _tempUint3, _tempUint4, _tempUint6, 
			//Top
			_tempUint5, _tempUint4, _tempUint0, _tempUint0, _tempUint4, _tempUint1, 
			//Bottom
			_tempUint2, _tempUint3, _tempUint7, _tempUint7, _tempUint3, _tempUint6);
			
			return this;
		}
		
		public function cone(radius:Number, length:Number, Slices:Number, r:Number, g:Number, b:Number, a:Number):PhasorSpriter3D {
			if (!_hasBegun || _primitiveType !== WebGLContext.TRIANGLES)
				drawTrianglesException();
			
			if (_posInVBData + (2 * Slices + 2) * _floatSizePerVer > _vbData.length || _posInIBData + 6 * Slices > _ibData.length)
				flush();
			
			_tempUint0 = _posInVBData;//_tempUint0为curVBPos
			_tempUint1 = _posInVBData / _floatSizePerVer;//_tempUint1为curVBPosVertex
			_tempNumver0 = Math.PI * 2 / Slices;//_tempNumver0为sliceStep
			// 计算顶点和索引
			
			addVertexIndex(0, length, 0, r, g, b, a, _tempUint0);
			addVertexIndex(0, 0, 0, r, g, b, a, _tempUint0 + _floatSizePerVer);
			
			// The other vertices
			_tempInt0 = 2;//_tempInt0为currentVertex
			_tempNumver1 = 0;//_tempNumver1为sliceAngle
			
			for (_tempInt1 = 0; _tempInt1 < Slices; _tempInt1++) {
				_tempNumver2 = Math.cos(_tempNumver1);//_tempNumver2为x
				_tempNumver3 = Math.sin(_tempNumver1);//_tempNumver3为y
				
				//顶部
				addVertexIndex(radius * _tempNumver2, 0, radius * _tempNumver3, r, g, b, a, _tempUint0 + _tempInt0 * _floatSizePerVer);
				
				addIndexes(_tempUint1, _tempUint1 + _tempInt0);
				if (_tempInt1 == Slices - 1)
					addIndexes(_tempUint1 + 2);
				else
					addIndexes(_tempUint1 + _tempInt0 + 1);
				
				//底部
				addVertexIndex(radius * _tempNumver2, 0, radius * _tempNumver3, r, g, b, a, _tempUint0 + (_tempInt0 + Slices) * _floatSizePerVer);
				
				addIndexes(_tempUint1 + 1);
				if (_tempInt1 == Slices - 1)
					addIndexes(_tempUint1 + Slices + 2);
				else
					addIndexes(_tempUint1 + _tempInt0 + Slices + 1);
				
				addIndexes(_tempUint1 + _tempInt0 + Slices);
				
				_tempInt0++;
				_tempNumver1 += _tempNumver0;
			}
			//............
			return this;
		}
		
		public function boundingBoxLine(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number, r:Number, g:Number, b:Number, a:Number):PhasorSpriter3D {
			if (!_hasBegun || _primitiveType !== WebGLContext.LINES)
				drawLinesException();
			
			if (_posInVBData + 8 * _floatSizePerVer > _vbData.length || _posInIBData + 48 > _ibData.length)
				flush();
			
			_tempUint0 = _posInVBData / _floatSizePerVer;//_tempUint0为curVBPosVertex
			addVertex(minX, maxY, maxZ, r, g, b, a); // 0
			addVertex(maxX, maxY, maxZ, r, g, b, a); // 1
			addVertex(minX, minY, maxZ, r, g, b, a); // 2
			addVertex(maxX, minY, maxZ, r, g, b, a); // 3
			
			addVertex(maxX, maxY, minZ, r, g, b, a); // 4
			addVertex(minX, maxY, minZ, r, g, b, a); // 5
			addVertex(maxX, minY, minZ, r, g, b, a); // 6
			addVertex(minX, minY, minZ, r, g, b, a); // 7
			
			//    v5----- v4
			//   /|            /|
			//  v0----- v1|
			//  | |            | |
			//  | |v7--   -|-|v6
			//  |/            |/
			//  v2------v3
			_tempUint1 = _tempUint0 + 1;//_tempUint1为curVBPosVertex1
			_tempUint2 = _tempUint0 + 2;//_tempUint2为curVBPosVertex2
			_tempUint3 = _tempUint0 + 3;//_tempUint3为curVBPosVertex3
			_tempUint4 = _tempUint0 + 4;//_tempUint4为curVBPosVertex4
			_tempUint5 = _tempUint0 + 5;//_tempUint5为curVBPosVertex5
			_tempUint6 = _tempUint0 + 6;//_tempUint6为curVBPosVertex6
			_tempUint7 = _tempUint0 + 7;//_tempUint7为curVBPosVertex7
			//Front
			addIndexes(_tempUint0, _tempUint1, _tempUint1, _tempUint3, _tempUint3, _tempUint2, _tempUint2, _tempUint0, 
			//Back
			_tempUint4, _tempUint5, _tempUint5, _tempUint7, _tempUint7, _tempUint6, _tempUint6, _tempUint4, 
			//Left
			_tempUint5, _tempUint0, _tempUint0, _tempUint2, _tempUint2, _tempUint7, _tempUint7, _tempUint5, 
			//Right
			_tempUint1, _tempUint4, _tempUint4, _tempUint6, _tempUint6, _tempUint3, _tempUint3, _tempUint1, 
			//Top
			_tempUint5, _tempUint4, _tempUint4, _tempUint1, _tempUint1, _tempUint0, _tempUint0, _tempUint5, 
			//Bottom
			_tempUint2, _tempUint3, _tempUint3, _tempUint6, _tempUint6, _tempUint7, _tempUint7, _tempUint2);
			
			return this;
		}
		
		private function addVertex(x:Number, y:Number, z:Number, r:Number, g:Number, b:Number, a:Number):PhasorSpriter3D {
			if (!_hasBegun)
				addVertexIndexException();
			
			_vbData[_posInVBData] = x, _vbData[_posInVBData + 1] = y, _vbData[_posInVBData + 2] = z;
			_vbData[_posInVBData + 3] = r, _vbData[_posInVBData + 4] = g, _vbData[_posInVBData + 5] = b, _vbData[_posInVBData + 6] = a;
			
			_posInVBData += _floatSizePerVer;
			
			return this;
		}
		
		private function addVertexIndex(x:Number, y:Number, z:Number, r:Number, g:Number, b:Number, a:Number, index:uint):PhasorSpriter3D {
			if (!_hasBegun)
				addVertexIndexException();
			
			_vbData[index] = x, _vbData[index + 1] = y, _vbData[index + 2] = z;
			_vbData[index + 3] = r, _vbData[index + 4] = g, _vbData[index + 5] = b, _vbData[index + 6] = a;
			index += _floatSizePerVer;
			
			if (index > _posInVBData)
				_posInVBData = index;
			return this;
		}
		
		private function addIndexes(... indexes):PhasorSpriter3D {
			if (!_hasBegun)
				addVertexIndexException();
			
			for (var i:int = 0; i < indexes.length; i++) {
				_ibData[_posInIBData] = indexes[i];
				_posInIBData++;
			}
			return this;
		}
		
		public function begin(primitive:Number, state:RenderState):PhasorSpriter3D {
			if (_hasBegun)
				beginException0();
			
			if (primitive !== WebGLContext.LINES && primitive !== WebGLContext.TRIANGLES)
				beginException1();
			
			_primitiveType = primitive;
			_renderState = state;
			
			_hasBegun = true;
			
			return this;
		}
		
		public function end():PhasorSpriter3D {
			if (!_hasBegun)
				endException();
			
			flush();
			_hasBegun = false;
			return this;
		}
		
		private function flush():void {
			if (_posInVBData === 0)
				return;

			_ib.setData(_ibData);
			_vb.setData(_vbData);
			_vb._bind();
			_ib._bind();
			
			_shader = _getShader(_renderState);
			_shader.bind();
			
			_shader.uploadAttributes(_vertexDeclaration.shaderValues.data, null);
			
			_spriteShaderValue.setValue(Sprite3D.MVPMATRIX, _renderState.projectionViewMatrix.elements);
			_shader.uploadSpriteUniforms(_spriteShaderValue.data);
			
			Stat.drawCall++;
			WebGL.mainContext.drawElements(_primitiveType, _posInIBData, WebGLContext.UNSIGNED_SHORT, 0);
			
			_posInIBData = 0;
			_posInVBData = 0;
		}
		
		protected function _getShader(state:RenderState):Shader3D {
			var defineValue:int = state.scene._shaderDefineValue;
			return _shaderCompile.withCompile(_sharderNameID, defineValue, _sharderNameID * ShaderCompile3D.SHADERNAME2ID+defineValue);
		}
		
		private function addVertexIndexException():void {
			throw new Error("请先调用begin()函数");
		}
		
		private function beginException0():void {
			throw new Error("调用begin()前请确保已成功调用end()！");
		}
		
		private function beginException1():void {
			throw new Error("只支持“LINES”和“TRIANGLES”两种基元！");
		}
		
		private function endException():void {
			throw new Error("调用end()前请确保已成功调用begin()！");
		}
		
		private function drawLinesException():void {
			throw new Error("您必须确保在此之前已调用begin()且使用“LINES”基元！");
		}
		
		private function drawTrianglesException():void {
			throw new Error("您必须确保在此之前已调用begin()且使用“TRIANGLES”基元！");
		}
	
	}
}