
//          Copyright Ferdinand Majerech 2010 - 2012.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)


///Shader handle.
module video.shader;
@trusted


///Exception thrown at shader related errors.
class ShaderException : Exception{this(string msg){super(msg);}} 

///Opague and immutable shader handle used used by code outside video subsystem.
struct Shader
{
    package:
        ///Index of the shader in VideoDriver implementation.
        uint index;
}
