
    

function loadWasm(url){
    Module.asmGlobalArg = { 
        "Math": Math, 
        "Int8Array": Int8Array, 
        "Int16Array": Int16Array, 
        "Int32Array": Int32Array, 
        "Uint8Array": Uint8Array, 
        "Uint16Array": Uint16Array, 
        "Uint32Array": Uint32Array, 
        "Float32Array": Float32Array, 
        "Float64Array": Float64Array, 
        "NaN": NaN, 
        "Infinity": Infinity };

    Module.asmLibraryArg = { 
        "abort": abort, 
        "assert": assert, 
        "enlargeMemory": enlargeMemory, 
        "getTotalMemory": getTotalMemory, 
        "abortOnCannotGrowMemory": abortOnCannotGrowMemory, 
        "abortStackOverflow": abortStackOverflow, 
        "nullFunc_vi": nullFunc_vi, 
        "nullFunc_iiii": nullFunc_iiii, 
        "nullFunc_viiiii": nullFunc_viiiii, 
        "nullFunc_i": nullFunc_i, 
        "nullFunc_iiiiiiiiii": nullFunc_iiiiiiiiii, 
        "nullFunc_vii": nullFunc_vii, 
        "nullFunc_ii": nullFunc_ii, 
        "nullFunc_viii": nullFunc_viii, 
        "nullFunc_v": nullFunc_v, 
        "nullFunc_iiiii": nullFunc_iiiii, 
        "nullFunc_viiiiii": nullFunc_viiiiii, 
        "nullFunc_iii": nullFunc_iii, 
        "nullFunc_viiii": nullFunc_viiii, 
        "invoke_vi": invoke_vi, 
        "invoke_iiii": invoke_iiii, 
        "invoke_viiiii": invoke_viiiii, 
        "invoke_i": invoke_i, 
        "invoke_iiiiiiiiii": invoke_iiiiiiiiii, 
        "invoke_vii": invoke_vii, 
        "invoke_ii": invoke_ii, 
        "invoke_viii": invoke_viii, 
        "invoke_v": invoke_v, 
        "invoke_iiiii": invoke_iiiii, 
        "invoke_viiiiii": invoke_viiiiii, 
        "invoke_iii": invoke_iii, 
        "invoke_viiii": invoke_viiii, 
        "_llvm_pow_f64": _llvm_pow_f64, 
        "__ZSt18uncaught_exceptionv": __ZSt18uncaught_exceptionv, 
        "___syscall54": ___syscall54, 
        "___syscall6": ___syscall6, 
        "___gxx_personality_v0": ___gxx_personality_v0, 
        "___cxa_free_exception": ___cxa_free_exception, 
        "___cxa_allocate_exception": ___cxa_allocate_exception, 
        "___cxa_find_matching_catch_3": ___cxa_find_matching_catch_3, 
        "_longjmp": _longjmp, 
        "___cxa_find_matching_catch_2": ___cxa_find_matching_catch_2, 
        "___setErrNo": ___setErrNo, 
        "___cxa_begin_catch": ___cxa_begin_catch, 
        "_emscripten_memcpy_big": _emscripten_memcpy_big, 
        "___cxa_end_catch": ___cxa_end_catch, 
        "___resumeException": ___resumeException, 
        "___cxa_find_matching_catch": ___cxa_find_matching_catch, 
        "_pthread_getspecific": _pthread_getspecific, 
        "_pthread_once": _pthread_once, 
        "_pthread_key_create": _pthread_key_create, 
        "_pthread_setspecific": _pthread_setspecific, 
        "___cxa_throw": ___cxa_throw, 
        "_abort": _abort, 
        "_emscripten_longjmp": _emscripten_longjmp, 
        "___syscall140": ___syscall140, 
        "___syscall146": ___syscall146, 
        "DYNAMICTOP_PTR": DYNAMICTOP_PTR, 
        "tempDoublePtr": tempDoublePtr, 
        "ABORT": ABORT, 
        "STACKTOP": STACKTOP, 
        "STACK_MAX": STACK_MAX };

        var TOTAL_MEMORY = 16777216;
        var WASM_PAGE_SIZE = 64*1024;
        Module['wasmMemory'] = new WebAssembly.Memory({ 'initial': TOTAL_MEMORY / WASM_PAGE_SIZE, 'maximum': TOTAL_MEMORY / WASM_PAGE_SIZE });
        buffer = Module['wasmMemory'].buffer;
        let TABLE_SIZE = 1344;
        let MAX_TABLE_SIZE = TABLE_SIZE;
        let tbl = new WebAssembly.Table({ 'initial': TABLE_SIZE, 'maximum': MAX_TABLE_SIZE, 'element': 'anyfunc' });
          
        //导入对象
        var info = {
            'global': null,
            'env': null,
            'asm2wasm': asm2wasmImports,
            'parent': Module // Module inside wasm-js.cpp refers to wasm-js.cpp; this allows access to the outside program.
          };

        fetch('layawasm.wasm', { credentials: 'same-origin' }).then(function(response) {
            if (!response['ok']) {
              throw "failed to load wasm binary file at '" + wasmBinaryFile + "'";
            }
            return response['arrayBuffer']();
        })
        .then(function(binary) {
            return WebAssembly.instantiate(binary, info)
        })
        .then(function(output) {
            var inst = output['instance'];
            Module['asm'] = inst.exports;
        })
        .catch(function(reason) {
            alert('e33')
        });
}

