FROM debian:stretch-slim as base

# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ARG TIME_ZONE

LABEL maintainer="INHddd <kyosls@gmail.com>"

RUN set -x && \
		apt-get update && \
		apt-get install \
			--no-install-recommends \
			--no-install-suggests \
			-y beanstalkd

RUN mkdir -p /opt/etc && \
		cp -a --parents /usr/bin/beanstalkd /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libsystemd.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libc.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libselinux.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/librt.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/liblzma.so.* /opt && \
		cp -a --parents /usr/lib/x86_64-linux-gnu/liblz4.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libgcrypt.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libpthread.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libpcre.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libdl.so.* /opt && \
		cp -a --parents /lib/x86_64-linux-gnu/libgpg-error.so.* /opt && \
		cp /usr/share/zoneinfo/${TIME_ZONE:-ROC} /opt/etc/localtime

FROM gcr.io/distroless/base

COPY --from=base /opt /

EXPOSE 11300

ENTRYPOINT ["beanstalkd"]
