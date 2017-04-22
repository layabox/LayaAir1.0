package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.RenderTexture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.RenderSprite3D;
	
	/**
	 * <code>Scene</code> 类用于实现普通场景。
	 */
	public class Scene extends BaseScene {
		/**@private */
		private var _tempBoundBoxCorners:Vector.<Vector3> = new Vector.<Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/**
		 * 创建一个 <code>Scene</code> 实例。
		 */
		public function Scene() {
			super();
		}
		
		///**
		 //* @private
		 //*/
		//private function _renderRenderableBoundBox(linePhasor:PhasorSpriter3D, sprite:*):void {
			//if (sprite is RenderableSprite3D) {
				//var renderableSprite:RenderableSprite3D = sprite as RenderableSprite3D;
				//var boundBox:BoundBox = renderableSprite._render.boundingBox;
				//var corners:Vector.<Vector3> = _tempBoundBoxCorners;
				//boundBox.getCorners(corners);
				//linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 0.0, 1.0, 0.0, 1.0, corners[1].x, corners[1].y, corners[1].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 0.0, 1.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 0.0, 1.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[6].x, corners[6].y, corners[6].z, 0.0, 1.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 0.0, 1.0, 0.0, 1.0);
				//
				//linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 0.0, 1.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 0.0, 1.0, 0.0, 1.0, corners[2].x, corners[2].y, corners[2].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 0.0, 1.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[3].x, corners[3].y, corners[3].z, 0.0, 1.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 0.0, 1.0, 0.0, 1.0);
				//
				//linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 0.0, 1.0, 0.0, 1.0, corners[4].x, corners[4].y, corners[4].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 0.0, 1.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 0.0, 1.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 0.0, 1.0, 0.0, 1.0);
				//linePhasor.line(corners[5].x, corners[5].y, corners[5].z, 0.0, 1.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 0.0, 1.0, 0.0, 1.0);
			//}
			//for (var i:int = 0, n:int = sprite._childs.length; i < n; i++)
				//_renderRenderableBoundBox(linePhasor, sprite._childs[i]);
		//}
		
		protected override function _renderCamera(gl:WebGLContext, state:RenderState, baseCamera:BaseCamera):void {
			var camera:Camera = baseCamera as Camera;
			(parallelSplitShadowMaps[0]) && (_renderShadowMap(gl, state, camera));//TODO:SM
		    state.camera = camera;
			camera._prepareCameraToRender();
			beforeRender(state);//渲染之前
			
			var viewMatrix:Matrix4x4 = camera.viewMatrix;
			var projectMatrix:Matrix4x4;
			state._viewMatrix = viewMatrix;
			var renderTarget:RenderTexture = camera.renderTarget;
			if (renderTarget) {
				renderTarget.start();
				Matrix4x4.multiply(_invertYScaleMatrix, camera.projectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, camera.projectionViewMatrix, _invertYProjectionViewMatrix);
				projectMatrix=state._projectionMatrix = _invertYProjectionMatrix;//TODO:
				state._projectionViewMatrix = _invertYProjectionViewMatrix;//TODO:
			} else {
				projectMatrix=state._projectionMatrix = camera.projectionMatrix;//TODO:
				state._projectionViewMatrix = camera.projectionViewMatrix;//TODO:
			}
			
			camera._prepareCameraViewProject(viewMatrix, projectMatrix);
			state._boundFrustum = camera.boundFrustum;
			state._viewport = camera.viewport;
			_preRenderScene(gl, state);
			_clear(gl, state);
			_renderScene(gl, state);
			//_renderDebug(gl, state);
			lateRender(state);//渲染之后
			
			//if (Laya3D.debugMode||OctreeNode.debugMode&&treeRoot) {
				//var linePhasor:PhasorSpriter3D = Laya3D._debugPhasorSprite;
				//linePhasor.begin(WebGLContext.LINES, state);
				//_renderRenderableBoundBox(linePhasor, this);
				//treeRoot.renderBoudingBox(linePhasor);
				//linePhasor.end();
			//}
			(renderTarget) && (renderTarget.end());
		
		}
	}
}