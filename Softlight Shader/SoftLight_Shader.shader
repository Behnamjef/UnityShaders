Shader "Custom/SoftLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlendTex ("Blend Texture", 2D) = "white" {}
    }
 
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"
 
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
 
            sampler2D _MainTex;
            sampler2D _BlendTex;
 
            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;
                return OUT;
            }
 
            fixed4 frag(v2f IN) : SV_Target
            {
                fixed4 baseColor = tex2D(_MainTex, IN.uv);
                fixed4 blendColor = tex2D(_BlendTex, IN.uv);
 
                fixed4 resultColor;
                resultColor.rgb = (blendColor.rgb < 0.5) ? (2 * baseColor.rgb * blendColor.rgb + baseColor.rgb * baseColor.rgb * (1 - 2 * blendColor.rgb)) : (sqrt(baseColor.rgb) * (2 * blendColor.rgb - 1) + (2 * baseColor.rgb) * (1 - blendColor.rgb));
                resultColor.a = baseColor.a * blendColor.a; // Multiply alpha channels
 
                return resultColor;
            }
            ENDCG
        }
    }
}
