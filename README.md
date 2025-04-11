mon_IO - historico de latencia de IO

------------------- Instalação

1. instalar chave SSH privada
~/.ssh/jpsp_github_20250411

2. configurar acesso github
$ cat ~/.ssh/config 
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/jpsp_github_20250411
  IdentitiesOnly yes

(nota: em Host em vez de "github.com" pode ser "github.com-mon_IO")

3. puxar projeto
$ git clone git@github.com:jpsp1/mon_IO.git

4. mover projeto 
# mv  mon_IO /usr/local/

5. configurar CRONTAB
$ crontab -l
.....
*/5 * * * * /usr/local/mon_IO/latencia_io.sh 2>&1 > /dev/null
