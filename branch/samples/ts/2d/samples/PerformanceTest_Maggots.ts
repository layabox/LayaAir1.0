module laya
{
    import Sprite = Laya.Sprite;
    import Browser = Laya.Browser;
    import Handler = Laya.Handler;
    import Stat = Laya.Stat;
    import Rectangle = Laya.Rectangle;
    import WebGL = Laya.WebGL;
    
    export class PerformanceTest_Maggots
    {
        private texturePath:string = "../../res/tinyMaggot.png";
        
        private padding:number = 100;
        private maggotAmount:number = 5000;

        private tick:number = 0;
        private maggots:Array<Sprite> = [];
        private wrapBounds:Rectangle;
        private maggotTexture:any;
        
        constructor()
        {
            Laya.init(Browser.width,Browser.height, WebGL);
            Laya.stage.bgColor = "#000000";
            Stat.show();
            
            this.wrapBounds = new Rectangle(-this.padding, -this.padding, Laya.stage.width + this.padding * 2, Laya.stage.height + this.padding * 2);
            
            Laya.loader.load(this.texturePath, Handler.create(this, this.onTextureLoaded));
        }
        
        private onTextureLoaded():void
        {
            this.maggotTexture = Laya.loader.getRes(this.texturePath);
            this.initMaggots();
            Laya.timer.frameLoop(1, this, this.animate);
        }
        
        private initMaggots():void 
        {
            var maggotContainer:Sprite;
            for (var i:number = 0; i < this.maggotAmount; i++)
            {
                if (i % 16000 == 0)
                    maggotContainer = this.createNewContainer();

                var maggot:Sprite = this.newMaggot();
                maggotContainer.addChild(maggot);
                this.maggots.push(maggot);
            }
        }

        private createNewContainer():Sprite
        {
            var container:Sprite = new Sprite();
            container.size(Browser.clientWidth,Browser.clientHeight);
            // 此处cacheAsBitmap主要是为了创建新画布
            // 解除IBQuadrangle数量限制
            // 在显示虫子数量超过16383时需要打开下面一行
            // container.cacheAsBitmap = true;
            Laya.stage.addChild(container);
            return container;
        }

        private newMaggot():Sprite
        {
            var maggot:any = new Sprite();
            maggot.graphics.drawTexture(this.maggotTexture, 0, 0);

            maggot.pivot(16.5, 35);

            var rndScale:number = 0.8 + Math.random() * 0.3;
            maggot.scale(rndScale, rndScale);
            maggot.rotation = 0.1;
            maggot.x = Math.random() * Laya.stage.width;
            maggot.y = Math.random() * Laya.stage.height;
            
            maggot.direction = Math.random() * Math.PI;
            maggot.turningSpeed = Math.random() - 0.8;
            maggot.speed = (2 + Math.random() * 2) * 0.2;
            maggot.offset = Math.random() * 100;

            return maggot;
        }
        
        private animate():void
        {
            var maggot:any;
            var wb:Rectangle = this.wrapBounds;
            var angleUnit:number = 180 / Math.PI;
            var dir:any, x:number = 0.0, y:number = 0.0;
            for (var i:number = 0; i < this.maggotAmount; i++)
            {
                maggot = this.maggots[i];
                
                maggot.scaleY = 0.90 + Math.sin(this.tick + maggot.offset) * 0.1;
                
                maggot.direction += maggot.turningSpeed * 0.01;
                dir = maggot.direction;
                x = maggot.x;
                y = maggot.y;

                x += Math.sin(dir) * (maggot.speed * maggot.scaleY);
                y += Math.cos(dir) * (maggot.speed * maggot.scaleY);
                
                maggot.rotation = (-dir + Math.PI) * angleUnit;
                
                if (x < wb.x)
                    x += wb.width;
                else if (x > wb.x + wb.width)
                    x -= wb.width;
                if (y < wb.y)
                    y += wb.height;
                else if (y > wb.y + wb.height)
                    y -= wb.height;
                
                maggot.pos(x, y);
            }
            
            this.tick += 0.1;
        }
    }
}
new laya.PerformanceTest_Maggots();