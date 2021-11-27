FROM python:3.9-slim

RUN apt update && apt upgrade -y && \
    apt install --no-install-recommends -y \
        bash curl git libjpeg62-turbo-dev libwebp-dev ffmpeg neofetch

COPY . /usr/src/app/PaperplaneRemix/
WORKDIR /usr/src/app/PaperplaneRemix/

# "Dirty Fix" for Heroku Dynos to track updates via 'git'.
# Fork/Clone maintainers may change the clone URL to match
# the location of their repository. [#ThatsHerokuForYa!]
RUN if [ ! -d /usr/src/app/PaperplaneRemix/.git ] ; then \
    git clone "https://github.com/AvinashReddy3108/PaperplaneRemix.git" /tmp/dirty/PaperplaneRemix/ && \
    mv -v -u /tmp/dirty/PaperplaneRemix/.git /usr/src/app/PaperplaneRemix/ && \
    rm -rf /tmp/dirty/PaperplaneRemix/; \
    fi

# Install PIP packages
RUN python3 -m pip install --no-warn-script-location --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-warn-script-location --no-cache-dir --upgrade -r requirements.txt

# Cleanup
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp

ENTRYPOINT ["python", "-m", "userbot"]
