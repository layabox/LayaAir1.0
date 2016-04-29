# windows-mutex

Expose the Windows CreateMutex API to Node.JS.

## Installation

`windows-mutex` will only compile in Windows machines, so it is advisable
to use the `--save-optional` flag and wrap the
`require('windows-mutex')` call in a `try {} catch {}` block, in case your
code also runs on other platforms.

```
npm install --save-optional windows-mutex
```

## Usage

```javascript
import { Mutex } from 'windows-mutex';

var mutex = new Mutex('my-mutex');
console.log(mutex.isActive());
mutex.release();
```
