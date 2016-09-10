package laya.d3.resource.tempelet {
	import laya.d3.core.material.Material;
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
	import laya.particle.ParticleSettings;
	import laya.particle.ParticleTemplateWebGL;
	import laya.resource.Texture;
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
		
		protected var _shaderValue:ValusArray = new ValusArray();
		protected var _sharderNameID:int;
		protected var _shader:Shader;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get VertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer3D.indexCount / 3;
		}
		
		public function getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer3D;
			else
				return null;
		}
		
		public function getIndexBuffer():IndexBuffer3D {
			return _indexBuffer3D;
		}
		
		public function ParticleTemplet3D(owner:Particle3D, setting:ParticleSettings) {
			super(setting);
			_owner = owner;
			initialize();
			loadShaderParams();
			_vertexBuffer = _vertexBuffer3D = VertexBuffer3D.create(VertexParticle.vertexDeclaration, setting.maxPartices * 4, WebGLContext.DYNAMIC_DRAW);
			_indexBuffer = _indexBuffer3D = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, setting.maxPartices * 6, WebGLContext.STATIC_DRAW, true);
			loadContent();
		}
		
		protected function loadShaderParams():void {
			_sharderNameID = Shader.nameKey.get("PARTICLE");
			
			if (settings.textureName)//预设纹理ShaderValue
			{
				var material:Material = (_owner as Particle3D).particleRender.shadredMaterial;
				_shaderValue.pushValue(Buffer2D.DIFFUSETEXTURE, null, -1);
				var _this:ParticleTemplet3D = this;
				Laya.loader.load(settings.textureName, Handler.create(null, function(texture:Texture):void {
					(texture.bitmap as WebGLImage).enableMerageInAtlas = false;
					(texture.bitmap as WebGLImage).mipmap = true;
					(texture.bitmap as WebGLImage).repeat = true;
					material.diffuseTexture /*=_this.texture*/ = texture;//TODO:移除父类纹理。
				}));
			}
			
			_shaderValue.pushValue(Buffer2D.DURATION, settings.duration, -1);
			_shaderValue.pushValue(Buffer2D.GRAVITY, settings.gravity, -1);
			_shaderValue.pushValue(Buffer2D.ENDVELOCITY, settings.endVelocity, -1);
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
				// 如果新增加的粒子在Buffer中是连续的区域，只upload一次
				start = _firstNewElement * 4 * _floatCountPerVertex;
				_vertexBuffer3D.setData(_vertices, start, start, (_firstFreeElement - _firstNewElement) * 4 * _floatCountPerVertex);
				
			} else {
				//如果新增粒子区域超过Buffer末尾则循环到开头，需upload两次
				start = _firstNewElement * 4 * _floatCountPerVertex;
				_vertexBuffer3D.setData(_vertices, start, start, (settings.maxPartices - _firstNewElement) * 4 * _floatCountPerVertex);
				
				if (_firstFreeElement > 0) {
					_vertexBuffer3D.setData(_vertices, 0, 0, _firstFreeElement * 4 * _floatCountPerVertex);
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		public function _render(state:RenderState):Boolean {
			var material:Material = (state.owner as Particle3D).particleRender.shadredMaterial;
			var diffuseTexture:Texture = material.diffuseTexture;
			if (diffuseTexture && diffuseTexture.loaded) {
				//设备丢失时.............................................................
				//  todo  setData  here!
				//...................................................................................
				if (_firstNewElement != _firstFreeElement) {
					addNewParticlesToVertexBuffer();
				}
				
				if (_firstActiveElement != _firstFreeElement) {
					var gl:WebGLContext = WebGL.mainContext;
					//_vertexBuffer3D.bind(_indexBuffer3D);
					_vertexBuffer3D._bind();
					_indexBuffer._bind();
					
					_shader = getShader(state);
					
					var presz:int = _shaderValue.length;
					
					_shaderValue.pushArray(state.shaderValue);
					_shaderValue.pushArray(_vertexBuffer3D.vertexDeclaration.shaderValues);
					
					_shaderValue.pushValue(Buffer2D.MVPMATRIX, state.owner.transform.worldMatrix.elements, -1);
					_shaderValue.pushValue(Buffer2D.MATRIX1, state.viewMatrix.elements, -1);
					_shaderValue.pushValue(Buffer2D.MATRIX2, state.projectionMatrix.elements, -1);
					
					//设置视口尺寸，被用于转换粒子尺寸到屏幕空间的尺寸
					var aspectRadio:Number = state.viewport.width / state.viewport.height;
					var viewportScale:Vector2 = new Vector2(0.5 / aspectRadio, -0.5);
					_shaderValue.pushValue(Buffer2D.VIEWPORTSCALE, viewportScale.elements, -1);
					
					//设置粒子的时间参数，可通过此参数停止粒子动画
					_shaderValue.pushValue(Buffer2D.CURRENTTIME, _currentTime, -1);
					
					_shaderValue.data[1][0] = diffuseTexture.source;//可能为空
					_shaderValue.data[1][1] = diffuseTexture.bitmap.id;
					
					_shader.uploadArray(_shaderValue.data, _shaderValue.length, null);
					
					_shaderValue.length = presz;
					
					var drawVertexCount:int;
					if (_firstActiveElement < _firstFreeElement) {
						drawVertexCount = (_firstFreeElement - _firstActiveElement) * 6;
						WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);//2为ushort字节数
						Stat.trianglesFaces += drawVertexCount / 3;
						Stat.drawCall++;
					} else {
						drawVertexCount = (settings.maxPartices - _firstActiveElement) * 6;
						WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);//2为ushort字节数
						Stat.trianglesFaces += drawVertexCount / 3;
						Stat.drawCall++;
						if (_firstFreeElement > 0) {
							drawVertexCount = _firstFreeElement * 6;
							WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, 0);
							Stat.trianglesFaces += drawVertexCount / 3;
							Stat.drawCall++;
						}
					}
					
				}
				_drawCounter++;
				return true;
			}
			return false;
		}
		
		protected function getShader(state:RenderState):Shader {
			var shaderDefs:ShaderDefines3D = state.shaderDefs;
			var preDef:int = shaderDefs._value;
			//_disableDefine && (shaderDefs._value = preDef & (~_disableDefine));
			shaderDefs.addInt(ShaderDefines3D.PARTICLE3D);
			var nameID:Number = (shaderDefs._value | state.shadingMode) + _sharderNameID * Shader.SHADERNAME2ID;
			_shader = Shader.withCompile(_sharderNameID, state.shadingMode, shaderDefs.toNameDic(), nameID, null);
			shaderDefs._value = preDef;
			return _shader;
		}
	}
}