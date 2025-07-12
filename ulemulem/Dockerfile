FROM node:alpine AS website
WORKDIR /build

RUN npm install -g pnpm 

COPY web/package.json web/pnpm-lock.yaml ./

RUN pnpm install

COPY web/ ./

RUN pnpm run build

FROM golang:alpine AS web-backend
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod tidy
COPY . .
RUN go build -o /usr/bin/ulemulem cmd/ulemulem/root.go

FROM golang:alpine AS runtime
WORKDIR /root
ENV HOME=/root
ENV ULEMULEM_USERDIR="${HOME}/.local/share/ulemulem"
ENV ULEMULEM_WEBDIR=/var/www/html
ENV ULEMULEM_MIGRATIONDIR="${ULEMULEM_USERDIR}/db/migrations"
COPY --from=website /build/dist/ ${ULEMLUEM_WEBDIR}/
COPY --from=web-backend /build/db/migrations ${ULEMULEM_MIGRATIONDIR}/
COPY --from=web-backend /usr/bin/ulemulem /usr/bin/ulemulem
RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
CMD ["/usr/bin/ulemulem", "serve"]
