#!/bin/bash

#対話型シェルの中でバックスペースを使えるようにコマンドを置換する
stty erase '^H'

declare -a menu_title
declare -a menu_command

### メニュー表示
menu_title=(
[1]="リソース一覧を表示（プロジェクト全体）"
[2]="リソース一覧を表示（特定のラベルのみ）"
[3]="リソースの削除"
[4]="OpenShiftへのログイン"
)

### 実行コマンド
menu_command=(
[1]="show_all_resource_execute"
[2]="show_specific_resource_execute"
[3]="delete_specifict_resource"
[4]="login_openshift_cli"
)


#メニュー表示
function display_menu() {
    echo "##### MENU #####"
    IFS=$'\n'
    for key in ${!menu_title[@]}; do
        if [ "${menu_title[${key}]}" = "-" ]; then
            echo "----------"
        else
            echo "${key}: ${menu_title[${key}]}"
        fi
    done
    echo "0: EXIT"
    echo -n "number> "
    read INPUT_KEY
}

#コマンド選択後もメニューに戻るようにする
function select_menu() {
    while :
    do
        display_menu

        if [ "${INPUT_KEY}" = "0" ]; then
            exit;
        fi
        IFS=$' '
        ${menu_command[${INPUT_KEY}]}
    done
}

show_all_resource(){
  # 全体のリソースの一覧化
  echo "--------------------------------------------------------------------------------"
  echo "＜ワークロード／デプロイメント： Deployment＞"
  echo "[$whoami@$current_project] oc get deployment"
  oc get deployment

  echo "--------------------------------------------------------------------------------"
  echo "＜ワークロード／デプロイメント設定： DeploymentConfig＞"
  echo "[$whoami@$current_project] oc get deploymentconfig"
  oc get deploymentconfig

  echo "--------------------------------------------------------------------------------"
  echo "＜ワークロード／シークレット：secret＞"
  echo "[$whoami@$current_project] oc get secret"
  oc get secret --field-selector type=Opaque

  echo "--------------------------------------------------------------------------------"
  echo "＜ネットワーク／サービス：serice＞"
  echo "[$whoami@$current_project] oc get service"
  oc get service

  echo "--------------------------------------------------------------------------------"
  echo "＜ネットワーク／ルート：route＞"
  echo "[$whoami@$current_project] oc get route"
  oc get route

  echo "--------------------------------------------------------------------------------"
  echo "＜ストレージ／永続ストレージ要求：persistentvolumeclaim＞"
  echo "[$whoami@$current_project] oc get pvc"
  oc get pvc

  echo "--------------------------------------------------------------------------------"
  echo "＜ビルド／ビルド設定：buildconfig＞"
  echo "[$whoami@$current_project] oc get buildconfig"
  oc get buildconfig

  echo "--------------------------------------------------------------------------------"
  echo "＜ビルド／イメージストリーム：imagestream＞"
  echo "[$whoami@$current_project] oc get imagestream"
  oc get imagestream
  echo "--------------------------------------------------------------------------------"

}

function show_specific_resource(){
  # 削除予定のリソースの一覧化
  echo "--------------------------------------------------------------------------------"
  echo "＜ワークロード／デプロイメント： Deployment＞"
  echo "[$whoami@$current_project] oc get deployment -l \"$lesson\""
  oc get deployment -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ワークロード／デプロイメント設定： DeploymentConfig＞"
  echo "[$whoami@$current_project] oc get deploymentconfig -l \"$lesson\""
  oc get deploymentconfig -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ワークロード／シークレット：secret＞"
  echo "[$whoami@$current_project] oc get secret -l \"$lesson\""
  oc get secret --field-selector type=Opaque -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ネットワーク／サービス：serice＞"
  echo "[$whoami@$current_project] oc get service -l \"$lesson\""
  oc get service -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ネットワーク／ルート：route＞"
  echo "[$whoami@$current_project] oc get route -l \"$lesson\""
  oc get route -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ストレージ／永続ストレージ要求：persistentvolumeclaim＞"
  echo "[$whoami@$current_project] oc get pvc -l \"$lesson\""
  oc get pvc -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ビルド／ビルド設定：buildconfig＞"
  echo "[$whoami@$current_project] oc get buildconfig -l \"$lesson\""
  oc get buildconfig -l "$lesson"

  echo "--------------------------------------------------------------------------------"
  echo "＜ビルド／イメージストリーム：imagestream＞"
  echo "[$whoami@$current_project] oc get imagestream -l \"$lesson\""
  oc get imagestream -l "$lesson"
  echo "--------------------------------------------------------------------------------"

}

function show_all_resource_execute(){
  whoami=$(oc whoami)
  current_project=$(oc config view --minify -o 'jsonpath={..namespace}')
  echo "現在ログインしているユーザ名 : $whoami"
  echo "現在使用しているプロジェクト : $current_project"

  export whoami
  export current_project
  echo "リソース一覧を表示（プロジェクト全体）"
  show_all_resource
}

