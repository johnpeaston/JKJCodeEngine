FROM icr.io/codeengine/golang:alpine
RUN apk add --no-cache curl
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
RUN ibmcloud plugin install cos -f
RUN mkdir -p -m 766 /root/Downloads
COPY app.sh /root/app.sh
RUN chmod +x /root/app.sh
ENTRYPOINT ["/root/app.sh"]

