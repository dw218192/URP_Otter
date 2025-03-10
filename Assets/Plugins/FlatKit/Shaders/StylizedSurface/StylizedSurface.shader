﻿Shader "FlatKit/Stylized Surface"
{
    Properties
    {
        [MainColor] _BaseColor ("Color", Color) = (1,1,1,1)
        
        [Space(10)]
        [KeywordEnum(None, Single, Steps, Curve)]_CelPrimaryMode("Cel Shading Mode", Float) = 1
        _ColorDim ("[_CELPRIMARYMODE_SINGLE]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _ColorDimSteps ("[_CELPRIMARYMODE_STEPS]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _ColorDimCurve ("[_CELPRIMARYMODE_CURVE]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SelfShadingSize ("[_CELPRIMARYMODE_SINGLE]Self Shading Size", Range(0, 1)) = 0.5
        _ShadowEdgeSize ("[_CELPRIMARYMODE_SINGLE]Shadow Edge Size", Range(0, 0.5)) = 0.05
        _Flatness ("[_CELPRIMARYMODE_SINGLE]Localized Shading", Range(0, 1)) = 1.0
        
        [IntRange]_CelNumSteps ("[_CELPRIMARYMODE_STEPS]Number Of Steps", Range(1, 10)) = 3.0
        _CelStepTexture ("[_CELPRIMARYMODE_STEPS][LAST_PROP_STEPS]Cel steps", 2D) = "black" {}
        _CelCurveTexture ("[_CELPRIMARYMODE_CURVE][LAST_PROP_CURVE]Ramp", 2D) = "black" {}
        
        [Space(10)]
        [Toggle(DR_CEL_EXTRA_ON)] _CelExtraEnabled("Enable Extra Cel Layer", Int) = 0
        _ColorDimExtra ("[DR_CEL_EXTRA_ON]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SelfShadingSizeExtra ("[DR_CEL_EXTRA_ON]Self Shading Size", Range(0, 1)) = 0.6
        _ShadowEdgeSizeExtra ("[DR_CEL_EXTRA_ON]Shadow Edge Size", Range(0, 0.5)) = 0.05
        _FlatnessExtra ("[DR_CEL_EXTRA_ON]Localized Shading", Range(0, 1)) = 1.0
        
        [Space(10)]
        [Toggle(DR_SPECULAR_ON)] _SpecularEnabled("Enable Specular", Int) = 0
        [HDR] _FlatSpecularColor("[DR_SPECULAR_ON]Specular Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _FlatSpecularSize("[DR_SPECULAR_ON]Specular Size", Range(0.0, 1.0)) = 0.1
        _FlatSpecularEdgeSmoothness("[DR_SPECULAR_ON]Specular Edge Smoothness", Range(0.0, 1.0)) = 0
        
        [Space(10)]
        [Toggle(DR_RIM_ON)] _RimEnabled("Enable Rim", Int) = 0
        [HDR] _FlatRimColor("[DR_RIM_ON]Rim Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _FlatRimLightAlign("[DR_RIM_ON]Light Align", Range(0.0, 1.0)) = 0
        _FlatRimSize("[DR_RIM_ON]Rim Size", Range(0, 1)) = 0.5
        _FlatRimEdgeSmoothness("[DR_RIM_ON]Rim Edge Smoothness", Range(0, 1)) = 0.5
        
        [Space(10)]
        [Toggle(DR_GRADIENT_ON)] _GradientEnabled("Enable Height Gradient", Int) = 0
        [HDR] _ColorGradient("[DR_GRADIENT_ON]Gradient Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _GradientCenterX("[DR_GRADIENT_ON]Center X", Float) = 0
        _GradientCenterY("[DR_GRADIENT_ON]Center Y", Float) = 0
        _GradientSize("[DR_GRADIENT_ON]Size", Float) = 10.0
        _GradientAngle("[DR_GRADIENT_ON]Gradient Angle", Range(0, 360)) = 0
        
        [Space(10)]
        [Toggle(DR_VERTEX_COLORS_ON)] _VertexColorsEnabled("Enable Vertex Colors", Int) = 0

        _LightContribution("[FOLDOUT(Advanced Lighting){5}]Light Color Contribution", Range(0, 1)) = 0
        _LightFalloffSize("Falloff size (point / spot)", Range(0.0001, 1)) = 0.0001

        // Used to provide light direction to cel shading if all light in the scene is baked.
        [Space]
        [Toggle(DR_ENABLE_LIGHTMAP_DIR)]_OverrideLightmapDir("Override light direction", Int) = 0
        _LightmapDirectionPitch("[DR_ENABLE_LIGHTMAP_DIR]Pitch", Range(0, 360)) = 0
        _LightmapDirectionYaw("[DR_ENABLE_LIGHTMAP_DIR]Yaw", Range(0, 360)) = 0
        [HideInInspector] _LightmapDirection("Direction", Vector) = (0, 1, 0, 0)

        [KeywordEnum(None, Multiply, Color)] _UnityShadowMode ("[FOLDOUT(Unity Built-in Shadows){4}]Mode", Float) = 0
        _UnityShadowPower("[_UNITYSHADOWMODE_MULTIPLY]Power", Range(0, 1)) = 0.2
        _UnityShadowColor("[_UNITYSHADOWMODE_COLOR]Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _UnityShadowSharpness("Sharpness", Range(1, 10)) = 1.0

        [MainTexture] _BaseMap("[FOLDOUT(Texture maps){4}]Albedo", 2D) = "white" {}
        [Space][KeywordEnum(Multiply, Add)]_TextureBlendingMode("[_]Blending Mode", Float) = 0
        [Space]_TextureImpact("[_]Texture Impact", Range(0, 1)) = 1.0
        [Space(20)]_BumpMap ("Bump Map", 2D) = "bump" {}

        [HideInInspector] _Cutoff ("Base Alpha cutoff", Range (0, 1)) = .5

        // Blending state
        [HideInInspector] _Surface("__surface", Float) = 0.0
        [HideInInspector] _Blend("__blend", Float) = 0.0
        [HideInInspector] _AlphaClip("__clip", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 1.0
        [HideInInspector] _DstBlend("__dst", Float) = 0.0
        [HideInInspector] _ZWrite("__zw", Float) = 1.0
        [HideInInspector] _Cull("__cull", Float) = 2.0

        // Editmode props
        [HideInInspector] _QueueOffset("Queue offset", Float) = 0.0
    }

    SubShader
    {
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"}
        LOD 300

        Pass
        {
            Name "ForwardLit"
            Tags {"LightMode" = "UniversalForward"}

            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM

            #pragma shader_feature_local __ _CELPRIMARYMODE_SINGLE _CELPRIMARYMODE_STEPS _CELPRIMARYMODE_CURVE
            #pragma shader_feature_local DR_CEL_EXTRA_ON
            #pragma shader_feature_local DR_GRADIENT_ON
            #pragma shader_feature_local DR_SPECULAR_ON
            #pragma shader_feature_local DR_RIM_ON
            #pragma shader_feature_local DR_VERTEX_COLORS_ON
            #pragma shader_feature_local __ _UNITYSHADOWMODE_MULTIPLY _UNITYSHADOWMODE_COLOR
            #pragma shader_feature_local _TEXTUREBLENDINGMODE_MULTIPLY _TEXTUREBLENDINGMODE_ADD

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _ _SPECGLOSSMAP _SPECULAR_COLOR
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex StylizedPassVertex
            #pragma fragment StylizedPassFragment
            #define BUMP_SCALE_NOT_SUPPORTED 1

            // TODO: Toggle _NORMALMAP from the editor script.
            #define _NORMALMAP

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "LibraryUrp/LitForwardPass_DR.hlsl"
            #include "LibraryUrp/Lighting_DR.hlsl"

            ENDHLSL
        }

        // All the following passes are from URP SimpleLit.shader.
        // UsePass "Universal Render Pipeline/Simple Lit/..." - not included in build and produces z-buffer glitches in
        // local and global outlines combination.
       
        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "GBuffer"
            Tags{"LightMode" = "UniversalGBuffer"}

            ZWrite[_ZWrite]
            ZTest LEqual
            Cull[_Cull]

            HLSLPROGRAM

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            //#pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _ _SPECGLOSSMAP _SPECULAR_COLOR
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            //#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            //#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex LitPassVertexSimple
            #pragma fragment LitPassFragmentSimple
            #define BUMP_SCALE_NOT_SUPPORTED 1

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitGBufferPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }

        // This pass is used when drawing to a _CameraNormalsTexture texture
        Pass
        {
            Name "DepthNormals"
            Tags{"LightMode" = "DepthNormals"}

            ZWrite On
            Cull[_Cull]

            HLSLPROGRAM

            #pragma vertex DepthNormalsVertex
            #pragma fragment DepthNormalsFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthNormalsPass.hlsl"
            ENDHLSL
        }

        // This pass it not used during regular rendering, only for lightmap baking.
        Pass
        {
            Name "Meta"
            Tags{ "LightMode" = "Meta" }

            Cull Off

            HLSLPROGRAM

            #pragma vertex UniversalVertexMeta
            #pragma fragment UniversalFragmentMetaSimple

            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _SPECGLOSSMAP

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Universal2D"
            Tags{ "LightMode" = "Universal2D" }
            Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON

            #include "LibraryUrp/StylizedInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/Utils/Universal2D.hlsl"
            ENDHLSL
        }


        Pass
        {
            Name "WorldSpaceOutline"
            Tags{ "LightMode" = "WorldSpaceOutline" "DisableBatching" = "True" }
            ZTest LEqual
            ZWrite Off
            Cull[_Cull]

             //Stencil
             //{
             //    Ref 255
             //    Comp NotEqual
             //    Pass Replace
             //}

            HLSLPROGRAM


            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #include "Assets/Shaders/include/EncodingHelper.hlsl"

            #pragma enable_d3d11_debug_symbols
            //#pragma shader_feature __WRITE_SHORELINE_BUFFER

            #pragma vertex vert
            #pragma fragment frag

            //float3 _ShorelineExpansionStart, _ShorelineExpansionEnd;
            float _ShorelineMaxDepth;
            sampler2D _WaterDepthBuffer;

            struct Attributes
            {
                float4 vertex : POSITION;
            };
            struct v2f
            {
                float3 WPOS : TEXCOORD0;
                float3 WPOS_ORIG : TEXCOORD1;
                nointerpolation float3 WO : TEXCOORD2;
                float4 SPOS : TEXCOORD3;
                float4 CPOS : SV_POSITION;
            };

            inline void GetWaterDepth(v2f i, out float scene_depth, out float surface_depth)
            {
                const float is_ortho = unity_OrthoParams.w;
                const float is_persp = 1.0 - unity_OrthoParams.w;

                float depth = i.CPOS.z;
                scene_depth = lerp(_ProjectionParams.z, _ProjectionParams.y, depth) * is_ortho +
                    LinearEyeDepth(depth, _ZBufferParams) * is_persp;

                //const float2 uv = i.CPOS.xy / i.CPOS.w * 0.5 + 0.5;
                const float2 uv = i.SPOS.xy / i.SPOS.w;
                depth = tex2D(_WaterDepthBuffer, uv).r;

                if (depth == 0.0) depth = 1.0;

                surface_depth = lerp(_ProjectionParams.z, _ProjectionParams.y, depth) * is_ortho +
                    LinearEyeDepth(depth, _ZBufferParams) * is_persp;
            }

            v2f vert(Attributes i)
            {
                v2f o;
                o.WO = TransformObjectToWorld(float3(0, 0, 0));
                o.WPOS_ORIG = TransformObjectToWorld(i.vertex);
                float3 tmp = o.WPOS_ORIG - o.WO;
                tmp.y = 0;
                //#ifdef  __WRITE_SHORELINE_BUFFER
                //    o.WPOS = o.WPOS_ORIG + normalize(tmp) * _ShorelineExpansionEnd;
                //#else
                //    o.WPOS = o.WPOS_ORIG + normalize(tmp) * _ShorelineExpansionStart;
                //#endif
                //o.CPOS = TransformWorldToHClip(o.WPOS);
                o.WPOS = o.WPOS_ORIG;
                o.CPOS = TransformWorldToHClip(o.WPOS_ORIG);
                o.SPOS = ComputeScreenPos(o.CPOS);
                return o;
            }
            half frag(v2f i/*, out half z_overwrite : SV_Depth*/) : SV_Target
            {
                float scene_depth, surface_depth;
                GetWaterDepth(i, scene_depth, surface_depth);
                if (abs(scene_depth - surface_depth) > _ShorelineMaxDepth) discard;
                //#ifdef  __WRITE_SHORELINE_BUFFER
                    return 1.0;
                //float3 worldPos = _WorldSpaceCameraPos + normalize(i.WPOS - _WorldSpaceCameraPos) * surface_depth;
                //    float3 dir = worldPos - i.WO;
                //    dir.y = 0;
                //    float dist = length(dir);
                //    dir = normalize(dir);
                //    float dir_out = atan2(dir.z, dir.x) / TWO_PI + 0.499999999;
                //    uint dir_packed = uint(dir_out * 255) << 16;
                //    return asfloat(0xff000000u | dir_packed | f32tof16(dist)); // weight, dir, dist
                //#else
                //    return 0;
                //#endif
            }
            ENDHLSL
        }
    }

    Fallback "Hidden/Universal Render Pipeline/FallbackError"
    CustomEditor "StylizedSurfaceEditor"
}
