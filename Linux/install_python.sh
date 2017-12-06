wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz
tar xf Python-3.6.3.tgz
cd Python-3.6.3/
 ./configure --prefix="/usr/local/lib/python3.6"
make -j8
sudo make install
sudo ln -s /usr/local/lib/python3.6/bin/python3.6 /usr/local/bin/python3.6
sudo ln -s /usr/local/lib/python3.6/bin/pip3.6 /usr/local/bin/pip3.6