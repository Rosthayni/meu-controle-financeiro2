# Meu Controle Financeiro — versão 4.2 (preparada para nuvem)

## O que mudou
- Mantém as áreas de **Faturas**, **Parcelas** e **Limites**, além dos lançamentos, planejamento, importação CSV/OFX e backup JSON.
- Adiciona tela de configuração do Supabase, criação de conta por e-mail/senha, login e logout.
- Com um projeto Supabase configurado, os dados são enviados para uma tabela privada e podem ser carregados em outros aparelhos ao entrar com a mesma conta.
- Se a nuvem não estiver configurada, o app continua funcionando em modo local.
- Adiciona o manifesto e o service worker PWA com cache v4.

## Importante: a nuvem ainda precisa ser configurada
Este pacote inclui o código de conexão, mas não cria automaticamente um projeto Supabase nem contém credenciais de um projeto. Até você configurar um projeto, o aplicativo continua armazenando dados localmente no navegador.

## Configurar a nuvem (uma única vez)
1. Acesse https://supabase.com e crie um projeto pessoal.
2. No painel do projeto, abra **SQL Editor** e execute todo o conteúdo do arquivo `supabase-setup.sql`.
3. Em **Project Settings → API** (ou **Connect**, conforme a interface), copie a **Project URL** e a chave pública **anon/publishable**. Nunca use a chave `service_role` no aplicativo.
4. Em **Authentication → URL Configuration**, configure a URL do site publicado como endereço permitido. Para GitHub Pages, use o endereço exato do seu app, por exemplo `https://SEU-USUARIO.github.io/meu-controle-financeiro/`.
5. Publique os arquivos deste pacote no GitHub Pages, substituindo os arquivos antigos.
6. Abra o app publicado e vá a **Dados e backup → Sincronização na nuvem e acesso pessoal**.
7. Cole a Project URL e a chave pública, clique em **Salvar configuração**, depois em **Criar minha conta**. Confirme o e-mail se o Supabase solicitar e entre.
8. Faça um backup JSON antes de escolher entre dados locais e dados já existentes na nuvem.
9. Depois de criar e confirmar sua conta, para restringir o acesso, desative novos cadastros públicos nas configurações de autenticação do Supabase, se a interface do seu projeto oferecer essa opção. Guarde suas credenciais com segurança.
10. Em cada aparelho, abra o mesmo endereço, informe a mesma URL/chave pública e entre com a mesma conta.

## Segurança
- A tabela `user_finance_data` usa Row Level Security (RLS), com políticas que permitem que a pessoa autenticada acesse somente a linha cujo `user_id` corresponde ao seu próprio usuário.
- A chave pública/anon é destinada ao cliente e não substitui a segurança: a proteção real dos dados depende de RLS e das configurações de autenticação.
- **Nunca** copie a chave `service_role` para este app, para o GitHub ou para qualquer navegador.
- Use uma senha exclusiva e mantenha o e-mail de recuperação seguro.
- O pacote não conecta automaticamente aos bancos e não armazena senhas bancárias, números completos de cartão ou credenciais financeiras.

## Como funciona a escolha de dados
Ao entrar, se houver um documento na nuvem e os dados locais forem diferentes, o app pergunta se deseja carregar a nuvem ou enviar os dados locais. Faça um backup antes de decidir. O primeiro aparelho que tiver dados locais e uma nuvem vazia envia seus dados para a nuvem.

## Limitações atuais desta etapa
- Esta é a primeira integração de nuvem. O envio ocorre após alterações feitas no app; enquanto o app está aberto, ele consulta atualizações a cada 20 segundos e também ao voltar para a tela. Não é uma atualização instantânea garantida.
- Em caso de edições concorrentes em vários aparelhos, prefira terminar uma alteração e aguardar a mensagem de sincronização antes de editar em outro dispositivo.
- A lógica de faturas/limites continua sendo estimada a partir dos lançamentos inseridos, não de consulta direta ao banco emissor.
- Faça backups regulares mesmo usando a nuvem.

## Publicar no GitHub Pages
1. Descompacte o ZIP.
2. Envie para a raiz do repositório os arquivos `index.html`, `manifest.json`, `sw.js`, `icon-192.png`, `icon-512.png` e `supabase-setup.sql` (o SQL também pode ficar fora do repositório depois de executado).
3. Em **Settings → Pages**, selecione `Deploy from a branch`, branch `main`, pasta `/(root)` e salve.
4. Aguarde o site ficar disponível.


## Versão 4.2 — histórico e edição
- Cria pontos de recuperação automáticos das alterações salvas.
- Mantém até 30 versões no navegador e até 30 versões na nuvem por usuário.
- Permite consultar e restaurar versões anteriores.
- Permite editar lançamentos; em compras parceladas, permite escolher entre editar somente a parcela selecionada ou todas as parcelas do grupo.
- A exclusão e a restauração também geram pontos de recuperação.
- Mantém o status de pagamento e a sincronização existentes.

### Ativar o histórico na nuvem
Execute o arquivo `supabase-setup.sql` atualizado no SQL Editor do mesmo projeto Supabase. O script preserva a tabela existente `user_finance_data` e acrescenta a tabela `user_finance_backups`, com RLS por usuário. O histórico local funciona sem essa tabela; o histórico em nuvem depende da execução do SQL.
