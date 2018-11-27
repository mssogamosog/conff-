

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY WebApplication2/WebApplication2.fsproj WebApplication2/
RUN dotnet restore WebApplication2/WebApplication2.fsproj
COPY . .
WORKDIR /src/WebApplication2

RUN dotnet build "WebApplication2.fsproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "WebApplication2.fsproj" -c Release -o /app

FROM microsoft/dotnet:2.1-aspnetcore-runtime
WORKDIR /app
EXPOSE 5000
EXPOSE 44365
ENV ASPNETCORE_URLS http://+:5000
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebApplication2.dll","--urls", "http://0.0.0.0:5000"]