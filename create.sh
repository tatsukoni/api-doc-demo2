#!/bin/bash
set -e

# usage
notEnoughAugument () {
    echo "第1引数に対象のAPIエンドポイント指定が必要です。"
    exit 1
}

# parameter set
cd $(dirname $0)
targetPath=$1
baseFile=$2
if [ $# -lt 1 ]; then
    notEnoughAugument
fi
if [ -z $2 ]; then
    baseFile='index.yaml'
fi

# execute
# 指定されたAPIエンドポイントの記述内容をベースのyamlから抜き取り、tmp.yamlに一時保存
expath=`printf '\"%s\"' $targetPath`
yq -y .paths.$expath $baseFile > tmp.yaml

# 指定されたAPIエンドポイントから、記述内容を置くためのディレクトリを作成し、tmp.yamlを配置する
mkdir -p paths && mv tmp.yaml ./paths/tmp.yaml && cd paths
arrPath=(${targetPath//// })
refPath='.'
for path in "${arrPath[@]}";
do
    dir=$path
    if [[ $path =~ ^{(.*)}$ ]]; then
        dir='_'${BASH_REMATCH[1]}
    fi
    refPath="${refPath}/${dir}"
done
# 配置の際、ファイル名は他と合わせてindex.yamlとする
mkdir -p $refPath && rm -f "${refPath}/index.yaml" && mv tmp.yaml "${refPath}/index.yaml"

# paths/index.yamlにAPIエンドポイント情報を書き込む (エンドポイント新規作成時のみ)
if ! grep -q $targetPath index.yaml; then
    ref='$ref'
    cat <<EOF >> index.yaml
$targetPath:
  $ref: "${refPath}/index.yaml"
EOF
fi
