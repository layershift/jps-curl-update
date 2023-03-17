#!/bin/bash
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
function is_curl_updated {
  curl_version=$(curl -V | awk -F' ' '{print $2}' | head -n1)
  curl_latest_version="7.88.1"
  if ! [ $(version $curl_version) -ge $(version $curl_latest_version) ]; then 
    # is NOT up to date 
    return 1;
  else 
    # is up to date
    return 0;
  fi
}


if ! yum repolist all | grep city-fan.org >> /dev/null 2>&1; then 
  rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/rhel7/x86_64/city-fan.org-release-3-6.rhel7.noarch.rpm
  if ! is_curl_updated; then 
    yum --enablerepo=city-fan.org -y install curl 
  fi
else 
  if is_curl_updated; then
    echo "isUp";
  else
    echo "isNot";
  fi
fi