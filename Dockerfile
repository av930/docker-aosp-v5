###
### Environments to build AOSP
### 


### basic information
FROM ubuntu:16.04
MAINTAINER joongkeun.kim <av9300@gmail.com>


### change from Dash to Bash shell which is a bit slow and a bit more functionalities 
RUN echo "changing shell to Bash" | debconf-set-selections && \ dpkg-reconfigure -p critical dash


### install dependent packages to build AOSP
RUN apt-get update ## update list of packages \
	&& apt-get install -y ## install packages answering yes to all prompts \
		openjdk-8-jdk ## build java with open JDK version 8\
		bison ## parser generator upward compatible to yacc\
		build-essential ## all the packages needed to compile a debian packages and generally include c/c++ compilers and libraries\
		curl \
		flex \
		g++-multilib \
		git \
		gnupg \
		gperf \
		ia32-libs \
		lib32ncurses5-dev \
		lib32readline5-dev \
		lib32z-dev \
		libc6-dev \
		libgl1-mesa-dev \
		libx11-dev \
		libxml2-utils \
		mingw32 \
		python-markdown \
		tofrodos \
		x11proto-core-dev \
		xsltproc \
		zip \
		zlib1g-dev\
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp ## clear local cache to save space


### Download the Repo tool and ensure that it is executable
RUN mkdir ~/bin \
	&& curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
&& chmod a+x ~/bin/repo
	&& PATH=~/bin:$PATH


# Install latest version of JDK # See http://source.android.com/source/initializing.html#setting-up-a-linux-build-environment WORKDIR /tmp 

# All builds will be done by user aosp 
COPY gitconfig /root/.gitconfig 
COPY ssh_config /root/.ssh/config 

# The persistent data will be in these two directories, everything else is considered to be ephemeral
 VOLUME ["/tmp/ccache", "/aosp"] 

# Improve rebuild performance by enabling compiler cache 
ENV USE_CCACHE 1 
ENV CCACHE_DIR /tmp/ccache 

# Work in the build directory, repo is expected to be init'd here 
WORKDIR /aosp 



# Prepare the directory needed for running ssh server 
RUN mkdir /var/run/sshd
EXPOSE 22 
CMD ["/usr/sbin/sshd", "-D"]

