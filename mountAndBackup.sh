#!/bin/bash
cd
mount ~/stack

cd stack

export myhost=$(hostname)
export daynr=$(date "+%d")

mkdir $myhost || true
cd $myhost
mkdir $daynr || true
cd $daynr


echo rm -rf ~/stack/$myhost/$daynr/*
rm -rf ~/stack/$myhost/$daynr/*

mkdir database || true
mkdir certificates || true
mkdir -p instance/log || true
mkdir -p instance/media || true
mkdir -p instance/translations || true

cp /data/ITR-data/database/backup/* database
cp /data/ITR-data/instance/* instance
cp -R /data/ITR-data/instance/log/* instance/log
cp -R /data/ITR-data/instance/media/* instance/media
cp -R /data/ITR-data/instance/translations/* instance/translations
cp -R /data/ITR-data/nginx/certificates/* certificates

umount ~/stack
