# anaconda_jupyter

This repository is jupyter server for my personal use.

This one contain feature is many programing language kernel , IPython3 (python2.7.9), IJulia, IRkernel, IGo, IScala, Bash, Redis kernel, IJavascript.
Containts of python module are numpy, scipy, matplotlib, PIL, scikits.learn, scikit-image, pandas, Cython, numba, cvxopt, sympy.

###Description
Installation :

    brew install docker boot2docker
    boot2docker init
    boot2docker up
    # export boot2docker path
    docker pull kota999/jupyter

Run by :

    docker run -d -p $JUPYTER_PORT:8888 kota999/jupyter notebook

Go to:

    http://$DOCKER_HOST:$JUPYTER_PORT

JUPYTER_PORT is your setting for going to jupyter. DOCKER_HOST is ip address of your boot2docker-vm.
