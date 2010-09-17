module platform.sdlplatform;


import std.string;

import derelict.sdl.sdl;

import platform.key;
import platform.platform;
import math.vector2;
import singleton;

class SDLPlatform : Platform
{
    public:
        //Constructor - initializes SDL and throws Exception on failure.
        this()
        {
            singleton_ctor();
            DerelictSDL.load();
			if(SDL_Init(SDL_INIT_VIDEO) < 0)
            {
                string error = std.string.toString(SDL_GetError());
				throw new Exception("Could not initialize SDL: " ~ error);
            }
            SDL_EnableUNICODE(SDL_ENABLE);
        }

        override void die()
        {
			SDL_Quit();
            DerelictSDL.unload();
        }
        
        override bool run()
        {
            SDL_Event event;

            while(SDL_PollEvent(&event))
            {
                switch(event.type)
                {
                    case SDL_QUIT:
                        quit();
                        break;
					case SDL_KEYDOWN:
					case SDL_KEYUP:
                        process_key(event.key);
                        break;
                    case SDL_MOUSEBUTTONDOWN:
                    case SDL_MOUSEBUTTONUP:
                        process_mouse_key(event.button);
                        break;
                    case SDL_MOUSEMOTION:
                        process_mouse_motion(event.motion);
                        break;
                    default:
                        break;
                }
            }
            return super.run();
        }

        override void window_caption(string str)
        {
            SDL_WM_SetCaption(toStringz(str), null); 
        }

        override void hide_cursor(){SDL_ShowCursor(0);}

        override void show_cursor(){SDL_ShowCursor(1);}

    package:
        
        //Process a keyboard event.
        void process_key(SDL_KeyboardEvent event)
        {
            KeyState state = KeyState.Pressed;
            keys_pressed_[event.keysym.sym] = true;
            if(event.type == SDL_KEYUP)
            {
                state = KeyState.Released;
                keys_pressed_[event.keysym.sym] = false;
            }
            key.emit(state, cast(Key)event.keysym.sym, 
                           event.keysym.unicode);
        }
        
        //Process a mouse button event.
        void process_mouse_key(SDL_MouseButtonEvent event)
        {
            KeyState state = KeyState.Pressed;
            if(event.type == SDL_MOUSEBUTTONUP){state = KeyState.Released;}

            MouseKey key;
            switch(event.button)
            {
                case(SDL_BUTTON_LEFT):
                    key = MouseKey.Left;
                    break;
                case(SDL_BUTTON_MIDDLE):
                    key = MouseKey.Middle;
                    break;
                case(SDL_BUTTON_RIGHT):
                    key = MouseKey.Right;
                    break;
                case(SDL_BUTTON_WHEELUP):
                    key = MouseKey.WheelUp;
                    break;
                case(SDL_BUTTON_WHEELDOWN):
                    key = MouseKey.WheelDown;
                    break;
            }

            Vector2u position = Vector2u(event.x, event.y);

            mouse_key.emit(state, key, position);
        }
        
        //Process a mouse motion event.
        void process_mouse_motion(SDL_MouseMotionEvent event)
        {
            Vector2u position = Vector2u(event.x, event.y);
            Vector2i position_relative = Vector2i(event.xrel, event.yrel);
            mouse_motion.emit(position, position_relative);
        }
}