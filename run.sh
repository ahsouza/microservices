#!/bin/bash
# Usando uma lista com botões de rádio com o Zenity
# REMOÇÃO DE CONTAINERS E IMAGENS
# export CONTAINERS=$(docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}")
zenity --height="120" --width="300" --notification --text "Olá ${LOGNAME} :)"
sleep 1s
# Criando variavel global e atribuindo informacoes docker containers e imagens
export CONTAINER=$(docker ps -a --format "{{.Names}}")
    # Caso tenha algum container
    if [[ "$CONTAINER" ]]; then
        # Crie uma lista de opções para dados serem excluídos
        DELETE=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
            --radiolist  \
            --column "" \
            --column "Excluir" \
            FALSE $CONTAINER FALSE Apagar-Tudo);

            # Caso a exclusão foi para containers; então
            if [[ "${DELETE}" == "${CONTAINER}" ]]; then

                echo "Deletando container: x - ${DELETE....}"
                docker rm -f "${DELETE}"
                docker rmi -f "${DELETE}"
                sleep 1s
                zenity --height="120" --width="300" --notification --text "\nO container <b>${CONTAINER}</b> \n\foi deletado!"
                exit 0

            else
                # Caso a exclusão foi para apagar tudo; então
                if [[ "${DELETE}" == "Apagar-Tudo" ]]; then
                    # Pergunta se realmente deseja apagar todos containers
                    zenity --question --width="420" --text "Tem certeza que deseja apagar todos os containers?"
                    if [[ $? = 0 ]]; then
                        
                        echo "Deletando todos containers..."
                        docker rm -f $(docker ps -aq)
                        docker rmi -f $(docker images -aq)
                        sleep 1s
                        zenity --height="120" --width="300" --notification --text "Todos os containers foram excluidos!"

                    else
                        exit 0
                    fi
                else
                # Caso nenhum. Saia!    
                    exit 0
                fi    
            fi
    fi
# REMOÇÃO DE CONTAINERS E IMAGENS    


# CRIANDO PROJETO
echo "Iniciando projeto....}"
ITEM_SELECIONADO=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
    --radiolist  \
    --column "Selecionar" \
    --column "Métodos" \
    TRUE Imagens FALSE Microservicos);


    # Caso algum método ágil para desenvolver foi selecionado
    if [[ "$ITEM_SELECIONADO" ]]; then
        # Caso método seja equivalente a Imagens
        if [[ "${ITEM_SELECIONADO}" == "Imagens" ]]; then

            IMAGEM_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Escolhendo imagem" \
                --radiolist \
                --column "Selecionar" \
                --column "Imagens" \
                TRUE crecies/laravel FALSE crecies/adonis FALSE crecies/vue FALSE crecies/ubuntu-server FALSE crecies/parrot FALSE crecies/windows-server);

            # Caso a imagem foi realmente selecionada
            if [[ "$IMAGEM_SELECIONADO" ]]; then
                sleep 1s
                zenity --height="120" --width="300" --notification --text "\Construindo <b>${IMAGEM_SELECIONADO}</b>..."

                echo "Building imagem...";
                echo "Building ${IMAGEM_SELECIONADO}...";

                docker build -t ${IMAGEM_SELECIONADO} .
                #docker run -d --name crecies -v $(pwd):/var/www -p 8000:8000 crecies/laravel-5.8
                docker run -d --name crecies -p 8000:8000 ${IMAGEM_SELECIONADO}
                #docker exec -it crecies bash server.sh
                docker exec -it crecies bash server.sh
                sleep 1s
                zenity --height="120" --width="300" --info --text "\nImagem <b>${IMAGEM_SELECIONADO}</b> \n\construida com sucesso!"
            else
                # Caso nenhum. Saia!
                exit 0
            fi

        else

            SERVICE_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Ativando serviços" \
            --checklist \
            --column "Selecionar" \
            --column "Serviços" \
            FALSE apache FALSE redis FALSE nginx FALSE mysql FALSE oracle FALSE mongo FALSE wordpress FALSE aws);

            # Caso método seja equivalente a Microserviços
            if [[ "$SERVICE_SELECIONADO" ]]; then
                sleep 1s
                zenity --height="120" --width="300" --notification --text "\Habilitando <b>${SERVICE_SELECIONADO}</b>..."
                echo "Activating services...";
                echo "Activating ${SERVICE_SELECIONADO}...";
                docker-compose up
                docker exec -it app bash
                ./server.sh

            else    
                # Caso nenhum. Saia!
                exit 0
            fi    
        fi
    fi