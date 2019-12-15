# Copyright (c) XPRIZE DevOps Team.
# Distributed under the terms of the MIT License.

ARG BASE_CONTAINER=jupyter/tensorflow-notebook
FROM $BASE_CONTAINER

LABEL maintainer="XPRIZE DevOps <xprizedevops@gmail.com>"

USER root
# Install all OS dependencies for a fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    dumb-init \
    host \
    && apt-get clean

USER $NB_UID
# Install the prompt-toolkit compatible with notebook 6.0.0
RUN pip install prompt-toolkit==2.0.10

# Install Spark magic
RUN pip install sparkmagic && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension

USER root
# Install Spark and PySpark kernels
RUN jupyter-kernelspec install /opt/conda/lib/python3.7/site-packages/sparkmagic/kernels/sparkkernel && \
    jupyter-kernelspec install /opt/conda/lib/python3.7/site-packages/sparkmagic/kernels/sparkrkernel && \
    jupyter-kernelspec install /opt/conda/lib/python3.7/site-packages/sparkmagic/kernels/pysparkkernel && \
    jupyter serverextension enable --py sparkmagic

# Copy the notebook startup script
COPY init /usr/local/bin/init

# Copy the Spark configuration file
COPY config.json /home/$NB_USER/.sparkmagic/

RUN fix-permissions /home/$NB_USER

USER $NB_UID
ENTRYPOINT ["dumb-init"]
CMD ["init"]
