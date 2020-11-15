# https://www.libsdl.org/projects/SDL_image/
# https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.tar.gz
export SDL2_URL=${UNIT_URL:-"GIT_REPOSITORY https://github.com/pmp-p/pydk.git"}
export SDL2_HASH=${UNIT_HASH:-}


sdl2_host_cmake () {
    cat >> CMakeLists.txt <<END
#${unit}

if(0)
ExternalProject_Add(
    ${unit}
    ${UNIT_URL}
    ${UNIT_HASH}

    DOWNLOAD_NO_PROGRESS ${CI}

    CONFIGURE_COMMAND sh -c "echo 1>&1;echo external.configure ${unit} 1>&2"
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)
else()
    message(" ********************************************************************")
    message("  No cmake ExternalProject_Add defined for unit : ${unit}")
    message(" ********************************************************************")
endif()

END
}

sdl2_patch () {
    echo
}

sdl2_build () {
    echo
}

sdl2_crosscompile () {
    echo
    mkdir -p ${BUILD_PREFIX}-${ABI_NAME}/SDL2
    cd ${BUILD_PREFIX}-${ABI_NAME}/SDL2
    chmod +x $ORIGIN/shell.${ABI_NAME}.sh
    $ORIGIN/shell.${ABI_NAME}.sh $ORIGIN/sources/sdl2_ndk.sh

}



