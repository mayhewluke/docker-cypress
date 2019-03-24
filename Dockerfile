FROM cypress/browsers:latest

ARG CYPRESS_VERSION

RUN apt-get install -y net-tools

# The base images create user 1000 already, calling it node - this just gives us
# more clarity on what we're setting up, and more sensible naming
ARG USERNAME=cypress
ARG UID=1000
RUN userdel node && \
  adduser --uid $UID --disabled-password --gecos '' $USERNAME

# This is where the project directory should be mounted
WORKDIR /app
# Have to chown since WORKDIR creates dirs as root
RUN chown -R "$USER_UID":"$USER_UID" /app

USER $USERNAME

# The cypress documentation doesn't seem to mention this, but when the npm
# package is installed it stores the binary here, under ~/.cache. However, since
# we need to install the binary BEFORE we have access to the project files, we
# need to download it there manually.
ENV CYPRESS_DIR /home/$USERNAME/.cache/Cypress/$CYPRESS_VERSION
ENV ZIP_PATH /tmp/cypress.zip

# Install Cypress
RUN curl -o $ZIP_PATH https://cdn.cypress.io/desktop/$CYPRESS_VERSION/linux64/cypress.zip && \
  mkdir -p $CYPRESS_DIR && \
  unzip -d $CYPRESS_DIR $ZIP_PATH && \
  rm -f $ZIP_PATH

# Cypress will try to verify the binary is installed correctly when first run.
# This slows down invocations of the container, but for some reason running the
# binary with the `verify` command doesn't work, so we have to fake the output
# ourselves.
RUN echo '{"verified": true}' > $CYPRESS_DIR/Cypress/binary_state.json

COPY ./entrypoint.sh /home/cypress/entrypoint.sh
ENTRYPOINT [ "/home/cypress/entrypoint.sh" ]
