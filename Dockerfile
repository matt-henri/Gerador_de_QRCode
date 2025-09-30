# Primeira imagem: BUILD
FROM ubuntu:latest AS build

# Instala JDK 21 e Maven
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven

# Define o diretório de trabalho
WORKDIR /app 

# --- CORREÇÃO AQUI ---
# Copia TODO o conteúdo do projeto (pom.xml, src, etc.) para o WORKDIR
# Isso substitui as linhas 11, 14, e 17
COPY . .

# Compila o projeto (gera o JAR dentro de /app/target)
RUN mvn clean package -DskipTests



# Segunda imagem: RUN
FROM openjdk:21-jdk-slim

WORKDIR /app
EXPOSE 8080

# Copia o JAR gerado da fase de build
COPY --from=build /app/target/qrcode-generator-0.0.1-SNAPSHOT.jar app.jar

# Roda a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]