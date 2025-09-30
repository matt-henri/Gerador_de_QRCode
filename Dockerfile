#--- STAGE 1: BUILD (Construção da Aplicação) ---
FROM ubuntu:latest AS build

#Instala o JDK 21 e o Maven
#Faz a atualização do apt e instala os pacotes em uma única camada
RUN apt-get update && \
      apt-get install -y openjdk-21-jdk maven

#Define o diretório de trabalho onde o Maven irá executar
WORKDIR /app

#Copia todos os arquivos do contexto de build (pom.xml, src, etc.)
#para o diretório de trabalho no contêiner. ISSO CORRIGE O ERRO "no POM".
COPY . /app

#Compila o projeto Maven, ignorando os testes (-DskipTests)
#O JAR gerado estará em /app/target/
RUN mvn clean package -DskipTests

#--- STAGE 2: RUN (Execução da Aplicação) ---
#Imagem base minimalista, contendo apenas o JRE necessário para rodar o JAR
FROM openjdk:21-jdk-slim

#Define o diretório de trabalho final
WORKDIR /app

#A porta que o Spring Boot usa
EXPOSE 8080

#Copia o JAR gerado na etapa 'build' para o diretório de execução.
#Mantenha o nome do arquivo JAR exatamente como ele é gerado pelo seu pom.xml.
COPY --from=build /app/target/qrcode-generator-0.0.1-SNAPSHOT.jar app.jar

#Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]