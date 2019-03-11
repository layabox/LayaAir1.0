var gulp = require('gulp');
var cp = require('child_process');
var fs = require("fs");
var del = require('del');

var PathLayaAir = '../../..';

//清理类库文件夹
gulp.task('clean', function (cb) {
    del(['../bin/as/',
        '../bin/js/',
        '../bin/ts/'
    ], { force: true }).then(paths => {
        cb();
    });
});

//copy as3代码到as3类库里面
gulp.task('copy_as', ["clean"], function () {
    gulp.src(PathLayaAir + '/ani/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/core/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/core/jsc/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/filter/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/html/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/particle/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/effect/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/plugins/tiledmap/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/plugins/wx/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/plugins/debugtool/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/plugins/device/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/plugins/pathfinding/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/ui/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/webGL/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/physics/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/d3/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
    gulp.src(PathLayaAir + '/d3Plugin/src/**')
        .pipe(gulp.dest('../bin/as/libs/src'));
});

//编译as3到js
gulp.task('compile_js', ['copy_as'], function (cb) {
    cp.exec(`"layajs" "publish/LayaPublish.as3proj";iflash=false;chromerun=false;`, function (error, stdout, stderr) {
        // console.log(`stdout: ${stdout}`);
        // console.log(`stderr: ${stderr}`);
        if (error !== null) {
            console.log(error);
        } else {
            //copy box2d.js到laya.physics.js里面
            var box2d = fs.readFileSync("libs/box2d.js", "utf-8");
            var physics = fs.readFileSync("publish/bin/h5/js/laya.physics.js", "utf-8");
            physics = box2d + physics;
            fs.writeFileSync("publish/bin/h5/js/laya.physics.js", physics, { encoding: "utf-8" });
            cb();
        }
    });
});

//copy js到ts，js类库
gulp.task('copy_js', ["compile_js"], function () {
    //copy laya类库到libs目录
    gulp.src('publish/bin/h5/js/*.js')//筛选要处理的文件
        .pipe(gulp.dest('../bin/js/libs'))//copy到发布目录
        .pipe(gulp.dest('../bin/ts/libs'));

    //发布第三方库到libs目录
    gulp.src(['libs/*.js','libs/*.wasm', '!libs/box2d.js'])
        .pipe(gulp.dest('../bin/js/libs'))
        .pipe(gulp.dest('../bin/ts/libs'))
        .pipe(gulp.dest('../bin/as/jslibs'));

    //copy d.ts到libs目录
    gulp.src('libs/*.ts')
        .pipe(gulp.dest('../bin/js/ts'))
        .pipe(gulp.dest('../bin/ts/ts'));

    //单独copy box2d.js和laya.wxmini.js到as3 的jslibs里面
    gulp.src(['publish/bin/h5/js/laya.wxmini.js','publish/bin/h5/js/laya.bdmini.js','publish/bin/h5/js/laya.debugtool.js', 'libs/box2d.js'])
        .pipe(gulp.dest('../bin/as/jslibs'));
    //单独copy layajs到as目录
    gulp.src(['layajs.exe', 'layajs','playerglobal.swc'])
        .pipe(gulp.dest('../bin/as'));
});

gulp.task('default', ["copy_js"], function (cb) {
    console.log("===========[Laya Publish Complete]===========");
});