#!/bin/bash
# Usando uma lista com botões de rádio com o Zenity
# REMOÇÃO DE CONTAINERS E IMAGENS
echo "Olá ${LOGNAME} :)"
echo "Vamos limpar algumas coisas por aqui !?"
# export CONTAINERS=$(docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}")
export CONTAINER=$(docker ps -a --format "{{.Names}}")
    
    if [[ "$CONTAINER" ]]; then

        DELETE=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
            --radiolist  \
            --column "" \
            --column "Excluir" \
            FALSE $CONTAINER FALSE Apagar-Tudo);

            if [[ "${DELETE}" == "${CONTAINER}" ]]; then

                echo "Deletando container: x - ${DELETE....}"
                docker rm -f "${DELETE}"
                docker rmi -f "${DELETE}"
                zenity --height="120" --width="300" --info --text "\nO container <b>${CONTAINER}</b> \n\foi deletado!"
                exit 0

            else
                if [[ "${DELETE}" == "Apagar-Tudo" ]]; then
                    echo "Deletando todos containers..."
                    docker rm -f $(docker ps -aq)
                    docker rmi -f $(docker images -aq)
                    zenity --height="120" --width="300" --info --text "Você apagou todos os containers!"
                else
                    exit 0
                fi    
            fi
    fi
# REMOÇÃO DE CONTAINERS E IMAGENS    


# SELEÇÃO DE CONTAINERS OU IMAGENS
echo "Iniciando projeto....}"
ITEM_SELECIONADO=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
    --radiolist  \
    --column "Selecionar" \
    --column "Métodos" \
    TRUE Imagens FALSE Microservicos);



    if [[ "$ITEM_SELECIONADO" ]]; then
        if [[ "${ITEM_SELECIONADO}" == "Imagens" ]]; then

            IMAGEM_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Escolhendo imagem" \
                --radiolist \
                --column "Selecionar" \
                --column "Imagens" \
                TRUE crecies/laravel FALSE crecies/adonis FALSE crecies/vue FALSE crecies/ubuntu-server FALSE crecies/parrot FALSE crecies/windows-server);

            if [[ "$IMAGEM_SELECIONADO" ]]; then

                echo "Building imagem...";
                echo "Building ${IMAGEM_SELECIONADO}...";

                docker build -t ${IMAGEM_SELECIONADO} .
                #docker run -d --name crecies -v $(pwd):/var/www -p 8000:8000 crecies/laravel-5.8
                docker run -d --name crecies -p 8000:8000 ${IMAGEM_SELECIONADO}
                #docker exec -it crecies bash server.sh
                docker exec -it crecies bash server.sh
                zenity --height="120" --width="300" --info --text "\nImagem <b>${IMAGEM_SELECIONADO}</b> \n\instalada com sucesso!"
            else
                exit 0
            fi


        else

            SERVICE_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Ativando serviços" \
            --checklist \
            --column "Selecionar" \
            --column "Serviços" \
            FALSE apache FALSE redis FALSE nginx FALSE mysql FALSE oracle FALSE mongo FALSE wordpress FALSE aws);


            if [[ "$SERVICE_SELECIONADO" ]]; then

                echo "Activating services...";
                echo "Activating ${SERVICE_SELECIONADO}...";
                docker-compose up
                docker exec -it app bash
                ./server.sh
                
            else    
    
                exit 0
            fi    
        fi
    fi