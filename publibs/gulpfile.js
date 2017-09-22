var gulp = require('gulp');
var uglify = require("gulp-uglify");
var rename = require('gulp-rename');
var cp = require('child_process');

gulp.task('copyas', function(cb) {
	let i = 0;
	function add(){
		console.log('last: ' + (13-i));
		if (14 === ++i) {
			cb();
		}
	}

    gulp.src('../src/ani/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/core/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/core/jsc/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/filter/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/html/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/particle/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/plugins/tiledmap/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/plugins/debugtool/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/plugins/device/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/plugins/pathfinding/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/ui/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/webGL/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/d3/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
	
	gulp.src('../src/d3Plugin/src/**')
    .pipe(gulp.dest('../bin/as/libs/src'))
    .on('end', add);
});

gulp.task('compile',["copyas"], function(cb) {
    cp.execFile('compile.bat',function(){cb();});
});

gulp.task('minify',["compile"], function() {
	let stream = gulp.src('publish/bin/h5/js/*.js')//筛选要处理的文件
	.pipe(gulp.dest('../bin/js/libs'))//copy到发布目录
    .pipe(gulp.dest('../bin/ts/libs'))
	.pipe(uglify())//使用uglify进行压缩。更多配置可参考
	.pipe(rename({extname: ".min.js"}))//重命名
	.pipe(gulp.dest('../bin/js/libs/min'))//保存压缩后的文件
    .pipe(gulp.dest('../bin/ts/libs/min'));
	return stream;
});

gulp.task('default',["minify"], function() {
	console.log('Completed.');
});