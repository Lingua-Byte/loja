#!/usr/bin/env bash
# Roda UMA vez, no seu computador. Cria a chave de assinatura do app e guarda nos segredos do GitHub.
# Requer: keytool (vem com o Java), openssl e o GitHub CLI logado (gh auth login).
# Uso: ./configurar-chave.sh [usuario/repositorio]     (padrão: Lingua-Byte/loja)
set -euo pipefail
REPO="${1:-Lingua-Byte/loja}"
for c in keytool openssl gh base64; do command -v "$c" >/dev/null || { echo "Falta o programa: $c"; exit 1; }; done

if [ -f minha-chave.jks ]; then
  echo "Usando a chave existente: minha-chave.jks"
  [ -f minha-chave.senha.txt ] || { echo "Falta minha-chave.senha.txt"; exit 1; }
  SENHA="$(cat minha-chave.senha.txt)"
else
  SENHA="$(openssl rand -hex 16)"
  keytool -genkeypair -v -keystore minha-chave.jks -storetype PKCS12 -alias loja \
    -keyalg RSA -keysize 2048 -validity 10000 -storepass "$SENHA" -keypass "$SENHA" \
    -dname "CN=Lingua-Byte, O=Lingua-Byte, C=BR"
  echo "$SENHA" > minha-chave.senha.txt
fi

base64 -w0 minha-chave.jks 2>/dev/null > /tmp/ks.b64 || base64 minha-chave.jks | tr -d '\n' > /tmp/ks.b64
gh secret set ANDROID_KEYSTORE_BASE64   --repo "$REPO" < /tmp/ks.b64
gh secret set ANDROID_KEYSTORE_PASSWORD --repo "$REPO" --body "$SENHA"
gh secret set ANDROID_KEY_ALIAS         --repo "$REPO" --body "loja"
gh secret set ANDROID_KEY_PASSWORD      --repo "$REPO" --body "$SENHA"
rm -f /tmp/ks.b64

echo
echo "Pronto. Segredos salvos em $REPO."
echo "FAÇA BACKUP de minha-chave.jks e minha-chave.senha.txt (fora do GitHub)."
echo "Sem esses dois arquivos ninguém consegue atualizar o app já instalado."
