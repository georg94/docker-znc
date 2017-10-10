FROM debian:stretch

ENV ZNC_HOME /znc-data

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libsasl2-modules \
    znc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && addgroup --gid 6001 znc \
  && adduser --system --uid 6001 --gid 6001 --home ${ZNC_HOME} --shell /bin/bash znc

ENV TINI_VERSION v0.16.1
ENV TINI_SHA c7faf940a2e5234bf9e324861469d7879c44c7152555e8b143f2b7c38c3d2efc
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -o /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c - \
  && chmod +x /bin/tini

COPY files/entrypoint.sh /entrypoint.sh
COPY files/znc.conf.default /znc.conf.default

VOLUME ${ZNC_HOME}

EXPOSE 80
EXPOSE 6667

ENTRYPOINT ["/bin/tini", "--", "/entrypoint.sh"]
