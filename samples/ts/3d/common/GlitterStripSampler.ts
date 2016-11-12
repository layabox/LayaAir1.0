class GlitterStripSampler {
    public pos1 = new Laya.Vector3(0, 0, 0);
    public pos2 = new Laya.Vector3(0, 0.6, 0);
    private nCount = 0;
    private direction = true;

    constructor() {
    }

    public getSampleP4(): void {
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
}