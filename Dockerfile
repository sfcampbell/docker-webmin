FROM debian:stable-slim
MAINTAINER SFCampbell (https://github.com/sfcampbell/docker-webmin); forked from Sita Liu <chsliu+docker@gmail>

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Denver
ENV LOCALE=en_US.UTF-8

RUN echo root:pass | chpasswd && \
	echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes && \
	ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && \
	echo "$TZ" > /etc/timezone && \
	apt-get update && apt-get install -y apt-utils wget locales gnupg iproute2 moreutils && apt-get upgrade -y --with-new-pkgs && \
	echo "$LOCALE" > /etc/locale-gen && \
	locale-gen && \
	/usr/bin/touch /etc/apt/sources.list && \
	wget https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh && \
	sh setup-repos.sh -f && apt-get update && apt-get install -y webmin --install-recommends && apt-get autoremove -y --purge && apt-get clean

ENV LC_ALL $LOCALE

EXPOSE 10000

VOLUME ["/etc/webmin"]

CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log
