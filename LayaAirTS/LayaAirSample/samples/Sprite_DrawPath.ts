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
            path.push(["moveTo", 0, -130]);
            path.push(["lineTo", 33, -33 ]);
            path.push(["lineTo", 137, -30]);
            path.push(["lineTo", 55, 32]);
            path.push(["lineTo", 85, 130]);
            path.push(["lineTo", 0, 73]);
            path.push(["lineTo", -85, 130]);
            path.push(["lineTo", -55, 32]);
            path.push(["lineTo", -137, -30]);
            path.push(["lineTo", -33, -33 ]);
            path.push(["lineTo", 0, -130]);
            path.push(["closePath"]);

            canvas.graphics.drawPath(275, 200, path, {fillStyle: "#00ffff"});
        }
    }
}
new sprites.DrawPath();