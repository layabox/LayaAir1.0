package laya.d3Extend.D3UI
{
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.material.RenderState;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Plane;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.layagl.LayaGL;
	import laya.maths.Point;
	import laya.ui.View;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.utils.RenderState2D;
	import ui.TestView;
	
	/**
	 * 缺省位置是000位置，正面朝向z正方向
	 */
	
	public class UISprite3D extends RenderableSprite3D
	{
		public var ctx:WebGLContext2D = new WebGLContext2D();
		public var rootView:View = new View();
		private var camera:Camera;
		public var isEnableIniput:Boolean = false;
		private var uiPlane:Plane;
		private var tmpPoint:Point = new Point();
		public var _bsphere:BoundSphere = new BoundSphere(new Vector3(0, 0, 0), 1);
		private var _mesh:UISprite3DFilter;
		private var _ctx2D:WebGLContext2D;
		public var _matWVP:Matrix4x4;
		private var _width:int = 0;
		private var _height:int = 0;
		private var _matInvW:Matrix4x4 = new Matrix4x4();
        private var _mousePoint:Vector2 = new Vector2();			// 鼠标点
		private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, -1));		// 鼠标射线
		// 临时变量
		private static var _transedRayO:Vector3 = new Vector3();
		private static var _transedRayDir:Vector3 = new Vector3();

		//TEST
		private var _testUI:Sprite;
		
		public function UISprite3D(cam:Camera):void{
			super("uisprite");
			camera = cam;
			_render = new UISprite3DRenderer(this);
			
			_mesh = new UISprite3DFilter(this);
			
			var renderElement:RenderElement = new RenderElement();
			_render._renderElements.push(renderElement);
			_render._defineDatas.add(MeshSprite3D.SHADERDEFINE_COLOR);
			
			renderElement.setTransform(_transform);
			renderElement.render = _render;
			
			var mat:BlinnPhongMaterial = _render.sharedMaterial as BlinnPhongMaterial;
			mat || (mat = new BlinnPhongMaterial());
			mat.albedoColor = new Vector4(1.0, 0.0, 0.0, 1.0);
			mat.renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
			//mat.getRenderState(0).blend = RenderState.BLEND_ENABLE_ALL;
			renderElement.material = mat;
			
			renderElement.setGeometry(_mesh);
			set2DSize(800, 600);
			
			_testUI = new Sprite();
			_testUI.size(1000, 1000);
			_testUI.graphics.drawRect(0, 0, 100, 100, 'blue');
			_testUI.on(Event.MOUSE_DOWN, this, function(e){
				debugger;
			});
			
			var v:View = new TestView();
			
			rootView.fromParentPoint = fromParentPoint.bind(this);
			rootView.addChild(v);
			//rootView.addChild(_testUI);
			Laya.stage.addInputChild(rootView);
		}
		
		public function handleEventStart():void {
			
		}
		
		public function handleEventEnd():void {
			
		}
		public function set2DSize(width:int, height:int):void {
			_width = width;
			_height = height;
			rootView.size(width, height);
			_ctx2D = new WebGLContext2D();
			_ctx2D.size(width, height);
		}
		
		/**
		 * 加载一个view，设置逻辑宽高
		 * @param	view
		 * @param	width
		 * @param	height
		 */
		public function loadView(viewClass:Function, width:int, height:int):void
		{
			var ui:View = new viewClass();
			// 用addchild 到 rootview么
		
		}
		
		
		/**
		 * 将父容器坐标系坐标转换到本地坐标系。
		 * @param point 父容器坐标点。
		 * @return  转换后的点。
		 */
		public function fromParentPoint(point:Point):Point {
			transform.worldMatrix.invert(_matInvW);
			
            _mousePoint.elements[0] = MouseManager.instance.mouseX;
            _mousePoint.elements[1] = MouseManager.instance.mouseY;
            camera.viewportPointToRay(_mousePoint, ray);	
			
			// 计算交点，作为新的坐标
			Vector3.transformV3ToV3(ray.origin, _matInvW, _transedRayO);
			// 如果起点在z的负方向，则不算
			if ( _transedRayO.z < 0) {
				point.x =-10000;
				point.y =-10000;
				return point;
			}
			
			Vector3.TransformNormal(ray.direction, _matInvW, _transedRayDir);
			// 如果朝向离开z也不算
			if ( _transedRayDir.z >= -1e-6) {
				point.x =-10000;
				point.y =-10000;
				return point;
			}
			
			var hitt:Number = -_transedRayO.z / _transedRayDir.z;	// z>0，方向<0,所以要取负
			var hitx:Number = _transedRayO.x + _transedRayDir.x * hitt;
			var hity:Number = _transedRayO.y + _transedRayDir.y * hitt;
			point.x = (hitx + 1) / 2 * _width;
			point.y = ( -hity + 1) / 2 * _height;
			return point;
		}
		
		// 设置旋转缩放平移以及父对象
		
		public function updateUIPlane():void
		{
		
		}
		
		public function enableInput(b:Boolean):void{
			isEnableIniput = b;
			if (b){
				// 监听鼠标事件
				//
			}
			else
			{
				
			}
		}
		
		public function renderUI():void {
			//update
			//render
			var oldw:int = RenderState2D.width;
			var oldh:int = RenderState2D.height;
			RenderState2D.width = _width;
			RenderState2D.height = _height;
			var gl:WebGLContext = LayaGL.instance;
			//gl.disable(WebGLContext.DEPTH_TEST);
			var enablezw:Boolean = gl.getParameter(gl.DEPTH_WRITEMASK);
			gl.disable(WebGLContext.CULL_FACE);
			gl.enable(WebGLContext.BLEND);
			gl.depthMask(false); // 不写入z
			_ctx2D.clear();
			rootView.render(_ctx2D, 0, 0);
			var lastWVP:Matrix4x4 = RenderState2D.matWVP;
			RenderState2D.matWVP = _matWVP;
			//RenderState2D.width = 
			_ctx2D.flush();
			RenderState2D.matWVP = lastWVP;
			gl.enable(WebGLContext.DEPTH_TEST);
			gl.enable(WebGLContext.CULL_FACE);
			gl.depthMask(enablezw);
			RenderState2D.width = oldw;
			RenderState2D.height = oldh;
		}
	}
}