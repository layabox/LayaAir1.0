package laya.webgl.utils {
	import laya.utils.Stat;
	import laya.webgl.BufferState2D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;

	/**
	 * Mesh2d只是保存数据。描述attribute用的。本身不具有渲染功能。
	 */
	public class Mesh2D {
		public var _stride:Number = 0;			//顶点结构大小。每个mesh的顶点结构是固定的。
		public var vertNum:int = 0;				//当前的顶点的个数
		public var indexNum:int = 0;			//实际index 个数。例如一个三角形是3个。由于ib本身可能超过实际使用的数量，所以需要一个indexNum
		protected var _applied:Boolean = false;	//是否已经设置给webgl了
		public var _vb:VertexBuffer2D;			//vb和ib都可能需要在外部修改，所以public
		public var _ib:IndexBuffer2D;
		private var _vao:BufferState2D;						//webgl VAO对象。需要WebGL扩展。
		private static var _gvaoid:int = 0;
		private var _attribInfo:Array;			//保存起来的属性定义数组。
		protected var _quadNum:int = 0;
		//public static var meshlist:Array = [];	//活着的mesh对象列表。
		public var canReuse:Boolean = false;	//用完以后，是删除还是回收。
		
		/**
		 * 
		 * @param	stride
		 * @param	vballoc  vb预分配的大小。主要是用来提高效率。防止不断的resizebfufer
		 * @param	iballoc
		 */
		public function Mesh2D(stride:Number,vballoc:int, iballoc:int):void {
			_stride = stride;
			_vb = new VertexBuffer2D(stride, WebGLContext.DYNAMIC_DRAW);
			if (vballoc) {
				_vb._resizeBuffer(vballoc,false);
			}else{
				Config.webGL2D_MeshAllocMaxMem && _vb._resizeBuffer( 64 * 1024 * stride,false);
			}
			_ib = new IndexBuffer2D();
			if (iballoc) {
				_ib._resizeBuffer(iballoc,false);
			}
			//meshlist.push(this);
		}
		
		/**
		 * 重新创建一个mesh。复用这个对象的vertex结构，ib对象和attribinfo对象
		 */
		//TODO:coverage
		public function cloneWithNewVB():Mesh2D {
			var mesh:Mesh2D = new Mesh2D(_stride,0,0);
			mesh._ib = _ib;
			mesh._quadNum = _quadNum;
			mesh._attribInfo = _attribInfo;
			return mesh;
		}
		
		/**
		 * 创建一个mesh，使用当前对象的vertex结构。vb和ib自己提供。
		 * @return
		 */
		//TODO:coverage
		public function cloneWithNewVBIB():Mesh2D {
			var mesh:Mesh2D = new Mesh2D(_stride,0,0);
			mesh._attribInfo = _attribInfo;
			return mesh;
		}
		
		/**
		 * 获得一个可以写的vb对象
		 */
		//TODO:coverage
		public function getVBW():VertexBuffer2D {
			_vb.setNeedUpload();
			return _vb;
		}
		/**
		 * 获得一个只读vb
		 */
		//TODO:coverage
		public function getVBR():VertexBuffer2D {
			return _vb;
		}
		
		//TODO:coverage
		public function getIBR():IndexBuffer2D {
			return _ib;
		}
		/**
		 * 获得一个可写的ib
		 */
		//TODO:coverage
		public function getIBW():IndexBuffer2D {
			_ib.setNeedUpload();
			return _ib;
		}
		
		/**
		 * 直接创建一个固定的ib。按照固定四边形的索引。
		 * @param	var QuadNum
		 */
		public function createQuadIB(QuadNum:int):void {
			_quadNum = QuadNum;
			_ib._resizeBuffer(QuadNum * 6 * 2, false);	//short类型
			_ib.byteLength = _ib.bufferLength;	//这个我也不知道是什么意思
			
			var bd:Uint16Array = _ib.getUint16Array();
			var idx:int = 0;
			var curvert:int = 0;
			for (var i:int = 0; i < QuadNum; i++){
				bd[idx++] = curvert;
				bd[idx++] = curvert + 2;
				bd[idx++] = curvert + 1;
				bd[idx++] = curvert;
				bd[idx++] = curvert + 3;
				bd[idx++] = curvert + 2;
				curvert += 4;
			}
			
			_ib.setNeedUpload();
		}
		
		/**
		 * 设置mesh的属性。每3个一组，对应的location分别是0,1,2...
		 * 含义是：type,size,offset
		 * 不允许多流。因此stride是固定的，offset只是在一个vertex之内。
		 * @param	attribs
		 */
		public function setAttributes( attribs:Array):void {
			_attribInfo = attribs;
			if ( _attribInfo.length % 3 != 0) {
				throw 'Mesh2D setAttributes error!';
			}
		}
		
		/**
		 * 初始化VAO的配置，只需要执行一次。以后使用的时候直接bind就行
		 * @param	gl
		 */
		private function configVAO(gl:WebGLContext):void {
			if (_applied)
				return;
			_applied = true;
			if (!_vao) { 
				//_vao = __JS__('gl.createVertexArray();');
				_vao = new BufferState2D();
				//_vao.dbgid = _gvaoid++;
			}
			_vao.bind();
			//gl.bindVertexArray(_vao);
			_vb._bindForVAO();
			
			//_vb._bind(); 这个有相同优化，不适用于vao
			_ib.setNeedUpload();	//vao的话，必须要绑定ib。即使是共享的别人的。
			_ib._bind_uploadForVAO();
			//gl.bindBuffer(WebGLContext.ARRAY_BUFFER,_vb);
			//gl.bindBuffer(WebGLContext.ELEMENT_ARRAY_BUFFER, _ib);
			var attribNum:int = _attribInfo.length / 3;
			var idx:int = 0;
			for ( var i:int = 0; i < attribNum; i++) {
				var _size:int = _attribInfo[idx + 1];
				var _type:int = _attribInfo[idx];
				var _off:int = _attribInfo[idx + 2];
				gl.enableVertexAttribArray(i);
				gl.vertexAttribPointer(i, _size, _type, false, _stride, _off); //注意 normalize都设置为false了，想必没人要用这个功能把。
				idx += 3;
			}
			_vao.unBind();
			//gl.bindVertexArray(null);
		}
		
		/**
		 * 应用这个mesh
		 * @param	gl
		 */
		public function useMesh(gl:WebGLContext):void {
			//要先bind，在bufferData
			_applied || configVAO(gl);
			
			//var attribNum:int = _attribInfo.length / 3;
			//var bindedAttributeBuffer:Array = Buffer._bindedAtributeBuffer;
			//for ( var i:int = 0; i < attribNum; i++) 
				//(bindedAttributeBuffer[i]) || (gl.enableVertexAttribArray(i), bindedAttributeBuffer[i] = _vb);
				
			//WebGLContext.bindVertexArray(gl, null);
			//gl.disableVertexAttribArray(0);
			_vao.bind();
			//gl.bindVertexArray(_vao);
			
			_vb.bind();	//vao必须要再bind vb,否则下面的操作可能是在操作其他的mesh
			_ib._bind_upload() || _ib.bind();
			_vb._bind_upload() || _vb.bind();
		}
		
		//TODO:coverage
		public function getEleNum():int {
			return _ib.getBuffer().byteLength / 2;
		}
		
		/**
		 * 子类实现。用来把自己放到对应的回收池中，以便复用。
		 */
		public function releaseMesh():void {}
		
		/**
		 * 释放资源。
		 */
		public function destroy():void {
		}
		
		/**
		 * 清理vb数据
		 */
		public function clearVB():void {
			_vb.clear();
		}
	}
}