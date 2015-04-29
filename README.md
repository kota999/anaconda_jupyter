# anaconda_jupyter

This repository is jupyter server for my personal use.

This one contain feature is many programing language kernel , IPython3 (python2.7.9), IJulia, IRkernel, IGo, IScala, Bash, Redis kernel, IJavascript.
Distribution of python is anaconda-2.1.0, this distribution is the latest version of using python2.

###Description
Installation :

    brew install docker boot2docker
    boot2docker init
    boot2docker up
    # export boot2docker path
    docker build "your docker image name" .

Run by :

    docker run -d -p $JUPYTER_PORT:8888 "your docker image name" notebook

Go to:

    http://$DOCKER_HOST:$JUPYTER_PORT

JUPYTER_PORT is your setting for going to jupyter. DOCKER_HOST is ip address of your boot2docker-vm.
