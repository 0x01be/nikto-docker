FROM alpine as build

RUN apk add --no-cache --virtual nikto-build-dependencies \
    git

ENV NIKTO_REVISION master
RUN git clone --depth 1 --branch ${NIKTO_REVISION} https://github.com/sullo/nikto.git /nikto

RUN mkdir -p /opt/nikto
RUN cp -R /nikto/program/* /opt/nikto/

FROM alpine

COPY --from=build /opt/nikto/ /opt/nikto/

RUN apk add --no-cache --virtual nikto-runtime-dependencies \
    perl \
    perl-net-ssleay

RUN adduser -D -u 1000 nikto
RUN chown -R nikto:nikto /opt/nikto

USER nikto

ENV PATH ${PATH}:/opt/nikto/

WORKDIR /opt/nikto

CMD "/opt/nikto/nikto.pl"

