#include"shader_library.hpp"
#include<sstream>

namespace shader {
#ifdef __EMSCRIPTEN__
    const char *vertex_shader = R"(#version 300 es
            precision highp float;
            layout (location = 0) in vec3 aPos;
            layout (location = 1) in vec2 aTexCoord;
            out vec2 tc;
            void main() {
                gl_Position = vec4(aPos, 1.0); 
                tc = aTexCoord;         
            }
    )";
#else
    const char *vertex_shader = R"(#version 330 core
            layout (location = 0) in vec3 aPos;
            layout (location = 1) in vec2 aTexCoord;
            out vec2 tc;
            void main() {
                gl_Position = vec4(aPos, 1.0); 
                tc = aTexCoord;         
            }
    )";
#endif
        
    Shader::Shader(const std::string &filename_) : filename(filename_) {
        load_shader(filename_);
    }

    void Shader::load_shader(const std::string &filename_) {
        std::fstream input_file;
        input_file.open(filename_, std::ios::in);
        if(!input_file.is_open()) {
            std::cerr << "Error opening: " << filename_ << "\n";
            return;
        }

        std::ostringstream stream;
        stream << input_file.rdbuf();
        fragment_text = stream.str();
#ifdef __EMSCRIPTEN__
        size_t pos = fragment_text.find("#version 330 core");
        if (pos != std::string::npos) {
            fragment_text.replace(pos, 17, "#version 300 es\nprecision highp float;\n");
        }
#endif
        if(fragment_text.empty() || !program.loadProgramFromText(vertex_shader, fragment_text)) {
            std::cerr << "Could not load shader: " + filename_;
            return;
        }
        
        std::cout << "Loaded: " << filename_ << "\n";
        opened_ = true;
    }

    bool Shader::opened() const {
        return opened_;
    }

    Library::Library(const std::string &filename_index) {
        load_library(filename_index);
    }

    void Library::load_library(const std::string &filename_index) {
        std::fstream file;
        file.open(filename_index+"/gfx/index.txt", std::ios::in);
        if(!file.is_open()) {
            std::cerr << "Error opening filen index.txt\n";
        }
        std::string line;
        while(std::getline(file, line)) {
            auto pos = line.find("\r");
            if(pos != std::string::npos)
                line = line.substr(0, pos);

            auto it = std::make_unique<Shader>(filename_index+"/gfx/"+line);
            if(it && it->opened()) {
                shaders.push_back(std::move(it));
            }

        }
        std::cout << "Loaded: " << shaders.size() << " shaders\n";
    }
}