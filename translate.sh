#!/bin/bash

# DeepL API 키 환경 변수에서 가져오기
API_KEY="${DEEPL_API_KEY}"

# API 키가 설정되어 있는지 확인
if [ -z "$API_KEY" ]; then
    echo "Error: DEEPL_API_KEY is not set. Please set it in your .zshrc file." >&2
    exit 1
fi

# 기본 설정
SOURCE_LANG="EN"
TARGET_LANG="KO"
API_URL="https://api.deepl.com/v2/translate"

# 사용법 함수
usage() {
    echo "Usage: echo 'Your text' | $0 [-s SOURCE_LANG] [-t TARGET_LANG]" >&2
    echo "  -s SOURCE_LANG : Source language (default: EN)" >&2
    echo "  -t TARGET_LANG : Target language (default: KO)" >&2
    exit 1
}

# 명령줄 인자 파싱
while getopts "s:t:h" opt; do
    case ${opt} in
        s )
            SOURCE_LANG=$OPTARG
            ;;
        t )
            TARGET_LANG=$OPTARG
            ;;
        h )
            usage
            ;;
        \? )
            usage
            ;;
    esac
done

# 표준 입력에서 텍스트 읽기 (줄바꿈 유지)
INPUT=$(cat)

# API 요청
RESPONSE=$(curl -s -X POST $API_URL \
    -H "Authorization: DeepL-Auth-Key $API_KEY" \
    -H "Content-Type: application/json" \
    --data "$(jq -n --arg text "$INPUT" \
        --arg source "$SOURCE_LANG" \
        --arg target "$TARGET_LANG" \
        '{text: [$text], source_lang: $source, target_lang: $target}')")

# 응답 확인 및 오류 처리
if echo "$RESPONSE" | jq -e '.error' > /dev/null; then
    ERROR_MESSAGE=$(echo "$RESPONSE" | jq -r '.error.message')
    echo "Error: $ERROR_MESSAGE" >&2
    exit 1
fi

# 응답에서 번역된 텍스트 추출 및 출력 (줄바꿈 유지)
echo "$RESPONSE" | jq -r '.translations[0].text'