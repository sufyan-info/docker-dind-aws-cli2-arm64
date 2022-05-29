FROM docker
#FROM alpine:3.14

ARG AWS_CLI_VERSION=2.3.6

ARG GLIBC_ARCH=aarch64
ARG GLIBC_VERSION=2.33-r0

#
# System tools and dependencies
RUN set -e \
    && apk add --no-cache \
        binutils \
        curl \
        groff \
    && rm -rf /var/cache/apk/* /tmp/*

#
# Install glibc (required for awscli)
RUN set -e \
    && cd /tmp \
    && GLIBC_KEY="https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/cyphernode@satoshiportal.com.rsa.pub" \
    && GLIBC_URL='https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download' \
    && curl -sL ${GLIBC_KEY} -o /etc/apk/keys/cyphernode@satoshiportal.com.rsa.pub \
    && curl -sLO ${GLIBC_URL}/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}-${GLIBC_ARCH}.apk -o glibc-${GLIBC_VERSION}.apk \
    && curl -sLO ${GLIBC_URL}/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}-${GLIBC_ARCH}.apk -o glibc-bin-${GLIBC_VERSION}.apk \
    && curl -sLO ${GLIBC_URL}/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}-${GLIBC_ARCH}.apk -o glibc-i18n-${GLIBC_VERSION}.apk \
    && apk add --update --no-cache *.apk; \
        /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && apk del --purge glibc-i18n \
    && rm -rf /var/cache/apk/* /tmp/*

#
# Install awscli2
RUN set -e \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-${GLIBC_ARCH}-${AWS_CLI_VERSION}.zip -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && aws/install; \
        aws --version \
    && rm -f awscliv2.zip

WORKDIR /app
CMD ["/bin/sh"]
