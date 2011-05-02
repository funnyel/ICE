/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.devil.ilu;

public
{
    import derelict.devil.ilutypes;
    import derelict.devil.ilufuncs;
}

private
{
    import derelict.util.sharedlib;
    import derelict.util.loader;
}

class DerelictILULoader : SharedLibLoader
{
public:
    this()
    {
        super(
             "ilu.dll",
            "libILU.so",
            ""
        );
    }

protected:
    override void loadSymbols()
    {
        bindFunc(cast(void**)&iluAlienify, "iluAlienify");
        bindFunc(cast(void**)&iluBlurAvg, "iluBlurAvg");
        bindFunc(cast(void**)&iluBlurGaussian, "iluBlurGaussian");
        bindFunc(cast(void**)&iluBuildMipmaps, "iluBuildMipmaps");
        bindFunc(cast(void**)&iluColoursUsed, "iluColoursUsed");
        bindFunc(cast(void**)&iluCompareImage, "iluCompareImage");
        bindFunc(cast(void**)&iluContrast, "iluContrast");
        bindFunc(cast(void**)&iluCrop, "iluCrop");
        bindFunc(cast(void**)&iluDeleteImage, "iluDeleteImage");
        bindFunc(cast(void**)&iluEdgeDetectE, "iluEdgeDetectE");
        bindFunc(cast(void**)&iluEdgeDetectP, "iluEdgeDetectP");
        bindFunc(cast(void**)&iluEdgeDetectS, "iluEdgeDetectS");
        bindFunc(cast(void**)&iluEmboss, "iluEmboss");
        bindFunc(cast(void**)&iluEnlargeCanvas, "iluEnlargeCanvas");
        bindFunc(cast(void**)&iluEnlargeImage, "iluEnlargeImage");
        bindFunc(cast(void**)&iluEqualize, "iluEqualize");
        bindFunc(cast(void**)&iluErrorString, "iluErrorString");
        bindFunc(cast(void**)&iluConvolution, "iluConvolution");
        bindFunc(cast(void**)&iluFlipImage, "iluFlipImage");
        bindFunc(cast(void**)&iluGammaCorrect, "iluGammaCorrect");
        bindFunc(cast(void**)&iluGenImage, "iluGenImage");
        bindFunc(cast(void**)&iluGetImageInfo, "iluGetImageInfo");
        bindFunc(cast(void**)&iluGetInteger, "iluGetInteger");
        bindFunc(cast(void**)&iluGetIntegerv, "iluGetIntegerv");
        bindFunc(cast(void**)&iluGetString, "iluGetString");
        bindFunc(cast(void**)&iluImageParameter, "iluImageParameter");
        bindFunc(cast(void**)&iluInit, "iluInit");
        bindFunc(cast(void**)&iluInvertAlpha, "iluInvertAlpha");
        bindFunc(cast(void**)&iluLoadImage, "iluLoadImage");
        bindFunc(cast(void**)&iluMirror, "iluMirror");
        bindFunc(cast(void**)&iluNegative, "iluNegative");
        bindFunc(cast(void**)&iluNoisify, "iluNoisify");
        bindFunc(cast(void**)&iluPixelize, "iluPixelize");
        bindFunc(cast(void**)&iluRegionfv, "iluRegionfv");
        bindFunc(cast(void**)&iluRegioniv, "iluRegioniv");
        bindFunc(cast(void**)&iluReplaceColour, "iluReplaceColour");
        bindFunc(cast(void**)&iluRotate, "iluRotate");
        bindFunc(cast(void**)&iluRotate3D, "iluRotate3D");
        bindFunc(cast(void**)&iluSaturate1f, "iluSaturate1f");
        bindFunc(cast(void**)&iluSaturate4f, "iluSaturate4f");
        bindFunc(cast(void**)&iluScale, "iluScale");
        bindFunc(cast(void**)&iluScaleColours, "iluScaleColours");
        bindFunc(cast(void**)&iluSetLanguage, "iluSetLanguage");
        bindFunc(cast(void**)&iluSharpen, "iluSharpen");
        bindFunc(cast(void**)&iluSwapColours, "iluSwapColours");
        bindFunc(cast(void**)&iluWave, "iluWave");
    }
}

DerelictILULoader DerelictILU;

static this()
{
    DerelictILU = new DerelictILULoader();
}

static ~this()
{
    DerelictILU.unload();
}