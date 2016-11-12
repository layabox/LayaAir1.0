/** @private */
class ProjectileParticle {
    private trailParticlesPerSecond = 200;
    private numExplosionParticles = 30;
    private numExplosionSmokeParticles = 50;
    private projectileLifespan = 1.5;
    private sidewaysVelocityRange = 0.6;
    private verticalVelocityRange = 0.4;
    private gravity = 0.15;

    private explosionParticles: Laya.Particle3D;
    private explosionSmokeParticles: Laya.Particle3D;
    private trailEmitter: Laya.ParticleEmitter;

    private position: Laya.Vector3;
    private velocity: Laya.Vector3;
    private age: number;

    constructor(explosion: Laya.Particle3D, smoke: Laya.Particle3D, projectileTrial: Laya.Particle3D) {
        this.explosionParticles = explosion;
        this.explosionSmokeParticles = smoke;

        this.age = 0;
        this.position = new Laya.Vector3();
        this.velocity = new Laya.Vector3();

        this.velocity.elements[0] = (Math.random() - 0.5) * this.sidewaysVelocityRange;
        this.velocity.elements[1] = (Math.random() + 0.5) * this.verticalVelocityRange;
        this.velocity.elements[2] = (Math.random() - 0.5) * this.sidewaysVelocityRange;

        this.trailEmitter = new Laya.ParticleEmitter(projectileTrial.templet, this.trailParticlesPerSecond, this.position.elements);
    }

    public update(interval: number): Boolean {
        var elapsedTime: number = interval / 1000;

        var velocitye: Float32Array = this.velocity.elements;
        var positione: Float32Array = this.position.elements;
        positione[0] += velocitye[0] * elapsedTime;
        positione[1] += velocitye[1] * elapsedTime;
        positione[2] += velocitye[2] * elapsedTime;

        this.velocity.elements[1] -= elapsedTime * this.gravity;
        this.age += elapsedTime;

        this.trailEmitter.update(interval, this.position.elements);

        if (this.age > this.projectileLifespan) {
            var i: number;
            for (i = 0; i < this.numExplosionParticles; i++)
                this.explosionParticles.templet.addParticle(this.position, this.velocity);

            for (i = 0; i < this.numExplosionSmokeParticles; i++)
                this.explosionSmokeParticles.templet.addParticle(this.position, this.velocity);

            return false;
        }

        return true;
    }

}