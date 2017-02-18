package threeDimen.common {
	import laya.d3.core.particle.Particle3D;
	import laya.d3.math.Vector3;
	import laya.particle.ParticleEmitter;
	
	public class ProjectileParticle {
		private const trailParticlesPerSecond:Number = 200;
		private const numExplosionParticles:int = 30;
		private const numExplosionSmokeParticles:int = 50;
		private const projectileLifespan:Number = 1.5;
		private const sidewaysVelocityRange:Number = 0.6;
		private const verticalVelocityRange:Number = 0.4;
		private const gravity:Number = 0.15;
		
		private var explosionParticles:Particle3D;
		private var explosionSmokeParticles:Particle3D;
		private var trailEmitter:ParticleEmitter;
		
		private var position:Vector3;
		private var velocity:Vector3;
		private var age:Number;
		
		public function ProjectileParticle(explosion:Particle3D, smoke:Particle3D, projectileTrial:Particle3D) {
			
			this.explosionParticles = explosion;
			this.explosionSmokeParticles = smoke;
			
			age = 0;
			position = new Vector3();
			velocity = new Vector3();
			
			velocity.elements[0] = (Math.random() - 0.5) * sidewaysVelocityRange;
			velocity.elements[1] = (Math.random() + 0.5) * verticalVelocityRange;
			velocity.elements[2] = (Math.random() - 0.5) * sidewaysVelocityRange;
			
			trailEmitter = new ParticleEmitter(projectileTrial.templet, trailParticlesPerSecond, position.elements);
		}
		
		public function update(interval:Number):Boolean {
			var elapsedTime:Number = interval / 1000;
			
			var velocitye:Float32Array = velocity.elements;
			var positione:Float32Array = position.elements;
			positione[0] += velocitye[0] * elapsedTime;
			positione[1] += velocitye[1] * elapsedTime;
			positione[2] += velocitye[2] * elapsedTime;
			
			velocity.elements[1] -= elapsedTime * gravity;
			age += elapsedTime;
			
			trailEmitter.update(interval, position.elements);
			
			if (age > projectileLifespan) {
				var i:int;
				for (i = 0; i < numExplosionParticles; i++)
					explosionParticles.templet.addParticle(position, velocity);
				
				for (i = 0; i < numExplosionSmokeParticles; i++)
					explosionSmokeParticles.templet.addParticle(position, velocity);
				
				return false;
			}
			
			return true;
		}
	
	}

}