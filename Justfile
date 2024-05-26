# Shows this message
help:
    @just --list

# Downloads external dependencies
install:
    rm -rf libs
    jresolve --output-directory libs @libs.txt

# Cleans up any build artifacts
clean:
    rm -rf build

# Compiles every module
build:
    rm -rf build/javac
    javac \
      -d build/javac \
      --module-path libs \
      --module-source-path "./*/src" \
      --module peruncs.utilities,peruncs.helidon,peruncs.webassets,insbiz.webapp \
      --enable-preview \
      --release 22


    jar --create \
        --file build/jar/peruncs.utilities.jar \
        -C build/javac/peruncs.utilities .

    jar --create \
        --file build/jar/peruncs.helidon.jar \
        -C build/javac/peruncs.helidon .

    jar --create \
        --file build/jar/peruncs.webassets.jar \
        -C build/javac/peruncs.webassets . \
        -C peruncs.webassets/res .

    jar --create \
        --file build/jar/insbiz.webapp.jar \
        --main-class insbiz.webapp.App \
        -C build/javac/insbiz.webapp . \
        -C insbiz.webapp/res .

javadoc:
    javadoc -d build/javadoc \
      --module-path libs \
      --module-source-path "./*/src" \
      --module peruncs.utilities,peruncs.helidon,peruncs.webassets,insbiz.webapp \
      --enable-preview \
      --source 22

run module="insbiz.webapp":
    java --enable-preview --module-path libs:build/jar -m {{module}}