FROM icr.io/codeengine/golang:alpine
RUN apk upgrade
COPY app.sh /root/app.sh
RUN chmod +x /root/app.sh
ENTRYPOINT ["/root/app.sh"]

