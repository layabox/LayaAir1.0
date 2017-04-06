/** @private */
var ProjectileParticle = (function () {
    function ProjectileParticle(explosion, smoke, projectileTrial) {
        this.trailParticlesPerSecond = 200;
        this.numExplosionParticles = 30;
        this.numExplosionSmokeParticles = 50;
        this.projectileLifespan = 1.5;
        this.sidewaysVelocityRange = 0.6;
        this.verticalVelocityRange = 0.4;
        this.gravity = 0.15;
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
    ProjectileParticle.prototype.update = function (interval) {
        var elapsedTime = interval / 1000;
        var velocitye = this.velocity.elements;
        var positione = this.position.elements;
        positione[0] += velocitye[0] * elapsedTime;
        positione[1] += velocitye[1] * elapsedTime;
        positione[2] += velocitye[2] * elapsedTime;
        this.velocity.elements[1] -= elapsedTime * this.gravity;
        this.age += elapsedTime;
        this.trailEmitter.update(interval, this.position.elements);
        if (this.age > this.projectileLifespan) {
            var i;
            for (i = 0; i < this.numExplosionParticles; i++)
                this.explosionParticles.templet.addParticle(this.position, this.velocity);
            for (i = 0; i < this.numExplosionSmokeParticles; i++)
                this.explosionSmokeParticles.templet.addParticle(this.position, this.velocity);
            return false;
        }
        return true;
    };
    return ProjectileParticle;
}());
