/// <reference path="../../libs/LayaAir.d.ts" />
module sprites
{
    export class DrawPath
    {
        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            var canvas:laya.display.Sprite = new laya.display.Sprite();
            Laya.stage.addChild(canvas);

            var path:Array<any> = [];
            
            path.push(0, -130);
            path.push(33, -33);
            path.push(137, -30);
            path.push(55, 32);
            path.push(85, 130);
            path.push(0, 73);
            path.push(-85, 130);
            path.push(-55, 32);
            path.push(-137, -30);
            path.push(-33, -33);

            canvas.graphics.drawPoly(275, 200, path, "#00ffff");
        }
    }
}
new sprites.DrawPath();