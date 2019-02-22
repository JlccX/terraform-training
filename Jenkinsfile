

pipeline {

  agent none

    options {
        skipDefaultCheckout true
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

  environment {
      MY_VAR"Hello Worldx!!!"
	}


  stages {

	stage('Build') {
    	steps {
    		script {
          		node {
                  println "\n${MY_VAR}\n"
          		}
        	}
    	}
  }



  } // stages closed

}