function show_specific_resource_execute(){
  whoami=$(oc whoami)
  current_project=$(oc config view --minify -o 'jsonpath={..namespace}')
  echo "現在ログインしているユーザ名 : $whoami"
  echo "現在使用しているプロジェクト : $current_project"

  export whoami
  export current_project
  echo "リソース一覧を表示（特定のラベルのみ）"
  # 削除したいレッスン名の入力（タグ名）
  echo "特定のラベルがついたリソースの一覧を取得します。ラベル名を入力してください。"
  read -ep 'ラベル名[app=openshift-lesson]:' lesson

  if [ -z $lesson ]; then
    lesson="app=openshift-lesson"
  fi

  show_specific_resource
}



function delete_specifict_resource(){
# 現在のログインユーザ／使用プロジェクトを確認する
  whoami=$(oc whoami)
  current_project=$(oc config view --minify -o 'jsonpath={..namespace}')
  echo "現在ログインしているユーザ名 : $whoami"
  echo "現在使用しているプロジェクト : $current_project"

  read -ep "ログインしているユーザ名／使用するプロジェクト名はあっていますか？[Y/N] :" confirm

  while [ -z $confirm ] || ( [ $confirm != 'Y' ] && [ $confirm != 'N' ] )
  do
    echo "Y/Nで入力してください。"
    read -ep '[Y/N] :'  confirm
  done

  if [ $confirm = 'N' ]; then
    echo "正しいユーザでログインしてください。正しいプロジェクト設定を実施してください。"
    return
  fi

# 削除したいレッスン名の入力（タグ名）
  echo "削除対象のリソース一覧を取得します。削除したいラベル名を入力してください。"
  read -ep 'ラベル名[app=openshift-lesson]:' lesson

  if [ -z $lesson ]; then
    lesson="app=openshift-lesson"
  fi
  echo "削除するラベル名：$lesson"

  export whoami
  export current_project
  export lesson
  show_specific_resource


# リソースの削除
  read -ep "上記リソースを削除します。よろしいですか？[Y/N]" confirm
  while [ -z $confirm ] || (  [ $confirm != 'Y' ] && [ $confirm != 'N' ] )
  do
    echo "Y/Nで入力してください。"
    read -ep '[Y/N] :'  confirm
  done

  if [ $confirm = 'N' ]; then
    echo "処理を終了します。"
    return
  fi

  echo "リソースを削除しています。"
  oc delete deployment -l "$lesson"
  oc delete deploymentconfig -l "$lesson"
  oc delete secret -l "$lesson"
  oc delete service -l "$lesson"
  oc delete route -l "$lesson"
  oc delete pvc -l "$lesson"
  oc delete buildconfig -l "$lesson"
  oc delete imagestream -l "$lesson"

  echo "リソースを削除しました。削除漏れのあるリソースがないか確認してください。"

  show_all_resource

}

function login_openshift_cli(){
default_URL=https://api.h6nreujn.eastus.aroapp.io:6443/
default_USER=ocurak0101

  whoami=$(oc whoami)
  echo "現在ログインしているユーザ名 : $whoami"
  read -ep "ログインしているユーザ名はあっていますか？[Y/N] :" confirm
  while [ -z $confirm ] || ( [ $confirm != 'Y' ] && [ $confirm != 'N' ] )
  do
    echo "Y/Nで入力してください。"
    read -ep '[Y/N] :'  confirm
  done

  if [ $confirm = 'N' ]; then
    echo "ログインするユーザIDを入力してください。"
    read -ep "ユーザID[$default_USER] :" username

    if [ -z $username ] ; then
      username=$default_USER
    fi
    oc login -u $username $default_URL
  fi

  current_project=$(oc config view --minify -o 'jsonpath={..namespace}')
  echo "現在使用しているプロジェクト : $current_project"
  read -ep "使用するプロジェクト名はあっていますか？[Y/N] :" confirm
  while [ -z $confirm ] || ( [ $confirm != 'Y' ] && [ $confirm != 'N' ] )
  do
    echo "Y/Nで入力してください。"
    read -ep '[Y/N] :'  confirm
  done

  if [ $confirm = 'N' ]; then
    echo "利用できるプロジェクト一覧"
    oc get projects
    echo "-----------------------------------------------------------"

    echo "使用するプロジェクト名を入力してください。"
    read -ep "プロジェクト名 ：" project_name
    oc project $project_name
    current_project=$(oc config view --minify -o 'jsonpath={..namespace}')
    echo "現在使用しているプロジェクト : $current_project"
  fi

  whoami=$(oc whoami)
  current_project=$(oc config view --minify -o 'jsonpath={..namespace}')
  echo "処理を終了します。"
  echo "-----------------------------------------------------------"
  echo "現在ログインしているユーザ名 : $whoami"
  echo "現在使用しているプロジェクト : $current_project"
  echo "-----------------------------------------------------------"

  return
}


# MAIN文 メニューの表示
select_menu



