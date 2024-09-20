FROM icr.io/codeengine/golang:alpine
RUN apk add --no-cache kubectl
RUN apk update 
COPY app.sh /root/app.sh
COPY DATAFILE /go/DATAFILE
RUN chmod +x /root/app.sh
ENTRYPOINT ["/root/app.sh"]

