FROM pritunl/archlinux
MAINTAINER kota999 <kota99949@gmail.com>

#
# set HOME
#
ENV HOME=/root

#
# install requirement library
#
RUN echo Y | pacman -S git wget zeromq gcc make tk mesa-libgl texlive-bin

#
# replace zmq.hpp
#
RUN wget https://raw.githubusercontent.com/zeromq/cppzmq/master/zmq.hpp && mv zmq.hpp /usr/local/include/

#
# install pyenv
#
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | /usr/sbin/bash
# export PYENV PATH
ENV PATH ${HOME}/.pyenv/bin:${HOME}/.pyenv/shims:$PATH
RUN echo "export PATH=\$PATH:\$HOME/.pyenv/bin:\$HOME/.pyenv/shims" >> ${HOME}/.bashrc
# set eval
RUN echo "eval \"\$(pyenv init -)\"" >> ${HOME}/.bashrc && echo "eval \"\$(pyenv virtualenv-init -)\"" >> ${HOME}/.bashrc
# source bashrc
RUN source ${HOME}/.bashrc

#
# install anaconda 2.1.0
#
RUN pyenv install anaconda-2.1.0
RUN pyenv rehash
# set using python-distribution
RUN pyenv global anaconda-2.1.0
# confirm using python version
RUN pyenv version
# conda update
RUN echo y | conda update conda

#
# update ipython v2 to v3
#
RUN echo y | pip uninstall ipython[all] && echo y | pip install ipython[all]

#
# set up ipython notebook configuration
#
# copy ipython notebook start shell
ADD files/notebook /usr/local/sbin/
# mkdir notebooks dir
RUN mkdir /notebooks

#
# install IJulia
#
# install julia
RUN echo Y | pacman -S julia
# install IJulia
ADD files/ijulia/installIJulia.jl ${HOME}/installIJulia.jl
RUN cd ${HOME} && julia installIJulia.jl && rm installIJulia.jl
# prepare kernel.json for julia
RUN sed -i -e "s|\/usr\/bin\/julia|\/usr\/sbin\/julia|" ${HOME}/.ipython/kernels/julia\ 0.3/kernel.json

#
# install IRkernel
#
# install R
RUN echo Y | pacman -S r
# install repr
RUN git clone git://github.com/IRkernel/repr && R CMD INSTALL repr && rm -rf repr
# install IRdisplay
RUN wget http://cran.rstudio.com/src/contrib/base64enc_0.1-2.tar.gz && R CMD INSTALL base64enc_0.1-2.tar.gz && rm -f base64enc_0.1-2.tar.gz
RUN git clone git://github.com/IRkernel/IRdisplay && R CMD INSTALL IRdisplay && rm -rf IRdisplay
# install IRkernel
RUN wget http://cran.rstudio.com/src/contrib/stringr_0.6.2.tar.gz && R CMD INSTALL stringr_0.6.2.tar.gz && rm -f stringr_0.6.2.tar.gz
RUN wget http://cran.rstudio.com/src/contrib/evaluate_0.7.tar.gz && R CMD INSTALL evaluate_0.7.tar.gz && rm -f evaluate_0.7.tar.gz
RUN wget http://cran.r-project.org/src/contrib/rzmq_0.7.7.tar.gz && R CMD INSTALL rzmq_0.7.7.tar.gz && rm -f rzmq_0.7.7.tar.gz
RUN wget http://cran.r-project.org/src/contrib/jsonlite_0.9.16.tar.gz && R CMD INSTALL jsonlite_0.9.16.tar.gz && rm -f jsonlite_0.9.16.tar.gz
RUN wget http://cran.r-project.org/src/contrib/uuid_0.1-1.tar.gz && R CMD INSTALL uuid_0.1-1.tar.gz && rm -f uuid_0.1-1.tar.gz
RUN wget http://cran.r-project.org/src/contrib/digest_0.6.8.tar.gz && R CMD INSTALL digest_0.6.8.tar.gz && rm -f digest_0.6.8.tar.gz
RUN git clone git://github.com/IRkernel/IRkernel && R CMD INSTALL IRkernel && rm -rf IRkernel
# prepare kernel.json for IRkernel
RUN echo "IRkernel::installspec()" > install.R
RUN R --vanilla < install.R
RUN rm install.R
RUN sed -i -e "1s|R|\/usr\/sbin\/R|" ${HOME}/.ipython/kernels/ir/kernel.json

#
# install igo
#
# install go
RUN echo Y | pacman -S go
# mkdir GOPATH
RUN mkdir ${HOME}/go
# export GOPATH PATH
RUN echo "export PATH=\$PATH:\$HOME/go/bin" >> ${HOME}/.bashrc
RUN echo "export GOPATH=\$HOME/go" >> ${HOME}/.bashrc
ENV PATH ${HOME}/go/bin:$PATH
ENV GOPATH ${HOME}/go
# install igo
RUN echo Y | pacman -S pkg-config
RUN go get -tags zmq_4_x github.com/alecthomas/gozmq
RUN go get github.com/takluyver/igo
# prepare kernel.json for IRkernel
RUN mkdir -p ${HOME}/.ipython/kernels/igo
RUN cp ${HOME}/go/src/github.com/takluyver/igo/kernel/* ${HOME}/.ipython/kernels/igo/
RUN sed -i -e "s|\$GOPATH|\/root\/go|" ${HOME}/.ipython/kernels/igo/kernel.json

#
# install IScala
#
# install jdk 8
RUN echo Y | pacman -S jdk8-openjdk
# install IScala
RUN cd $HOME && wget https://github.com/mattpap/IScala/releases/download/v0.1/IScala-0.1.tgz && tar zxvf IScala-0.1.tgz && rm -rf ${HOME}/IScala-0.1.tgz
# prepare kernel.json for iscala
RUN mkdir -p ${HOME}/.ipython/kernels/iscala
ADD files/iscala/kernel.json ${HOME}/.ipython/kernels/iscala/kernel.json

#
# install bash kernel
#
RUN echo y | pip install bash_kernel

#
# install redis kernel
#
# install redis
RUN echo Y | pacman -S redis
# install kernel.json for redis
RUN echo y | pip install redis_kernel

#
# install ijavascript
#
# install nodejs
RUN echo Y | pacman -S nodejs
# install ijavascript
RUN npm install ijavascript && mv /node_modules ${HOME}/node_modules
# prepare kernel.json for ijavascript
RUN mkdir -p ${HOME}/.ipython/kernels/ijs
ADD files/ijs/kernel.json ${HOME}/.ipython/kernels/ijs/kernel.json
