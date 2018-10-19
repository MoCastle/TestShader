// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/AlphaShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Cutoff("Alpha Cutoff",Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags { "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType"="TransparentCutout" }
		LOD 100
			/*
		Pass
		{
			ZWrite On
			ColorMask 0
		}*/
		Pass
		{
			Tags{"LightMode" = "ForwardBase"}
			ZWrite Off
			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 texColor = tex2D(_MainTex,i.uv);
				clip(texColor.a - _Cutoff);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				fixed3 albedo = texColor.rgb;
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
				//fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot())

				//return fixed4(albedo,1.0 );
				return fixed4(albedo,0.7);
			}
			ENDCG
		}
		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			ZWrite Off
			Cull Back
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
							// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 texColor = tex2D(_MainTex,i.uv);
				clip(texColor.a - _Cutoff);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				fixed3 albedo = texColor.rgb;
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
				//fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot())
				//return fixed4(albedo,1.0 );
				return fixed4(albedo,0.7);
			}
			ENDCG
		}
	}
}
