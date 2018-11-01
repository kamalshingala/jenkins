FROM centos:7

LABEL maintainer="Derrick Fernandes">

ARG JMETER_VERSION="5.0"

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN  ${JMETER_HOME}/bin
ENV MIRROR_HOST http://mirrors.ocf.berkeley.edu/apache/jmeter
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL https://jmeter-plugins.org/files/packages
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/

RUN    yum -y update \
        && yum -y install ca-certificates unzip zip fontconfig ttf-dejavu\
            && yum -y install java tzdata curl unzip bash \
            && cp /usr/share/zoneinfo/Australia/Sydney /etc/localtime \
            && echo "Australia/Sydney" >  /etc/timezone \
        && rm -rf /var/cache/yum/* \
        && mkdir -p /tmp/dependencies  \
        && curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
        && mkdir -p /opt  \
        && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
        && rm -rf /tmp/dependencies \
		&& mkdir -p /mnt/jmeter  

RUN curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL}/jpgc-webdriver-3.0.zip -o jpgc-webdriver-3.0.zip
RUN unzip jpgc-webdriver-3.0.zip -d jpgc-webdriver-3.0
RUN cp -r jpgc-webdriver-3.0/lib/* ${JMETER_HOME}/lib/
RUN rm jpgc-webdriver-3.0.zip
RUN rm -r jpgc-webdriver-3.0
RUN curl -L --silent https://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.4.0.zip -o JMeterPlugins-Standard-1.4.0.zip
RUN unzip JMeterPlugins-Standard-1.4.0.zip -d JMeterPlugins-Standard
RUN cp -r JMeterPlugins-Standard/lib/* ${JMETER_HOME}/lib/
RUN rm JMeterPlugins-Standard-1.4.0.zip
RUN rm -r JMeterPlugins-Standard
RUN curl -L --silent https://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.4.0.zip -o JMeterPlugins-Extras-1.4.0.zip
RUN unzip JMeterPlugins-Extras-1.4.0.zip -d JMeterPlugins-Extras
RUN cp -r JMeterPlugins-Extras/lib/* ${JMETER_HOME}/lib/
RUN rm JMeterPlugins-Extras-1.4.0.zip
RUN rm -r JMeterPlugins-Extras
RUN curl -L --silent https://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.4.0.zip -o JMeterPlugins-ExtrasLibs-1.4.0.zip
RUN unzip JMeterPlugins-ExtrasLibs-1.4.0.zip -d JMeterPlugins-ExtrasLibs
RUN cp -r JMeterPlugins-ExtrasLibs/lib/* ${JMETER_HOME}/lib/
RUN rm -r JMeterPlugins-ExtrasLibs
RUN rm JMeterPlugins-ExtrasLibs-1.4.0.zip
RUN curl -L --silent https://jmeter-plugins.org/files/packages/jpgc-synthesis-2.1.zip -o jpgc-synthesis-2.1.zip
RUN unzip jpgc-synthesis-2.1.zip -d jpgc-synthesis
RUN cp -r jpgc-synthesis/lib/* ${JMETER_HOME}/lib/
RUN rm -r jpgc-synthesis
RUN rm jpgc-synthesis-2.1.zip
RUN curl -L --silent https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -o google-chrome-stable_current_x86_64.rpm
RUN yum -y install ./google-chrome-stable_current_x86_64.rpm
RUN rm google-chrome-stable_current_x86_64.rpm
RUN curl -L --silent https://chromedriver.storage.googleapis.com/2.43/chromedriver_linux64.zip -o chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d chromedriver_linux64
RUN cp -r chromedriver_linux64/* ${JMETER_HOME}/
RUN chmod +x ${JMETER_HOME}/chromedriver
RUN rm chromedriver_linux64.zip
RUN rm -r chromedriver_linux64

ENV PATH $PATH:$JMETER_BIN


COPY launch.sh /
COPY jmeter-plugins-webdriver-3.0.jar ${JMETER_HOME}/lib/ext/jmeter-plugins-webdriver-3.0.jar
RUN chmod +x /launch.sh

WORKDIR ${JMETER_HOME}

ENTRYPOINT ["/launch.sh"]
