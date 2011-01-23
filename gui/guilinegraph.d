module gui.guilinegraph;


import std.math;
import std.string;

import video.videodriver;
import math.math;
import math.vector2;
import gui.guigraph;
import time.time;
import time.timer;
import color;

///Line graph widget, showing changing values system monitor style.
final class GUILineGraph : GUIGraph
{
    invariant
    {
        assert(data_point_time_ > 0.0, "Graph data point time period must be more than 0");
        assert(scale_x_ > 0.0, "Graph X scale must be more than 0");
        assert(scale_y_ > 0.0, "Graph Y scale must be more than 0");
    }

    private:
        ///Stores data used to display graph of one value (GuiGraph.Graph class)
        static class GraphDisplay
        {
            //Is this graph visible?
            bool visible = true;
            //Color of the graph.
            Color color = Color(128, 128, 128, 255);
            //Vertices of the line strip used to display the graph, in screen space.
            Vector2f[] line_strip;
        }

        //Horizontal line on the graph.
        static align(1) struct Line
        {
            //Info text of the line (i.e. number represented by the line)
            string text;
            //Color of the line and its text.
            Color color;
            //Y coordinate the line is at.
            float y;
        }

        //Time offset of the graph view (used for scrolling)
        //Time offset is actually time since start of graph the data point
        //at the left end of graph display is showing.
        float time_offset_ = 0.0;
        //Distance between two data points on X axis
        float scale_x_ = 1.0;
        //Distance between values differing by 1, e.g. 1.0 and 0.0 on Y axis.
        //Doesn't apply when auto_scale_ is true.
        float scale_y_ = 0.1;
        //Automatically scroll the graph view?
        bool auto_scroll_ = true;
        //If true, highest value is always at the top of graph display and height
        //of the graph is scaled accordingly.
        bool auto_scale_ = true;

        //Display data for graph of every value.
        GraphDisplay[string] graphics_;
        //Horizontal lines on the graph.
        Line[] lines_;
        //Font size used for numbers describing values represented by the lines.
        uint font_size_ = 8;

        //Time between two data points displayed on the graph.
        real data_point_time_ = 1.0;
        //Timer used to time graph display updates.
        Timer display_timer_;

    public:
        /**
         * Construct a line graph with specified names of measured values.
         *
         * Params:  graph_names = Names of values shown in the graph.
         */
        this(string[] graph_names ...)
        {
            super(graph_names);
            reset_timer(get_time());
            foreach(name; graph_names){graphics_[name] = new GraphDisplay;}
        }

        ///Set time between two graph data points.
        void data_point_time(real time)
        {
            aligned_ = false;
            //limiting to prevent absurd values
            data_point_time_ = clamp(time, time_resolution_, 64.0L);
        }

        ///Return time between two graph data points.
        real data_point_time(){return data_point_time_;}

        ///Toggle visibility of graph of specified value.
        void toggle_value(string value)
        {
            auto graphics = graphics_[value];
            graphics.visible = !graphics.visible;
        }

        /**
         * Set color of graph of specified value.
         *
         * Params:  value = Value to set color for.
         *          color = Color to set.
         */
        void color(string value, Color color){graphics_[value].color = color;}

        ///If true, Y axis of the graph will be scaled automatically according to highest value.
        void auto_scale(bool scale){aligned_ = false; auto_scale_ = scale;}

        ///If true, graph will automatically scroll to show newest data.
        void auto_scroll(bool scroll){aligned_ = false; auto_scroll_ = scroll;}

        ///Set time offset of the graph. Used for manual scrolling.
        void time_offset(float offset)
        {
            aligned_ = false; 
            //limiting to prevent absurd values
            time_offset_ = clamp(cast(real)offset, 0.0L, age());
        }

        ///Manually scrolls the graph horizontally.
        void scroll(float offset)
        {
            auto_scroll = false;

            //convert time offset to screen space, modify it and convert back to time.
            float conv = data_point_time_ / scale_x;
            float space_offset = time_offset_ / conv + offset;
            time_offset(space_offset * conv);
        }

        ///Set X scale of the graph. Used for manual zooming.
        void scale_x(float scale_x){aligned_ = false; scale_x_ = clamp(scale_x, 0.005f, 100.0f);}

        ///Set Y scale of the graph. Used for manual zooming.
        void scale_y(float scale_y){aligned_ = false; scale_y_ = clamp(scale_y, 0.0005f, 10.0f);}

        ///Get time offset of the graph. 
        float time_offset(){return time_offset_;}

        ///Get X scale of the graph.
        float scale_x(){return scale_x_;}

        ///Get Y scale of the graph. 
        float scale_y(){return scale_y_;}

        ///Set font size of this graph.
        void font_size(uint size){font_size_ = size;}

    protected:
        override void update()
        {
            super.update();

            real time = get_time();
            //time to update display
            if(display_timer_.expired(time))
            {
                update_view();
                reset_timer(time);
            }
        }

        override void draw()
        {
            if(!visible_){return;}

            super.draw();

            foreach(graph; graphs_.keys){draw_graph(graph);}
            draw_info();
        }

