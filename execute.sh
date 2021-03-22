#!/bin/bash
set -e

# function
checkRequiredArgument () {
    if [ -z $1 ]; then
        echo "入力必須項目です"
        exit 1
    fi
}
checkBaseFileArgument () {
    if [ $1 != 'index.yaml' -a $1 != 'merge.yaml' ]; then
        echo "index.yaml/merge.yaml のどちらかの値のみ有効です"
        exit 1
    fi
}

# parameter set
echo -n "作成するAPIのエンドポイントを1つ入力してください:"
read apiPath
checkRequiredArgument $apiPath
echo "作成するAPIのエンドポイント: $apiPath"

echo -n "作成するAPIが属するタグを入力してください (タグがない場合は何も入力せずEnter):"
read tag
echo "作成するAPIが属するタグ: $tag"

echo -n "GUIで操作を行ったファイル名を入力してください (index.yaml/merge.yaml):"
read baseFile
checkRequiredArgument $baseFile
checkBaseFileArgument $baseFile
echo "GUIで操作を行ったファイル名: $baseFile"

# execute
./create.sh $apiPath $baseFile
