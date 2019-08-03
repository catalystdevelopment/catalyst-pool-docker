FROM       ubuntu:18.04
MAINTAINER n8tb1t <n8tb1t@gmail.com>

# Change the root password: docker exec -ti test_sshd passwd
# Don't allow passwords at all, use keys instead:
# docker exec test_sshd passwd -d root
# docker cp file_on_host_with_allowed_public_keys test_sshd:/root/.ssh/authorized_keys
# docker exec test_sshd chown root:root /root/.ssh/authorized_keys

RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:root' |chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
