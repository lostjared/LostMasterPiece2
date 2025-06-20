#include"shader_library.hpp"
#include<sstream>

namespace shader {

    const char *vertex_shader = R"(#version 330 core
            layout (location = 0) in vec3 aPos;
            layout (location = 1) in vec2 aTexCoord;
            out vec2 tc;
            void main() {
                gl_Position = vec4(aPos, 1.0); 
                tc = aTexCoord;         
            }
    )";
        
    Shader::Shader(const std::string &filename_) : filename(filename_) {
        load_shader(filename_);
    }

    void Shader::load_shader(const std::string &filename_) {
        std::ifstream fin(filename_);
        if(!fin.is_open()) 
            throw mx::Exception("Error could not open shader: " + filename_);

        std::ostringstream stream;
        stream << fin.rdbuf();
        fragment_text = stream.str();

       if(!program.loadProgramFromText(vertex_shader, fragment_text)) {
            throw mx::Exception("Error could not load shader: " + filename_);
       }
       fin.close();
       std::cout << "Loaded " << filename_ << "\n";
    }

    Library::Library(const std::string &filename_index) {
        load_library(filename_index);
    }

    void Library::load_library(const std::string &filename_index) {
        std::ifstream fin(filename_index);
        if(!fin.is_open()) {
            throw mx::Exception("Could not open library index file: " + filename_index);
        }
        std::string line;
        while(std::getline(fin, line)) {
            shaders.push_back(std::make_unique<Shader>(line));
        }
        std::cout << "Loaded " << shaders.size() << " shaders..\n";
    }
}