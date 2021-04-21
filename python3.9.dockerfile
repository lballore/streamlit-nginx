FROM python:3.9-slim

LABEL maintainer="Luca Ballore <luca@lucaballore.com>"

USER root

# System deps
RUN apt-get -qq update && \
    apt-get -y install wget gnupg && \
    wget https://nginx.org/keys/nginx_signing.key && \
    cat nginx_signing.key | apt-key add - && \
    apt-get -qq update && \
    apt-get -y install nginx && \
    rm nginx_signing.key && \
    rm -rf /var/lib/apt/lists/*

# Python deps
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt --no-cache-dir --timeout 1000

# User settings
RUN useradd -m -u 1000 -d /home/streamlitapp streamlitapp
RUN chown -R streamlitapp /var/log/nginx /var/lib/nginx

# Config and exec files
COPY --chown=streamlitapp ./config/nginx /home/streamlitapp/.nginx/
COPY --chown=streamlitapp ./config/streamlit /home/streamlitapp/.streamlit/
COPY --chown=streamlitapp ./bin /home/streamlitapp/bin/

# Paths
ENV PYTHONPATH "${PYTHONPATH}:/home/streamlitapp/src"
ENV PATH "${PATH}:/home/streamlitapp/src/bin:/home/streamlitapp/src/server/bin"

WORKDIR /home/streamlitapp
USER streamlitapp

ENTRYPOINT ["/home/streamlitapp/bin/start-nginx.sh"]

CMD ["streamlit", "hello"]
