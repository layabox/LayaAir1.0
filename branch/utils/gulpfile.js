var gulp = require('gulp');
var uglify = require("gulp-uglify");
var rename = require('gulp-rename');
var process = require('child_process');

gulp.task('copyas', function() {
    gulp.src('../src/ani/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/core/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/core/jsc/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/filter/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/html/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/particle/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/plugins/tiledmap/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/plugins/debugtool/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/plugins/device/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/plugins/pathfinding/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/ui/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/webGL/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/d3/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
	
	gulp.src('../src/d3Plugin/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'));
});

gulp.task('compile',["copyas"], function(cb) {
    process.execFile('compile.bat',function(){cb();});
});

gulp.task('minify',["compile"], function() {
	var stream = gulp.src('publish/bin/h5/js/*.js')//筛选要处理的文件
	.pipe(gulp.dest('../bin/js/libs'))//copy到发布目录
	.pipe(uglify())//使用uglify进行压缩。更多配置可参考
	.pipe(rename({extname: ".min.js"}))//重命名
	.pipe(gulp.dest('../bin/js/libs/min'));//保存压缩后的文件
	return stream;
});

gulp.task('default',["minify"], function() {
	gulp.src('../bin/js/libs/**')
    .pipe(gulp.dest('../bin/ts/libs/'))
});