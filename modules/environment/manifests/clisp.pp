# projects/clisp.pp

class project::clisp {
  package { 
    "clisp":;
    "cl-asdf":;
  }
}
