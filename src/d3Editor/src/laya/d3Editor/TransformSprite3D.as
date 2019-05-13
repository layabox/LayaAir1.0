package laya.d3Editor {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.RenderState;
	import laya.d3.core.pixelLine.PixelLineMaterial;
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.math.Color;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.PrimitiveMesh;
	import laya.d3Editor.material.DepthCullLineMaterial;
	import laya.d3Editor.material.GizmoMaterial;
	
	/**
	 * ...
	 * @author
	 */
	public class TransformSprite3D extends Sprite3D {
		
		public var positionSprite3D:Sprite3D;
		public var positionX:Sprite3D;
		public var positionY:Sprite3D;
		public var positionZ:Sprite3D;
		
		public var rotationSprite3D:Sprite3D;
		public var rotationX:PixelLineSprite3D;
		public var rotationY:PixelLineSprite3D;
		public var rotationZ:PixelLineSprite3D;
		public var rotationS:PixelLineSprite3D;
		public var rotationL:PixelLineSprite3D;
		
		public var scaleSprite3D:Sprite3D;
		public var scalingX:Sprite3D;
		public var scalingY:Sprite3D;
		public var scalingZ:Sprite3D;
		
		public var color:* = new Color(1, 1, 1, 1);
		public var colorX:Vector4 = new Vector4(1, 0, 0, 0);
		public var colorY:Vector4 = new Vector4(0, 1, 0, 0);
		public var colorZ:Vector4 = new Vector4(0, 0, 1, 0);
		public var selectColor:Vector4 = new Vector4(1, 0.92, 0.016, 0);
		public var selectSprite3D:Sprite3D;
		
		public var curCamera:Camera;
		private var _mat:Matrix4x4 = new Matrix4x4();
		private var _position:Vector3 = new Vector3();
		private var _rotation:Quaternion = new Quaternion();
		private var _scale:Vector3 = new Vector3();
		private var _right:Vector3 = new Vector3();
		private var _up:Vector3 = new Vector3();
		private var _forward:Vector3 = new Vector3();
		
		public function TransformSprite3D() {
			
			name = "Transform3D";
			active = false;
			GizmoMaterial.initShader();
			DepthCullLineMaterial.initShader();
			initPositionSprite3D();
			initRotationSprite3D();
			initScaleSprite3D();
			positionSprite3D.active = true;
			rotationSprite3D.active = false;
			scaleSprite3D.active = false;
			
			Laya.timer.loop(1, this, function():void {
				
				if (curCamera && active && rotationSprite3D.active) {
					var cameraTransform:Transform3D = curCamera.transform;
					var cameraRight:Vector3 = cameraTransform.getRight(_right);
					var cameraUp:Vector3 = cameraTransform.getUp(_up);
					var cameraForward:Vector3 = cameraTransform.getForward(_forward);
					var mate:Float32Array = _mat.elements;
					mate[0] = cameraRight.x;
					mate[1] = cameraRight.y;
					mate[2] = cameraRight.z;
					mate[4] = cameraUp.x;
					mate[5] = cameraUp.y;
					mate[6] = cameraUp.z;
					mate[8] = cameraForward.x;
					mate[9] = cameraForward.y;
					mate[10] = cameraForward.z;
					_mat.decomposeTransRotScale(_position, _rotation, _scale);
					rotationS.transform.rotation = rotationL.transform.rotation = _rotation;
				}
			});
		}
		
		public function initPositionSprite3D():void {
			
			positionSprite3D = addChild(new Sprite3D()) as Sprite3D;
			initPositionXSprite3D();
			initPositionYSprite3D();
			initPositionZSprite3D();
		}
		
		public function initRotationSprite3D():void {
			
			rotationSprite3D = addChild(new Sprite3D()) as Sprite3D;
			initRotationSSprite3D();
			initRotationLSprite3D();
			initRotationXSprite3D();
			initRotationYSprite3D();
			initRotationZSprite3D();
		}
		
		public function initScaleSprite3D():void {
			
			scaleSprite3D = addChild(new Sprite3D()) as Sprite3D;
			initScaleXSprite3D();
			initScaleYSprite3D();
			initScaleZSprite3D();
		}
		
		public function initPositionXSprite3D():void {
			positionX = positionSprite3D.addChild(new Sprite3D()) as Sprite3D;
			
			var line:PixelLineSprite3D = positionX.addChild(new PixelLineSprite3D(2)) as PixelLineSprite3D;
			line.addLine(new Vector3(0, 0, 0), new Vector3(0, 0.5, 0), color, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.color = colorX;
			lm.renderQueue = 4999;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			line.pixelLineRenderer.sharedMaterial = lm;
			line.name = 'PositionX';
			//line.transformType = 1;
			
			var cone:MeshSprite3D = positionX.addChild(new MeshSprite3D(PrimitiveMesh.createCone(0.04, 0.125))) as MeshSprite3D;
			cone.transform.localPosition = new Vector3(0, 0.5, 0);
			var mat:GizmoMaterial = new GizmoMaterial();
			mat.color = colorX;
			mat.renderQueue = 5000;
			mat.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			cone.meshRenderer.sharedMaterial = mat;
			cone.name = 'PositionX';
			//cone.transformType = 1;
			
			positionX.transform.rotate(new Vector3(0, 0, -90), true, false);
		}
		
		public function initPositionYSprite3D():void {
			
			positionY = positionSprite3D.addChild(new Sprite3D()) as Sprite3D;
			
			var line:PixelLineSprite3D = positionY.addChild(new PixelLineSprite3D(2)) as PixelLineSprite3D;
			line.addLine(new Vector3(0, 0, 0), new Vector3(0, 0.5, 0), color, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.color = colorY;
			lm.renderQueue = 4999;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			line.pixelLineRenderer.sharedMaterial = lm;
			line.name = 'PositionY';
			//line.transformType = 2;
			
			var cone:MeshSprite3D = positionY.addChild(new MeshSprite3D(PrimitiveMesh.createCone(0.04, 0.125))) as MeshSprite3D;
			cone.transform.localPosition = new Vector3(0, 0.5, 0);
			var mat:GizmoMaterial = new GizmoMaterial();
			mat.color = colorY;
			mat.renderQueue = 5000;
			mat.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			cone.meshRenderer.sharedMaterial = mat;
			cone.name = 'PositionY';
			//cone.transformType = 2;
		}
		
		public function initPositionZSprite3D():void {
			
			positionZ = positionSprite3D.addChild(new Sprite3D()) as Sprite3D;
			
			var line:PixelLineSprite3D = positionZ.addChild(new PixelLineSprite3D(2)) as PixelLineSprite3D;
			line.addLine(new Vector3(0, 0, 0), new Vector3(0, 0.5, 0), color, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.color = colorZ;
			lm.renderQueue = 4999;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			line.pixelLineRenderer.sharedMaterial = lm;
			line.name = 'PositionZ';
			//line.transformType = 3;
			
			var cone:MeshSprite3D = positionZ.addChild(new MeshSprite3D(PrimitiveMesh.createCone(0.04, 0.125))) as MeshSprite3D;
			cone.transform.localPosition = new Vector3(0, 0.5, 0);
			var mat:GizmoMaterial = new GizmoMaterial();
			mat.color = colorZ;
			mat.renderQueue = 5000;
			mat.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			cone.meshRenderer.sharedMaterial = mat;
			cone.name = 'PositionZ';
			//cone.transformType = 3;
			
			positionZ.transform.rotate(new Vector3(90, 0, 0), true, false);
		}
		
		public function initRotationSSprite3D():void {
			
			rotationS = rotationSprite3D.addChild(new PixelLineSprite3D(64)) as PixelLineSprite3D;
			drawAxisZCircle(rotationS, 0.5, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.renderQueue = 5001;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			rotationS.pixelLineRenderer.sharedMaterial = lm;
		}
		
		public function initRotationLSprite3D():void {
			
			rotationL = rotationSprite3D.addChild(new PixelLineSprite3D(64)) as PixelLineSprite3D;
			drawAxisZCircle(rotationL, 0.56, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.renderQueue = 5001;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			rotationL.pixelLineRenderer.sharedMaterial = lm;
		}
		
		public function initRotationXSprite3D():void {
			
			rotationX = rotationSprite3D.addChild(new PixelLineSprite3D(64)) as PixelLineSprite3D;
			drawAxisXCircle(rotationX, 0.5, color);
			var lm:DepthCullLineMaterial = new DepthCullLineMaterial();
			lm.color = colorX;
			lm.renderQueue = 5000;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			rotationX.pixelLineRenderer.sharedMaterial = lm;
			rotationX.name = 'RotationX';
			//rotationX.transformType = 4;
		}
		
		public function initRotationYSprite3D():void {
			
			rotationY = rotationSprite3D.addChild(new PixelLineSprite3D(64)) as PixelLineSprite3D;
			drawAxisYCircle(rotationY, 0.5, color);
			var lm:DepthCullLineMaterial = new DepthCullLineMaterial();
			lm.color = colorY;
			lm.renderQueue = 5000;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			rotationY.pixelLineRenderer.sharedMaterial = lm;
			rotationY.name = 'RotationY';
			//rotationY.transformType = 5;
		}
		
		public function initRotationZSprite3D():void {
			
			rotationZ = rotationSprite3D.addChild(new PixelLineSprite3D(64)) as PixelLineSprite3D;
			drawAxisZCircle(rotationZ, 0.5, color);
			var lm:DepthCullLineMaterial = new DepthCullLineMaterial();
			lm.color = colorZ;
			lm.renderQueue = 5000;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			rotationZ.pixelLineRenderer.sharedMaterial = lm;
			rotationZ.name = 'RotationZ';
			//rotationZ.transformType = 6;
		}
		
		public function initScaleXSprite3D():void {
			
			scalingX = scaleSprite3D.addChild(new Sprite3D()) as Sprite3D;
			
			var line:PixelLineSprite3D = scalingX.addChild(new PixelLineSprite3D(2)) as PixelLineSprite3D;
			line.addLine(new Vector3(0, 0, 0), new Vector3(0, 0.5, 0), color, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.renderQueue = 5000;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			line.pixelLineRenderer.sharedMaterial = lm;
			line.name = 'ScaleX';
			//line.transformType = 7;
			
			var cone:MeshSprite3D = scalingX.addChild(new MeshSprite3D(PrimitiveMesh.createBox(0.05, 0.05, 0.05))) as MeshSprite3D;
			cone.transform.localPosition = new Vector3(0, 0.5, 0);
			var mat:GizmoMaterial = new GizmoMaterial();
			mat.color = color;
			mat.renderQueue = 5000;
			mat.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			cone.meshRenderer.sharedMaterial = mat;
			cone.name = 'ScaleX';
			//cone.transformType = 7;
			
			scalingX.transform.rotate(new Vector3(0, 0, -90), true, false);
		}
		
		public function initScaleYSprite3D():void {
			
			scalingY = scaleSprite3D.addChild(new Sprite3D()) as Sprite3D;
			
			var line:PixelLineSprite3D = scalingY.addChild(new PixelLineSprite3D(2)) as PixelLineSprite3D;
			line.addLine(new Vector3(0, 0, 0), new Vector3(0, 0.5, 0), color, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.renderQueue = 5000;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			line.pixelLineRenderer.sharedMaterial = lm;
			line.name = 'ScaleY';
			//line.transformType = 8;
			
			var cone:MeshSprite3D = scalingY.addChild(new MeshSprite3D(PrimitiveMesh.createBox(0.05, 0.05, 0.05))) as MeshSprite3D;
			cone.transform.localPosition = new Vector3(0, 0.5, 0);
			var mat:GizmoMaterial = new GizmoMaterial();
			mat.color = color;
			mat.renderQueue = 5000;
			mat.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			cone.meshRenderer.sharedMaterial = mat;
			cone.name = 'ScaleY';
			//cone.transformType = 8;
		}
		
		public function initScaleZSprite3D():void {
			
			scalingZ = scaleSprite3D.addChild(new Sprite3D()) as Sprite3D;
			
			var line:PixelLineSprite3D = scalingZ.addChild(new PixelLineSprite3D(2)) as PixelLineSprite3D;
			line.addLine(new Vector3(0, 0, 0), new Vector3(0, 0.5, 0), color, color);
			var lm:PixelLineMaterial = new PixelLineMaterial();
			lm.renderQueue = 5000;
			lm.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			line.pixelLineRenderer.sharedMaterial = lm;
			line.name = 'ScaleZ';
			//line.transformType = 9;
			
			var cone:MeshSprite3D = scalingZ.addChild(new MeshSprite3D(PrimitiveMesh.createBox(0.05, 0.05, 0.05))) as MeshSprite3D;
			cone.transform.localPosition = new Vector3(0, 0.5, 0);
			var mat:GizmoMaterial = new GizmoMaterial();
			mat.color = color;
			mat.renderQueue = 5000;
			mat.getRenderState(0).depthTest = RenderState.DEPTHTEST_ALWAYS;
			cone.meshRenderer.sharedMaterial = mat;
			cone.name = 'ScaleZ';
			//cone.transformType = 9;
			
			scalingZ.transform.rotate(new Vector3(90, 0, 0), true, false);
		}
		
		public function onSelectChangeColor(sprite:Sprite3D, color:Vector4 = null):void {
			if (color == null) {
				color = selectColor;
			}
			if (sprite is PixelLineSprite3D) {
				var mat1:* = (sprite as PixelLineSprite3D).pixelLineRenderer.sharedMaterial;
				mat1.color = color;
			}
			if (sprite is MeshSprite3D) {
				var mat2:GizmoMaterial = (sprite as MeshSprite3D).meshRenderer.sharedMaterial as GizmoMaterial;
				mat2.color = color;
			}
			for (var i:int = 0; i < sprite.numChildren; i++) {
				onSelectChangeColor(sprite.getChildAt(i) as Sprite3D, color);
			}
		}
		
		public function reFresh():void {
			
			onSelectChangeColor(positionX, colorX);
			onSelectChangeColor(positionY, colorY);
			onSelectChangeColor(positionZ, colorZ);
			
			onSelectChangeColor(rotationX, colorX);
			onSelectChangeColor(rotationY, colorY);
			onSelectChangeColor(rotationZ, colorZ);
			
			onSelectChangeColor(scalingX, colorX);
			onSelectChangeColor(scalingY, colorY);
			onSelectChangeColor(scalingZ, colorZ);
		}
		
		public function drawAxisXCircle(line:PixelLineSprite3D, radius:Number, circleColor:*, lineCount:int = 60):void {
			
			var perAngle:Number = (Math.PI * 2.0) / lineCount;
			var curAngle:Number = 0;
			var lasePosition:Vector3 = new Vector3(0, 0, radius);
			var curPosition:Vector3 = new Vector3();
			for (var i:int = 0; i <= lineCount; i++) {
				curAngle = i * perAngle;
				curPosition.x = 0;
				curPosition.y = Math.sin(curAngle) * radius;
				curPosition.z = Math.cos(curAngle) * radius;
				line.addLine(lasePosition, curPosition, circleColor, circleColor);
				curPosition.cloneTo(lasePosition);
			}
		}
		
		public function drawAxisYCircle(line:PixelLineSprite3D, radius:Number, circleColor:*, lineCount:int = 60):void {
			
			var perAngle:Number = (Math.PI * 2.0) / lineCount;
			var curAngle:Number = 0;
			var lasePosition:Vector3 = new Vector3(radius, 0, 0);
			var curPosition:Vector3 = new Vector3();
			for (var i:int = 0; i <= lineCount; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = 0;
				curPosition.z = Math.sin(curAngle) * radius;
				line.addLine(lasePosition, curPosition, circleColor, circleColor);
				curPosition.cloneTo(lasePosition);
			}
		}
		
		public function drawAxisZCircle(line:PixelLineSprite3D, radius:Number, circleColor:*, lineCount:int = 60):void {
			
			var perAngle:Number = (Math.PI * 2.0) / lineCount;
			var curAngle:Number = 0;
			var lasePosition:Vector3 = new Vector3(radius, 0, 0);
			var curPosition:Vector3 = new Vector3();
			for (var i:int = 0; i <= lineCount; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = Math.sin(curAngle) * radius;
				curPosition.z = 0;
				line.addLine(lasePosition, curPosition, circleColor, circleColor);
				curPosition.cloneTo(lasePosition);
			}
		}
	}
}