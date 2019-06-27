#!/bin/bash
# Usando uma lista com botões de rádio com o Zenity
# export CONTAINERS=$(docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}")
#----------#
# Welcome  #
#----------#
zenity --height="120" --width="300" --notification --text "Olá ${LOGNAME} :)"
export PATH = "${PWD}/app"
zenity --height="120" --width="600" --notification --text "Olá ${PATH} :)"


# REMOÇÃO DE CONTAINERS E IMAGENS
sleep 1s
# Criando variavel global e atribuindo informacoes sobre docker na máquina local
export CONTAINER=$(docker ps -a --format "{{.Names}}")
	# Caso tenha algum container
	#----------#
	#  DELETE  #
	#----------#
	if [[ "$CONTAINER" ]]; then
		# Criando uma lista de opções para dados serem excluídos
		DELETE=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
		    --radiolist  \
		    --column "" \
		    --column "Excluir" \
		    FALSE $CONTAINER FALSE Apagar-Tudo);

		    # Caso a exclusão foi para containers; então
			if [[ "${DELETE}" == "${CONTAINER}" ]]; then
				print_style "Excluindo ${CONTAINER}...\n" "info";
				
				docker rm -f "${DELETE}"
				docker rmi -f "${DELETE}"
				sleep 1s
				zenity --height="120" --width="360" --notification --text "\n${CONTAINER} foi apagado!"
				exit 0

			else
				# Caso a exclusão foi para apagar tudo; então
				if [[ "${DELETE}" == "Apagar-Tudo" ]]; then
					# Pergunta se realmente deseja apagar todos containers
					zenity --question --width="420" --text "Tem certeza que deseja apagar todos os containers?"
					if [[ $? = 0 ]]; then
						
						print_style "Deletando todos containers...\n" "info"
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
# REMOÇÃO DE CONTAINERS E IMAGENS }	

# DOCKTERIZANDO AMBIENTE DA APLICAÇÃO
#----------#
# Ambiente #
#----------#
zenity --height="120" --width="300" --notification --text "Iniciando projeto...\n" "info"
ITEM_SELECIONADO=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
    --radiolist  \
    --column "Selecionar" \
    --column "Métodos" \
    TRUE Imagens FALSE Microservicos);

    # Caso algum método ágil para desenvolver foi selecionado
	if [[ "$ITEM_SELECIONADO" ]]; then
		# Caso método seja equivalente a Imagens
		if [[ "${ITEM_SELECIONADO}" == "Imagens" ]]; then

			# BAIXANDO SEU PROJETO
			sleep 1s
		    zenity --question --width="420" --text "\nDeseja enviar o código fonte do projeto?"
		    if [[ $? = 0 ]]; then				
			    sleep 1s
		  
		        zenity --height="120" --width="300" --file-selection
		    else
			    exit 0
		    fi
		    # BAIXANDO SEU PROJETO }

			IMAGEM_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Escolhendo imagem" \
			    --radiolist \
			    --column "Selecionar" \
			    --column "Imagens" \
			    TRUE crecies/laravel FALSE crecies/adonis FALSE crecies/vue FALSE crecies/ubuntu-server FALSE crecies/parrot FALSE crecies/windows-server);

			# Caso a imagem foi realmente selecionada
			if [[ "$IMAGEM_SELECIONADO" ]]; then
				sleep 1s
				zenity --height="120" --width="360" --notification --text "\Construindo ${IMAGEM_SELECIONADO}..."

				echo "Building imagem...\n" "info";
				echo "Building ${IMAGEM_SELECIONADO}..." "info";

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