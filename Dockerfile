FROM docker.io/library/fedora 

RUN dnf install squid -y && dnf clean all

ENV SQUID_CACHE_DIR=/var/spool/squid
# ENV SQUID_LOG_DIR=/var/log/squid
ENV SQUID_LOCK_FILE=/var/run/squid.pid
# 
RUN touch "${SQUID_LOCK_FILE}" && chown squid:squid "${SQUID_LOCK_FILE}"
RUN chown -R squid:squid "${SQUID_CACHE_DIR}"
# RUN chown -R squid:squid "${SQUID_LOG_DIR}"
RUN /usr/lib64/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
RUN chown squid:squid -R /var/lib/ssl_db


VOLUME "/etc/squid/squid.conf"
VOLUME "/etc/squid/ssl_cert/"

EXPOSE "3128/tcp"

USER "squid"

# ENTRYPOINT ["/usr/sbin/squid", "-d", "3", "-X", "-N", "/etc/squid/squid.conf"]
ENTRYPOINT ["/usr/sbin/squid", "-N", "/etc/squid/squid.conf"]

