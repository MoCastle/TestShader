// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

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
		_NormalTex("NormalTextrure",2D) = "white"{}
		_SpeTex("SpeTextrure",2D) = "white"{}
		_Gloss("GLOSS",Range(8.0,256)) = 20
		_BumpScale("BumpScale",Float) = 1.0
		_RampTex("RampTex",2D) = "white"{}
		_DiffColor("DiffColor",Color) = (1,1,1,1)
	}
	SubShader
	{
			Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CULL Front
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct a2v
			{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};
			struct v2f
			{
				float4 pos:SV_POSITION;
			};
			v2f vert(a2v v)
			{
				v2f o;
				float3 Dir = normalize(v.vertex.xyz);
				float D = dot(Dir, v.normal);
				o.pos = UnityObjectToClipPos(v.vertex + v.normal*0.0002);
				return o;
			}

			fixed4 frag(v2f i) :SV_TARGET
			{
				return fixed4(0,0,0,1.0);
			}
			ENDCG
		}
		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _COLOR;
			float _Gloss;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalTex;
			float4 _NormalTex_ST;
			float _BumpScale;
			sampler2D _SpeTex;
			sampler2D _RampTex;
			float _RampTex_ST;
			float4 _DiffColor;
			struct invert
			{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
				float4 texcorrd:TEXCOORD0;
			};
			struct v2f
			{
				float4 pos:SV_POSITION;
				float3 tangentLightDir:TEXCOORD0;
				float3 tangentViewDir:TEXCOORD1;
				
				SHADOW_COORDS(2)
				float3 worldPos:TEXCOORD3;
				float3 worldNormal:TEXCOORD4;
				float4 uv:TEXCOORD5;
			};
			v2f vert(invert v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcorrd, _MainTex);
				TANGENT_SPACE_ROTATION;
				fixed3 worldLight = normalize(ObjSpaceLightDir(v.vertex));
				fixed3 viewDir = normalize(ObjSpaceViewDir(v.vertex));

				o.tangentLightDir = normalize(mul(rotation, worldLight));
				o.tangentViewDir = normalize(mul(rotation, viewDir));

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldPos = worldPos;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldNormal = worldNormal;

				float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				float3 worldBinormal = cross(o.worldNormal, worldTangent)*v.tangent.w;

				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) :SV_TARGET
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 tangentNormal = tex2D(_NormalTex, i.uv.xy).rgb ;
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
				fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb;
				fixed halflamb = pow(dot(i.worldNormal, UnityWorldSpaceLightDir(i.worldPos))*0.5 + 0.5, 2);
				fixed3 diffuse = _LightColor0.rgb *pow(tex2D(_RampTex, fixed2(halflamb, halflamb)).rgb,2);
				


				fixed3 halfv = normalize( i.tangentViewDir + i.tangentLightDir);
				fixed3 specularmap = pow(tex2D(_SpeTex, i.uv.xy).rgb,4);
				fixed3 specular = _LightColor0.rgb *specularmap* pow(saturate( dot( tangentNormal, halfv ) ), _Gloss);

				fixed shadow = SHADOW_ATTENUATION(i);
				//return fixed4(tangentNormal.z, tangentNormal.z, tangentNormal.z,1);
				diffuse *= 10;
				diffuse -= 5;
				diffuse = fixed3(saturate( diffuse.r)*shadow, saturate( diffuse.g)*shadow, saturate( diffuse.b)*shadow);
				//fixed3 color = fixed3(pow(albedo.r, 2 - diffuse.r), pow(albedo.g, 2 - diffuse.g), pow(albedo.b, 2 - diffuse.b));
				fixed3 color = fixed3(pow(albedo, 2 - diffuse));
				fixed3 Light = (diffuse)*1.5 + 0.5;
				return fixed4(albedo*Light, 1.0);
				//return fixed4(1 - diffuse, 1.0);
			}
			ENDCG
		}

		
	}	
	FallBack "Specular"
		
}
