# Shows this message
help:
    @just --list

# Downloads external dependencies
install:
    just --working-directory peruncs-submodule --justfile peruncs-submodule/Justfile install
    rm -rf libs
    jresolve --output-directory libs @libs.txt @peruncs-submodule/libs.txt

# Cleans up any build artifacts
clean:
    just --working-directory peruncs-submodule --justfile peruncs-submodule/Justfile clean
    rm -rf build

# Compiles every module
build:
    just --working-directory peruncs-submodule --justfile peruncs-submodule/Justfile build
    rm -rf build/javac
    javac \
      -d build/javac \
      --module-path libs:peruncs-submodule/build/jar \
      --module-source-path "./*/src" \
      --module insbiz.webapp \
      --enable-preview \
      --release 22

    jar --create \
        --file build/jar/insbiz.webapp.jar \
        --main-class insbiz.webapp.App \
        -C build/javac/insbiz.webapp . \
        -C insbiz.webapp/res .

docker_build: build
    jib build \
        --build-file=insbiz.webapp/jib.yaml \
        --target=docker://jib-cli-quickstart \
        --context=insbiz.webapp

docker_run:
    docker run --platform=linux/amd64 jib-cli-quickstart

javadoc:
    javadoc -d build/javadoc \
      --module-path libs:peruncs-submodule/build/jar \
      --module-source-path "./*/src" \
      --module insbiz.webapp \
      --enable-preview \
      --source 22

run module="insbiz.webapp":
    java --enable-preview --module-path libs:build/jar:peruncs-submodule/build/jar -m {{module}}