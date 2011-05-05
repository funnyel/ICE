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
module derelict.devil.ilut;

public
{
    import derelict.devil.iluttypes;
    import derelict.devil.ilutfuncs;
}

private
{
    import derelict.util.sharedlib;
    import derelict.util.loader;
}

class DerelictILUTLoader : SharedLibLoader
{
public:
    this()
    {
        super(
            "ilut.dll",
            "libILUT.so",
            ""
        );
    }

protected:
    override void loadSymbols()
    {
        bindFunc(cast(void**)&ilutDisable, "ilutDisable");
        bindFunc(cast(void**)&ilutEnable, "ilutEnable");
        bindFunc(cast(void**)&ilutGetBoolean, "ilutGetBoolean");
        bindFunc(cast(void**)&ilutGetBooleanv, "ilutGetBooleanv");
        bindFunc(cast(void**)&ilutGetInteger, "ilutGetInteger");
        bindFunc(cast(void**)&ilutGetIntegerv, "ilutGetIntegerv");
        bindFunc(cast(void**)&ilutGetString, "ilutGetString");
        bindFunc(cast(void**)&ilutInit, "ilutInit");
        bindFunc(cast(void**)&ilutIsDisabled, "ilutIsDisabled");
        bindFunc(cast(void**)&ilutIsEnabled, "ilutIsEnabled");
        bindFunc(cast(void**)&ilutPopAttrib, "ilutPopAttrib");
        bindFunc(cast(void**)&ilutPushAttrib, "ilutPushAttrib");
        bindFunc(cast(void**)&ilutSetInteger, "ilutSetInteger");
        bindFunc(cast(void**)&ilutRenderer, "ilutRenderer");
        bindFunc(cast(void**)&ilutGLBindTexImage, "ilutGLBindTexImage");
        bindFunc(cast(void**)&ilutGLBindMipmaps, "ilutGLBindMipmaps");
        bindFunc(cast(void**)&ilutGLBuildMipmaps, "ilutGLBuildMipmaps");
        bindFunc(cast(void**)&ilutGLLoadImage, "ilutGLLoadImage");
        bindFunc(cast(void**)&ilutGLScreen, "ilutGLScreen");
        bindFunc(cast(void**)&ilutGLScreenie, "ilutGLScreenie");
        bindFunc(cast(void**)&ilutGLSaveImage, "ilutGLSaveImage");
        bindFunc(cast(void**)&ilutGLSetTex, "ilutGLSetTex");
        bindFunc(cast(void**)&ilutGLTexImage, "ilutGLTexImage");
        bindFunc(cast(void**)&ilutGLSubTex, "ilutGLSubTex");

        version(Windows)
        {
            bindFunc(cast(void**)&ilutConvertToHBitmap, "ilutConvertToHBitmap");
            bindFunc(cast(void**)&ilutFreePaddedData, "ilutFreePaddedData");
            bindFunc(cast(void**)&ilutGetBmpInfo, "ilutGetBmpInfo");
            bindFunc(cast(void**)&ilutGetHPal, "ilutGetHPal");
            bindFunc(cast(void**)&ilutGetPaddedData, "ilutGetPaddedData");
            bindFunc(cast(void**)&ilutGetWinClipboard, "ilutGetWinClipboard");
            bindFunc(cast(void**)&ilutLoadResource, "ilutLoadResource");
            bindFunc(cast(void**)&ilutSetHBitmap, "ilutSetHBitmap");
            bindFunc(cast(void**)&ilutSetHPal, "ilutSetHPal");
            bindFunc(cast(void**)&ilutSetWinClipboard, "ilutSetWinClipboard");
            bindFunc(cast(void**)&ilutWinLoadImage, "ilutWinLoadImage");
            bindFunc(cast(void**)&ilutWinLoadUrl, "ilutWinLoadUrl");
            bindFunc(cast(void**)&ilutWinPrint, "ilutWinPrint");
            bindFunc(cast(void**)&ilutWinSaveImage, "ilutWinSaveImage");
        }

        version(linux)
        {
           // TODO
        }
    }
}

DerelictILUTLoader DerelictILUT;

static this()
{
    DerelictILUT = new DerelictILUTLoader();
}

static ~this()
{
    DerelictILUT.unload();
}