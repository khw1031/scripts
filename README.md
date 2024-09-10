# Shell Scripts

## consume_document.sh

```sh
./consume_document/input.md
./consume_document/run.sh
```

## translate.sh

파이프를 사용한 직접 입력

```bash
echo "Hello, world!" | ./translate.sh
```

파일 내용을 파이프로 전달

```bash
cat input.md | ./translate.sh
```

언어 옵션 지정:

```bash
echo "Bonjour le monde!" | ./translate.sh -s FR -t EN
```

여러 명령어 연결:

```bash
echo "Hello, world!" | ./translate.sh -s EN -t KO | ./translate.sh -s KO -t JA
```
