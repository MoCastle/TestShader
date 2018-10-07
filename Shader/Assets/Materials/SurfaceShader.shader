Shader "MyShader/SurfaceShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		CGPROGRAM
		#pragma surface surf Lambert
		struct Input
		{
			float4 color:COLOR;
		};
		void surf(Input In, inout SurfaceOutput o)
		{
			o.Albedo = 1;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
