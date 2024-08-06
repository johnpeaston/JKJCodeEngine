FROM icr.io/codeengine/golang:alpine
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
COPY app.sh /root/app.sh
RUN chmod +x /root/app.sh
ENTRYPOINT ["/root/app.sh"]

