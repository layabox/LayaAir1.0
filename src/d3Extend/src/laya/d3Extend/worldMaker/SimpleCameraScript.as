package worldMaker {
	import laya.components.Component;
	import laya.d3.component.Script3D;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import worldMaker.ArcBall;
	import laya.events.Event;
	import laya.events.KeyBoardManager;
	import laya.events.Keyboard;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	/**
	 * TODO 自己测试用。只要效果，不顾效率
	 * 摄像机世界坐标的z轴的反向表示看的方向
	 */
	public class SimpleCameraScript extends Script3D {
		/** @private */
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		protected var isMouseDown:Boolean;
		protected var isRightDown:Boolean = false;
		protected var camera:Camera;
		protected var isWheel:int;
		protected var isMove:Boolean;
		
		
		public var saveCameraInfoHandler:Handler;
		public var updateWorldCentreDistance:Handler;
		public var worldCentreDistance:Number;
		
		public var target:Vector3 = new Vector3();	// 摄像机的目标
		//public var pos:Vector3 = new Vector3();		// 摄像机的位置
		public var dist:Number = 10;				// 到目标的距离
		public var camWorldMatrix:Matrix4x4 = new Matrix4x4(); // 计算出来的摄像机的世界矩阵
		public var outMatrix:Matrix4x4 = new Matrix4x4();		// 最终给摄像机的矩阵。主要是加了target的影响
		
		public var arcball:ArcBall = new ArcBall();
		private var isInitArcball:Boolean = false;
		private var quatArcBallResult:Quaternion = new Quaternion();
		private var startDragMatrix:Matrix4x4 = new Matrix4x4();	// 开始旋转的时候的矩阵
		
		private var movVel:Number = 0.5;				// 移动速度，用来计算vMovVel的
		private var vMovVel:Vector3 = new Vector3();	// 向量移动速度。实际使用的。
		private var ctrlDown:Boolean = false;
		private var changed:Boolean = false;
		
		public function SimpleCameraScript(posx:Number, posy:Number, posz:Number, targetx:Number, targety:Number, targetz:Number) {
			target.x = targetx;
			target.y = targety;
			target.z = targetz;
			var dx:Number = targetx - posx;
			var dy:Number = targety - posy;
			var dz:Number = targetz - posz;
			dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
			var mat1:Matrix4x4 = new Matrix4x4();
			Matrix4x4.createLookAt(new Vector3(posx,posy,posz), target, new Vector3(0, 1, 0), mat1);
			mat1.invert(camWorldMatrix);
		
		}
		
		override public function _onAdded():void {
			Laya.stage.on(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.on(Event.MOUSE_UP, this, mouseUp);
			Laya.stage.on(Event.RIGHT_MOUSE_DOWN, this, rightMouseDown);
			Laya.stage.on(Event.RIGHT_MOUSE_UP, this, rightMouseUp);
			Laya.stage.on(Event.MOUSE_MOVE, this, mouseMov);
			Laya.stage.on(Event.MOUSE_WHEEL, this, mouseWheel);
			camera = owner as Camera;
			camera.transform.worldMatrix = camWorldMatrix;
		}
		
		override protected function _onDestroy():void {
			super._onDestroy();
			Laya.stage.off(Event.MOUSE_DOWN, this, mouseDown);
			Laya.stage.off(Event.MOUSE_UP, this, mouseUp);
			Laya.stage.off(Event.RIGHT_MOUSE_DOWN, this, rightMouseDown);
			Laya.stage.off(Event.RIGHT_MOUSE_UP, this, rightMouseUp);
			Laya.stage.off(Event.MOUSE_WHEEL, this, mouseWheel);
		}
		
		override public function onUpdate():void {
			super.onUpdate();
			//移动的处理
			var mov:Boolean = false;
			var vel:Vector3=  vMovVel;
			vel.x = vel.y = vel.z = 0;
			var cammat:Float32Array = camWorldMatrix.elements;
			var v:Number = movVel;
			if(KeyBoardManager.hasKeyDown(Keyboard.A)){
				vel.x -= cammat[0] * v;
				vel.y -= cammat[1] * v;
				vel.z -= cammat[2] * v;
				mov = true;
			}
			if (KeyBoardManager.hasKeyDown(Keyboard.D)) {
				vel.x += cammat[0] * v;
				vel.y += cammat[1] * v;
				vel.z += cammat[2] * v;
				mov = true;
			}
			if (KeyBoardManager.hasKeyDown(Keyboard.S)) {
				vel.x += cammat[8] * v;
				vel.y += cammat[9] * v;
				vel.z += cammat[10] * v;
				mov = true;
			}
			if (KeyBoardManager.hasKeyDown(Keyboard.W)) {
				vel.x -= cammat[8] * v;
				vel.y -= cammat[9] * v;
				vel.z -= cammat[10] * v;
				mov = true;
			}
			
			if (mov) {
				// 平移相当于同时修改摄像机位置和target位置。摄像机与target的距离不变
				target.x += vel.x;
				target.y += vel.y;
				target.z += vel.z;
				
				// 加上target影响
				camera.transform.worldMatrix.cloneTo(outMatrix);
				outMatrix.elements[12] += vel.x;
				outMatrix.elements[13] += vel.y;
				outMatrix.elements[14] += vel.z;
				
				camera.transform.worldMatrix = outMatrix;
			}
			
			if (!isInitArcball && Laya.stage.width > 0) {
				arcball.init(Laya.stage.width, Laya.stage.height);
				isInitArcball = true;
			}
		}
		
		public function frontView():void {
			camWorldMatrix.identity();
			var mat:Float32Array = camWorldMatrix.elements;
			mat[12] = target.x;
			mat[13] = target.y;
			mat[14] = target.z + dist;
			camera.transform.worldMatrix = camWorldMatrix;
		}
		
		public function leftView():void {
			camWorldMatrix.identity();
			var mat:Float32Array = camWorldMatrix.elements;
			mat[0] = 0; mat[1] = 0; mat[2] = -1;	//x 轴转到了-z上
			// y不变
			mat[8] = 1; mat[9] = 0;  mat[10] = 0;	 	// z轴转到 x上
			mat[12] = target.x + dist;
			mat[13] = target.y;
			mat[14] = target.z ;
			camera.transform.worldMatrix = camWorldMatrix;
		}
		
		public function topView():void {
			camWorldMatrix.identity();
			var mat:Float32Array = camWorldMatrix.elements;
			mat[4] = 0; mat[5] = 0; mat[6] = -1;
			mat[8] = 0; mat[9] = 1, mat[10] =0;
			mat[12] = target.x;
			mat[13] = target.y + dist;
			mat[14] = target.z;
			camera.transform.worldMatrix = camWorldMatrix;
		}
		
		/**
		 * 看向这个目标，但是不改变距离
		 * @param	px
		 * @param	py
		 * @param	pz
		 * @param	size
		 */
		public function setTarget(px:Number, py:Number, pz:Number, size:Number):void {
			target.x = px;
			target.y = py;
			target.z = pz;
			// 更新摄像机位置
			if (!camera) return;
			camera.transform.worldMatrix.cloneTo(outMatrix);
			var camm:Float32Array = outMatrix.elements;
			camm[12] = target.x + camm[8] * dist;
			camm[13] = target.y + camm[9] * dist;
			camm[14] = target.z + camm[10] * dist;
			camera.transform.worldMatrix = outMatrix;
		}
		
		override public function onKeyDown(e:Event):void {
			var mat:Float32Array = camera.transform.worldMatrix.elements;
			switch (e.keyCode) {
			case Keyboard.NUMPAD_1:
				frontView();
				break;
			case Keyboard.NUMPAD_3:
				leftView();
				break;
			case Keyboard.NUMPAD_7:
				topView();
				break;
			case Keyboard.A: {
				target.x += 0.1;
			}	
				break;
			case Keyboard.S:
				break;
			case Keyboard.D: {
				target.x -= 0.1;
			}
				break;
			case Keyboard.W:
				break;
				
			case Keyboard.CONTROL:
				ctrlDown = true;
				break;				
			default:
				break;
			}
		}
		
		override public function onKeyUp(e:Event):void {
			switch (e.keyCode) {
				case Keyboard.CONTROL:
					ctrlDown = false;
				break;
			case Keyboard.A: {
			}	
				break;
			case Keyboard.S:
				break;
			case Keyboard.D: {
			}
				break;
			case Keyboard.W:
				break;
				default:
			}
		}
		
		protected function rightMouseDown(e:Event):void {
			Laya.stage.captureMouseEvent(true);
			lastMouseX = e.stageX;
			lastMouseY = e.stageY;
			isRightDown = true;
			camWorldMatrix.cloneTo(startDragMatrix);
			arcball.startDrag(e.stageX, e.stageY, camera.transform.worldMatrix);
		}
		
		protected function rightMouseUp(e:Event):void {
			isRightDown = false;
			Laya.stage.releaseMouseEvent();
		}
		
		protected function mouseMov(e:Event):void {
			if (isRightDown) {
				var dragQuat:Quaternion = arcball.dragTo(e.stageX, e.stageY);	// 相对值
				//DEBUG
				//arcball.startDrag(Laya.stage.width / 2, Laya.stage.height / 2);
				//dragQuat = arcball.dragTo(Laya.stage.width / 2+2, Laya.stage.height / 2);
				//DEBUG
				dragQuat.invert(quatArcBallResult);	// 取逆表示不转物体，转摄像机对象
				var dragMat:Matrix4x4 = new Matrix4x4();
				Matrix4x4.createFromQuaternion(quatArcBallResult, dragMat);
				var cammate:Float32Array = camWorldMatrix.elements;
				cammate[12] = cammate[13] = cammate[14] = 0;
				Matrix4x4.multiply(dragMat, startDragMatrix, camWorldMatrix);				
				updateCam(true);
			}
		}
		
		// 更新摄像机的世界矩阵
		public function updateCam(force:Boolean):void {
			if(changed || force){
				camWorldMatrix.cloneTo(outMatrix);
				var camm:Float32Array = outMatrix.elements;
				camm[12] = target.x + camm[8] * dist;
				camm[13] = target.y + camm[9] * dist;
				camm[14] = target.z + camm[10] * dist;
				camera.transform.worldMatrix = outMatrix;
				changed = false;
				//owner.event("scrollView");
			}
		}
				
		
		private function mouseDown(e:Event):void{
			isMouseDown = true;
		}
		
		private function mouseUp(e:Event):void {
			isMouseDown = false;
			isRightDown = false;
			arcball.stopDrag();
		}
		
		protected function mouseWheel(e:Event):void {
			//滚轮是改变距离的
			isWheel = e.delta;
			camera.transform.worldMatrix.cloneTo(outMatrix);			
			
			var wmat:Float32Array = outMatrix.elements;
			var px:Number = wmat[12];
			var py:Number = wmat[13];
			var pz:Number = wmat[14];
			var dx:Number = target.x - px;
			var dy:Number = target.y - py;
			var dz:Number = target.z - pz;
			var d:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
			var vel:Number = 0.1*d;
			if (e.delta > 0) {
				//前进
				wmat[12] -= wmat[8] * vel;
				wmat[13] -= wmat[9] * vel;
				wmat[14] -= wmat[10] * vel;
				dist -= vel;
			}else if (e.delta < 0) {
				//后退
				wmat[12] += wmat[8] * vel;
				wmat[13] += wmat[9] * vel;
				wmat[14] += wmat[10] * vel;
				dist += vel;
			}
			
			camera.transform.worldMatrix = outMatrix;
		}
		
		/**
		 * 向前移动。
		 * @param distance 移动距离。
		 */
		public function moveForward(distance:Number):void {
		}
	}
}