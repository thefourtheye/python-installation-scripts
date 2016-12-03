# Usage: ./install-python-rhel-6.sh 3.5.1 $PWD
# will install Python 3.5.1 in the current directory/python-3.5.1 directory

# This script is inspired from http://unix.stackexchange.com/q/77293/74826

VERSION=$1
MINOR_VERSION=$(echo $VERSION| cut -d'.' -f 1,2)
DESTDIR=$2/python-$VERSION

# Install Dependencies
sudo yum groupinstall "development tools" -y
sudo yum install readline-devel openssl-devel gmp-devel ncurses-devel gdbm-devel zlib-devel expat-devel libGL-devel tk tix gcc-c++ libX11-devel glibc-devel bzip2 tar tcl-devel tk-devel pkgconfig tix-devel bzip2-devel sqlite-devel autoconf db4-devel libffi-devel valgrind-devel -y

# Download Python source code
wget --no-check-certificate http://python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz

# Unpack it
tar xvfz Python-${VERSION}.tgz

# Do the standard configure-make procedure
cd Python-${VERSION}
./configure --prefix=$DESTDIR --enable-shared
make
make altinstall

# Configure the dynamically loaded libraries location
echo $DESTDIR/lib | sudo tee /etc/ld.so.conf.d/python-${VERSION}.conf
sudo ldconfig

# Install easy_install
wget --no-check-certificate https://bootstrap.pypa.io/ez_setup.py
$DESTDIR/bin/python$MINOR_VERSION ez_setup.py

# Clean up
rm -rf ez_setup.py
cd ..
rm -rf Python-${VERSION}
rm -rf Python-${VERSION}.tgz

# Do the victory dance
echo
echo "============================================================================================"
echo "Python-$VERSION successfully installed in $DESTDIR/bin"
echo "============================================================================================"
echo
