#pragma header

uniform float scale;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 snappedUV = floor(uv * scale) / scale;
    gl_FragColor = texture2D(bitmap, snappedUV);
}
