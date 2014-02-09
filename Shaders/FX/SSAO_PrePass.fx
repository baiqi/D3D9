//////////////////////////////////////////////////////////////////////////////////////////
// SSAO Pre-Pass Shader
//////////////////////////////////////////////////////////////////////////////////////////
float4x4 	matWorldView;
float4x4 	matWorldViewProjection;

//////////////////////////////////////////////////////////////////////////////////////////
// Structres
//////////////////////////////////////////////////////////////////////////////////////////
struct VS_INPUT
{
	float4 Position : POSITION;
	float3 Normal	: NORMAL;
	float2 Tex		: TEXCOORD0;
};

struct VS_OUTPUT
{
	float4 Pos		: POSITION;
	float3 wvPos	: TEXCOORD0;
	float3 normal	: TEXCOORD1;
	float  depth	: TEXCOORD2;
};
//////////////////////////////////////////////////////////////////////////////////////////
// Vertex Shader
//////////////////////////////////////////////////////////////////////////////////////////
VS_OUTPUT VS_PRE_SSAO(VS_INPUT In)
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	Out.Pos = mul(In.Position, matWorldViewProjection);

	Out.wvPos = mul(In.Position, (float3x3)matWorldView);
	Out.normal = mul(In.Normal, (float3x3)matWorldView);
	
	float depth = mul(In.Position, matWorldView).z;
	Out.depth = depth; // / 10000.0f);

	return Out;
}

//////////////////////////////////////////////////////////////////////////////////////////
// Pixel Shader
//////////////////////////////////////////////////////////////////////////////////////////
float4 PS_PRE_SSAO_POS(VS_OUTPUT In) : COLOR0
{
	float zMax = 2000.0f;
	float depth  = In.depth / zMax;

	return float4(depth, depth, depth, 1.0f); // Depth & Position Information
}

float4 PS_PRE_SSAO_NOR(VS_OUTPUT In) : COLOR0
{
	return float4(In.normal, 1.0f); // Depth & Position Information
}

//////////////////////////////////////////////////////////////////////////////////////////
// Shader Technique
//////////////////////////////////////////////////////////////////////////////////////////
technique SSAO_PrePassPosition
{
	pass p0
    {
        VertexShader = compile vs_3_0 VS_PRE_SSAO();
        PixelShader = compile ps_3_0 PS_PRE_SSAO_POS();
    }
}

technique SSAO_PrePassNormal
{
	pass p0
    {
        VertexShader = compile vs_3_0 VS_PRE_SSAO();
        PixelShader = compile ps_3_0 PS_PRE_SSAO_NOR();
    }
}