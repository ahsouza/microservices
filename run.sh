#!/bin/bash
# Usando uma lista com botões de rádio com o Zenity
ITEM_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Iniciando projeto" \
    --radiolist \
    --column "Selecionar" \
    --column "Docker" \
    TRUE Imagens FALSE Microservicos);
echo "Execução com $ITEM_SELECIONADO para seu projeto";
	# if ((ITEM_SELECIONADO)); then

		if [[ "${ITEM_SELECIONADO}" == "Imagens" ]]; then

			IMAGEM_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Escolhendo imagem" \
			    --radiolist \
			    --column "Selecionar" \
			    --column "Imagens" \
			    TRUE crecies/laravel FALSE crecies/adonis FALSE crecies/vue FALSE crecies/ubuntu-server FALSE crecies/parrot FALSE crecies/windows-server);


			echo "Building imagem...";
			echo "Building ${IMAGEM_SELECIONADO}...";

			docker build -t anibalhsouza/laravel-5.8 .
			#docker run -d --name crecies -v $(pwd):/var/www -p 8000:8000 crecies/laravel-5.8
			docker run -d --name crecies -p 8000:8000 anibalhsouza/laravel-5.8
			#docker exec -it crecies bash server.sh
			docker exec -it crecies bash server.sh
			
			zenity --height="120" --width="300" --info --text "\nImagem <b>${IMAGEM_SELECIONADO}</b> \n\instalada com sucesso!"

			exit 0


		else

			SERVICE_SELECIONADO=$(zenity --height="300" --width="600" --list --text "Ativando serviços" \
			--checklist \
			--column "Selecionar" \
			--column "Serviços" \
			TRUE apache FALSE redis FALSE nginx FALSE mysql FALSE oracle FALSE mongo FALSE wordpress FALSE aws);

			echo "Activating services...";
			echo "Activating ${SERVICE_SELECIONADO}...";
			docker-compose up
			docker exec -it app bash
			./server.sh
			# # Usando uma lista com botões de rádio com o Zenity
			# ITEM_SELECIONADO=$(zenity --list --text "Levantando container" \
			#     --radiolist \
			#     --column "Selecionar" \
			#     --column "Docker" \
			#     TRUE crecies/laravel FALSE docker-compose);
			# exit 1
		fi
	# fi