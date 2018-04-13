
getMavenJarVersion() {
    _PROP_FILE=$1

    grep version ${_PROP_FILE} | awk -F '=' '{ print $2 }'
}

getMavenJarArtifactId() {
    _PROP_FILE=$1

    grep artifactId ${_PROP_FILE} | awk -F '=' '{ print $2 }'
}

getMavenJarGroupId() {
    _PROP_FILE=$1

    grep groupId ${_PROP_FILE} | awk -F '=' '{ print $2 }'
}



usage() {
    echo "Usage: $0 <GET_VERSION | GET_GROUPID | GET_ARTIFACTID | GET_JARFILENAME> <pom.properties path>"
}

if [ $# -lt 2 ]; then
    usage
    exit 1
fi


CMD=$1
POM_PATH=$2

case $CMD in
    "GET_VERSION")
                getMavenJarVersion $POM_PATH
                ;;
    "GET_GROUPID")
                getMavenJarGroupId $POM_PATH
                ;;
    "GET_ARTIFACTID")
                getMavenJarArtifactId $POM_PATH
                ;;
    "GET_JARFILENAME")
                echo "`getMavenJarArtifactId $POM_PATH`-`getMavenJarVersion $POM_PATH`.jar"
                ;;
     *)
                echo "Wrong command: $CMD"
                usage
                ;;
esac