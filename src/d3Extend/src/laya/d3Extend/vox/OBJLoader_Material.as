package vox {
	/**
	 * https://en.wikipedia.org/wiki/Wavefront_.obj_file
	 * http://paulbourke.net/dataformats/mtl/
	 * https://github.com/frenchtoast747/webgl-obj-loader
	 */
	
	public class OBJLoader_Material {
		public var name:String;
		public var ambient:Array = [0, 0, 0]; // Ka - Ambient Reflectivity
		public var diffuse:Array = [0, 0, 0]; // Kd - Defuse Reflectivity
		public var specular:Array = [0, 0, 0];// Ks
		public var emissive:Array = [0, 0, 0];// Ke
		public var transmissionFilter:Array = [0, 0, 0];// Tf
		public var dissolve:int = 0;// d
		public var specularExponent:int = 0;// valid range is between 0 and 1000
		public var transparency:int = 0;// either d or Tr; valid values are normalized
		public var illumination:int = 0;// illum - the enum of the illumination model to use
		public var refractionIndex:int = 1;// Ni - Set to "normal" (air).
		public var sharpness:int= 0;// sharpness
		public var mapDiffuse = null;// map_Kd
		public var mapAmbient = null;// map_Ka
		public var mapSpecular = null;// map_Ks
		public var mapSpecularExponent = null;// map_Ns
		public var mapDissolve = null;// map_d
		public var antiAliasing = false;// map_aat
		public var mapBump = null;// map_bump or bump
		public var mapDisplacement = null;// disp
		public var mapDecal = null;// decal
		public var mapEmissive = null;// map_Ke
		// refl - when the reflection type is a cube, there will be multiple refl
		//        statements for each side of the cube. If it's a spherical
		//        reflection, there should only ever be one.
		public var mapReflections:Array = [];
        public var currentMaterial:OBJLoader_Material = null;
        public var materials:Object = { };		// 
		
		/**
		 * Constructor
		 * @param {String} name the unique name of the material
		 */
		public function OBJLoader_Material(name):void {
			// the unique material ID.
			name = name;
		}

		public function parse_newmtl(tokens:Vector.<String>):void {
			var name:String = tokens[0];
			currentMaterial = materials[name] = new OBJLoader_Material(name);
		}

		public function parseColor(tokens) {
			if (tokens[0] == "spectral") {
				console.error(
					"The MTL parser does not support spectral curve files. You will " +
						"need to convert the MTL colors to either RGB or CIEXYZ."
				);
				return;
			}

			if (tokens[0] == "xyz") {
				console.warn("TODO: convert XYZ to RGB");
				return;
			}

			// from my understanding of the spec, RGB values at this point
			// will either be 3 floats or exactly 1 float, so that's the check
			// that i'm going to perform here
			if (tokens.length == 3) {
				return tokens.map(parseFloat);
			}

			// Since tokens at this point has a length of 3, we're going to assume
			// it's exactly 1, skipping the check for 2.
			var value = parseFloat(tokens[0]);
			// in this case, all values are equivalent
			return [value, value, value];
		}

		
		public function parse_Ka(tokens) {
			currentMaterial.ambient = parseColor(tokens);
		}

	 
		public function parse_Kd(tokens) {
			currentMaterial.diffuse = parseColor(tokens);
		}

	   
		public function parse_Ks(tokens) {
			currentMaterial.specular = parseColor(tokens);
		}

	  
		public function parse_Ke(tokens) {
			currentMaterial.emissive = parseColor(tokens);
		}

	   
		public function parse_Tf(tokens) {
			currentMaterial.transmissionFilter = parseColor(tokens);
		}

		public function parse_d(tokens) {
			// this ignores the -halo option as I can't find any documentation on what
			// it's supposed to be.
			currentMaterial.dissolve = parseFloat(tokens.pop());
		}

		public function parse_illum(tokens) {
			currentMaterial.illumination = parseInt(tokens[0]);
		}

	  
		public function parse_Ni(tokens) {
			currentMaterial.refractionIndex = parseFloat(tokens[0]);
		}

		public function parse_Ns(tokens) {
			currentMaterial.specularExponent = parseInt(tokens[0]);
		}

	  
		public function parse_sharpness(tokens) {
			currentMaterial.sharpness = parseInt(tokens[0]);
		}

	   
		public function parse_cc(values, options) {
			options.colorCorrection = values[0] == "on";
		}

	  
		public function parse_blendu(values, options) {
			options.horizontalBlending = values[0] == "on";
		}

		public function parse_blendv(values, options) {
			options.verticalBlending = values[0] == "on";
		}

	   
		public function parse_boost(values, options) {
			options.boostMipMapSharpness = parseFloat(values[0]);
		}

	  
		public function parse_mm(values, options) {
			options.modifyTextureMap.brightness = parseFloat(values[0]);
			options.modifyTextureMap.contrast = parseFloat(values[1]);
		}

	  
		public function parse_ost(values, option, defaultValue) {
			while (values.length < 3) {
				values.push(defaultValue);
			}

			option.u = parseFloat(values[0]);
			option.v = parseFloat(values[1]);
			option.w = parseFloat(values[2]);
		}

	   
		public function parse_o(values, options) {
			parse_ost(values, options.offset, 0);
		}

	  
		public function parse_s(values, options) {
			parse_ost(values, options.scale, 1);
		}

	  
		public function parse_t(values, options) {
			parse_ost(values, options.turbulence, 0);
		}

	  
		public function parse_texres(values, options) {
			options.textureResolution = parseFloat(values[0]);
		}

	  
		public function parse_clamp(values, options) {
			options.clamp = values[0] == "on";
		}

	  
		public function parse_bm(values, options) {
			options.bumpMultiplier = parseFloat(values[0]);
		}

	  
		public function parse_imfchan(values, options) {
			options.imfChan = values[0];
		}

	   
		public function parse_type(values, options) {
			options.reflectionType = values[0];
		}

	  
		public function parseOptions(tokens) {
			var options = {
				colorCorrection: false,
				horizontalBlending: true,
				verticalBlending: true,
				boostMipMapSharpness: 0,
				modifyTextureMap: {
					brightness: 0,
					contrast: 1
				},
				offset: { u: 0, v: 0, w: 0 },
				scale: { u: 1, v: 1, w: 1 },
				turbulence: { u: 0, v: 0, w: 0 },
				clamp: false,
				textureResolution: null,
				bumpMultiplier: 1,
				imfChan: null
			};

			var option;
			var values;
			var optionsToValues = {};

			tokens.reverse();

			while (tokens.length) {
				const token:String = tokens.pop();

				if (token.charAt(0)=="-") {
					option = token.substr(1);
					optionsToValues[option] = [];
				} else {
					optionsToValues[option].push(token);
				}
			}

			for (option in optionsToValues) {
				if (!optionsToValues.hasOwnProperty(option)) {
					continue;
				}
				values = optionsToValues[option];
				var optionMethod = this['parse_'+option];
				if (optionMethod) {
					optionMethod.call(this,values, options);
				}
			}

			return options;
		}

	   
		public function parseMap(tokens) {
			// according to wikipedia:
			// (https://en.wikipedia.org/wiki/Wavefront_.obj_file#Vendor_specific_alterations)
			// there is at least one vendor that places the filename before the options
			// rather than after (which is to spec). All options start with a '-'
			// so if the first token doesn't start with a '-', we're going to assume
			// it's the name of the map file.
			var filename;
			var options;
			if (!tokens[0].charAt(0)=="-") {
				__JS__('[filename, ...options] = tokens;')
			} else {
				filename = tokens.pop();
				options = tokens;
			}

			options = parseOptions(options);
			options["filename"] = filename;
			return options;
		}

	   
		public function parse_map_Ka(tokens) {
			currentMaterial.mapAmbient = parseMap(tokens);
		}

	   
		public function parse_map_Kd(tokens) {
			currentMaterial.mapDiffuse = parseMap(tokens);
		}

		public function parse_map_Ks(tokens) {
			currentMaterial.mapSpecular = parseMap(tokens);
		}

	   
		public function parse_map_Ke(tokens) {
			currentMaterial.mapEmissive = parseMap(tokens);
		}

	   
		public function parse_map_Ns(tokens) {
			currentMaterial.mapSpecularExponent = parseMap(tokens);
		}

	 
		public function parse_map_d(tokens) {
			currentMaterial.mapDissolve = parseMap(tokens);
		}

	 
		public function parse_map_aat(tokens) {
			currentMaterial.antiAliasing = tokens[0] == "on";
		}

	 
		public function parse_map_bump(tokens) {
			currentMaterial.mapBump = parseMap(tokens);
		}

	  
		public function parse_bump(tokens) {
			parse_map_bump(tokens);
		}

	  
		public function parse_disp(tokens) {
			currentMaterial.mapDisplacement = parseMap(tokens);
		}

	  
		public function parse_decal(tokens) {
			currentMaterial.mapDecal = parseMap(tokens);
		}

	  
		public function parse_refl(tokens) {
			currentMaterial.mapReflections.push(parseMap(tokens));
		}

   
		public function parse(mtlData:String) {
			var lines:Vector.<String> = mtlData.split(/\r?\n/) as Vector.<String>;
			for (var i:int = 0; i < lines.length; i++) {
				var line:String = __JS__('lines[i].trim()');
				if (!line || line.charAt(0)=="#") {
					continue;
				}

				var tokens:Vector.<String> = line.split(/\s/) as Vector.<String>;
				var directive = tokens[0];
				var parseMethod = this['parse_' + directive];
				if (!parseMethod) {
					console.warn("Don't know how to parse the directive: "+directive);
					continue;
				}
				
				__JS__('[directive, ...tokens] = tokens;');
				parseMethod.call(this, tokens);
			}
			currentMaterial = null;
		}
	}
	
}	