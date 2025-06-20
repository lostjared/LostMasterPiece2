cmake_minimum_required(VERSION 3.10)
project(LostMasterPiece2 VERSION 0.1 LANGUAGES CXX C)


set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

if(RELEASE)
    set(CMAKE_BUILD_TYPE Release)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
else()
    set(CMAKE_BUILD_TYPE Debug)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
endif()


find_package(SDL2 REQUIRED)
find_package(SDL2_ttf REQUIRED)
find_package(SDL2_mixer REQUIRED)
find_package(libmx2 REQUIRED)
find_package(glm REQUIRED)

add_executable(LostMasterPiece2 
    src/main.cpp
    src/gameover.cpp
    src/intro.cpp
    src/quadtris.cpp
    src/start.cpp
)

target_include_directories(LostMasterPiece2 PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include
        ${libmx2_INCLUDE_DIRS}
        ${SDL2_INCLUDE_DIRS} 
        ${SDL2_TTF_INCLUDE_DIRS}
        ${SDL2_MIXER_INCLUDE_DIRS}
	    ${GLM_INCLUDE_DIRS}
    )

if(WIN32)
    set_target_properties(LostMasterPiece2 PROPERTIES WIN32_EXECUTABLE TRUE)
endif()
    
target_link_libraries(LostMasterPiece2 PRIVATE
    libmx2::mx 
    ${SDL2_LIBRARIES} 
    ${SDL2_TTF_LIBRARIES} 
    ${SDL2_MIXER_LIBRARIES}    
)

# if(WIN32)
#  set(RESOURCE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/data/icon.rc")
#  set_source_files_properties(
#    ${RESOURCE_FILE}
#    PROPERTIES
#      LANGUAGE RC
# )
#  target_sources(cmd-console PRIVATE ${RESOURCE_FILE})
#endif()
