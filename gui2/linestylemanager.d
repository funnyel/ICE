
//          Copyright Ferdinand Majerech 2012.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)


/// Style manager that draws widgets as line rectangles.
module gui2.linestylemanager;


import std.algorithm;
import std.array;

import color;
import gui2.stylemanager;
import gui2.widgetutils;
import math.rect;
import math.vector2;
import video.videodriver;
import util.yaml;


/// Style manager that draws widgets as line rectangles.
///
/// Widgets with this style manager have no background, only a border;
/// they are completely transparent. This is the most basic style manager - 
/// it's a placeholder before something more elaborate is implemented.
class LineStyleManager: StyleManager
{
public:
    /// LineStyleManager style.
    struct Style
    {
        /// Name of the style. Empty for default style.
        string name;
        /// Font used to draw text.
        string font       = "default";
        /// Color of widget border.
        Color borderColor = rgba!"FFFFFF60";
        /// Color of font used to draw text.
        Color fontColor   = rgba!"FFFFFF60";
        /// Font size in points.
        uint fontSize     = 12;
        /// Draw border of the widget?
        bool drawBorder   = true;

        /// Construct a LineStyleManager style.
        ///
        /// Params: yaml = YAML to load the style from.
        ///         name = Name of the style (empty string for default).
        ///
        /// Throws: StyleInitException on error.
        this(ref YAMLNode yaml, string name)
        {
            this.name   = name;
            drawBorder  = styleInitPropertyOpt(yaml, "drawBorder",  drawBorder);
            borderColor = styleInitPropertyOpt(yaml, "borderColor", borderColor);
            fontColor   = styleInitPropertyOpt(yaml, "fontColor",   fontColor);
            font        = styleInitPropertyOpt(yaml, "font",        font);
            fontSize    = styleInitPropertyOpt(yaml, "fontSize",    fontSize);
        }
    }

private:
    // Styles managed (e.g. default, mouse over, etc.)
    Style[] styles_;
    // Currently used style.
    Style style_;

public:
    /// Construct a LineStyleManager with specified styles.
    this(ref Style[] styles)
    {
        bool defStyle(ref Style s){return s.name == "";}
        auto searchResult = styles.find!defStyle();
        style_  = searchResult.empty ? Style.init : searchResult.front;
        styles_ = styles;
    }

    override void drawWidgetRectangle(VideoDriver video, ref const Recti area)
    {
        video.drawRect(area.min.to!float, area.max.to!float, style_.borderColor);
    }

    override void drawText
        (VideoDriver video, const string text, const Vector2i position)
    {
        video.font     = style_.font;
        video.fontSize = style_.fontSize;
        video.drawText(position, text, style_.fontColor);
    }
}
