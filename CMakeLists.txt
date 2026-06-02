cmake_minimum_required(VERSION 3.21) # Minimum CMake version
project(SDLTemplate) # Project name

set(CMAKE_CXX_STANDARD 17) # Using C++17

# Add headers
include_directories(${PROJECT_SOURCE_DIR}/libs/SDL2/include)

# Add paths to libs
link_directories(${PROJECT_SOURCE_DIR}/libs/SDL2/lib)

# Define executable
file(GLOB_RECURSE SRC_FILES ${PROJECT_SOURCE_DIR}/src/*.cpp)
add_executable(${PROJECT_NAME} ${SRC_FILES})

# Linking SDL2
target_link_libraries(${PROJECT_NAME}
    PRIVATE
    SDL2
    SDL2main
    SDL2_image
    SDL2_mixer
)

# Get all SDL DLLs automatically
file(GLOB SDL_DLLS
    "${PROJECT_SOURCE_DIR}/libs/SDL2/bin/*.dll"
)

# Copy SDL DLLs to executable folder after build
foreach(DLL ${SDL_DLLS})
    add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${DLL}"
            $<TARGET_FILE_DIR:${PROJECT_NAME}>
    )
endforeach()

# Set executable as startup project in Visual Studio
set_property(
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME}
)
