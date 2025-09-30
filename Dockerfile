FROM ubuntu:latest AS build

# Atualiza pacotes e instala JDK + Maven
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk maven

# Define diretório de trabalho
WORKDIR /app

# Copia apenas o pom.xml primeiro (melhor aproveitamento do cache)
COPY pom.xml .

# Baixa dependências (sem compilar ainda)
RUN mvn dependency:go-offline

# Agora copia o código fonte
COPY src ./src

# Compila o projeto (gera o JAR)
RUN mvn clean package -DskipTests

# -----------------------------
# Segunda imagem só para rodar
FROM openjdk:21-jdk-slim

WORKDIR /app

EXPOSE 8080

# Copia o jar gerado na fase anterior
COPY --from=build /app/target/qrcode-generator-0.0.1-SNAPSHOT.jar app.jar

# Comando para iniciar o app
ENTRYPOINT ["java", "-jar", "app.jar"]
