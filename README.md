# GymDashboard #

### Descrição do Projeto ###

O projeto consiste no desenvolvimento de um sistema Web que permita aos atendentes de uma academia um maior controle sobre as disponibilidades de aulas específicas disponíveis assim como sugestões de atividades que se encaixam de forma a suprir os objetivos do seu cliente, garantindo ao mesmo tempo a segurança destes dados.

### Ferramentas Utilizadas ###

A seguir segue a lista de ferramentas e extensões que serão utilizadas para o desenvolvimento do software:

- RAD Studio 10.1 Berlin (Delphi)
- Angular JS
- Astah Professional

* .pas (Arquivos de código fonte)
* .dfm (Arquivos de formulários)
*.dcu (Arquivos de código fonte compilados)
* .dpr, .dproj (Arquivos de projeto)
* .exe (Arquivo executável do servidor)
* .dof (Arquivos de opções de projeto)
* .fdb (Arquivos de banco de dados)
* .js
* .html
* .css

### Componentes da Equipe ###

A equipe do projeto é fomarda por cinco pessoas, sendo três desenvolvedores, um analista de sistemas, um tester e o gerente de configurações. Entre os desenvolvedores o grupo será dividido entre dois front-end e um back-end. Os membros do grupo encarregados pela parte de front-end serão Ike e Rafael. Já a parte de back-end será atribuida ao Jonathan. O cargo de analista de sistemas será de responsabilidade da integrante Thais. A função de tester será da Angel e o de gerente de configuração será do Igor.

### Estágios dos Itens de Congfiguração ###

#### Processo de Desenvolvimento/ Metodologia de Colaboração ####

O board do projeto será dividido em cinco colunas: to do(tarefas a serem feitas), work in progress(tarefas que estão sendo feitas/em progresso), ready to test(tarefas concluídas prontas para teste), ready to release(tarefas testadas e prontas para entrar em produção) e ready to prod(tarefas prontas para produção). 

Sobre as issues, ao criar uma em seu título deve conter uma pequena descrição da tarefa a ser feita, por exemplo: adicionar funcionalidade x do sistema, adicionar funcionalidade de cadastramento de clientes no sistema, incluir menu principal, etc... No corpo da issue deve haver uma descrição detalhada da funcionalidade. Ao ser criada uma issue também deve-se selecionar um label que será pré-definido pelo gerente de configuração. Exemplos de label: funcionalidade, bug, urgente, backend, frontend, etc... Em projects deve-se vincular a issue ao board correspondente. Também deve ser selecionada uma data de entrega para a tarefa em milestone que também será pré-definida pelo gerente de configuração. No nome da milestone será informado a data que a tarefa deverá ser entregue.

Haverão duas branches principais, master e develop.
- A branch master conterá o código atualizado e funcional. Ela refletirá o estado atual do projeto em desenvolvimento.
- A branch develop conterá as modificações feitas na fase de desenvolvimento e que serão enviadas para o próximo release. Quando o código da branch develop estiver estável, todas as alterações feitas nela deverão ser mergeadas para a branch master.

Haverão mais duas branches de apoio, release e a da tarefa(issue).
- A brach tarefa será para o desenvolvimento de funções para um futuro release e ao ser concluida deve ser mergeada para a branch develop para ser adicionada no proximo release. 
- A branch release será criada a partir da branch develop quando essa estiver próxima de um estado desejado para a nova versão. O nome da branch deve corresponder ao release que será lançado, por exemplo, release 1.0. Quando a essa branch estiver pronta para produção ela deve ser mergeada para a branch master e também para a branch develop, para que as futuras versões também contenham as alterações das releases passadas.

Somente os desenvolvedores terão autonomia na criação e edição de issues, os demais integrantes do grupo não. Quando um desenvolvedor criar uma nova issue ele deve atribui-la a outro desenvolvedor, assim o desenvolvedor atruibuido a tarefa deverá arrasta-la da coluna to do para a coluna work in progress e assim que concluir a tarefa o responsavel deve fecha-la e arrasta-la para a coluna ready to test. Após o tester concluir todos os teste, ele deve descrever e listar os casos que foram testados no comentário para validar a funcionalidade. Depois do processo de testes o tester deve arrastar a tarefa da coluna ready to test para a coluna ready to release. Por fim, o gerente de configurção arrastará da coluna ready to release para ready to prod.

Após a criação e configuração da issue o próximo passo é acessar o repósitorio localmente onde a tarefa será desenvolvida e criar um novo branch da tarefa a partir do branch develop. Todas as alterações alterações só devem ser commitadas nessa branch da tarefa. Por fim, depois de terminar o desenvolvimento da tarefa deve-se disponibiliza-la para teste, dando merge da branch tarefa para a branch develop.
