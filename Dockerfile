FROM ubuntu:latest AS build

# Instala JDK 21 e Maven
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven

# Define o diretório de trabalho
WORKDIR /app

# Copia o pom.xml primeiro (para cachear dependências)
COPY pom.xml .

# Baixa dependências
RUN mvn dependency:go-offline

# Copia o restante do código
COPY src ./src

# Compila o projeto (gera o JAR dentro de /app/target)
RUN mvn clean package -DskipTests

# -----------------------------
# Segunda imagem: apenas para rodar
FROM openjdk:21-jdk-slim

WORKDIR /app
EXPOSE 8080

# Copia o JAR gerado da fase de build
COPY --from=build /app/target/qrcode-generator-0.0.1-SNAPSHOT.jar app.jar

# Roda a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
