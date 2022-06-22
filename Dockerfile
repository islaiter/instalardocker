# Elegimos distribucion de Linux

FROM alpine:edge

# Instalamos y configuramos las dependencias

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester libqrencode && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Configuramos variables de entorno

ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

# Linkeamos el volumen que configuramos fuera

VOLUME ["/etc/openvpn"]

# Exponemos el puerto interno 1194, luego tenemos que remapearlo con docker run -p 443:1194/tcp
EXPOSE 1194/tcp

# Instalamos ovpn

CMD ["ovpn_run"]

# Damos permisos

#ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Añadimos autenticacion con OTP si fuera necesario

#ADD ./otp/openvpn /etc/pam.d/
