FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["src/Services/Transaction/Transaction.WebApi.csproj","dotnetcore/"]
RUN dotnet restore "src/Services/Transaction/Transaction.WebApi.csproj"
COPY . .
WORKDIR "/src/dotnetcore"
RUN dotnet build "Transaction.WebApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Transaction.WebApi.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet","Transaction.WebApi.dll"]
