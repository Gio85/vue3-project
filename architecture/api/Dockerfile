FROM node:14-alpine as base

FROM base as development
WORKDIR usr/app

FROM base as builder
WORKDIR usr/app
COPY . .
RUN ["yarn", "--cwd", "/usr/app", "install"]
RUN ["yarn", "--cwd", "/usr/app", "tsc" , "--skipLibCheck"]

FROM base as production
WORKDIR /usr/app
ENV NODE_ENV=production
RUN apk add --no-cache nginx
RUN apk add --no-cache supervisor  && rm -rf /tmp/* /var/cache/apk/*
COPY --from=builder /usr/app/supervisord.conf /etc/supervisord.conf
COPY --from=builder /usr/app/proxy.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/app/dist ./src
COPY --from=builder /usr/app/package.json ./
RUN ["yarn", "--cwd", "/usr/app", "install"]

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

EXPOSE 80

ARG BUILD_VERSION
ARG BUILD_DATE
ARG BUILD_VCS_REF
ARG IMAGE_NAME
ENV BUILD_VERSION=${BUILD_VERSION} \
  BUILD_DATE=${BUILD_DATE} \
  BUILD_VCS_REF=${BUILD_VCS_REF}
LABEL "org.label-schema.build-date"=${BUILD_DATE} \
  "org.label-schema.version"=${BUILD_VERSION} \
  "org.label-schema.vcs-ref"=${BUILD_VCS_REF} \
  "org.aimusic.image-name"=${IMAGE_NAME}
