apt-get install squid-deb-proxy-client -y
echo 'Acquire::http::Proxy "#{deb_cache_host}";' | sudo tee /etc/apt/apt.conf.d/30autoproxy
echo "Acquire::http::Proxy { debian.datastax.com DIRECT; };" | sudo tee -a /etc/apt/apt.conf.d/30autoproxy
echo "Acquire::http::Proxy { ppa.launchpad.net DIRECT; };" | sudo tee -a /etc/apt/apt.conf.d/30autoproxy
cat /etc/apt/apt.conf.d/30autoproxy
CACHE
