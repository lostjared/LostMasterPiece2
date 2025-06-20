#ifndef __START_H__
#define __START_H__

#include <iostream>
#include "mx.hpp"
#include "gl.hpp"
#include"shader_library.hpp"

class Start : public gl::GLObject {
public:
    Start() {}
    virtual void load(gl::GLWindow *win) override {
        int index = mx::generateRandomInt(10, 20);
        std::cout << "Loading...: " << library->getShader(index)->filename << "\n";
        gl::ShaderProgram &prog = library->getShader(index)->shader();
        program = &prog;
        program->useProgram();
        start.initSize(win->w, win->h);
        start.loadTexture(program, win->util.getFilePath("data/start.png"), 0.0f, 0.0f, win->w, win->h);
        win->console.print("Press any key to start\n");
    }
    virtual void event(gl::GLWindow *win, SDL_Event &e) override;
    virtual void draw(gl::GLWindow *win) override;
private:
    gl::ShaderProgram *program;
    gl::GLSprite start;
    float fade = 0.0f;
    bool fade_in = true;
    Uint32 currentTime = 0, lastUpdateTime = 0;
    void setGame(gl::GLWindow *win);
};

#endif