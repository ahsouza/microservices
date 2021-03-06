#!/bin/bash
# Usando uma lista com botões de rádio com o Zenity
# export CONTAINERS=$(docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Names}}")
#----------#
# Welcome  #
#----------#
dir=".extras/"

if [ -d "$dir" ];then
	zenity --height="120" --width="300" --notification --text "Olá ${LOGNAME}"
	sleep 1s
	rm -rf .extras/

	OCI8=$(zenity --height="360" --width="720" --list --text "Iniciando projeto" \
		--radiolist  \
		--column "" \
		--column "Excluir" \
		FALSE OCI8_12 FALSE OCI8_18);

		if [[ "$OCI8" == "OCI8_12" ]]; then	
				    
		    zenity --height="120" --width="300" --notification --text "Baixando programas..."
		    mkdir .extras/
		    cd .extras/
		    curl -o basic.zip https://www.crecies.gov.br/Dowloads_Arquivos/basic-10.2.0.5.0-linux-x64.zip
		    curl -o sdk.zip https://www.crecies.gov.br/Dowloads_Arquivos/sdk-10.2.0.5.0-linux-x64.zip
		    cd ..
				
		else
			mkdir .extras/
			cp instantclient-basic-linux.x64-18.5.zip .extras/basic.zip
			cp instantclient-sdk-linux.x64-18.5.zip .extras/sdk.zip
		fi
fi



#zenity --height="120" --width="300" --notification --text "Olá ${LOGNAME} :)"
export PATH = "${PWD}/app"

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
				
				docker stop "${DELETE}"
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
						docker stop $(docker ps -aq)
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

			IMAGEM_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Escolhendo imagem" \
			    --radiolist \
			    --column "Selecionar" \
			    --column "Imagens" \
			    TRUE crecies/area-restrita FALSE crecies/infosec FALSE crecies/wordpress FALSE crecies/alfresco FALSE crecies/server);
				# Caso a imagem foi realmente selecionada
				if [[ "$IMAGEM_SELECIONADO" ]]; then

					if [[ "$IMAGEM_SELECIONADO" == "crecies/alfresco" ]];then
						docker-compose -f alfresco.docker-compose.yaml up
					else
						sleep 1s
						zenity --height="120" --width="360" --notification --text "\Construindo ${IMAGEM_SELECIONADO}..."
						echo "Building imagem...\n" "info";
						echo "Building ${IMAGEM_SELECIONADO}..." "info";
						docker build -t ${IMAGEM_SELECIONADO} .
						#docker run -d --name crecies -v $(pwd):/var/www -p 8000:8000 crecies/laravel-5.8
						docker run -d --name crecies -p 8000:8000 ${IMAGEM_SELECIONADO}
						docker exec -it crecies bash server.sh
						# docker exec -it crecies bash
						sleep 1s
						zenity --height="120" --width="300" --info --text "\nImagem <b>${IMAGEM_SELECIONADO}</b> \n\construida com sucesso!"
					fi

				else
					# Caso nenhum. Saia!
					exit 0
					rm -rf .extras/
				fi
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