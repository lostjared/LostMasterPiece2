#ifndef _SHADER_LIB_H_
#define _SHADER_LIB_H_

#include<iostream>
#include<fstream>
#include<string>
#include<mx.hpp>
#include<gl.hpp>
#include<unordered_map>
#include<vector>
#include<memory>

namespace shader {

    extern const char *vertex_shader;

    class Shader {
    public:
        Shader() = default;
        Shader(const std::string &filename_);
        gl::ShaderProgram &shader() { return program; }
    protected:
        std::string fragment_text;
        std::string filename;
        gl::ShaderProgram program;       
        void load_shader(const std::string &filename_);
    };

    class Library  {
    public:
        explicit Library(const std::string &index_filename);
    private:
        void load_library(const std::string &filename);
        std::vector<std::unique_ptr<Shader>> shaders;
    };
}

#endif