        override void realign()
        {
            super.realign();

            update_view();
        }

    private:
        //Resets update timer according to data point time, starting at specified time.
        void reset_timer(real time)
        {
            //limiting to prevent absurd values (and lag)
            display_timer_ = Timer(clamp(data_point_time_, 0.125L, 8.0L), time);
        }

        //Returns age of this timer at last display timer reset.
        real age()
        {
            return display_timer_.start - start_time_;
        }

        //This is quite ineffective (associative array accesses),
        //but shouldn't be changed unless it's a bottleneck or more readable
        //code can be written.

        //Update graph display data such as graph line strips.
        void update_view()
        {
            if(auto_scroll_){time_offset_ = age();}

            real maximum;
            real[][string] data_points = get_data_points_and_maximum(maximum);

            if(auto_scale_)
            {
                if(!equals(maximum, 0.0L)){scale_y = (bounds_.height * 0.8) / maximum;}
            }

            update_lines();

            //generate line strips
            foreach(name; graphs_.keys)
            {
                real[] points = data_points[name];
                auto graph = graphs_[name];
                auto graphics = graphics_[name];
                graphics.line_strip.length = 0;
                if(graph.empty){continue;}

                float x = bounds_.max.x - scale_x_ * (points.length - 1);
                x += (graph.start_time - start_time_) * scale_x_;
                float y = bounds_.max.y;

                foreach(real point; points)
                {
                    graphics.line_strip ~= Vector2f(x, y - point * scale_y);
                    x += scale_x_;
                }
            }
        }

        /*
         * Officially the worst named method in this entire project.
         *
         * Gets data points to draw from graph of each value, used by update_view.
         * Also gets maximum of all data points, used for autoscaling.
         * 
         * Params:  maximum = Maximum of all data points will be written here.
         *
         * Returns: Data points of every graph in an associative array indexed by graph name.
         */
        real[][string] get_data_points_and_maximum(out real maximum)
        {
            alias math.math.max max;
            alias math.math.min min;

            //calculate the time window we want to get data points for
            //why +3 : get a few more points so the graph is always full if there's enough data
            real time_width = (bounds_.width / scale_x_ + 3) * data_point_time_;

            real end_time = start_time_ + time_offset_;
            real start_time = end_time - time_width;

            maximum = 0.0;
            real[][string] data_points;

            //getting all data points and the maximum
            foreach(name; graphs_.keys)
            {
                real[] points = graphs_[name].data_points(start_time, end_time, data_point_time_);

                data_points[name] = points;
                if(points.length <= 1){continue;}

                real graph_maximum = max(points);
                if(graph_maximum > maximum){maximum = graph_maximum;}
            }

            return data_points;
        }

        ///Update the horizontal lines of the graph.
        void update_lines()
        {
            lines_.length = 0;

            real graph_height = bounds_.height / scale_y_;
            uint spacing = cast(uint)pow(cast(real)10.0, cast(uint)log10(graph_height));
            if(spacing == 0){spacing = 1;}

            //always have at least two horizontal lines.
            if(graph_height / spacing < 2){spacing /= 2;}

            uint line_height = 0;

            Line line;
            do
            {
                line.y = bounds_.max.y - scale_y_ * line_height;
                line.text = to_string(line_height);
                line.color = Color(255, 128, 0, 192);
                lines_ ~= line;

                line_height += spacing;
            }
            while(line_height <= graph_height)
        }

        /**
         * Draw specified graph.
         *
         * Params:  name = Name of the graph to draw.
         */
        void draw_graph(string name)
        {
            auto graph = graphs_[name];
            auto graphics = graphics_[name];

            if(!graphics.visible || graphics.line_strip.length <= 1){return;}
            auto driver = VideoDriver.get;

            //Use scissor test to only draw within bounds of the graph.
            driver.scissor(bounds_);
            driver.line_aa = true;
            driver.line_width = 0.7;

            driver.draw_line_strip(graphics.line_strip, graphics.color);

            driver.line_width = 1;                  
            driver.line_aa = false;
            driver.disable_scissor();
        }

        ///Draw graph related information, e.g. the horizontal lines and data point time.
        void draw_info()
        {
            static data_time_color = Color(255, 0, 0, 192);
            static data_time_offset = Vector2i(-32, 4);

            Vector2f start;
            start.x = bounds_.min.x;
            Vector2f end;
            end.x = bounds_.max.x;
            Vector2i text_start;
            text_start.x = bounds_.min.x;

            auto driver = VideoDriver.get;
            driver.font = "default";
            driver.font_size = 8;
            driver.scissor(bounds_);

            //lines
            foreach(ref line; lines_)
            {
                start.y = end.y = line.y;
                text_start.y = cast(int)line.y;
                driver.draw_line(start, end, line.color, line.color);
                driver.draw_text(text_start, line.text, line.color);
            }

            //data point time
            driver.draw_text(bounds_.max_min() + data_time_offset,
                             to_string(data_point_time_) ~ "s", data_time_color);

            driver.disable_scissor();
        }
}