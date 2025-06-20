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
        bool opened() const;
        std::string filename;
    protected:
        std::string fragment_text;
        gl::ShaderProgram program;       
        void load_shader(const std::string &filename_);
        bool opened_= false;
        
    };

    class Library  {
    public:
        explicit Library(const std::string &index_filename);
        Shader *getShader(int index) { return shaders.at(index).get(); }
        std::size_t size() const  { return shaders.size(); }
    private:
        void load_library(const std::string &filename);
        std::vector<std::unique_ptr<Shader>> shaders;
    };
}

extern std::unique_ptr<shader::Library> library;

#endif