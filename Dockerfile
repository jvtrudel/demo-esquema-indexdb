FROM node:18-alpine3.15 AS builder

RUN apk update && apk add python3 make g++ curl

RUN      mkdir -p /builder/vendors/bootstrap\
         && mkdir -p /builder/vendors/js-yaml\
         && mkdir -p /builder/vendors/ajv
WORKDIR /builder
RUN npm install js-yaml browserify
    
RUN ls /builder/vendors && npx browserify node_modules/js-yaml/dist/js-yaml.min.js > /builder/vendors/js-yaml/js-yaml.min.js

RUN wget https://github.com/ajv-validator/ajv/archive/refs/tags/v8.11.0.tar.gz\
    && tar xzf v8.11.0.tar.gz\
    && cd ajv-8.11.0\
    && npm install\
    && npm run bundle

RUN cp ajv-8.11.0/bundle/* /builder/vendors/ajv/

RUN curl https://raw.githubusercontent.com/nodeca/js-yaml/master/dist/js-yaml.min.js > /builder/vendors/js-yaml/js-yaml.min.js\
    && curl https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css.map > /builder/vendors/bootstrap/bootstrap.min.css.map\
    && curl https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css > /builder/vendors/bootstrap/bootstrap.min.css\
    && curl https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js.map > /builder/vendors/bootstrap/bootstrap.bundle.min.js.map\
    && curl https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js > /builder/vendors/bootstrap/bootstrap.bundle.min.js

FROM nginx:1.23.1-alpine

COPY --from=builder /builder/vendors /usr/share/nginx/html/vendors

# TODO: generate a certificate at runtime if needed
#COPY --from=builder /etc/nginx/certs /etc/nginx/certs
#RUN mkdir -p /etc/nginx/certs
#RUN curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"\
#    && chmod +x mkcert-*\
#    && mv mkcert-* /usr/local/bin/mkcert
#RUN mkcert localhost 0.0.0.0 192.168.0.171\
#    && mkdir -p /etc/nginx/certs\
#    && mv *.pem /etc/nginx/certs/


# TODO: supercharge the entrypoint to start a html file watch process
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
