
//          Copyright Ferdinand Majerech 2012.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)


/// Base class for all events.
module gui2.event;


/// Base class for all events.
///
/// Propagated recursively through the widget tree. Widgets can register handler 
/// functions to react to events (e.g. rendering, user input, layout resizing, etc.).
class Event 
{
public:
    /// Specifies whether the event is moving down (sinking) or up (bubbling) the widget tree.
    enum Status
    {
        /// The event is sinking into subwidgets.
        Sinking,
        /// The event is bubbling back to parent widgets.
        Bubbling
    }

package:
    // Specifies whether the event is sinking or bubbling the widget tree.
    //
    // Only Widget can set this as it traverses its subwidgets passing an event.
    Status status_;
}
