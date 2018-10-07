// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/TankShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_COLOR("TextColor",Color) = (1.0,1.0,1.0,1.0)
	}
	SubShader
	{
		Tags{"LightMode" = "ForwardBase"}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _COLOR;
			struct invert
			{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcorrd:TEXCOORD0;
			};
			struct infrag
			{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				//fixed3 color : COLOR0;
			};
			infrag vert(invert VertInfo)
			{
				infrag OutPut;
				OutPut.pos = UnityObjectToClipPos(VertInfo.vertex);
				/*
				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(mul((float3x3)unity_ObjectToWorld,VertInfo.normal));
				//
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _COLOR.rgb * saturate(dot(worldNormal, worldLight));
				OutPut.color = ambient +diffuse;
				*/
				OutPut.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, VertInfo.normal));

				return OutPut;
			}

			fixed4 frag(infrag FragInfo) :SV_TARGET
			{
				//return fixed4(FragInfo.color,1.0);
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _COLOR.rgb * (dot(FragInfo.worldNormal, worldLight)*0.5 + 0.5);
				return fixed4(diffuse, 1.0);
			}
			ENDCG
		}		
	}	
}
