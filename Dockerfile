  FROM ubuntu:latest
  #using latest base os of ubuntu

  MAINTAINER shubhamkolekar7@gmail.com
  #owner


  RUN apt update -y && \
      apt install nginx -y && \
      apt clean
  #commands should be exucute 

  EXPOSE 80 
  #port http has been used to build connection

  CMD ["nginx", "-g" , "daemon off;"]

  #Daemon runs in foreground
  