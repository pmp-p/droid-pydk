
export OPENSSL_URL=${OPENSSL_URL:-"URL https://ftp.openssl.org/source/openssl-1.1.1f.tar.gz"}
export OPENSSL_HASH="URL_HASH SHA256=186c6bfe6ecfba7a5b48c47f8a1673d0f3b0e5ba2e25602dd23b629975da3f35"


openssl_host_cmake () {
    #already done in aosp
    echo
}

openssl_patch () {
    echo " -> openssl patch is made in cmake_host step"
}

openssl_build () {
    echo
}

openssl_crosscompile () {

    # poc https://github.com/DigitalArsenal/openssl.js/blob/master/packages/openssl/build.sh

    if [ -f  ${APKUSR}/lib/libssl.a ]
    then
        echo "    -> openssl-${OPENSSL_VERSION} already built for $ABI_NAME"
    else
        echo " ---------------------------------------------"
        PrepareBuild openssl
        echo " ------------------- $(pwd) --------------------------"

        /bin/cp -aRfxp ${BUILD_SRC}/openssl-prefix/src/openssl/. ./
        unset CFLAGS
        rm Makefile
# no-sock  -> python3-wasm/Modules/_ssl.c:954:9: error: implicit declaration of function 'SSL_set_fd' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
#        SSL_set_fd(self->ssl, Py_SAFE_DOWNCAST(sock->sock_fd, SOCKET_T, int))

        emconfigure ./Configure gcc -static -no-pic --prefix=${APKUSR}\
 no-hw no-tests no-asm no-afalgeng \
 -DCTLOG_FILE=/ssl.log \
 -DOPENSSL_SYS_NETWARE -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_AFALGENG=1 \
 --with-rand-seed=getrandom
        sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile
        emmake make install
         #CROSS_COMPILE="" emmake make -s -j1 depend
#        # no-ssl2 no-ssl3 no-comp
#            CROSS_COMPILE="" ARCH=${ARCH} API=${API} ./Configure -D__ANDROID_API__=${API} shared no-hw --prefix=${APKUSR} android-${ARCH}\
# >/dev/null && CROSS_COMPILE="" make -s -j1 depend >/dev/null && CROSS_COMPILE="" make -s -j1 install >/dev/null
#            SOVER="1.1"

        if [ -f  ${APKUSR}/lib/libssl.a ]
        then
            echo "    -> openssl-${OPENSSL_VERSION}  built for $ANDROID_NDK_ABI_NAME"
        else
            echo "ERROR: openssl-${OPENSSL_VERSION}  $ANDROID_NDK_ABI_NAME"
            exit 1
        fi

    fi


}


