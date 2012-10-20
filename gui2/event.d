
//          Copyright Ferdinand Majerech 2012.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)


/// Base class for all events.
module gui2.event;


import gui2.widget;


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

    /// Return the parent widget the event sunk from when sinking.
    @property Widget sunkFrom()
    {
        assert(status_ == Status.Sinking,
               "Trying to get the widget we sunk from when not sinking");
        return sunkFrom_;
    }

    /// Is the widget sinking or bubbling?
    @property Status status() const pure nothrow {return status_;}

package:
    // Specifies whether the event is sinking down or bubbling up the widget tree.
    //
    // Only Widget can set this as it traverses its subwidgets passing an event.
    Status status_;

    // Widget that handled the event previously during sinking.
    //
    // Used to pass the parent widget for various events.
    Widget sunkFrom_;
}

/// Used when widgets need to be resized. Passed before ExpandEvent.
///
/// An example is when a RootWidget is connected to a SlotWidget - all widgets
/// in the RootWidget's subtree need to be resized.
class MinimizeEvent : Event
{
}

/// Used when widgets need to be resized. Passed after MinimizeEvent.
///
/// Handled when sinking, passing the parent widget for the children to expand into.
///
/// SeeAlso: MinimizeEvent
class ExpandEvent : Event
{
}
