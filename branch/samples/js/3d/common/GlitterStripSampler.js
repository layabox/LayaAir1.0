var Vector3 = Laya.Vector3;

function GlitterStripSampler() {
    this.pos1 = new Laya.Vector3(0, 0, 0);
    this.pos2 = new Laya.Vector3(0, 0.6, 0);
    this.nCount = 0;
    this.direction = true;

}
Laya.class(GlitterStripSampler, "GlitterStripSampler");

GlitterStripSampler.prototype.getSampleP4 = function () {
    if (this.direction) {
        this.nCount += 0.5;
        if (this.nCount >= 12) {
            this.direction = false;
        }
    } else {
        this.nCount -= 0.5;
        if (this.nCount <= -12) {
            this.direction = true;
        }
    }
    //TODO
    this.pos1.elements[0] = this.nCount;
    this.pos2.elements[0] = this.nCount * 1.3;
}