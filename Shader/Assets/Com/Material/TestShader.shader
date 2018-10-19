// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShader/TestShader"
{
	Properties{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }

		Pass{
		// Pass for ambient light & first pixel light (directional light)
		Tags{ "LightMode" = "ForwardBase" }

		CGPROGRAM

		// Apparently need to add this declaration 
		#pragma multi_compile_fwdbase	

		#pragma vertex vert
		#pragma fragment frag

				// Need these files to get built-in macros
		#include "Lighting.cginc"
		#include "AutoLight.cginc"

		struct a2v {
			float4 vertex : POSITION;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			SHADOW_COORDS(2)
		};

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);

			TRANSFER_SHADOW(o);

			return o;
		}

		fixed4 frag(v2f i) : SV_Target{

			fixed shadow = SHADOW_ATTENUATION(i);

			return fixed4(shadow, shadow,shadow, 1.0);
		}

		ENDCG
	}
		/*
		Properties
		{
			_MainTex("Base 2D", 2D) = "white"{}
		}

		SubShader
		{
			Tags{ "Queue" = "Geometry+100" "RenderType" = "Opaque" }
			Pass
			{

				CGPROGRAM
				#include "Lighting.cginc"
				#include "AutoLight.cginc"
				#pragma vertex vert
				#pragma fragment frag
				struct a2v
				{
					float4 vertex:POSITION;
				};
				struct v2f
				{
					float4 pos : SV_POSITION;
					SHADOW_COORDS(2)
				};
				v2f vert(appdata_base v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);

					TRANSFER_SHADOW(0);
					return o;
				}
				fixed4 frag(v2f i) : SV_Target
				{

					fixed shadow = SHADOW_ATTENUATION(i);

					return fixed4(shadow, shadow,shadow, 1.0);
				}

				ENDCG
			}
		}
			*/
	}
	FallBack "Specular"
	
}
