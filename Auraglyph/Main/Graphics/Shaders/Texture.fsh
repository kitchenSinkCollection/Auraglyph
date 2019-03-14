//
//  Shader.fsh
//  Auragraph
//
//  Created by Spencer Salazar on 8/2/13.
//  Copyright (c) 2013 Spencer Salazar. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec2 texcoord;

uniform sampler2D tex;

void main()
{
    gl_FragColor = colorVarying * vec4(0.75, 0.5, 0.0, 1.0) * texture2D(tex, texcoord);
}

