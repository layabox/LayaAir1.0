package laya.d3.water 
{
	import laya.d3.core.MeshFilter;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.WaterMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Vector3;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.PrimitiveMesh;
	import laya.d3.resource.models.QuadMesh;
	import laya.d3.shader.Shader3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WaterSprite extends MeshSprite3D {
		public var mtl:WaterMaterial;
		public var detailMtl:WaterDetailMaterial;
		public var mesh:Mesh;
		private var _stop:Boolean = false;
		private var _texWave:RenderTexture;
		private var _texRefract:RenderTexture;
		private var _detailMesh:PrimitiveMesh;
		private static var _waveInfoEleNum:int = 4;
		private var _geoWaveInfo:Float32Array = new Float32Array(_waveInfoEleNum * 4);//顶点固定只是4个波形组成
		private var _geoWaveInfoDir:Float32Array = new Float32Array(2 * 4);	
		private var _texWaveInfo:Float32Array = new Float32Array(_waveInfoEleNum * 15);//纹理波多一些。 TODO 修改
		private var _texWaveInfoDir:Float32Array = new Float32Array(2 * 15);
		public static var detailTexWidth:int = 256;
		public static var detailTexHeight:int = 256;
		private static var deg2rad:Number = Math.PI / 180;
		private static var _2pi:Number = 2 * Math.PI;
		private var _texWaveTrans:Float32Array = new Float32Array(9);	//贴图纹理的旋转矩阵
		private var _texWaveDegTest:Number = 0;
		private var _shownormal:Boolean = false;
		private var _refractQueue:RenderQueue ;
		private var _refractObjStack:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>() ;//因为开始的时候可能还没有加载完成，不知道renderelements
		private var _refractObjecs:Vector.<MeshSprite3D> = new Vector.<MeshSprite3D>();
		private var _loaded:Boolean = false;
		public var _scene:Scene;
		private var _scrSizeInfo:Float32Array = new Float32Array(2);
		private var _waterColor:Vector3 = new Vector3();
		private var _waterFogStart:Number = 0;
		private var _waterFogRange:Number = 20;
		
		public function WaterSprite(mesh:BaseMesh=null, name:String = null) {
			super(mesh, name);
			mtl = new WaterMaterial();
		}
		
		private function _getWaveInfo(out:Float32Array, outdir:Float32Array, i:int, deg:Number, L:Number, Q:Number, A:Number):void {
			var st:int = i * _waveInfoEleNum;
			var dirst:int = i * 2;
			var r:Number = deg * deg2rad;
			outdir[dirst++] = Math.cos(r);
			outdir[dirst++] = Math.sin(r);
			out[st++] = Q;
			out[st++] = A;
			out[st++] = _2pi / L;
			out[st++] = 7.846987702957 / Math.sqrt(L);
		}
		
		public function set src(v:String):void {
			var ld:Loader = new Loader();
			ld.on(Event.COMPLETE, this, onDescLoaded);
			ld.load(v);
		}
		
		private function onDescLoaded(desc:Object):void {
			var mesh:Mesh = Mesh.load(desc.mesh);
		
			_texWave = new RenderTexture(desc.detailTexSize[0], desc.detailTexSize[1],WebGLContext.RGBA,WebGLContext.UNSIGNED_BYTE,WebGLContext.DEPTH_COMPONENT16,false,false);
			//_texWave.repeat = false;
			//_texWave.mipmap = true;
			_texRefract = new RenderTexture(desc.refracTexSize[0], desc.refracTexSize[1]);
			_texRefract.repeat = false;
			_texRefract.mipmap = true;
			
			(_geometryFilter as MeshFilter).sharedMesh = mesh;
			mesh.once(Event.LOADED, this, _applyMeshMaterials);
			mesh.on(Event.LOADED, this, onMeshLoaded);
			
			if (desc.skyTexture.substr(desc.skyTexture.length-4).toLowerCase()==='.ltc') {
				mtl.skyTexture = TextureCube.load(desc.skyTexture);
				mtl._addShaderDefine(WaterMaterial.SHADERDEFINE_CUBE_ENV);
			}else {
				mtl.skyTexture = Texture2D.load(desc.skyTexture);	
				mtl._removeShaderDefine(WaterMaterial.SHADERDEFINE_CUBE_ENV);
			}
			if (desc.hdrsky) {
				mtl._addShaderDefine(WaterMaterial.SHADERDEFINE_HDR_ENV);
			}
			mtl.skyTexture.repeat = true;
			//mtl.detailTexture = Texture2D.load('./threeDimen/water/seanormal.jpg');
			//mtl.detailTexture = Texture2D.load('./threeDimen/water/normal1.png');
			//mtl.deepColorTexture = Texture2D.load('./threeDimen/water/deepcolor.png');
			var infotex:Texture2D = Texture2D.load(desc.infoTexture);
			infotex.repeat = false;
			mtl.waterInfoTexture = infotex;
			var foamTex:Texture2D = Texture2D.load(desc.foamTexture);// './threeDimen/water/foam1.png');
			foamTex.repeat = true;
			mtl.foamTexture = foamTex;
			
			mtl.renderMode = WaterMaterial.RENDERMODE_TRANSPARENT;
			mtl.waveMainDir = desc.geoWaveData[0].dir;//TODO 
			mtl.geoWaveUVScale = desc.geoWaveUVScale;
			
			_detailMesh = new QuadMesh(2, 2);
			detailMtl = new WaterDetailMaterial();
			detailMtl.texWaveUVScale = desc.detailWaveUVScale;
			
			if (desc.geoWaveData.length != 4) throw "error 3";
			if (desc.detailData.length != 4) throw "error 4";
			
			(desc.geoWaveData as Array).forEach( function(v:*,i:int):void { 
				_getWaveInfo(_geoWaveInfo, _geoWaveInfoDir, i, v.dir, v.L, v.Q, v.A);
			} );
			
			var kAmp_over_L:Number = 0.01;//固定的振幅和波长的比
			(desc.detailData as Array).forEach(function (v:*,i:int):void 
			{
				_getWaveInfo(_texWaveInfo, _texWaveInfoDir, i, v.dir, v.L, 1.5, v.L * kAmp_over_L);
			});
			
			_waterColor.x = desc.color[0]; _waterColor.y = desc.color[1]; _waterColor.z = desc.color[2];
			mtl.seaColor = new Float32Array(desc.color);
			_waterFogStart = desc.fogStart;
			_waterFogRange = desc.fogRange;
		}
		
		public function  onMeshLoaded():void {
			_refractQueue = new RenderQueue(_scene);
			//meshSprite = new MeshSprite3D( Mesh.load('./threeDimen/models/river/river-Plane001.lm')) ;
			//meshSprite = new MeshSprite3D( Mesh.load('./threeDimen/models/plane/plane100-Plane001.lm')) ;
			//this.addChild(meshSprite);
			//mtl.vertexDispTexture = Texture2D.load('./threeDimen/water/OceanShape.jpg');
			//mtl.underWaterTexture = Texture2D.load("./threeDimen/water/sand.jpg");
			_scrSizeInfo[0] = Laya.stage.width;//TODO 以后改成事件通知
			_scrSizeInfo[1] = Laya.stage.height;
			mtl.scrsize = _scrSizeInfo;
			meshRender.sharedMaterial = mtl;
			
			//addChild(_detailMeshSprite);
			
			if (_render._renderElements.length > 0) {
				_render._renderElements[0]._onPreRenderFunction = onPreRender;
			}else {
				throw "error2";
			}
			_loaded = true;
		}
		
		public function stop():void{
			_stop = !_stop;
		}
		
		public function addRefractObj(obj:RenderableSprite3D):void {
			_refractObjStack.push(obj);	
			_refractObjecs.push(obj);
		}
		
		/**
		 * 渲染之前，生成必要的数据。
		 * @param	state
		 */
		public function onPreRender(state:RenderState):void {
			if (!_loaded)
				return;
			if (_refractObjStack.length) {
				for (var i:int = 0; i < _refractObjStack.length; i++) {
					var obj:RenderableSprite3D = _refractObjStack[i];
					if (obj._render._renderElements.length) {
						obj._render._renderElements.forEach(function(v:RenderElement):void { _refractQueue._addRenderElement(v); } );
						_refractObjStack.splice(i, 1);
						i--;
					}
				}
			}
			var gl:WebGLContext = WebGL.mainContext;
			var olddf:Boolean = gl.getParameter(WebGLContext.DEPTH_TEST) as Boolean;
			var oldcf:Boolean = gl.getParameter(WebGLContext.CULL_FACE) as Boolean;
			var oldvp:Float32Array = gl.getParameter(WebGLContext.VIEWPORT) as Float32Array;
			
			//渲染折射对象
			_texRefract.start();
			gl.viewport(0, 0, _texRefract.width, _texRefract.height);
			gl.clearColor( _waterColor.x,_waterColor.y,_waterColor.z,1.);
			gl.clear(WebGLContext.DEPTH_BUFFER_BIT | WebGLContext.COLOR_BUFFER_BIT);
			_refractObjecs.forEach(function(v:MeshSprite3D):void { 
				v._renderUpdate(state._projectionViewMatrix);//给mvp的shaderValue赋值
			} );
			_refractQueue._preRender(state);
			
			var old_fog:Boolean = scene.enableDepthFog;
			var old_fogcol:Vector3 = scene.fogColor;
			var old_fogstart:Number = scene.fogStart;
			var old_fogrange:Number = scene.fogRange;
			scene.enableDepthFog = true;
			scene.fogColor = _waterColor;
			scene.fogStart = _waterFogStart;
			scene.fogRange = _waterFogRange;
			_refractQueue._render(state, false);//TODO false? true?
			_texRefract.end();
			_texRefract.repeat = true;
			scene.enableDepthFog = old_fog;
			scene.fogColor = old_fogcol;
			scene.fogStart = old_fogstart;
			scene.fogRange = old_fogrange;
			
			//TODO 下面的状态恢复是不是有问题
			//https://developer.mozilla.org/en-US/docs/Web/API/WebGLRenderingContext/getParameter
			_texWave.start();
			gl.disable(WebGLContext.DEPTH_TEST);
			gl.disable(WebGLContext.CULL_FACE);
			gl.viewport(0, 0, detailTexWidth, detailTexHeight);
			var re:IRenderable = _detailMesh.getRenderElement(0);	//(_detailMesh._geometryFilter as MeshFilter).sharedMesh
			re._beforeRender(state);//
			detailMtl.currentTm = Laya.timer.currTimer;
			detailMtl.waveInfo = _texWaveInfo;
			detailMtl.waveInfoD = _texWaveInfoDir;
			var detailShader:Shader3D = detailMtl._getShader(0, 0, 0);
			detailShader.bind();
			var vb:VertexBuffer3D = _detailMesh._getVertexBuffer(0);
			detailShader.uploadAttributes(vb.vertexDeclaration.shaderValues.data,null);//TODO 只做一次
			detailMtl._upload();
			re._render(state);
			_texWave.end();
			
			olddf && gl.enable(WebGLContext.DEPTH_TEST);
			oldcf && gl.enable(WebGLContext.CULL_FACE);
			gl.viewport(oldvp[0], oldvp[1], oldvp[2], oldvp[3]);
			
			mtl.detailTexture = _texWave;//TODO 优化一下
			mtl.waveInfo = _geoWaveInfo;
			mtl.waveInfoD = _geoWaveInfoDir;
			mtl.underWaterTexture = _texRefract;
			
			if(!_stop){
				mtl.currentTm = Laya.timer.currTimer;
			}else {
				_texWaveDegTest += 0.02;	
				mtl.waveMainDir = _texWaveDegTest;
				//mtl.texWaveTrans = getTexTrans(_texWaveDegTest, _texWaveTrans);
			}
			
			if (__JS__('window.shownormal') && !_shownormal) {
				_shownormal = true;
				mtl._addShaderDefine(WaterMaterial.SHADERDEFINE_SHOW_NORMAL);
			}
			if( __JS__('window.shownormal') && _shownormal){
				_shownormal = false;
				mtl._removeShaderDefine(WaterMaterial.SHADERDEFINE_SHOW_NORMAL);
			}
		}
		
		override public function _update(state:RenderState):void {
			super._update(state);
		}
	}
}