#include"start.hpp"

void Start::draw(gl::GLWindow *win) {
    glDisable(GL_DEPTH_TEST);
    program->useProgram();
    program->setSilent(true);
    glUniform2f(glGetUniformLocation(program->id(), "iResolution"), win->w, win->h);
    program->setUniform("alpha", fade);
    program->setUniform("time_f", SDL_GetTicks() / 1000.0f);
    start.draw();
    currentTime = SDL_GetTicks();
    if((currentTime - lastUpdateTime) > 25) {
        lastUpdateTime = currentTime;
        if(fade_in == true && fade < 1.0f) fade += 0.05;
        if(fade_in == false && fade > 0.1f) fade -= 0.05;
    }
    if(fade_in == true && fade >= 1.0f) {
        fade = 1.0f;
    } else if(fade_in == false  && fade <= 0.1f) {
        fade = 0.0f;
        setGame(win);
        return;
    }
}

