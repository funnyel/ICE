
//          Copyright Ferdinand Majerech 2010 - 2011.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module time.timer;


import time.time;


///A timer struct; handles timing of various delayed or periodic events.
align(1) struct Timer
{
    invariant
    {
        assert(delay_ >= 0.0, "Can't have a Timer with negative delay");
        assert(start_ >= 0.0, "Can't have a Timer with negative start");
    }

    private:
        ///Start time of the timer.
        real start_ = 0.0;

        ///Delay of the timer (i.e. how long after start does the timer expire).
        real delay_ = 0.0;

    public:
        /**
         * Constructs a timer starting now.
         *
         * Params:  delay = Delay of the timer.
         */
        static Timer opCall(real delay){return Timer(delay, get_time());}

        /**
         * Constructs a timer starting at specified time.
         *
         * Params:  delay = Delay of the timer.
         *          time  = Start time of the timer.
         */
        static Timer opCall(real delay, real start)
        {               
            Timer t;
            t.start_ = start;
            t.delay_ = delay; 
            return t;
        }

        ///Get time when the timer was started.
        real start(){return start_;}

        ///Get delay of this timer.
        real delay(){return delay_;}

        /**
         * Returns time since start of the timer at specified time.
         *
         * Params:  time = Time relative to which to calculate the age.
         *
         * Returns: Age of the timer relative to specified time.
         */
        real age(real time){return time - start_;}

        ///Returns time since start of the timer.
        real age(){return age(get_time());}

        /**
         * Returns time since start of the timer at specified time divided by the timer's delay.
         *
         * Params:  time = Time relative to which to calculate the age.
         *
         * Returns: Age of the timer relative to specified time divided by the delay.
         *          This is 0.0 at the start of the timer, and 1.0 at its end, 
         *          so it can be used to get percentage of timer's delay that has elapsed.
         *
         */
        real age_relative(real time){return age(time) / delay_;}

        /**
         * Returns time since start of the timer divided by the timer's delay. 
         *
         * Returns: Age of the timer divided by the delay.
         *          This is 0.0 at the start of the timer, and 1.0 at its end, 
         *          so it can be used to get percentage of timer's delay that has elapsed.
         */
        real age_relative(){return age_relative(get_time());}

        /**
         * Determines if the timer has expired at specified time.
         *
         * Params:  time = Time relative to which to check for expiration.
         *
         * Returns: True if the timer has expired, false otherwise.
         */
        bool expired(real time){return time - start_ > delay_;}

        ///Determines if the timer has expired.
        bool expired(){return expired(get_time());}

        ///Resets the timer with specified start time.
        void reset(real start){start_ = start;}

        ///Resets the timer.
        void reset(){reset(get_time());}
}
