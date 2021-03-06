
//          Copyright Ferdinand Majerech 2010 - 2012.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)


///OpenGL vertex.
module video.glvertex;


import math.vector2;
import color;


///Vertex type enum.
package enum GLVertexType
{
    ///Vertex with position and color.
    Colored,
    ///Vertex with position, color and texture coordinate.
    Textured
}

///Vertex with position and color.
package align(4) struct GLVertex2DColored
{
    ///Vertex position.
    Vector2f vertex;
    ///Vertex color.
    Color color;

    ///Offset of GLVertex2DColored.vertex relative to the struct in bytes.
    static immutable vertexOffset = 0;
    ///Offset of GLVertex2DColored.color relative to the struct in bytes.
    static immutable colorOffset = 8;
    ///Enum value corresponding to this vertex type.
    static immutable vertexType = GLVertexType.Colored;
}

///Vertex with position, color and texture coordinate.
package align(4) struct GLVertex2DTextured
{
    ///Vertex position.
    Vector2f vertex;
    ///Vertex texcoord.
    Vector2f texcoord;
    ///Vertex color.
    Color color;

    ///Offset of GLVertex2DTextured.vertex relative to the struct in bytes.
    static immutable vertexOffset = 0;
    ///Offset of GLVertex2DTextured.texcoord relative to the struct in bytes.
    static immutable texcoordOffset = 8;
    ///Offset of GLVertex2DTextured.color relative to the struct in bytes.
    static immutable colorOffset = 16;
    ///Enum value corresponding to this vertex type.
    static immutable vertexType = GLVertexType.Textured;
}
