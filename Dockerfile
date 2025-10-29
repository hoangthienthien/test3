# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy toàn bộ mã nguồn
COPY . .

# Cho phép chạy mvnw nếu có (không lỗi nếu thiếu quyền)
RUN chmod +x mvnw || true

# Build bỏ test -> tạo JAR trong target/
RUN ./mvnw -q -DskipTests package || mvn -q -DskipTests package

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy JAR đã build sang image chạy
COPY --from=build /app/target/*.jar app.jar

# Render cấp PORT qua biến PORT
ENV JAVA_OPTS="-Dserver.port=${PORT}"

# (tuỳ chọn) múi giờ VN
# ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 8080
CMD ["sh","-c","java $JAVA_OPTS -jar app.jar"]
