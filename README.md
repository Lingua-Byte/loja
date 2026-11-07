# Lingua Store

Loja de apps no estilo Microsoft Store, em três partes:

- `site/`: a loja (HTML), publicada no GitHub Pages. Também instalável como PWA.
- `app-android/`: o app Android que abre a loja. O APK é compilado na nuvem do GitHub.
- `.github/workflows/`: `pages.yml` publica a loja; `apk.yml` compila, assina e publica o APK.

## Passo a passo (uma vez)

1. Crie um repositório **público** chamado exatamente `loja` na conta `Lingua-Byte`
   (o endereço da loja será `https://lingua-byte.github.io/loja/`) e envie todo o conteúdo desta pasta.
2. No repositório: **Settings → Pages → Source: GitHub Actions**. A loja entra no ar sozinha.
3. No seu computador, dentro desta pasta, rode **`./configurar-chave.sh`**.
   Ele cria a chave de assinatura e guarda nos segredos do GitHub.
   **Faça backup de `minha-chave.jks` e `minha-chave.senha.txt`**: sem eles nenhuma atualização é aceita.
4. **Actions → "APK da loja" → Run workflow**. Em alguns minutos o `Loja.apk` aparece em **Releases**.

## Instalar no celular

Abra a loja (ou a página de Releases), toque em **Baixar para Android** e abra o arquivo.
Na primeira vez o Android pede para permitir "instalar apps desconhecidos" para o navegador.

## Atualizações

- **Conteúdo da loja** (novos apps, textos, visual): é só dar push em `site/`. O app mostra na hora, sem APK novo.
- **O próprio APK**: rode o workflow de novo. Cada execução gera uma versão maior (`v1.0.N`).
  Para receber sozinho, adicione `https://github.com/Lingua-Byte/loja` no Obtainium.

## Adicionar um app à loja

Acrescente um bloco em `site/apps.json` e publique um Release público no repositório do app
(`.apk` vira botão Android, `.exe` vira botão Windows, o campo `web` vira "Abrir no navegador").
