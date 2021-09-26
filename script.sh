#!/bin/bash

export accesskey=$1
export secretaccesskey=$2
export s3bucket=$3 
export client="10.0.0.212"  
export mgs="10.0.0.148"  
export mds="10.0.0.114"  
export oss1="10.0.0.90"   
export oss2="10.0.0.124"  
export oss3="10.0.0.78"

ip=$(hostname -I | awk '{print $1}') 

echo $ip >> ip


cat >/tmp/hosts <<\__EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.0.0.212  client
10.0.0.148  mgs
10.0.0.114  mds
10.0.0.90   oss1
10.0.0.124  oss2
10.0.0.78   oss3
__EOF

\cp /tmp/hosts /etc/hosts 


if [ $mgs == $ip ]; then
    echo "This is MGS node" >> out
    sudo yum -y install lustre-2.12.7
cat >/etc/modprobe.d/lnet.conf<<\__EOF
options lnet networks=tcp0(eth0)
__EOF
sudo modprobe lnet

lsmod | grep lnet

cat >/etc/sysconfig/modules/lnet.modules <<\__EOF
#!/bin/sh

if [ ! -c /dev/lnet ] ; then
    exec /sbin/modprobe lnet >/dev/null 2>&1
fi
__EOF
    #Create MGT on MDGS:
    mkfs.lustre --mgs /dev/nvme1n1
    mkdir /mgt
    mount.lustre /dev/nvme1n1 /mgt
elif [ $mds == $ip ]; then
    echo "This is MDS node" >> out
    sudo yum -y install lustre-2.12.7
cat >/etc/modprobe.d/lnet.conf<<\__EOF
options lnet networks=tcp0(eth0)
__EOF
sudo modprobe lnet

lsmod | grep lnet

cat >/etc/sysconfig/modules/lnet.modules <<\__EOF
#!/bin/sh

if [ ! -c /dev/lnet ] ; then
    exec /sbin/modprobe lnet >/dev/null 2>&1
fi
__EOF
    #Create MDT on MDS:
    mkfs.lustre --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --mdt --index=0 /dev/nvme1n1
    mkdir /mdt
    mount.lustre /dev/nvme1n1 /mdt
elif [ $oss1 == $ip ]; then
    echo "This is oss1 node" >> out
    sudo yum -y install lustre-2.12.7
cat >/etc/modprobe.d/lnet.conf<<\__EOF
options lnet networks=tcp0(eth0)
__EOF
sudo modprobe lnet

lsmod | grep lnet

cat >/etc/sysconfig/modules/lnet.modules <<\__EOF
#!/bin/sh

if [ ! -c /dev/lnet ] ; then
    exec /sbin/modprobe lnet >/dev/null 2>&1
fi
__EOF
    #Create OST 1,2,3,4 on OSS 1:
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=1 /dev/nvme1n1
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=2 /dev/nvme2n1  
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=3 /dev/nvme3n1  
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=4 /dev/nvme4n1  
    mkdir /ost1
    mkdir /ost2
    mkdir /ost3
    mkdir /ost4
    mount.lustre /dev/nvme1n1 /ost1
    mount.lustre /dev/nvme2n1 /ost2
    mount.lustre /dev/nvme3n1 /ost3
    mount.lustre /dev/nvme4n1 /ost4
elif [ $oss2 == $ip ]; then
    echo "This is oss2 node" >> out
    sudo yum -y install lustre-2.12.7
cat >/etc/modprobe.d/lnet.conf<<\__EOF
options lnet networks=tcp0(eth0)
__EOF
sudo modprobe lnet

lsmod | grep lnet

cat >/etc/sysconfig/modules/lnet.modules <<\__EOF
#!/bin/sh

if [ ! -c /dev/lnet ] ; then
    exec /sbin/modprobe lnet >/dev/null 2>&1
fi
__EOF
    #Create OST 5,6,7,8 on OSS 2:
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=5 /dev/nvme1n1
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=6 /dev/nvme2n1  
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=7 /dev/nvme3n1  
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=8 /dev/nvme4n1  
    mkdir /ost5
    mkdir /ost6
    mkdir /ost7
    mkdir /ost8
    mount.lustre /dev/nvme1n1 /ost5
    mount.lustre /dev/nvme2n1 /ost6
    mount.lustre /dev/nvme3n1 /ost7
    mount.lustre /dev/nvme4n1 /ost8
elif [ $oss3 == $ip ]; then
    echo "This is oss3 node" >> out
    sudo yum -y install lustre-2.12.7
cat >/etc/modprobe.d/lnet.conf<<\__EOF
options lnet networks=tcp0(eth0)
__EOF
sudo modprobe lnet

lsmod | grep lnet

cat >/etc/sysconfig/modules/lnet.modules <<\__EOF
#!/bin/sh

if [ ! -c /dev/lnet ] ; then
    exec /sbin/modprobe lnet >/dev/null 2>&1
fi
__EOF
    #Create OST 9,10,11,12 on OSS 3:
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=9 /dev/nvme1n1
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=10 /dev/nvme2n1  
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=11 /dev/nvme3n1  
    mkfs.lustre --ost --fsname=lustrefs --mgsnode=mgs@tcp0 \
        --index=12 /dev/nvme4n1  
    mkdir /ost9
    mkdir /ost10
    mkdir /ost11
    mkdir /ost12
    mount.lustre /dev/nvme1n1 /ost9
    mount.lustre /dev/nvme2n1 /ost10
    mount.lustre /dev/nvme3n1 /ost11
    mount.lustre /dev/nvme4n1 /ost12
elif [ $client == $ip ]; then
    echo "This is client node" >> out
    modprobe lustre

lsmod | grep lustre

cat >/etc/sysconfig/modules/lustre.modules <<\__EOF
#!/bin/sh

if [ ! -c /dev/lnet ] ; then
    exec /sbin/modprobe lnet >/dev/null 2>&1
fi
__EOF

    mkdir /lustrefs 
    mount -t lustre mgs@tcp0:/lustrefs /lustrefs

    df -h /lustrefs

    lfs check servers

    lfs df -h
    yum -y install \
        libs3-devel \
        libconfig-devel \
        libconfig-devel \
        libyaml-devel \
        kernel-devel \
        lz4-devel \
        libbsd-devel \
        openssl-devel \
        git \
        curl-devel \
        libxml2-devel\
        wget
        
    ###Install HSM S3 CopyTool 
    
    yum -y group install "Development Tools" 

    wget https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz 

    tar zxvf cmake-3.21.3.tar.gz 

    cd cmake-3.21.3
    ./bootstrap --prefix=/usr/local
    make -j$(nproc)
    make install
    cd ..

    git clone https://git.ichec.ie/performance/storage/estuary.git 

    cd estuary

    mkdir build

    cd build
     
    /usr/local/bin/cmake ..

    make 

cat >/tmp/config.cfg <<\__EOF
access_key = "$accesskey";
secret_key = "$secretaccesskey";
host = "$s3bucket.s3.amazonaws.com";
bucket_prefix = "lustrebucket";
bucket_count = 1;
chunk_size = 104857600;
ssl = true
__EOF
\cp /tmp/config.cfg /home/centos/estuary/config.cfg

else 
    echo "Something wrong" >> out
fi



