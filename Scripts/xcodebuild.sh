#!/bin/sh

#
# 安装Facebook 的xctool https://github.com/facebook/xctool
# brew install xctool
#

OPTIONDEBUG="Debug"
OPTIONRELEASE="Release"
OPTIONQUIT="Quit"

PS3='请输入你想要的《WeChat》发布的版本: '
OPTIONS=("$OPTIONDEBUG" "$OPTIONRELEASE" "$OPTIONQUIT")
VERSION="none"
select opt in "${OPTIONS[@]}"
do
    case $opt in
        "Debug")
            VERSION="$OPTIONDEBUG"
            break
            ;;
        "Release")
            VERSION="$OPTIONRELEASE"
            break
            ;;
        "Quit")
            VERSION="$OPTIONQUIT"
            break
            ;;
        *) echo invalid option;;
    esac
done

if [ "$VERSION" = "$OPTIONDEBUG" ];then
    echo "你选择的版本是《WeChat》 Debug"
elif [ "$VERSION" = "$OPTIONRELEASE" ];then
    echo "你选择的版本是《WeChat》 Release"
else
    echo "\n"
    echo "Error:你没有选择版本，程序退出"
    exit 0
fi


echo "你选择的版本是《WeChat》 $selectValue"

echo "----------正在编译《WeChat》----------"

#生成 build 的目录名称
BUILD_DIRECTORY="${HOME}/Desktop/TSWeChat_build"

#生成 ipa 的目录名称
IPA_DIRECTORY="${HOME}/Desktop/TSWeChat_ipa"

#运行当前脚本的路径名称
CURRENT_SCRIPTS_PATH=`pwd`

# cd ${HOME}/code/TSWeChat
cd ${CURRENT_SCRIPTS_PATH}/..

if [ ! -d ${BUILD_DIRECTORY} ]; then
    mkdir ${BUILD_DIRECTORY}
fi

if [ ! -d ${IPA_DIRECTORY} ]; then
    mkdir ${IPA_DIRECTORY}
fi

#配置参数
BUILD_DAY=$(date +%Y-%m-%d)
BUILD_TIME=$(date +%Y-%m-%d-%H-%M)

#代码签名的文件名称，也就是Target->Build Settings->Provisioning Profile 的名称
PROVISIONING_PROFILE="TSWeChat_provisioning_profile"

#开发证书文件的名称
CODE_SIGN_IDENTITY="iPhone Distribution: TSWeChat"

#配置信息
BUILD_CONFIG="Release"
if [ "$VERSION" = "Debug" ];then
    BUILD_CONFIG="Test"
fi

#build 的文件地址
BUILD_PATH="${BUILD_DIRECTORY}/${BUILD_DAY}/TSWeChat_${BUILD_TIME}.xcarchive"

#ipa 文件名称
IPA_NAME="${IPA_DIRECTORY}/TSWeChat_${BUILD_TIME}.ipa"

#workspace 名称
WORKSPACE_NAME="TSWeChat.xcworkspace"

#scheme 名称
SCHEME_NAME="TSWeChat"

osascript -e 'display notification "正在编译" with title "WeChat"'

#判断是否安装了 xctool
hash xctool &> /dev/null
if [ $? -eq 0 ];then
    #利用 Facebook 的 xctool 进行 clean 和编译
    xctool -workspace ${WORKSPACE_NAME} -scheme ${SCHEME_NAME} -configuration ${BUILD_CONFIG} CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" clean
    xctool -workspace ${WORKSPACE_NAME} -scheme ${SCHEME_NAME} -configuration ${BUILD_CONFIG} CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" archive -archivePath ${BUILD_PATH} -destination generic/platform=iOS
else
    xcodebuild -workspace ${WORKSPACE_NAME} -scheme ${SCHEME_NAME} -configuration ${BUILD_CONFIG} CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" clean
    xcodebuild -workspace ${WORKSPACE_NAME} -scheme ${SCHEME_NAME} -configuration ${BUILD_CONFIG} CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" archive -archivePath ${BUILD_PATH} -destination generic/platform=iOS
fi


# #如果是Release版本，导出 dSYM 文件，利用 bugly 的压缩工具进行解压 (http://bugly.qq.com/iossdk)
if [ "$VERSION" = "$OPTIONRELEASE" ];then
    echo "----------正在导出 dSYM 文件-----------"
    dSYM_PATH="${IPA_DIRECTORY}/TSWeChat.app.symbol.zip"
    java -jar `pwd`/buglySymbolIOS.jar -i ${BUILD_PATH}/dSYMs/TSWeChat.app.dSYM/Contents/Resources/DWARF/TSWeChat -o ${dSYM_PATH}
fi

echo "----------正在导出 ipa 文件 -------------"
#利用 xcodebuild 进行ipa 文件导出
xcodebuild \
    -exportArchive \
    -archivePath ${BUILD_PATH} \
    -exportPath ${IPA_NAME} \
    -exportFormat ipa \
    -exportProvisioningProfile "$PROVISIONING_PROFILE" \
    # -exportSigningIdentity "$CODE_SIGN_IDENTITY"



