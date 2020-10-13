export SQLITE3_URL=${SQLITE3_URL:-"GIT_REPOSITORY https://github.com/azadkuh/sqlite-amalgamation.git"}
export SQLITE3_HASH=${SQLITE3_HASH:-}

sqlite3_host_cmake () {
    cat >> CMakeLists.txt <<END

if(1)
    message("")
    message(" processing unit : ${unit}")
ExternalProject_Add(
    sqlite3
    ${SQLITE3_URL}
    ${SQLITE3_HASH}

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

sqlite3_patch () {
    echo
}

sqlite3_build () {
    echo
}

sqlite3_crosscompile () {
    if [ -f  ${APKUSR}/lib/libsqlite3.a ]
    then
        echo "    -> sqlite3 already built for $ABI_NAME"
    else
        PrepareBuild ${unit}
        $ACMAKE ${BUILD_SRC}/${unit}-prefix/src/${unit} && make -s install
    fi
}



