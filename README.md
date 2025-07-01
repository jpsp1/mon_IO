mon_IO - historico de latencia de IO


------------------- Instalação e uso

1. instalar chave SSH privada
Fonte: chimarea2 em ~/.ssh/jpsp_github_20250411

não esquecer:
$ chmod 600  ~/.ssh/jpsp_github_20250411


2. configurar acesso github
$ cat ~/.ssh/config 
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/jpsp_github_20250411
  IdentitiesOnly yes

(nota: em Host em vez de "github.com" pode ser "github.com-mon_IO")

3. puxar projeto
$ cd ~/tmp
$ git clone git@github.com:jpsp1/mon_IO.git
$ cd mon_IO/
$ git config user.email "joao.pagaime@gmail.com"
$ git config pull.rebase false  # merge (the default strategy)


4. mover projeto 
$ sudo  mv  mon_IO /usr/local/

5. configurar CRONTAB
$ crontab -l
.....
*/5 * * * * /usr/local/mon_IO/latencia_io.sh 2>&1 > /usr/local/mon_IO/latencia_io.log

6.  adicionar ao repositório GIT o ficheiro de dados do cliente especifico. Exemplo:
$ git add latencia_io.data.historico.chimaera2-serv

7. Atualizar
Convenção: master é o chimarae
upload / sync: git_upload.sh

8. remover ficheiros do projeto sem apagar
$ git ls-files
$ git rm --cached <file> 

