
module ParticleSample {
    import Vector3 = Laya.Vector3;
    import ParticleSetting = Laya.ParticleSetting;
    import Particle3D = Laya.Particle3D;
    import Browser = Laya.Browser;
    import Sprite3D = Laya.Sprite3D;

    export class ParticleSample {
        private pos: Vector3;
        private Vel: Vector3;
        private lastTime: number;

        private currentState = 0;
        private simple: Particle3D;
        private smoke: Particle3D;
        private fire: Particle3D;
        private projectileTrail: Particle3D;
        private explosionSmoke: Particle3D;
        private explosion: Particle3D;

        private timeToNextProjectile = 0;
        private projectiles: Array<ProjectileParticle> = new Array<ProjectileParticle>();

        constructor() {
            this.pos = new Vector3();
            this.Vel = new Vector3();
            this.lastTime = Browser.now();

            Laya3D.init(0, 0,true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            this.loadUI();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
            camera.transform.translate(new Vector3(0, 1, 2.6));
            camera.transform.rotate(new Vector3(-20, 0, 0), false, false);
            camera.clearColor = null;
            camera.addComponent(CameraMoveScript);

            var grid: Sprite3D = scene.addChild(Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh")) as Sprite3D;

            var settings: ParticleSetting = new ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/texture.png";
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

            this.simple = new Particle3D(settings);
            this.simple.transform.localPosition = new Vector3(0, 0.5, 0);
            scene.addChild(this.simple);

            settings = new ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/smoke.png";
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
            this.smoke = new Particle3D(settings);
            scene.addChild(this.smoke);

            settings = new ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/fire.png";
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
            this.fire = new Particle3D(settings);
            scene.addChild(this.fire);

            //...............................
            settings = new ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/smoke.png";
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
            settings.minEndColor = new Float32Array([64 / 255, 96 / 255, 128 / 255, 1.0]);
            settings.maxEndColor = new Float32Array([1.0, 1.0, 1.0, 128 / 255]);
            settings.minRotateSpeed = -4;
            settings.maxRotateSpeed = 4;
            settings.minStartSize = 0.01;
            settings.maxStartSize = 0.03;
            settings.minEndSize = 0.04;
            settings.maxEndSize = 0.11;
            settings.blendState = 0;
            this.projectileTrail = new Particle3D(settings);
            scene.addChild(this.projectileTrail);

            settings = new ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/explosion.png";
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
            settings.minEndColor = new Float32Array([169 / 255, 169 / 255, 169 / 255, 1.0]);
            settings.maxEndColor = new Float32Array([128 / 255, 128 / 255, 128 / 255, 1.0]);
            settings.minRotateSpeed = -1;
            settings.maxRotateSpeed = 1;
            settings.minStartSize = 0.07;
            settings.maxStartSize = 0.07;
            settings.minEndSize = 0.7;
            settings.maxEndSize = 1.4;
            settings.blendState = 1;
            this.explosion = new Particle3D(settings);
            scene.addChild(this.explosion);

            settings = new ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/smoke.png";
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
            settings.minEndColor = new Float32Array([211 / 255, 211 / 255, 211 / 255, 1.0]);
            settings.maxEndColor = new Float32Array([1.0, 1.0, 1.0, 1.0]);
            settings.minRotateSpeed = -2;
            settings.maxRotateSpeed = 2;
            settings.minStartSize = 0.07;
            settings.maxStartSize = 0.07;
            settings.minEndSize = 0.7;
            settings.maxEndSize = 1.4;
            settings.blendState = 0;
            this.explosionSmoke = new Particle3D(settings);
            scene.addChild(this.explosionSmoke);

            Laya.timer.frameLoop(1, this, this.updateParticle);
        }

        private updateParticle(): void {
            var currentTime = Browser.now();
            var interval = currentTime - this.lastTime;
            this.lastTime = currentTime;

            switch (this.currentState) {
                case 0:
                    this.updateSimple();
                    break;
                case 1:
                    this.updateSmoke();
                    break;
                case 2:
                    this.updateFire();
                    break;
                case 3:
                    this.updateExplosions(interval);
                    this.updateProjectiles(interval);
                    break;
            }
        }

        private updateSimple(): void {
            for (var i = 0; i < 3; i++) {
                Vector3.ZERO.cloneTo(this.pos);
                Vector3.ZERO.cloneTo(this.Vel);
                this.simple.templet.addParticle(this.pos, this.Vel);
            }

        }

        private updateSmoke(): void {
            Vector3.ZERO.cloneTo(this.pos);
            Vector3.ZERO.cloneTo(this.Vel);
            this.smoke.templet.addParticle(this.pos, this.Vel);

        }

        private updateFire(): void {
            for (var i = 0; i < 8; i++) {
                Vector3.ZERO.cloneTo(this.Vel);
                this.fire.templet.addParticle(this.randomPointOnCircle(), this.Vel);

            }
            Vector3.ZERO.cloneTo(this.Vel);
            this.smoke.templet.addParticle(this.randomPointOnCircle(), this.Vel);

        }

        private updateExplosions(interval: number): void {
            this.timeToNextProjectile -= interval / 1000;
            if (this.timeToNextProjectile <= 0) {
                this.projectiles.push(new ProjectileParticle(this.explosion, this.explosionSmoke, this.projectileTrail));
                this.timeToNextProjectile += 1;
            }
        }

        private updateProjectiles(interval: number): void {
            var i = 0;
            while (i < this.projectiles.length) {
                if (!this.projectiles[i].update(interval))
                    this.projectiles.splice(i, 1);
                else
                    i++;
            }
        }

        private randomPointOnCircle(): Vector3 {
            const radiusX = 0.3;
            const radiusY = 0.5;
            const height = 0.5;

            var angle: number = Math.random() * Math.PI * 2;

            var x = Math.cos(angle);
            var y = Math.sin(angle);
            var zeroPosE: any = this.pos.elements;
            zeroPosE[0] = x * radiusX;
            zeroPosE[1] = y * radiusY + height;
            zeroPosE[2] = 0;
            return this.pos;
        }

        private loadUI(): void {
            Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, () => {
                var btn: Laya.Button = new Laya.Button();
                btn.skin = "../../res/threeDimen/ui/button.png";
                btn.label = "切换";
                btn.labelBold = true;
                btn.labelSize = 20;
                btn.sizeGrid = "4,4,4,4";
                btn.size(120, 30);
                btn.scale(Browser.pixelRatio, Browser.pixelRatio);
                btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
                btn.strokeColors = "#ff0000,#ffff00,#00ffff";
                btn.on(Laya.Event.CLICK, this, this.onclick);
                Laya.stage.addChild(btn);

                Laya.stage.on(Laya.Event.RESIZE, this, () => {
                    btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
                });
            }));
        }

        private onclick(): void {
            this.currentState++;
            (this.currentState > 3) && (this.currentState = 0);
        }
    }
}
new ParticleSample.ParticleSample();