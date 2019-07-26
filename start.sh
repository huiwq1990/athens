#Athens程序运行时依赖下载

ps -ef |grep athens2 | grep -v "grep" | awk '{print $2}' | xargs kill -9
rm -rf athens2
rm -rf hg.yaml

cd athens
export GOPROXY=https://goproxy.io
git pull
go mod vendor

#go依赖存储路径
mkdir -p /opt/athens/storage

go build -mod=vendor -o athens cmd/proxy/main.go

#由于下载内部包时，不需要使用代理，所以直接使用git
git config --global url."git@git.sankuai.com:".insteadOf "https://git.sankuai.com/"

cp ./athens ../athens2
cp ./hg.yaml ../
cd ../
rm -rf nohup.out
nohup ./athens2 -config_file hg.yaml &
