package threeDimen.advancedStage {
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.particle.ParticleSetting;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import threeDimen.common.ProjectileParticle;
	
	import threeDimen.common.CameraMoveScript;
	
	/** @private */
	public class D3Advance_ParticleSample {
		private var pos:Vector3;
		private var Vel:Vector3;
		private var lastTime:Number;
		
		private var currentState:int = 0;
		private var simple:Particle3D;
		private var smoke:Particle3D;
		private var fire:Particle3D;
		private var projectileTrail:Particle3D;
		private var explosionSmoke:Particle3D;
		private var explosion:Particle3D;
		
		private var timeToNextProjectile:uint = 0;
		private var projectiles:Vector.<ProjectileParticle> = new Vector.<ProjectileParticle>();
		
		public function D3Advance_ParticleSample() {
			pos = new Vector3();
			Vel = new Vector3();
			lastTime = Browser.now();
			
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			loadUI();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 1, 2.6));
			camera.transform.rotate(new Vector3(-20, 0, 0), false, false);
			camera.clearColor = null;
			
			camera.addComponent(CameraMoveScript);
			
			var grid:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			grid.loadHierarchy("../../../../res/threeDimen/staticModel/grid/plane.lh");
			
			var settings:ParticleSetting = new ParticleSetting();
			settings.textureName = "../../../../res/threeDimen/particle/texture.png";
			settings.maxPartices = 3600;
			settings.duration = 6.0;
			settings.ageAddScale = 1.0;
			settings.minHorizontalVelocity = 0.00001;
			settings.maxHorizontalVelocity = 0.00001;
			settings.minVerticalVelocity = 0.00001;
			settings.maxVerticalVelocity = 0.00001;
			settings.gravity = new Float32Array([0, 0.01, 0]);
			settings.endVelocity = 1.0;
			settings.minRotateSpeed = -2;
			settings.maxRotateSpeed = 2;
			settings.minStartSize = 0.04;
			settings.maxStartSize = 0.06;
			settings.minEndSize = 0.12;
			settings.maxEndSize = 0.26;
			settings.blendState = 1;
			
			settings.colorComponentInter = true;
			settings.minStartColor = new Float32Array([0.1, 0.3, 0.6, 0.6]);
			settings.maxStartColor = new Float32Array([1.0, 0.5, 1.0, 1.0]);
			settings.minEndColor = new Float32Array([0.1, 0.3, 0.6, 0.6]);
			settings.maxEndColor = new Float32Array([1.0, 0.5, 1.0, 1.0]);
			settings.minStartRadius = 0.5;
			settings.maxStartRadius = 0.5;
			settings.minEndRadius = 0.5;
			settings.maxEndRadius = 0.5;
			settings.minHorizontalStartRadian = 0;
			settings.maxHorizontalStartRadian = 0;
			settings.minVerticalStartRadian = 0;
			settings.maxVerticalStartRadian = 0;
			
			settings.minHorizontalEndRadian = -3.14 * 2;
			settings.maxHorizontalEndRadian = 3.14 * 2;
			settings.minVerticalEndRadian = -3.14 * 2;
			settings.maxVerticalEndRadian = 3.14 * 2;
			
			simple = new Particle3D(settings);
			simple.transform.localPosition = new Vector3(0, 0.5, 0);
			scene.addChild(simple);
			
			settings = new ParticleSetting();
			settings.textureName = "../../../../res/threeDimen/particle/smoke.png";
			settings.maxPartices = 600;
			settings.duration = 10;
			settings.minHorizontalVelocity = 0;
			settings.maxHorizontalVelocity = 0.15;
			settings.minVerticalVelocity = 0.1;
			settings.maxVerticalVelocity = 0.2;
			settings.gravity = new Float32Array([-0.20, -0.05, 0]);
			settings.endVelocity = 0.75;
			settings.minRotateSpeed = -1;
			settings.maxRotateSpeed = 1;
			settings.minStartSize = 0.04;
			settings.maxStartSize = 0.07;
			settings.minEndSize = 0.35;
			settings.maxEndSize = 1.4;
			smoke = new Particle3D(settings);
			scene.addChild(smoke);
			
			settings = new ParticleSetting();
			settings.textureName = "../../../../res/threeDimen/particle/fire.png";
			settings.maxPartices = 1200;
			settings.duration = 2;
			settings.ageAddScale = 1;
			settings.minHorizontalVelocity = 0;
			settings.maxHorizontalVelocity = 0.15;
			settings.minVerticalVelocity = -0.1;
			settings.maxVerticalVelocity = 0.1;
			settings.gravity = new Float32Array([0, 0.15, 0]);
			settings.minStartColor = new Float32Array([1.0, 1.0, 1.0, 0.29215]);
			settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 0.56]);
			settings.minEndColor = new Float32Array([1.0, 1.0, 1.0, 0.29215]);
			settings.maxEndColor = new Float32Array([1.0, 1.0, 1.0, 0.56]);
			settings.minStartSize = 0.05;
			settings.maxStartSize = 0.1;
			settings.minEndSize = 0.1;
			settings.maxEndSize = 0.4;
			settings.blendState = 1;
			fire = new Particle3D(settings);
			scene.addChild(fire);
			
			//...............................
			settings = new ParticleSetting();
			settings.textureName = "../../../../res/threeDimen/particle/smoke.png";
			settings.maxPartices = 1000;
			settings.duration = 3;
			settings.ageAddScale = 1.5;
			settings.emitterVelocitySensitivity = 0.1;
			settings.minHorizontalVelocity = 0;
			settings.maxHorizontalVelocity = 0.01;
			settings.minVerticalVelocity = -0.01;
			settings.maxVerticalVelocity = 0.01;
			settings.minStartColor = new Float32Array([64 / 255, 96 / 255, 128 / 255, 1.0]);
			settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 128 / 255]);
			settings.minRotateSpeed = -4;
			settings.maxRotateSpeed = 4;
			settings.minStartSize = 0.01;
			settings.maxStartSize = 0.03;
			settings.minEndSize = 0.04;
			settings.maxEndSize = 0.11;
			settings.blendState = 0;
			projectileTrail = new Particle3D(settings);
			scene.addChild(projectileTrail);
			
			settings = new ParticleSetting();
			settings.textureName = "../../../../res/threeDimen/particle/explosion.png";
			settings.maxPartices = 100;
			settings.duration = 2;
			settings.ageAddScale = 1;
			settings.minHorizontalVelocity = 0.2;
			settings.maxHorizontalVelocity = 0.3;
			settings.minVerticalVelocity = -0.2;
			settings.maxVerticalVelocity = 0.2;
			settings.endVelocity = 0;
			settings.minStartColor = new Float32Array([169 / 255, 169 / 255, 169 / 255, 1.0]);
			settings.maxStartColor = new Float32Array([128 / 255, 128 / 255, 128 / 255, 1.0]);
			settings.minRotateSpeed = -1;
			settings.maxRotateSpeed = 1;
			settings.minStartSize = 0.07;
			settings.maxStartSize = 0.07;
			settings.minEndSize = 0.7;
			settings.maxEndSize = 1.4;
			settings.blendState = 1;
			explosion = new Particle3D(settings);
			scene.addChild(explosion);
			
			settings = new ParticleSetting();
			settings.textureName = "../../../../res/threeDimen/particle/smoke.png";
			settings.maxPartices = 200;
			settings.duration = 4;
			settings.minHorizontalVelocity = 0;
			settings.maxHorizontalVelocity = 0.5;
			settings.minVerticalVelocity = -0.1;
			settings.maxVerticalVelocity = 0.5;
			settings.gravity = new Float32Array([0, -0.2, 0]);
			settings.endVelocity = 0;
			settings.minStartColor = new Float32Array([211 / 255, 211 / 255, 211 / 255, 1.0]);
			settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 1.0]);
			settings.minRotateSpeed = -2;
			settings.maxRotateSpeed = 2;
			settings.minStartSize = 0.07;
			settings.maxStartSize = 0.07;
			settings.minEndSize = 0.7;
			settings.maxEndSize = 1.4;
			settings.blendState = 0;
			explosionSmoke = new Particle3D(settings);
			scene.addChild(explosionSmoke);
			
			Laya.timer.frameLoop(1, this, updateParticle);
		}
		
		private function updateParticle():void {
			var currentTime:Number = Browser.now();
			var interval:Number = currentTime - lastTime;
			lastTime = currentTime;
			
			switch (currentState) {
			case 0: 
				updateSimple();
				break;
			case 1: 
				updateSmoke();
				break;
			case 2: 
				updateFire();
				break;
			case 3: 
				updateExplosions(interval);
				updateProjectiles(interval);
				break;
			}
		}
		
		private function updateSimple():void {
			for (var i:int = 0; i < 3; i++) {
				Vector3.ZERO.cloneTo(pos);
				Vector3.ZERO.cloneTo(Vel);
				simple.templet.addParticle(pos, Vel);
			}
		
		}
		
		private function updateSmoke():void {
			Vector3.ZERO.cloneTo(pos);
			Vector3.ZERO.cloneTo(Vel);
			smoke.templet.addParticle(pos, Vel);
		
		}
		
		private function updateFire():void {
			for (var i:int = 0; i < 8; i++) {
				Vector3.ZERO.cloneTo(Vel);
				fire.templet.addParticle(randomPointOnCircle(), Vel);
				
			}
			Vector3.ZERO.cloneTo(Vel);
			smoke.templet.addParticle(randomPointOnCircle(), Vel);
		
		}
		
		private function updateExplosions(interval:Number):void {
			timeToNextProjectile -= interval / 1000;
			if (timeToNextProjectile <= 0) {
				projectiles.push(new ProjectileParticle(explosion, explosionSmoke, projectileTrail));
				timeToNextProjectile += 1;
			}
		}
		
		private function updateProjectiles(interval:Number):void {
			var i:int = 0;
			while (i < projectiles.length) {
				if (!projectiles[i].update(interval))
					projectiles.splice(i, 1);
				else
					i++;
			}
		}
		
		private function randomPointOnCircle():Vector3 {
			const radiusX:Number = 0.3;
			const radiusY:Number = 0.5;
			const height:Number = 0.5;
			
			var angle:Number = Math.random() * Math.PI * 2;
			
			var x:Number = Math.cos(angle);
			var y:Number = Math.sin(angle);
			var zeroPosE:Array = pos.elements;
			zeroPosE[0] = x * radiusX;
			zeroPosE[1] = y * radiusY + height;
			zeroPosE[2] = 0;
			return pos;
		}
		
		private function loadUI():void {
			var _this:D3Advance_ParticleSample = this;
			Laya.loader.load(["../../../../res/threeDimen/ui/button.png"], Handler.create(null, function():void {
				var btn:Button = new Button();
				btn.skin = "../../../../res/threeDimen/ui/button.png";
				btn.label = "切换";
				btn.labelBold = true;
				btn.labelSize = 20;
				btn.sizeGrid = "4,4,4,4";
				btn.size(120, 30);
				btn.scale(Browser.pixelRatio, Browser.pixelRatio);
				btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				btn.strokeColors = "#ff0000,#ffff00,#00ffff";
				btn.on(Event.CLICK, _this, onclick);
				Laya.stage.addChild(btn);
				
				Laya.stage.on(Event.RESIZE, null, function():void {
					btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				});
			}));
		}
		
		private function onclick():void {
			currentState++;
			(currentState > 3) && (currentState = 0);
		}
	}

}