//loadWasm()


function startGame(){
	var img;
	img='res/Itemsheet.png';
	img="res/comp.png"
	//img="res/image.png"
    _createImageBitmap(img).then(bmp=>{/**@type {ImageData} */
        /**@type {HTMLCanvasElement} */
        //var canv = document.getElementById('canvas');
        //var ctx = canv.getContext('2d');
        //ctx.putImageData(bmp,100,100);
		console.log("data",bmp);
    })
	
	 _createImageBitmap(img).then(bmp=>{/**@type {ImageData} */
        /**@type {HTMLCanvasElement} */
        //var canv = document.getElementById('canvas');
        //var ctx = canv.getContext('2d');
        //ctx.putImageData(bmp,100,100);
		console.log("data",bmp);
    })
	
	 _createImageBitmap(img).then(bmp=>{/**@type {ImageData} */
        /**@type {HTMLCanvasElement} */
        //var canv = document.getElementById('canvas');
        //var ctx = canv.getContext('2d');
        //ctx.putImageData(bmp,100,100);
		console.log("data",bmp);
    })
}

function getTimeNow()
{
	return new Date().getTime();
}
function _createImageBitmap(url){
    return new Promise((res,rej)=>{
        fetch(url)
        .then(response=>{
            if(!response.ok){
                alert('error 1');
                throw 'e1';
            }
            return response.arrayBuffer();
        })
        .then(binary=>{/** @type {ArrayBuffer}*/
		
		    var tTime=getTimeNow();
            let ptr = Module._malloc(binary.byteLength);
            /** @type {ArrayBuffer} */
            var buf = Module.buffer;
            //copy
            new Uint8Array(buf,ptr,binary.byteLength).set(new Uint8Array(binary));
            let bmpdata = Module._decodePng(ptr, binary.byteLength);
			
			
            let w = Module.HEAP32[bmpdata>>2];
            let h = Module.HEAP32[(bmpdata>>2)+1];
            var bmp = new ImageData(w,h);//w,h
            bmp.data.set(  new Uint8Array( Module.buffer, Module.HEAP32[(bmpdata>>2)+3], w*h*4) );
            Module._free(bmpdata);
            Module._free(ptr);
			var dTime=getTimeNow()-tTime;
			console.log("parseTime:",dTime);
            res(bmp);
        });
    });
}