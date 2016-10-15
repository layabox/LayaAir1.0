package laya.d3.resource.tempelet {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexParticle;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines3D;
	import laya.particle.ParticleSetting;
	import laya.particle.ParticleTemplateWebGL;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * @private
	 * <code>ParticleTemplet3D</code> 类用于创建3D粒子数据模板。
	 */
	public class ParticleTemplet3D extends ParticleTemplateWebGL implements IRenderable {
		private var _owner:Particle3D;
		private var _vertexBuffer3D:VertexBuffer3D;
		private var _indexBuffer3D:IndexBuffer3D;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer3D.indexCount / 3;
		}
		
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer3D;
			else
				return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer3D;
		}
		
		public function ParticleTemplet3D(owner:Particle3D, setting:ParticleSetting) {
			super(setting);
			_owner = owner;
			initialize();
			_vertexBuffer = _vertexBuffer3D = VertexBuffer3D.create(VertexParticle.vertexDeclaration, setting.maxPartices * 4, WebGLContext.DYNAMIC_DRAW);
			_indexBuffer = _indexBuffer3D = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, setting.maxPartices * 6, WebGLContext.STATIC_DRAW, true);
			loadContent();
		}
		
		public function addParticle(position:Vector3, velocity:Vector3):void {
			addParticleArray(position.elements, velocity.elements);
		}
		
		override protected function loadContent():void {
			var indexes:Uint16Array = new Uint16Array(settings.maxPartices * 6);
			
			for (var i:int = 0; i < settings.maxPartices; i++) {
				indexes[i * 6 + 0] = (i * 4 + 0);
				indexes[i * 6 + 1] = (i * 4 + 1);
				indexes[i * 6 + 2] = (i * 4 + 2);
				
				indexes[i * 6 + 3] = (i * 4 + 0);
				indexes[i * 6 + 4] = (i * 4 + 2);
				indexes[i * 6 + 5] = (i * 4 + 3);
			}
			_indexBuffer3D.setData(indexes);
		}
		
		override public function addNewParticlesToVertexBuffer():void {
			var start:int;
			if (_firstNewElement < _firstFreeElement) {
				start = _firstNewElement * 4 * _floatCountPerVertex;
				_vertexBuffer3D.setData(_vertices, start, start, (_firstFreeElement - _firstNewElement) * 4 * _floatCountPerVertex);
				
			} else {
				start = _firstNewElement * 4 * _floatCountPerVertex;
				_vertexBuffer3D.setData(_vertices, start, start, (settings.maxPartices - _firstNewElement) * 4 * _floatCountPerVertex);
				
				if (_firstFreeElement > 0) {
					_vertexBuffer3D.setData(_vertices, 0, 0, _firstFreeElement * 4 * _floatCountPerVertex);
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			//设备丢失时,貌似WebGL不会丢失
			//  todo  setData  here!
			if (_firstNewElement != _firstFreeElement) {
				addNewParticlesToVertexBuffer();
			}
			
			_drawCounter++;
			if (_firstActiveElement != _firstFreeElement) {
				_vertexBuffer3D._bind();
				_indexBuffer._bind();
				return true;
			}
			return false;
		}
		
		public function _render(state:RenderState):void {
			var drawVertexCount:int;
			var glContext:WebGLContext = WebGL.mainContext;
			if (_firstActiveElement < _firstFreeElement) {
				drawVertexCount = (_firstFreeElement - _firstActiveElement) * 6;
				glContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);//2为ushort字节数
				Stat.trianglesFaces += drawVertexCount / 3;
				Stat.drawCall++;
			} else {
				drawVertexCount = (settings.maxPartices - _firstActiveElement) * 6;
				glContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);//2为ushort字节数
				Stat.trianglesFaces += drawVertexCount / 3;
				Stat.drawCall++;
				if (_firstFreeElement > 0) {
					drawVertexCount = _firstFreeElement * 6;
					glContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, 0);
					Stat.trianglesFaces += drawVertexCount / 3;
					Stat.drawCall++;
				}
			}
		}
	}
}