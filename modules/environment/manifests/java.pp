# environment/java.pp

class environment::java {
  package { 
    # Java dependencies, as seen at <http://www.freshports.org/java/jdk16>.
   ["zip", "unzip", "open-motif", "cups-client", "diablo-jdk16", "gmake",
    "libX11", "libXext", "libXi", "pkg-config", "desktop-file-utils"]:;
    # Java runtime dependencies.
   ["javavmwrapper", "libXtst", "gio-fam-backend"]:;
    # Java required libraries.
   ["libiconv", "glib20"]:;
    "jdk16":;
    "apache-ant":;
  }
}
